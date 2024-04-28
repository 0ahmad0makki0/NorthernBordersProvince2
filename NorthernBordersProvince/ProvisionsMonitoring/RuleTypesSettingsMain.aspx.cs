using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class RuleTypesSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(7, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(7, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(7, 3) &&
                !FL.IsProvisionsMonitoringUserAuthorized(7, 4)) FL.ConfirmationMessage("لا توجد لديك صلاحية على إعدادات أنواع القضايا", this, "SettingsMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(7, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف نوع القضية", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    RuleType ruleType = ctx.RuleTypes.First(a => a.RuleType_Id == ID);

                    try
                    {
                        ctx.RuleTypes.DeleteObject(ruleType);
                        FL.AddProvisionsMonitoringUserLog(7, 4, ruleType.Title);
                        ctx.SaveChanges();
                        gvContents.DataBind();
                    }
                    catch (Exception ex)
                    {
                        FL.ConfirmationMessage("لا يمكن حذف نوع القضية لإرتباطها ببيانات الأحكام", this);
                        return;
                    }
                }
            }
            catch (Exception)
            { }
        }
    }
}