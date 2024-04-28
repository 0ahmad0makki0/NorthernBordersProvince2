using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class RuleStatusSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(5, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(5, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(5, 3) &&
                !FL.IsProvisionsMonitoringUserAuthorized(5, 4)) FL.ConfirmationMessage("لا توجد لديك صلاحية على إعدادات حالات التنفيذ", this, "SettingsMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(5, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف حالة التنفيذ", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    RuleStatu ruleStatus = ctx.RuleStatus.First(a => a.RuleStatus_Id == ID);

                    if (ruleStatus.RuleDatas.Count > 0)
                    {
                        FL.ConfirmationMessage("لا يمكن حذف حالة التنفيذ لإرتباطها ببيانات الأحكام", this);
                        return;
                    }

                    FL.AddProvisionsMonitoringUserLog(5, 4, ruleStatus.Title);

                    ctx.RuleStatus.DeleteObject(ruleStatus);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}