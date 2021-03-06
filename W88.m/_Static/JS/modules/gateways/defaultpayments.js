function DefaultPayments() {

    var autorouteIds = {
        QuickOnline: "999999",
        UnionPay: "999998",
        TopUpCard: "999997",
        AliPay: "999996",
        WeChat: "999995",
    };

    var defaultpayments = {
        Deposit: deposit,
        Withdraw: withdraw,
        AutoRouteIds: autorouteIds,
        Send: sendv1,
        SendDeposit: send,
        DisplaySettings: displaySettings,
        setPaymentTabs: setPaymentTabs,
        onTransactionCreated: onTransactionCreated,
        formatDateTime: formatDateTime,
        init: init
    };

    var paymentCache = {};

    var paymentOptions = {};

    return defaultpayments;

    function init(isDeposit) {

        var headerTitle = isDeposit ? _w88_contents.translate("LABEL_FUNDS_DEPOSIT") : _w88_contents.translate("LABEL_FUNDS_WIDRAW");
        $('#headerTitle').text(headerTitle);
        $('span[id$="lblMode"]').text(_w88_contents.translate("LABEL_MODE"));
        $('span[id$="lblMinMaxLimit"]').text(_w88_contents.translate("LABEL_MINMAX_LIMIT"));
        $('span[id$="lblDailyLimit"]').text(_w88_contents.translate("LABEL_DAILY_LIMIT"));
        $('span[id$="lblTotalAllowed"]').text(_w88_contents.translate("LABEL_TOTAL_ALLOWED"));

        $('input[id$="btnSubmit"]').val(_w88_contents.translate("BUTTON_SUBMIT")).button("refresh");

        var type = isDeposit ? "deposit" : "withdrawal";

        fetchSettings(type, function () { });
    }

    function formatDateTime(dateTime) {
        //MM/DD/YYYY h:m:s
        var month = (dateTime.getMonth() + 1).toString().length == 1 ? "0" + (dateTime.getMonth() + 1).toString() : (dateTime.getMonth() + 1).toString();
        var day = (dateTime.getDate()).toString().length == 1 ? "0" + dateTime.getDate().toString() : dateTime.getDate().toString();
        var year = dateTime.getFullYear();

        var hours = dateTime.getHours();
        var minutes = dateTime.getMinutes();
        var seconds = dateTime.getSeconds();

        return month + "/" + day + "/" + year + " " + hours + ":" + minutes + ":" + seconds
    }

    function displaySettings(methodId, options) {
        paymentOptions = options;
        fetchSettings(paymentOptions.type, function () {
            if (!_.isEmpty(paymentCache)) {
                var setting = _.find(paymentCache.settings, function (data) {
                    return data.Id == methodId;
                });

                if (setting) {
                    $('#txtMode').text(": " + setting.PaymentMode);
                    $('#txtMinMaxLimit').text(": " + setting.MinAmount.toLocaleString(undefined, { minimumFractionDigits: 2 }) + " / " + setting.MaxAmount.toLocaleString(undefined, { minimumFractionDigits: 2 }));
                    $('#txtDailyLimit').text(": " + setting.LimitDaily);
                    $('#txtTotalAllowed').text(": " + setting.TotalAllowed);
                }
            }
        })
    }

    function setPaymentTabs(type, activeMethodId) {
        if (type.toLowerCase() == "deposit") {
            fetchSettings(type, function () {
                if (paymentCache.settings.length == 0) {
                    // track accounts with no gateways
                    w88Mobile.PiwikManager.trackEvent({
                        category: type,
                        action: window.User.countryCode,
                        name: window.User.memberId
                    });

                    nogateway();
                }
                else {
                    // payment cache variable is now present once callback is triggered
                    setDepositPaymentTab(paymentCache.settings, activeMethodId);
                    togglePayment();
                }
            });
        } else {
            fetchSettings(type, function () {
                if (paymentCache.settings.length == 0) {
                    nogateway();
                }
                else {
                    setWithdrawalPaymentTab(paymentCache.settings, activeMethodId);
                    togglePayment();
                }
            });
        }
    }

    function fetchSettings(type, callback) {

        var url = "/payments/settings/" + type;
        cacheKey = (type.toLowerCase() == "deposit") ? w88Mobile.Keys.depositSettings : w88Mobile.Keys.withdrawalSettings;

        paymentCache = amplify.store(cacheKey);

        if (!_.isEmpty(paymentCache) && User.lang == paymentCache.language) {
            callback();
        } else {
            send(url, "GET", {},
                    function (response) {
                        switch (response.ResponseCode) {
                            case 1:
                                paymentCache = {
                                    settings: response.ResponseData
                                    , language: window.User.lang
                                };
                                amplify.store(cacheKey, paymentCache, User.storageExpiration);
                                callback();
                            default:
                                break;
                        }
                    }
                );
        }
    }

    function send(resource, method, data, success, complete) {
        var url = w88Mobile.APIUrl + resource;

        var headers = {
            'Token': window.User.token,
            'LanguageCode': window.User.lang
        };

        $.ajax({
            type: method,
            url: url,
            data: data,
            beforeSend: function () {
                pubsub.publish('startLoadItem', { selector: "" });
            },
            headers: headers,
            success: success,
            error: function () {
                console.log("Error connecting to api");
            },
            complete: function () {
                pubsub.publish('stopLoadItem', { selector: "" });
                if (!_.isUndefined(complete)) complete();
            }
        });
    }

    function onTransactionCreated(form) {

        var historyBtn = "<a href='/v2/History/Default.aspx' class='btn btn-primary' data-ajax='false'>" + _w88_contents.translate("LABEL_FUNDS_HISTORY") + "</a>";
        var message = "<p>" + _w88_contents.translate("MESSAGES_CHECK_HISTORY") + "</p>" + historyBtn;
        if (!_.isUndefined(form)) _.first(form).reset();
        w88Mobile.Growl.shout(message);
    }

    // to be deprecated, use "send"
    function sendv1(resource, method, success, data, complete) {
        send(resource, method, data, success, complete);
    }


    // deposit to be deprecated once new flow is applied use fetchSettings
    function deposit(countryCode, memberid, paymentNotice, activeTabId) {

        var payment = amplify.store(w88Mobile.Keys.depositSettings);

        if (payment && window.User.lang == payment.language) {
            setDepositPaymentTab(payment.settings, activeTabId);
        }
        else {
            send("/payments/settings/deposit", "GET", {},
                function (response) {
                    switch (response.ResponseCode) {
                        case 1:
                            var data = { settings: response.ResponseData, language: window.User.lang };

                            amplify.store(w88Mobile.Keys.depositSettings, data, window.User.storageExpiration);

                            setDepositPaymentTab(response.ResponseData, activeTabId);
                        default:
                            break;
                    }
                }
            );
        }

        togglePayment();
    }

    function setDepositPaymentTab(responseData, activeTabId) {
        if (responseData.length > 0) {
            var routing = [
                autorouteIds.QuickOnline,
                autorouteIds.UnionPay,
                autorouteIds.TopUpCard,
                autorouteIds.AliPay,
                autorouteIds.WeChat
            ];

            var isAutoRoute = false, title = "", page = null, deposit = "/Deposit/";

            for (var i = 0; i < responseData.length; i++) {
                var data = responseData[i];

                if (data.Method)
                    continue;

                page = setPaymentPage(data.Id);

                if (page)
                    page = deposit + page;
                else
                    continue;

                if (activeTabId) {
                    if (_.isEqual(data.Id, activeTabId))
                        title = data.Title;

                    var anchor = $('<a />', { class: 'ui-btn ui-shadow ui-corner-all', id: data.Id, href: page, 'data-ajax': false }).text(data.Title);

                    if ($('#depositTabs').length > 0)
                        $('#depositTabs').append($('<li />').append(anchor));

                    if ($('#paymentTabs').length > 0)
                        $('#paymentTabs').append($('<li />').append(anchor));

                }
            }

            if (activeTabId) {
                if (title) {
                    if ($('#activeDepositTabs').length > 0)
                        $('#activeDepositTabs').text(title);

                    if ($('#activeTab').length > 0)
                        $('#activeTab').text(title);

                    $('#headerTitle').append(' - ' + title);
                } else {
                    window.location.href = deposit;
                }

                if (_.includes(routing, activeTabId)) {
                    $('#dailyLimit').hide()
                    $('#totalAllowed').hide()
                }
            }
            else {
                page = setPaymentPage(_.first(responseData).Id);
                if (page)
                    window.location.href = deposit + page;
            }
        } else {
            if (activeTabId) {
                window.location.href = deposit;
            }
            else {

                // track accounts with no gateways
                w88Mobile.PiwikManager.trackEvent({
                    category: "Deposit",
                    action: window.User.countryCode,
                    name: window.User.memberId
                });

                nogateway();
            }
        }
    }

    // withdraw to be deprecated once new flow is applied use fetchSettings
    function withdraw(countryCode, memberid, paymentNotice, activeTabId) {

        var payment = amplify.store(w88Mobile.Keys.withdrawalSettings);

        if (payment && window.User.lang == payment.language) {
            setWithdrawalPaymentTab(payment.settings, activeTabId);
        }
        else {
            send("/payments/settings/Withdrawal", "GET", {},
                function (response) {
                    switch (response.ResponseCode) {
                        case 1:
                            var data = { settings: response.ResponseData, language: window.User.lang };

                            amplify.store(w88Mobile.Keys.withdrawalSettings, data, window.User.storageExpiration);

                            setWithdrawalPaymentTab(response.ResponseData, activeTabId);
                            break;
                        default:
                            break;
                    }
                }
            );
        }

        togglePayment();
    }

    function setWithdrawalPaymentTab(responseData, activeTabId) {
        if (responseData.length > 0) {
            var title = "", withdraw = "/Withdrawal/";
            _.forEach(responseData, function (data) {
                var page = setPaymentPage(data.Id);

                if (page)
                    page = withdraw + page;
                else
                    return;

                if (activeTabId) {
                    if (_.isEqual(data.Id, activeTabId))
                        title = data.Title;

                    var anchor = $('<a />', { class: 'ui-btn ui-shadow ui-corner-all', id: data.Id, href: page, 'data-ajax': false }).text(data.Title);

                    if ($('#withdrawalTabs').length > 0)
                        $('#withdrawalTabs').append($('<li />').append(anchor));

                    if ($('#paymentTabs').length > 0)
                        $('#paymentTabs').append($('<li />').append(anchor));
                }
            })

            if (activeTabId) {
                if ($('#activeWithdrawalTabs').length > 0)
                    $('#activeWithdrawalTabs').text(title);

                if ($('#activeTab').length > 0)
                    $('#activeTab').text(title);

                $('#headerTitle').append(' - ' + title);
            }
            else {
                page = setPaymentPage(_.first(responseData).Id);
                if (page)
                    window.location.href = withdraw + page;
            }
        } else {
            if (activeTabId) {
                window.location.href = withdraw;
            }
            else {
                nogateway();
            }
        }
    }

    function nogateway() {
        $('.empty-state').show();
        $('#paymentNote').html(_w88_contents.translate("LABEL_PAYMENT_NOTE_NO_GATEWAY"));
        $('#btnSubmitPlacement').hide();
        $('#paymentSettings').hide();
        $('#paymentList').hide();

        pubsub.publish('stopLoadItem', { selector: "" });
    }

    function setPaymentPage(id) {
        if (_.isEmpty(id)) return "";
        return id;
    }

    function togglePayment() {
        $(".toggle-list-btn").click(function () {
            $(this).parent().find('.toggle-list').slideToggle("fast", function () {
                if (!$('.toggle-list-btn').hasClass('toggled')) {
                    $(this).parent().find('.toggle-list-btn').addClass('toggled');
                }
                else {
                    $(this).parent().find('.toggle-list-btn').removeClass('toggled');
                }
            });
        });
    }
}

var _w88_paymentSvc = window.w88Mobile.Gateways.DefaultPayments = DefaultPayments();