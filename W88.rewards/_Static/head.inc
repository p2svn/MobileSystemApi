<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="mobile-web-app-capable" content="yes"/>
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="apple-mobile-web-app-title" content="W88" />   
<link rel="apple-touch-icon" href="/_Static/Images/icon_76.png"/>
<link rel="apple-touch-startup-image" href="/_Static/Images/icon_120.png" />
<link rel="stylesheet" href="/_Static/Css/Mobile/jquery.mobile-1.4.5.min.css" />
<link rel="stylesheet" href="/_Static/Css/w88.mrewards.css" />
<%if(HttpContext.Current.Request.Url.AbsolutePath.ToLower().Contains("/_secure/vip/login")){%>
    <link rel="stylesheet" href="/_Secure/VIP/css/style.css" />
    <script src="/_Static/JS/dist/w88.mrewards.login.js"></script>
<%}%>
<script src="/_Static/JS/dist/w88.mrewards.js"></script>
<script>
    // set initial values for notification
    if(w88Mobile.Growl) {
        w88Mobile.Growl.options.lang = '<%=W88.BusinessLogic.Shared.Helpers.LanguageHelpers.SelectedLanguageShort%>';
        w88Mobile.Growl.options.close = '<%=W88.BusinessLogic.Rewards.Helpers.RewardsHelper.GetTranslation(W88.BusinessLogic.Rewards.Models.TranslationKeys.Label.Close)%>';
    }
    var sessionInterval = '<%=W88.Utilities.Common.GetAppSetting<string>("sessionInterval")%>',
        sessionId = '<%=BasePage.Token%>';
    window.onload = function() {
        $('.navbar-toggle').on('click', function () {
            $(this).toggleClass('active');
        });
        GPINTMOBILE.HideSplash();
        checkSession();
    };
</script>
<script src="/_Static/JS/dist/w88.mrewards.main.js"></script>
<script>
    var frsm_code = !_.isEmpty(window.user) && window.user.hasSession() ? window.user.MemberId : '';
</script>
<script src="//inpref-asia.s3.amazonaws.com/frosmo.easy.js"></script>
<script src="//inpref-asia.s3.amazonaws.com/sites/m_w88live_com.js"></script>
<script src="/_Static/JS/vendor/piwik.js"></script>
<meta name="viewport" id="viewport" content="width=device-width, initial-scale=1.0" />