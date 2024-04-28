using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class ProvisionsMonitoring : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsBrowserFit(this.Page))
            {
                Response.Redirect("../NotValidBrowser.aspx");
                return;
            }

            if (Session["Username"] == null && Session["LocalLoginPassword"] == null)
            {
                Response.Redirect("../LoginPage.aspx?Mode=ProvisionsMonitoring");
                return;
            }
            if (!FL.Authenticate((string)Session["Username"], (string)Session["LocalLoginPassword"], "ProvisionsMonitoring", this.Page))
            {
                Response.Redirect("../LoginPage.aspx?Mode=ProvisionsMonitoring");
                return;
            }
        }
    }
}