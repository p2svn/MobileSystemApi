﻿using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Configuration;

public partial class LiveChat_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            string strPageName = "LiveChat";
            string strMemberId = string.Empty;
            string strMemberCode = string.Empty;
            string riskId = string.Empty;

            try
            {
                string strMemberName = commonVariables.GetSessionVariable("MemberName");
                string shortlang = commonVariables.SelectedLanguageShort;
                string lang = commonVariables.SelectedLanguage.ToLower();
                bool isVIP = false;

                string value = commonVariables.GetSessionVariable("priorityVIP");
                string CurrentUrl = System.Web.HttpContext.Current.Request.Url.ToString();

                Uri myUri = new Uri(CurrentUrl);
                //Uri myUri = new Uri("http://m.w88vv.asia/");
                string[] host = myUri.Host.Split('.');
                string domain = string.Format(ConfigurationManager.AppSettings["WebHandler2"], host[1], host[2]);

                string chatLang = string.Empty;
                string skill = string.Empty;

                string platform = "Mobile";
                string redirectLink = string.Empty;


                if (!string.IsNullOrEmpty(base.userInfo.CurrentSessionId))
                {
                    strMemberId = base.userInfo.MemberId;
                    strMemberCode = base.userInfo.MemberCode;
                    riskId = commonVariables.GetSessionVariable("RiskId");

                    if (riskId.Length >= 3)
                    {
                        if (riskId.Trim().ToLower() == "vipg" || riskId.ToLower() == "vipd" || riskId.ToLower() == "vipp")
                            isVIP = true;
                    }
                }

                //BO settings integration
                try
                {
                    //Uncomment to enable LivePerson Mobile//
                    //if (lang == "zh-cn" || lang == "vi-vn")
                    //{
                    //    redirectLink = string.Format(ConfigurationManager.AppSettings["LivePersonMobile2"],host[1],host[2]);
                    //}
                    //if (lang == "en-us")
                    //{
                    //    if (isVIP)
                    //    {
                    //        redirectLink = "http://www.livehelpnow.net/lhn/livechatvisitor.aspx?lhnid=26982&zzwindow=29999&custom1=&custom2=&custom3=" + strMemberId;
                    //    }
                    //    else
                    //    {
                    //        redirectLink = "http://www.livehelpnow.net/lhn/livechatvisitor.aspx?lhnid=26982&zzwindow=29995&custom1=&custom2=&custom3=" + strMemberId;
                    //    }
                    //}
                    //else
                    //{
                    redirectLink = domain + CurrentUrl;
                    //}

                    //redirectLink = domain + CurrentUrl;
                }
                catch (Exception)
                {
                    if (shortlang == "en" || shortlang == "kh" || shortlang == "kr" || shortlang == "th" || shortlang == "jp" || shortlang == "id" || shortlang == "vn")
                    {
                        #region livezilla

                        string KM = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes("KM"));
                        var code1 = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(strMemberCode));
                        var code2 = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(platform));
                        var code3 = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(CurrentUrl));
                        var code4 = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(strMemberId));
                        var code5 = Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(System.Web.HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"].ToString()));

                        if (string.IsNullOrEmpty(strMemberCode) || string.IsNullOrEmpty(strMemberId))
                        {
                            code1 = "";
                            code4 = "";

                            switch (shortlang)//null member
                            {
                                case "en":
                                    redirectLink = "http://en.chat.liveperson88.com/chat.php?a=1bb6a&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&rgs=MQ__";
                                    break;
                                case "kh":
                                    redirectLink = "http://kh.chat.liveperson88.com/chat.php?a=d1712&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&rgs=MQ__&el=" + KM;
                                    break;
                                case "kr":
                                    redirectLink = "http://kr.chat.liveperson88.com/chat.php?a=7b233&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "th":
                                    redirectLink = "http://th.chat.liveperson88.com/chat.php?a=d4a99&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "id":
                                    redirectLink = "http://id.chat.liveperson88.com/chat.php?a=5c303&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "jp":
                                    redirectLink = "http://jp.chat.liveperson88.com/chat.php?a=f3c22&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "vn":
                                    redirectLink = "http://vn.chat.liveperson88.com/chat.php?a=1052a&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "cn":
                                    redirectLink = "http://cn.chat.liveperson88.com/chat.php?a=1cbe6&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                default:
                                    redirectLink = "http://en.chat.liveperson88.com/chat.php?a=1bb6a&hg=P1ZJUA__&hg=P01hbmFnZXI_&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&rgs=MQ__";
                                    break;

                            }
                        }
                        else
                        {
                            switch (shortlang)
                            {
                                case "en":
                                    if (isVIP)
                                        redirectLink = "http://en.chat.liveperson88.com/chat.php?a=a08c2&intgroup=VklQ&hg=Pw__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__";
                                    else
                                        redirectLink = "http://en.chat.liveperson88.com/chat.php?a=1bb6a&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&rgs=MQ__";
                                    break;
                                case "kh":
                                    if (isVIP)
                                        redirectLink = "http://kh.chat.liveperson88.com/chat.php?a=35df1&intgroup=VklQ&hg=Pw__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&el=" + KM;
                                    else
                                        redirectLink = "http://kh.chat.liveperson88.com/chat.php?a=d1712&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&rgs=MQ__&el=" + KM;
                                    break;
                                case "kr":
                                    if (isVIP)
                                        redirectLink = "http://kr.chat.liveperson88.com/chat.php?a=581f1&intgroup=VklQ&hg=Pw__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}";
                                    else
                                        redirectLink = "http://kr.chat.liveperson88.com/chat.php?a=7b233&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "th":
                                    if (isVIP)
                                        redirectLink = "http://th.chat.liveperson88.com/chat.php?a=0db09&intgroup=VklQ&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}";
                                    else
                                        redirectLink = "http://th.chat.liveperson88.com/chat.php?a=d4a99&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "id":
                                    if (isVIP)
                                        redirectLink = "http://id.chat.liveperson88.com/chat.php?a=f7bd2&intgroup=VklQ&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}";
                                    else
                                        redirectLink = "http://id.chat.liveperson88.com/chat.php?a=5c303&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "jp":
                                    if (isVIP)
                                        redirectLink = "http://jp.chat.liveperson88.com/chat.php?a=e94d5&intgroup=VklQ&hg=Pw__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}";
                                    else
                                        redirectLink = "http://jp.chat.liveperson88.com/chat.php?a=f3c22&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "vn":
                                    if (isVIP)
                                        redirectLink = "http://vn.chat.liveperson88.com/chat.php?a=f9d71&intgroup=VklQ&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}";
                                    else
                                        redirectLink = "http://vn.chat.liveperson88.com/chat.php?a=1052a&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                case "cn":
                                    if (isVIP)
                                        redirectLink = "http://cn.chat.liveperson88.com/chat.php?a=dd1c7&intgroup=VklQ&hg=Pw__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}";
                                    else
                                        redirectLink = "http://cn.chat.liveperson88.com/chat.php?a=1cbe6&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&mp=MQ__&rgs=MQ__";
                                    break;
                                default:
                                    if (isVIP)
                                        redirectLink = "http://en.chat.liveperson88.com/chat.php?a=a08c2&intgroup=VklQ&hg=Pw__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__";
                                    else
                                        redirectLink = "http://en.chat.liveperson88.com/chat.php?a=1bb6a&hg=P1ZJUA__&en={0}&cf0={1}&cf1={2}&cf2={3}&cf3={4}&dl=MQ__&rgs=MQ__";
                                    break;
                            }
                        }
                        redirectLink = string.Format(redirectLink, code1, code2, code3, code4, code5);

                        #endregion livezilla

                    }
                    else
                    {
                        #region liveperson
                        if (isVIP)
                        {
                            switch (lang)
                            {
                                case "id":
                                    chatLang = "VIP-Bahasa"; skill = "VIP-Bahasa";
                                    break;
                                case "vn":
                                    chatLang = "VIP-TiengViet "; skill = "VIP-TiengViet ";
                                    break;
                                case "cn":
                                    chatLang = "VIP-Chinese "; skill = "VIP-Chinese ";
                                    break;
                                default:
                                    chatLang = "VIP-English"; skill = "VIP-English";
                                    break;
                            }
                        }
                        else
                        {
                            switch (shortlang)
                            {
                                case "id": chatLang = "Indonesia"; skill = "Indonesia"; break;
                                case "jp": chatLang = "Japanese"; skill = "Japanese"; break;
                                case "vn": chatLang = "Vietnamese"; skill = "Vietnamese"; break;
                                case "cn": chatLang = "Chinese"; skill = "Chinese"; break;
                                default: chatLang = "English"; break;
                            }
                        }
                        redirectLink = "https://server.iad.liveperson.net/hc/88942816/?cmd=file&file=visitorWantsToChat&site=88942816&SV!skill=" + skill + "&leInsId=88942816527642465&skId=1&leEngId=88942816_29aeab82-a5fc-4de7-b801-c6a87c638106&leEngTypeId=8&leEngName=LiveHelp_default&leRepAvState=3&referrer=" + CurrentUrl + "&SESSIONVAR!visitor_profile=" + chatLang;

                        #endregion liveperson
                    }
                }
                Response.Redirect(redirectLink, true);
            }
            catch (Exception ex)
            {

                commonAuditTrail.appendLog("system", strPageName, "PageLoad", "LivechatDefault.DLL", "", "", "Ex: " + ex.Message, "StackTrace: " + ex.StackTrace, "MemberId:" + strMemberId + ", MemberCode:" + strMemberCode + ", RiskId: " + riskId, "", "", true);
            }
        }
    }

}