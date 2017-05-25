﻿using System;
using Helpers;

public partial class v2_Account_Default : BasePage
{
    protected override void OnLoad(EventArgs e)
    {
        Page.Items.Add("Parent", Pages.Dashboard);
        base.OnLoad(e);
    }

    protected override void OnPreInit(EventArgs e)
    {
        this.isPublic = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}