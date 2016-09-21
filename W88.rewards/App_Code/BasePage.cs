﻿using System;
using System.Web;
using System.Web.UI;
using W88.BusinessLogic.Accounts.Models;
using W88.Rewards.BusinessLogic.Accounts.Helpers;
using W88.Rewards.BusinessLogic.Rewards.Helpers;
using W88.Rewards.BusinessLogic.Rewards.Models;
using W88.Utilities;
using MemberSession = W88.Rewards.BusinessLogic.Accounts.Models.MemberSession;

public class BasePage : Page
{
    protected bool HasSession = false;
    protected MemberSession MemberSession = null;
    protected UserSessionInfo UserSessionInfo = null;
    protected MemberRewardsInfo MemberRewardsInfo = null;

    protected override void OnPreInit(EventArgs e)
    {
        if (string.Compare(System.Configuration.ConfigurationManager.AppSettings.Get("ClearWebCache"), "true", true) == 0)
        {
            foreach (System.Collections.DictionaryEntry deCache in HttpContext.Current.Cache)
            {
                HttpContext.Current.Cache.Remove(Convert.ToString(deCache.Key));
            }
        }
        CheckSession();
        base.OnPreInit(e);
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
    }

    protected void CheckSession()
    {
        try
        {
            var token = HttpContext.Current.Request.Headers["token"];
            if (string.IsNullOrEmpty(token))
            {
                var cookie = HttpContext.Current.Request.Cookies["user"];
                if (cookie == null) return;
                var user = Common.DeserializeObject<W88.BusinessLogic.Accounts.Models.MemberSession>(cookie.Value);
                if (user == null) return;
                token = user.Token;
            }

            if (string.IsNullOrEmpty(token)) return;
            var memberHelper = new Members();
            var processCode = memberHelper.MembersSessionCheck(token);
            HasSession = processCode.Code == 1;
            if (!HasSession) return;
            MemberSession = processCode.Data;
            UserSessionInfo = memberHelper.GetMemberInfo(token);
            SetMemberRewardsInfo();
        }
        catch (Exception exception)
        {

        }
    }

    protected void SetMemberRewardsInfo()
    {
        if (MemberSession == null || UserSessionInfo == null) return;
        MemberRewardsInfo = new MemberRewardsInfo();
        MemberRewardsInfo.CurrentPoints = (new Members()).GetRewardsPoints(UserSessionInfo);
        MemberRewardsInfo.CurrentPointLevel = (new RewardsHelper()).GetPointLevel(MemberSession.MemberId);
    }
}