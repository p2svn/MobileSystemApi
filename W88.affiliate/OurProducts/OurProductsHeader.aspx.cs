﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class OurProducts_OurProductsHeader : System.Web.UI.Page
{
    protected System.Xml.Linq.XElement xeResources = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        commonCulture.appData.getRootResource("/OurProducts.aspx", out xeResources);
               
    }
}