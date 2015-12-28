﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FundTransfer.aspx.cs" Inherits="FundTransfer_Default" %>

<!DOCTYPE html>
<html>
<head>
    <title><%=commonCulture.ElementValues.getResourceString("brand", commonVariables.LeftMenuXML) + commonCulture.ElementValues.getResourceString("transfer", commonVariables.LeftMenuXML)%></title>
    <!--#include virtual="~/_static/head.inc" -->
    <script type="text/javascript" src="/_Static/Js/Main.js"></script>
    <style type="text/css">
        .page-content { max-width:700px; margin-left:auto; margin-right:auto; }
        .button-blue {}
        .auto-style1 {
            width: 9px;
        }
    </style>
</head>
<body>
    <!--#include virtual="~/_static/splash.shtml" -->
    <div data-role="page">

        <div class="ui-content" role="main">
            <div class="div-page-header"><span>Wallet Transfer</span></div>
            <div class="page-content">
                <form id="form1" runat="server" data-ajax="false">
                    <div class="div-content-wrapper">
                        <div runat="server" id="divBalance" data-role="collapsible" data-mini="true" data-theme="a" data-content-theme="b">
                        </div>
                        <div>
                            <div class="ui-field-contain ui-hide-label">
                                <asp:Label ID="lblTransferFrom" runat="server" AssociatedControlID="drpTransferFrom" Text="from" CssClass="ui-hidden-accessible" />
                                <asp:DropDownList data-theme="a" ID="drpTransferFrom" runat="server" data-corners="false" />
                            </div>
                        </div>
                        <%--<div><a href="javascript:void(0)" onclick="javascript:switchWallets();">switch</a></div>--%>
                        <div>
                            <div class="ui-field-contain ui-hide-label">
                                <asp:Label ID="lblTransferTo" runat="server" AssociatedControlID="drpTransferTo" Text="to" CssClass="ui-hidden-accessible" />
                                <asp:DropDownList data-theme="a" ID="drpTransferTo" runat="server" data-corners="false" />
                            </div>
                        </div>
                        <div>
                            <div class="ui-field-contain ui-hide-label">
                                <asp:Label ID="lblTransferAmount" runat="server" AssociatedControlID="txtPromoCode" Text="amount" CssClass="ui-hidden-accessible" />
                                <asp:TextBox ID="txtTransferAmount" runat="server" placeholder="amount" type="number" step="any" min="1" />
                            </div>
                        </div>
                        <div>
                            <asp:Literal ID="litExchangeRate" runat="server" />
                        </div>
                        <div id="divPromoCode" style="display: none;">
                            <div class="ui-field-contain ui-hide-label">
                                <asp:Label ID="lblPromoCode" runat="server" AssociatedControlID="txtPromoCode" Text="code" CssClass="ui-hidden-accessible" />
                                <asp:TextBox ID="txtPromoCode" runat="server" placeholder="code" />
                            </div>
                        </div>
                        <div><span id="litPromoDetails" /></div>
                        <div>
                            <asp:Button data-theme="b" ID="btnSubmit" runat="server" Text="login" CssClass="button-blue" OnClick="btnSubmit_Click" data-corners="false" />
                        </div>
                        <asp:HiddenField runat="server" ID="_repostcheckcode" />
                    </div>
                    <br />
                    <div>
                         <table style="width:100%">
                            <tr>
                                <td style="width:50%">
                                    <input type="button" data-theme="b" onclick="location.href = '/Deposit/Default_app.aspx';" value="<%=commonCulture.ElementValues.getResourceString("deposit", commonVariables.LeftMenuXML)%>" class="button-blue"  data-corners="false" />
                                </td>
                                <td style="width:50%">
                                     <input type="button" data-theme="b" onclick="location.href = '/Withdrawal/Withrawal.aspx';" value="<%=commonCulture.ElementValues.getResourceString("withrawal", commonVariables.LeftMenuXML)%>" class="button-blue"  data-corners="false" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
        </div>
        <!-- /content -->
<%--        <!--#include virtual="~/_static/footer.shtml" -->
        <!--#include virtual="~/_static/navMenu.shtml" -->--%>

        <script type="text/javascript">

            $('#form1').submit(function (e) {
                if ($('#drpTransferFrom').val() == '-1') {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/SelectTransferFrom", xeErrors)%>');
                    e.preventDefault();
                    return;
                }
                else if ($('#drpTransferTo').val() == '-1') {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/SelectTransferTo", xeErrors)%>');
                    e.preventDefault();
                    return;
                }
                else if ($('#drpTransferFrom').val() == $('#drpTransferTo').val()) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/InvalidFundTransfer", xeErrors)%>');
                    e.preventDefault();
                    return;
                }
                else if (isNaN(parseFloat($('#txtTransferAmount').val()))) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/InputTransferAmount", xeErrors)%>');
                    e.preventDefault();
                    return;
                }
                else if (parseFloat($('#txtTransferAmount').val()) < 1) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/TransferAmountDisallowed", xeErrors)%>');
                    e.preventDefault();
                    return;
                }
                GPINTMOBILE.ShowSplash();
            });

            function switchWallets() {
                var valTransferFrom = $('#drpTransferFrom').val();
                $('#drpTransferFrom').val($('#drpTransferTo').val()).change();
                $('#drpTransferTo').val(valTransferFrom).change();
            }

            $(function () {

                window.history.forward();

                $('#drpTransferFrom').change(function () {

                    $('#drpTransferTo option').each(function () {
                        if ($(this).val() != '-1') {
                            if ($(this).val() == $('#drpTransferFrom').val()) { $(this).hide(); $('#drpTransferTo').val('-1').change(); }
                            else { $(this).show(); }
                        }
                    });
                   
                    if ($('#drpTransferFrom').val() == '6') {
                        $('#txtTransferAmount').attr('placeholder', ($('#txtTransferAmount').attr('placeholder').replace('(<%=commonVariables.GetSessionVariable("CurrencyCode")%>)', '(USD)')));
                    } else {
                        $('#txtTransferAmount').attr('placeholder', ($('#txtTransferAmount').attr('placeholder').replace('(USD)', '(<%=commonVariables.GetSessionVariable("CurrencyCode")%>)')));
                    }

                    if ($('#drpTransferFrom').val() == '0') { $('#divPromoCode').show(); }
                    else { $('#divPromoCode').hide(); }
                });

                $('#txtPromoCode').on('input', function () {
                   var strCode = $('#txtPromoCode').val();
                   if (parseInt($('#drpTransferFrom').val()) == 0 && parseInt($('#drpTransferTo').val()) > 0 && strCode.length > 0) {
                       var strWallet = $('#drpTransferTo').val();
                       var strAmount = $('#txtTransferAmount').val();

                       $.ajax({
                           type: 'POST',
                           url: '/AjaxHandlers/CheckPromo.ashx',
                           data: { Wallet: strWallet, Amount: strAmount, Code: strCode },
                           //dataType: "text/xml",
                           success: function (xml) {
                               var strStatusCode = $(xml).find('statusCode').text();
                               var strBonus = $(xml).find('bonusAmount').text();
                               var strRollover = $(xml).find('rolloverAmount').text();
                               var strMin = $(xml).find('minTransferAmount').text();

                               switch (strStatusCode) {
                                   case '00':
                                       $('#litPromoDetails').text('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/BonusAmount", xeErrors)%>' + strBonus);
                                       break;
                                   case '103':
                                       $('#litPromoDetails').text('<%=commonCulture.ElementValues.getResourceXPathString("/FundTransfer/RolloverNotMet", xeErrors)%>');
                                       break;
                                   case '109':
                                       $('#litPromoDetails').text('<%=commonCulture.ElementValues.getResourceXPathString("/Promotion/PromoAlreadyClaimed", xeErrors)%>');
                                       break;
                                   case '100':
                                   case '101':
                                   case '102':
                                   case '104':
                                   case '105':
                                   case '106':
                                   case '107':
                                   case '108':
                                       $('#litPromoDetails').text('<%=commonCulture.ElementValues.getResourceXPathString("/Promotion/InvalidPromo", xeErrors)%>');
                                       break;
                               }
                           }
                       });
                   } else { $('#litPromoDetails').text(''); }
                });

                if ('<%=strAlertMessage%>'.length > 0) { alert('<%=strAlertMessage%>'.split('[break]').join('\n')); }
                if ('<%=strAlertCode%>'.length > 0) { 
                    switch('<%=strAlertCode%>')
                    {
                        case "-1":
                            window.location.replace('/default.aspx');
                            break;
                    }
                }
            });

            function hBalanceToggle(obj, strShow, strHide)
            {
                if ($(obj).hasClass('ui-collapsible-heading-collapsed')) {
                    $(obj).find(".ui-btn-text").text(strHide);
                    getBalance();
                }
                else { $(obj).find(".ui-btn-text").text(strShow); }
            }

            function getBalance()
            {
                $(document).ready(function () {
                    $('span[name="WalletBalance"]').each(function () {
                        var objWallet = $(this);
                        var strWallet = objWallet.attr('id');
                        $.ajax({
                            type: "POST",
                            url: '/AjaxHandlers/GetBalance.ashx',
                            data: { Wallet: strWallet },
                            success: function (html) {
                                objWallet.text(html);
                            }
                        });
                    });
                });
            }
        </script>
    </div>
</body>
</html>