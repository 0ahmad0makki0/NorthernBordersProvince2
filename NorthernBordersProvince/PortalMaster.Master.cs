using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class PortalMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsBrowserFit(this.Page))
            {
                Response.Redirect("NotValidBrowser.aspx");
            }
        }
    }
}