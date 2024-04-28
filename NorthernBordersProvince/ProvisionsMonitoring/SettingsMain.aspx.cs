using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class ProvisionsMonitoringSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(5, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(5, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(5, 3) &&
                !FL.IsProvisionsMonitoringUserAuthorized(5, 4) &&
                !FL.IsProvisionsMonitoringUserAuthorized(6, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(6, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(6, 3) &&
                !FL.IsProvisionsMonitoringUserAuthorized(6, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على الإعدادات", this, "default.aspx"); return; }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnSettings');", true);

            LoadData();
        }

        private void LoadData()
        {
            DBEntities ctx = new DBEntities();
            List<string> titles = new List<string>();
            titles.Add("حالات تنفيذ الأحكام");
            titles.Add("أنواع القضايا");
            titles.Add("الأنواع الفرعية للقضايا");
            titles.Add("مستخدمين النظام");
            List<string> Links = new List<string>();
            Links.Add("RuleStatusSettingsMain.aspx");
            Links.Add("RuleTypesSettingsMain.aspx");
            Links.Add("RuleSubTypesSettingsMain.aspx");
            Links.Add("ProvisionsMonitoringUsersSettingsMain.aspx");
            string s = "";
            for (int i = 0; i <= titles.Count - 1; i++)
            {
                if (i < titles.Count - 2) s += "<div class=\"EServicesDiv OneThirdsWidth\"><a href=\"" + Links[i] + "\" ><div class=\"EServicesInnerDiv\">" + titles[i] + "</div></a></div>";
                else if (i == (titles.Count - 1) && i % 3 == 2) s += "<div class=\"EServicesDiv OneThirdsWidth\"><a href=\"" + Links[i] + "\" ><div class=\"EServicesInnerDiv\">" + titles[i] + "</div></a></div>";
                else if (i == (titles.Count - 1) && i % 3 == 1) s += "<div class=\"EServicesDiv OneHalfWidth\"><a href=\"" + Links[i] + "\" ><div class=\"EServicesInnerDiv\">" + titles[i] + "</div></a></div>";
                else if (i == (titles.Count - 1) && i % 3 == 0) s += "<div class=\"EServicesDiv OneThirdsWidth\" style=\"margin-right:399px;\"><a href=\"" + Links[i] + "\" ><div class=\"EServicesInnerDiv\">" + titles[i] + "</div></a></div>";
                else if (i == (titles.Count - 2) && i % 3 == 0) s += "<div class=\"EServicesDiv OneHalfWidth\"><a href=\"" + Links[i] + "\" ><div class=\"EServicesInnerDiv\">" + titles[i] + "</div></a></div>";
                else if (i == (titles.Count - 2) && i % 3 != 0) s += "<div class=\"EServicesDiv OneThirdsWidth\"><a href=\"" + Links[i] + "\" ><div class=\"EServicesInnerDiv\">" + titles[i] + "</div></a></div>";
            }
            if (s == "")
            {
                s += "<div class=\"EmptyDiv\">لا يوجد روابط لإعدادات لعرضها</div>";
            }
            else
            {
                int n = titles.Count / 3;
                if (titles.Count % 3 > 0) n++;
                divPageContents.Style.Add("Height", (n * 94.33).ToString() + "px");
            }
            lblContents.Text = s;
        }
    }
}