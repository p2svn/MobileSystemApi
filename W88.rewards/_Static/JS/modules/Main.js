﻿var sessionPoll;

// Set window.user property
setUser();

function checkSession() {
    if (!sessionId) return;
    var intervalMin = 10000,
        interval = !isNaN(parseInt(sessionInterval)) ? parseInt(sessionInterval) : intervalMin;

    sessionPoll = window.setInterval(function () {
        $.ajax({
            contentType: 'text/html',
            url: '/_Secure/AjaxHandlers/MemberSessionCheck.ashx',
            type: 'POST',
            data: sessionId,
            success: function (data) {
                if (!data || _.isUndefined(data.Code)) return;
                switch (data.Code) {
                    case 1: return;
                    default:
                        if (!_.isEmpty(data.Message)) w88Mobile.Growl.shout(data.Message);
                        clearInterval(sessionPoll);
                        setTimeout(function () {
                            logout();
                        }, 2000);
                        break;
                }
            }
        });
    }, interval);
}

$(document).on('pagecontainerbeforeshow', function (event, ui) {
    var baseUri = [event.target.baseURI];
    if (_.some(baseUri, _.method('match', /Login/i))) {
        if (window.user && window.user.Token) {
            window.location.href = '/Index.aspx';
        }
    }

    if ($.mobile) {
        if ($.mobile.navigate.history.stack.length === 0)
            $('#backButton').hide();
        else
            $('#backButton').show();
    }

    if (GPINTMOBILE)
        GPINTMOBILE.HideSplash();
});

function loadPage(uri, params, transition) {
    $(':mobile-pagecontainer').pagecontainer('change', uri, { data: params, reload: true, transition: transition });
}

function logout() {
    if (!sessionId) return;
    $.ajax({
        contentType: 'text/html',
        url: '/_Secure/AjaxHandlers/MemberSessionCheck.ashx',
        type: 'POST',
        data: sessionId,
        beforeSend: function () {
            $.mobile.loading('show');
        },
        success: function (data) {
            if (!data || _.isUndefined(data.Code)) return;
            switch (data.Code) {
                case 1:
                    $.ajax({
                        url: '/api/user/logout',
                        contentType: 'text/html',
                        async: true,
                        data: 'MemberId=' + data.Data.MemberId,
                        success: function (response) {
                            if (sessionPoll) clearInterval(sessionPoll);
                            switch (response.ResponseCode) {
                                case 1:
                                    break;
                                default:
                                    if (!_.isEmpty(response.ResponseMessage));
                                        window.w88Mobile.Growl.shout(response.ResponseMessage);
                                    break;
                            }
                            clear();
                        }
                    });
                    break;
                default:
                    if (!_.isEmpty(data.Message)) w88Mobile.Growl.shout(data.Message);
                    if (sessionPoll) clearInterval(sessionPoll);
                    clear();
                    break;
            }
        }
    });
}

function clear() {
    amplify.store(window.location.host + '_user', null);
    window.user = null;
    $.mobile.loading('hide');
    window.location.href = '/Logout';
}

function Cookies() {
    var setCookie = function (cname, cvalue, expiryDays) {
        var date = new Date();
        date.setTime(date.getTime() + (expiryDays * 24 * 60 * 60 * 1000));
        var expires = 'expires=' + date.toUTCString(),
            splitHost = window.location.host.split('.'),
            domain = splitHost.length > 2 ? (splitHost[1] + '.' + splitHost[2]) : (splitHost[0] + '.' + splitHost[1]);
        document.cookie = cname + '=' + cvalue + ';expires=' + expires + ';domain=' + domain + ';path=/';
    };

    var getCookie = function (cname) {
        var name = cname + '=';
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i];
            while (cookie.charAt(0) == ' ')
                cookie = cookie.substring(1);

            if (cookie.indexOf(name) == 0) {
                return cookie.substring(name.length, cookie.length);
            }
        }
        return '';
    };

    return {
        setCookie: setCookie,
        getCookie: getCookie
    };
}

function setUser() {
    var storedObject = amplify.store(window.location.host + '_user');
    window.user = _.isEmpty(storedObject) ? new User() : (new User()).createUser(storedObject);
}
