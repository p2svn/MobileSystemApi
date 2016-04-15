﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="_Secure_Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta name="viewport" content="width=device-width,height=device-height,initial-scale=1.0" />
    <title><%=commonCulture.ElementValues.getResourceString("brand", commonVariables.LeftMenuXML) + commonCulture.ElementValues.getResourceString("login", commonVariables.LeftMenuXML)%></title>
    <!--#include virtual="~/_static/head.inc" -->
    <script type="text/javascript" src="/_Static/Js/PreLoad.js"></script>
    <script type="text/javascript" src="/_Static/Js/Main.js"></script>
</head>
<body>
    <!--#include virtual="~/_static/splash.shtml" -->
    <div data-role="page" data-close-btn="right" data-corners="false" id="login">
        <header id="header" data-role="header" data-position="fixed" data-theme="b" data-tap-toggle="false">
            <a href="" role="button" data-rel="back" class="btn-clear ui-btn-left ui-btn ion-ios-arrow-back" id="aMenu" data-load-ignore-splash="true">
                <%=commonCulture.ElementValues.getResourceString("back", commonVariables.LeftMenuXML)%>
            </a>
            <h1 class="title"><%=commonCulture.ElementValues.getResourceString("login", commonVariables.LeftMenuXML)%></h1>
        </header>
        <div class="ui-content" role="main">
            <form class="form" id="form1" runat="server" data-ajax="false">
                <ul class="list fixed-tablet-size">
                    <li class="item item-icon-left item-input">
                        <i class="icon icon-profile"></i>
                        <asp:Label ID="lblUsername" runat="server" AssociatedControlID="txtUsername" Text="username" />
                        <asp:TextBox ID="txtUsername" runat="server" data-corners="false" autofocus="on" MaxLength="16" data-clear-btn="true" />
                    </li>
                    <li class="item item-icon-left item-input">
                        <i class="icon icon-password"></i>
                        <asp:Label ID="lblPassword" runat="server" AssociatedControlID="txtPassword" Text="password" />
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" data-corners="false" MaxLength="10" data-clear-btn="true" />
                    </li>
                    <li class="item item-icon-left item-input hide capt">
                        <i class="icon icon-check"></i>
                        <asp:Label ID="lblCaptcha" runat="server" AssociatedControlID="txtCaptcha" Text="code" />
                        <asp:Image ID="imgCaptcha" runat="server" CssClass="imgCaptcha" />
                        <asp:TextBox ID="txtCaptcha" runat="server" MaxLength="4" type="tel" data-mini="true" data-corners="false" />
                    </li>
                    <li class="item row">
                        <div class="col">
                            <a href="" role="button" data-rel="back" class="ui-btn btn-bordered"><%=commonCulture.ElementValues.getResourceString("cancel", commonVariables.LeftMenuXML)%></a>
                        </div>
                        <div class="col">
                            <asp:Button ID="btnSubmit" runat="server" Text="login" data-corners="false" />
                        </div>
                    </li>
                    <li class="item item-text-wrap">
                        <asp:Literal ID="lblRegister" runat="server" />
                    </li>
                </ul>
                <asp:HiddenField runat="server" ID="ioBlackBox" Value="" />
            </form>
        </div>
        <script type="text/javascript">

            var counter = 0;
            $('#<%=imgCaptcha.ClientID%>').attr('class', 'hide');
            $('#<%=lblCaptcha.ClientID%>').attr('class', 'hide');
            $('#<%=txtCaptcha.ClientID%>').attr('class', 'hide');

            $(function () { $('#<%=imgCaptcha.ClientID%>').attr('src', '/_Secure/Captcha.aspx?t=' + new Date().getTime()); });

            $('#form1').submit(function (e) {
                $('#btnSubmit').attr("disabled", true);
                if ($('#txtUsername').val().trim().length == 0) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("Login/MissingUsername", xeErrors)%>');
                    $('#btnSubmit').attr("disabled", false);
                    e.preventDefault();
                    return;
                }
                else if (!/^[a-zA-Z0-9]+$/.test($('#txtUsername').val().trim())) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("Login/InvalidUsername", xeErrors)%>');
                    $('#btnSubmit').attr("disabled", false);
                    e.preventDefault();
                    return;
                }
                else if ($('#txtUsername').val().trim().indexOf(' ') >= 0) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("Login/InvalidUsername", xeErrors)%>');
                    $('#btnSubmit').attr("disabled", false);
                    e.preventDefault();
                    return;
                }
                else if ($('#txtPassword').val().trim().length == 0) {
                    alert('<%=commonCulture.ElementValues.getResourceXPathString("Login/MissingPassword", xeErrors)%>');
                    $('#btnSubmit').attr("disabled", false);
                    e.preventDefault();
                    return;
                }
                else if ($('#txtCaptcha').val().trim().length == 0 && $('#imgCaptcha').is(':visible') == true) {
                    alert('<%=commonCulture.ElementValues.getResourceString("MissingVCode", xeErrors)%>');
                    $('#btnSubmit').attr("disabled", false);
                    e.preventDefault();
                    return;
                }
                else {
                    GPINTMOBILE.ShowSplash();

                    initiateLogin();
                    $('#btnSubmit').attr("disabled", false);
                    e.preventDefault();
                }
                e.preventDefault();
                return;
            });

            $('#<%=imgCaptcha.ClientID%>').click(function () { $(this).attr('src', '/_Secure/Captcha.aspx'); });

            function initiateLogin() {
                console.log('txt: ' + $('#txtCaptcha').val());
                $.ajax({
                    type: "POST",
                    url: '/_Secure/Login',
                    beforeSend: function () { GPINTMOBILE.ShowSplash(); },
                    timeout: function () {
                        $('#<%=btnSubmit.ClientID%>').prop('disabled', false);
                        alert('<%=commonCulture.ElementValues.getResourceString("Exception", xeErrors)%>');
                        window.location.replace('/Default.aspx');
                    },
                    data: { txtUsername: $('#txtUsername').val(), txtPassword: $('#txtPassword').val(), txtCaptcha: $('#txtCaptcha').val(), ioBlackBox: $('#ioBlackBox').val() },
                    success: function (xml) {
                        switch ($(xml).find('ErrorCode').text()) {
                            case "1":
                                switch ('<%=strRedirect%>') {
                                    case 'mlotto':
                                        window.location.replace('<%=commonLottery.getKenoUrl%>');
                                        break;
                                    default:
                                        window.location.replace('<%=strRedirect%>');
                                        break;
                                }

                                Cookies().setCookie('is_app', '0', 0);
                                break;
                            case "22":
                                var message = $(xml).find('Message').text();

                                $("#inactiveAcctText").html(message);
                                $("#inactiveAcctModal").popup();
                                $("#inactiveAcctModal").popup('open');

                                break;
                            case "resetPassword":
                                    window.location.replace('/Settings/ChangePassword.aspx?lang=<%=commonVariables.SelectedLanguage.ToLower()%>');
                                break;
                            default:

                                counter += 1;

                                if (counter >= 3) {
                                    $(".capt").removeClass("hide");
                                    $('#<%=imgCaptcha.ClientID%>').attr('class', 'show imgCaptcha');
                                    $('#<%=lblCaptcha.ClientID%>').attr('class', 'show imgCaptcha');
                                    $('#<%=txtCaptcha.ClientID%>').attr('class', 'show imgCaptcha');
                                    alert($(xml).find('Message').text());
                                    $('#<%=imgCaptcha.ClientID%>').attr('src', '/_Secure/Captcha.aspx?t=' + new Date().getTime());
                                    $('#<%=txtCaptcha.ClientID%>').val('');
                                    $('#<%=txtPassword.ClientID%>').val('');
                                    GPINTMOBILE.HideSplash();
                                }
                                else if (counter < 3) {
                                    alert($(xml).find('Message').text());
                                    GPINTMOBILE.HideSplash();
                                }
                                break;
                        }
                    },
                    error: function (err) {
                        alert('<%=commonCulture.ElementValues.getResourceString("Exception", xeErrors)%>');
                        window.location.replace('<%=strRedirect%>');
                    }
                });
            }
        </script>
        <script type="text/javascript" id="iovs_script">
	        var io_operation = 'ioBegin';
	        var io_bbout_element_id = 'ioBlackBox';
	        //var io_submit_element_id = 'btnSubmit';
	        var io_submit_form_id = 'form1';
	        var io_max_wait = 5000;
	        var io_install_flash = false;
	        var io_install_stm = false;
	        var io_exclude_stm = 12;
        </script>
        <script type="text/javascript" src="//ci-mpsnare.iovation.com/snare.js"></script>

        <div id="inactiveAcctModal" data-role="popup" data-overlay-theme="b" data-theme="b" data-history="false">
            <a href="#" data-rel="back" class="close close-enhanced">&times;</a>
            <br>
            <h1 class="title">
                <img src="/_Static/Images/logo-<%=commonVariables.SelectedLanguageShort%>.png" width="220" class="logo img-responsive" alt="logo">
            </h1>
            <div class="padding">
                <div class="download-app padding">
                    <div id="inactiveAcctText">
                    </div>
                </div>
            </div>
            <div class="row row-no-padding">
                <div class="col">
                    <a href="#" data-rel="back" class="ui-btn btn-primary"><%=commonCulture.ElementValues.getResourceString("close", commonVariables.LeftMenuXML)%>
                    </a>
                </div>
            </div>
        </div>

    </div>
</body>
</html>
