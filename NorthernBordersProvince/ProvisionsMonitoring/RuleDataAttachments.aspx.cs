using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class RuleDataAttachments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(2, 1) &&
                !FL.IsProvisionsMonitoringUserAuthorized(2, 2) &&
                !FL.IsProvisionsMonitoringUserAuthorized(2, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على مرفقات الأحكام", this, "RuleDataMain.aspx"); return; } 

            if (Request.QueryString["ID"] == null) { Response.Redirect("RuleDataMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleDataMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            if (ctx.RuleDatas.Count(s => s.RuleData_Id == TestID) == 0) { Response.Redirect("RuleDataMain.aspx"); return; }
            RuleData ruleData = ctx.RuleDatas.First(pd => pd.RuleData_Id == TestID);
            lblTitle.Text = "صفحة الملفات المرفقة للقضية رقم " + ruleData.CaseNumber + " ، على المتهم " + ruleData.AccusedName + " [" + ruleData.AccusedSSN + "]";
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(2, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة مرفقات الأحكام", this); return; }

            long RuleData_Id = long.Parse(Request.QueryString["ID"]);

            RuleDataAttachment attachment = new RuleDataAttachment() {
                RuleData_Id = RuleData_Id,
                Description = txtFileName.Text,
                UploadedDate = DateTime.Now,
                UploadedTime = DateTime.Now.TimeOfDay
            };

            DBEntities ctx = new DBEntities();
            ctx.RuleDataAttachments.AddObject(attachment);
            ctx.SaveChanges();

            string FileName = attachment.RuleDataAttachment_Id.ToString() + Path.GetExtension(Fud_Pic.PostedFile.FileName);
            Fud_Pic.PostedFile.SaveAs(Server.MapPath("../Files/ProvisionsMonitoring/RuleData/" + FileName));

            txtFileName.Text = "";

            attachment.Url = FileName;

            ctx.SaveChanges();

            FL.AddProvisionsMonitoringUserLog(2, 2, "قضية رقم : " + attachment.RuleData.CaseNumber + " ، على المتهم " + attachment.RuleData.AccusedName + " [" + attachment.RuleData.AccusedSSN + "] ، ملف بإسم " + attachment.Description);

            gvContents.DataBind();

            FL.ConfirmationMessage("تم إضافة الملف بنجاح", this);
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("RuleDataMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(2, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف مرفقات الأحكام", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    RuleDataAttachment attachment = ctx.RuleDataAttachments.First(a => a.RuleDataAttachment_Id == ID);
                    System.IO.File.Delete(Server.MapPath("../Files/ProvisionsMonitoring/RuleData/" + attachment.Url));
                    FL.AddProvisionsMonitoringUserLog(2, 4, "قضية رقم : " + attachment.RuleData.CaseNumber + " ، على المتهم " + attachment.RuleData.AccusedName + " [" + attachment.RuleData.AccusedSSN + "] ، ملف بإسم " + attachment.Description);
                    ctx.RuleDataAttachments.DeleteObject(attachment);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
                else if (e.CommandName == "ShowCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(2, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض مرفقات الأحكام", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    RuleDataAttachment attachment = ctx.RuleDataAttachments.First(a => a.RuleDataAttachment_Id == ID);
                    FL.AddProvisionsMonitoringUserLog(2, 1, "قضية رقم : " + attachment.RuleData.CaseNumber + " ، على المتهم " + attachment.RuleData.AccusedName + " [" + attachment.RuleData.AccusedSSN + "] ، ملف بإسم " + attachment.Description);
                    FL.RunJSFun("window.open('../Files/ProvisionsMonitoring/RuleData/" + attachment.Url + "', '_blank');", this);
                }
            }
            catch (Exception)
            { }
        }
    }
}