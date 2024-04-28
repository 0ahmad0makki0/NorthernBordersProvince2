using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class RuleDataMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(1, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(1, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(1, 3) &&
                !FL.IsProvisionsMonitoringUserAuthorized(1, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على معلومات الأحكام", this, "default.aspx"); return; }
            else 
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnRuleData');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(1, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف معلومات الأحكام", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    RuleData ruleData = ctx.RuleDatas.First(a => a.RuleData_Id == ID);

                    List<RuleDataAttachment> attachments = ruleData.RuleDataAttachments.ToList();
                    for (int i = 0; i < attachments.Count; i++)
                    {
                        System.IO.File.Delete(Server.MapPath("../Files/ProvisionsMonitoring/RuleData/" + attachments[i].Url));
                    }

                    FL.AddProvisionsMonitoringUserLog(1, 4, "قضية رقم : " + ruleData.CaseNumber + " ، على المتهم " + ruleData.AccusedName + " [" + ruleData.AccusedSSN + "]");

                    ctx.RuleDatas.DeleteObject(ruleData);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}