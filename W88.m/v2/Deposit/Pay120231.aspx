﻿<%@ Page Title="" Language="C#" MasterPageFile="~/v2/MasterPages/Payment.master" AutoEventWireup="true" CodeFile="Pay120231.aspx.cs" Inherits="v2_Deposit_Pay120231" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PaymentMainContent" Runat="Server">
     <div class="form-group">
        <asp:Label ID="lblAmount" runat="server" AssociatedControlID="txtAmount" />
        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" required data-paylimit="0" data-numeric />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptsHolder" Runat="Server">
    <script type="text/javascript" src="/_static/v2/assets/js/gateways/quickonline.js?v=<%=ConfigurationManager.AppSettings.Get("scriptVersion") %>"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            _w88_paymentSvcV2.setPaymentTabs("<%=base.PaymentType %>", "<%=base.PaymentMethodId %>");
            _w88_paymentSvcV2.DisplaySettings("<%=base.PaymentMethodId %>", { type: "<%=base.PaymentType %>" });

            window.w88Mobile.Gateways.QuickOnlineV2.init("<%=base.PaymentMethodId %>", false);

            $('#form1').validator().on('submit', function (e) {

                if (!e.isDefaultPrevented()) {
                    e.preventDefault();
                    var data = {
                        Amount: $('input[id$="txtAmount"]').autoNumeric('get'),
                        ThankYouPage: location.protocol + "//" + location.host + "/Index",
                        MethodId: "<%=base.PaymentMethodId%>"
                    };

                    var params = decodeURIComponent($.param(data));
                    window.open(_w88_paymentSvcV2.payRoute + "?" + params, "<%=base.PageName%>");
                    _w88_paymentSvcV2.onTransactionCreated($(this));
                    return;
                }
            });

        });

    </script>
</asp:Content>

