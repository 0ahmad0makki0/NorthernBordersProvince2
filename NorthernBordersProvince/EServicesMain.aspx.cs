using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class EServicesMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnEServices');", true);

            LoadData();
        }

        private void LoadData()
        {
            DBEntities ctx = new DBEntities();
            List<sp_GetEServices_Result> eservices = ctx.GetEServices_Result().ToList();
            string s = "";
            for (int i = 0; i <= eservices.Count - 1; i++)
            {
                if (i < eservices.Count - 2) s += "<div class=\"EServicesDiv OneThirdsWidth\"><a href=\"" + eservices[i].Link + "\" target=\"_blank\"><div class=\"EServicesInnerDiv\">" + eservices[i].Title + "</div></a></div>";
                else if (i == (eservices.Count - 1) && i % 3 == 2) s += "<div class=\"EServicesDiv OneThirdsWidth\"><a href=\"" + eservices[i].Link + "\" target=\"_blank\"><div class=\"EServicesInnerDiv\">" + eservices[i].Title + "</div></a></div>";
                else if (i == (eservices.Count - 1) && i % 3 == 1) s += "<div class=\"EServicesDiv OneHalfWidth\"><a href=\"" + eservices[i].Link + "\" target=\"_blank\"><div class=\"EServicesInnerDiv\">" + eservices[i].Title + "</div></a></div>";
                else if (i == (eservices.Count - 1) && i % 3 == 0) s += "<div class=\"EServicesDiv OneThirdsWidth\" style=\"margin-right:399px;\"><a href=\"" + eservices[i].Link + "\" target=\"_blank\"><div class=\"EServicesInnerDiv\">" + eservices[i].Title + "</div></a></div>";
                else if (i == (eservices.Count - 2) && i % 3 == 0) s += "<div class=\"EServicesDiv OneHalfWidth\"><a href=\"" + eservices[i].Link + "\" target=\"_blank\"><div class=\"EServicesInnerDiv\">" + eservices[i].Title + "</div></a></div>";
                else if (i == (eservices.Count - 2) && i % 3 != 0) s += "<div class=\"EServicesDiv OneThirdsWidth\"><a href=\"" + eservices[i].Link + "\" target=\"_blank\"><div class=\"EServicesInnerDiv\">" + eservices[i].Title + "</div></a></div>";
            }
            if (s == "")
            {
                s += "<div class=\"EmptyDiv\">لا يوجد خدمات إلكترونية لعرضها</div>";
            }
            else
            {
                int n = eservices.Count / 3;
                if (eservices.Count % 3 > 0) n++;
                divPageContents.Style.Add("Height", (n * 94.33).ToString() + "px");
            }
            lblContents.Text = s;
        }
    }
}