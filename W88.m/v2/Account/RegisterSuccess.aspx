﻿<%@ Page Language="C#" MasterPageFile="~/v2/MasterPages/Main.master" AutoEventWireup="true" CodeFile="RegisterSuccess.aspx.cs" Inherits="v2_Account_RegisterSuccess" %>


<asp:Content ID="MainContent" ContentPlaceHolderID="MainContentHolder" runat="Server">
    <div class="container">
        <div class="register-success-message">
            <div class="register-success-icon">
                <span class="icon-check-circle"></span>
            </div>
            <span data-i18n="[html]LABEL_REGISTER_SUCCESS"></span>
            <p class="payment-note"><small id="paymentNote"></small></p>
        </div>
        <div id="paymentTabs" class="register-gateway list-group">
        </div>
        <div class="bank_logo">
            <p><small id="reg-contact"></small></p>
            <i class="logo_10"></i>
            <i class="logo_11"></i>
            <i class="logo_12"></i>
            <i class="logo_13"></i>
            <i class="logo_14"></i>
            <i class="logo_15"></i>
        </div>
    </div>
</asp:Content>

<asp:Content ID="ScriptHolder" ContentPlaceHolderID="InnerScriptPlaceHolder" runat="server">
    <script src="<%=ConfigurationManager.AppSettings.Get("AssetsPath") %>/assets/js/modules/accounts/register.js?v=<%=ConfigurationManager.AppSettings.Get("scriptVersion") %>"></script>

    <script>
        $(document).ready(function () {
            _w88_register.initSuccess();
        });
    </script>
</asp:Content>
