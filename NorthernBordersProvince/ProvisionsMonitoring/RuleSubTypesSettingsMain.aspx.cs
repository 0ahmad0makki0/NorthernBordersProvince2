using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class RuleSubTypesSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(8, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(8, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(8, 3) &&
                !FL.IsProvisionsMonitoringUserAuthorized(8, 4)) FL.ConfirmationMessage("لا توجد لديك صلاحية على إعدادات أنواع القضايا الفرعية", this, "SettingsMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(8, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف نوع القضية الفرعي", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    RuleSubType ruleSubType = ctx.RuleSubTypes.First(a => a.RuleSubType_Id == ID);

                    try
                    {
                        ctx.RuleSubTypes.DeleteObject(ruleSubType);
                        FL.AddProvisionsMonitoringUserLog(8, 4, ruleSubType.Title);
                        ctx.SaveChanges();
                        gvContents.DataBind();
                    }
                    catch (Exception ex)
                    {
                        FL.ConfirmationMessage("لا يمكن حذف نوع القضية الفرعي لإرتباطها ببيانات الأحكام", this);
                        return;
                    }
                }
            }
            catch (Exception)
            { }
        }
    }
}