﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VenusPoint.aspx.cs" Inherits="Withdrawal_VenusPoint" %>

<%@ Register TagPrefix="uc" TagName="Wallet" Src="~/UserControls/MainWalletBalance.ascx" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <!--#include virtual="~/_static/head.inc" -->
    <script type="text/javascript" src="/_Static/JS/modules/gateways/defaultpayments.js"></script>
    <script type="text/javascript" src="/_Static/JS/modules/gateways/venuspoint.js"></script>
</head>
<body>
    <div data-role="page" data-theme="b">
        <header data-role="header" data-theme="b" data-position="fixed" id="header">
            <% if (commonCookie.CookieIsApp != "1")
               { %>
            <a class="btn-clear ui-btn-left ui-btn" href="#divPanel" data-role="none" id="aMenu" data-load-ignore-splash="true">
                <% if (commonFunctions.isExternalPlatform())
                   { %>
                <i class="icon icon-back"></i>
                <% }
                   else
                   { %>
                <i class="icon icon-navicon"></i>
                <% } %>
            </a>
            <% } %>

            <h1 class="title" id="headerTitle"><%=commonCulture.ElementValues.getResourceString("withdrawal", commonVariables.LeftMenuXML)%></h1>
        </header>

        <div class="ui-content" role="main">
            <div class="wallet main-wallet">
                <uc:Wallet ID="uMainWallet" runat="server" />
            </div>

            <div class="toggle-list-box">
                <button class="toggle-list-btn btn-active" id="activeWithdrawalTabs"></button>
                <ul class="toggle-list hidden" id="withdrawalTabs">
                </ul>
            </div>

            <form class="form" id="form1" runat="server" data-ajax="false">
                <br>
                <ul class="list fixed-tablet-size">
                    <li class="row">
                        <div class="col">
                            <asp:Literal ID="lblMode" runat="server" />
                        </div>
                        <div class="col">
                            <asp:Literal ID="txtMode" runat="server" />
                        </div>
                    </li>
                    <li class="row">
                        <div class="col">
                            <asp:Literal ID="lblMinMaxLimit" runat="server" />
                        </div>
                        <div class="col">
                            <asp:Literal ID="txtMinMaxLimit" runat="server" />
                        </div>
                    </li>
                    <li class="row">
                        <div class="col">
                            <asp:Literal ID="lblDailyLimit" runat="server" />
                        </div>
                        <div class="col">
                            <asp:Literal ID="txtDailyLimit" runat="server" />
                        </div>
                    </li>
                    <li class="row">
                        <div class="col">
                            <asp:Literal ID="lblTotalAllowed" runat="server" />
                        </div>
                        <div class="col">
                            <asp:Literal ID="txtTotalAllowed" runat="server" />
                        </div>
                    </li>
                    <li class="item item-input">
                        <asp:Label ID="lblWithdrawAmount" runat="server" AssociatedControlID="txtAmount" />
                        <asp:TextBox ID="txtAmount" runat="server" type="number" step="any" min="1" data-clear-btn="true" />
                    </li>
                    <li class="item item-input">
                        <asp:Label ID="lblAcctName" runat="server" AssociatedControlID="txtAccountName" />
                        <asp:TextBox ID="txtAccountName" runat="server" data-clear-btn="true" />
                    </li>
                    <li class="item-text-wrap">
                        <asp:Label ID="lblVenusPoints" runat="server" />
                    </li>
                    <li class="item-text-wrap">
                        <asp:Label ID="lblExchangeRate" runat="server" />
                    </li>
                    <li class="item row">
                        <div class="col">
                            <asp:Button data-theme="b" ID="btnSubmit" runat="server" CssClass="button-blue" data-corners="false" />
                        </div>
                    </li>
                </ul>
            </form>
        </div>

        <% if (commonCookie.CookieIsApp != "1")
           { %>
        <!--#include virtual="~/_static/navMenu.shtml" -->
        <% } %>

        <script type="text/javascript">
            $(document).ready(function () {
                window.w88Mobile.Gateways.DefaultPayments.Withdraw("<%=base.strCountryCode %>", "<%=base.strMemberID %>", '<%= commonCulture.ElementValues.getResourceString("paymentNotice", commonVariables.PaymentMethodsXML)%>', "<%=base.PaymentMethodId %>");

                window.w88Mobile.Gateways.VenusPoint.Initialize();

                $('#form1').submit(function (e) {
                    e.preventDefault();
                    window.w88Mobile.FormValidator.disableSubmitButton('#btnSubmit');

                    var data = {
                        Amount: $('#txtAmount').val(),
                        AccountName: $('#txtAccountName').val(),
                    };

                    window.w88Mobile.Gateways.VenusPoint.Withdraw(data, function (response) {
                        switch (response.ResponseCode) {
                            case 1:
                                w88Mobile.Growl.shout("<p>" + response.ResponseMessage + "</p> <p>" + '<%=lblTransactionId%>' + ": " + response.ResponseData.TransactionId + "</p>", function (event, ui) {
                                    window.location.replace('/Withdrawal/VenusPoint.aspx');
                                });
                                break;
                            default:
                                if (_.isArray(response.ResponseMessage))
                                    w88Mobile.Growl.shout(w88Mobile.Growl.bulletedList(response.ResponseMessage));
                                else
                                    w88Mobile.Growl.shout(response.ResponseMessage);

                                break;
                        }
                    },
                    function () {
                        window.w88Mobile.FormValidator.enableSubmitButton('#btnSubmit');
                        GPInt.prototype.HideSplash();
                    });
                });

                $("#txtAmount").blur(function () {
                    if ($(this).val() && '<%=commonCookie.CookieCurrency%>' == "JPY") {
                        var data = {
                            amount: $('#txtAmount').val(),
                            currencyFrom: "JPY",
                            currencyTo: "USD"
                        }

                        window.w88Mobile.Gateways.VenusPoint.ExchangeRate(data);
                    }
                });
            });
        </script>
    </div>
</body>
</html>
