﻿window.w88Mobile.Gateways.Paysec = Paysec();
var _w88_paysec = window.w88Mobile.Gateways.Paysec;

function Paysec() {

    var paysec = Object.create(new w88Mobile.Gateway(_w88_paymentSvc));

    paysec.createDeposit = function () {
        var _self = this;
        var params = _self.getUrlVars();
        var data = {
            Amount: params.Amount,
            ThankYouPage: params.ThankYouPage
        };

        _self.methodId = params.MethodId;
        _self.changeRoute();
        _self.deposit(data, function (response) {
            switch (response.ResponseCode) {
                case 1:
                    if (response.ResponseData.PostUrl) {
                    w88Mobile.PostPaymentForm.createv2(response.ResponseData.FormData, response.ResponseData.PostUrl, "body");
                    w88Mobile.PostPaymentForm.submit();
                    } else {
                        var data = {
                            VANumber: response.ResponseData.FormData.VANumber,
                            VAExpiry: response.ResponseData.FormData.VAExpiry,
                            Amount: response.ResponseData.FormData.Amount,
                            OrderId: response.ResponseData.FormData.OrderId,
                            CartId: response.ResponseData.FormData.CartId
                        };

                        var action = "/Deposit/PaySec.html";
                        var params = decodeURIComponent($.param(data));
                        window.location.href = action + "?" + params;

                    }
                    break;
                default:
                    if (_.isArray(response.ResponseMessage))
                        w88Mobile.Growl.shout(w88Mobile.Growl.bulletedList(response.ResponseMessage), _self.shoutCallback);
                    else
                        w88Mobile.Growl.shout(response.ResponseMessage, _self.shoutCallback);

                    break;
            }
        },
        function () {
            GPInt.prototype.HideSplash();
        });
    }

    return paysec;
}