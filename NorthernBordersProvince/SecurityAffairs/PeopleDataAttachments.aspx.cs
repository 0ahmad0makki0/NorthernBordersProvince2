using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class PeopleDataAttachments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsSecurityAffairsUserAuthorized(3, 1) &&
                !FL.IsSecurityAffairsUserAuthorized(3, 2) &&
                !FL.IsSecurityAffairsUserAuthorized(3, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على مرفقات الأشخاص", this, "PeopleDataMain.aspx"); return; } 

            if (Request.QueryString["ID"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PeopleDataMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            if (ctx.PeopleDatas.Count(s => s.PeopleData_Id == TestID) == 0) { Response.Redirect("PeopleDataMain.aspx"); return; }
            PeopleData peopleData = ctx.PeopleDatas.First(pd => pd.PeopleData_Id == TestID);
            lblTitle.Text = "صفحة الملفات المرفقة ل" + peopleData.FullName + " [" + peopleData.SSN + "]";
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (!FL.IsSecurityAffairsUserAuthorized(3, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة مرفقات الأشخاص", this); return; }

            long PeopleData_Id = long.Parse(Request.QueryString["ID"]);

            PeopleDataAttachment attachment = new PeopleDataAttachment() {
                PeopleData_Id = PeopleData_Id,
                Description = txtFileName.Text,
                UploadedDate = DateTime.Now,
                UploadedTime = DateTime.Now.TimeOfDay
            };

            DBEntities ctx = new DBEntities();
            ctx.PeopleDataAttachments.AddObject(attachment);
            ctx.SaveChanges();

            string FileName = attachment.PeopleDataAttachment_Id.ToString() + Path.GetExtension(Fud_Pic.PostedFile.FileName);
            Fud_Pic.PostedFile.SaveAs(Server.MapPath("../Files/SecurityAffairs/PeopleData/" + FileName));

            txtFileName.Text = "";

            attachment.Url = FileName;

            ctx.SaveChanges();

            FL.AddSecurityAffairsUserLog(3, 2, attachment.PeopleData.FullName + " [" + attachment.PeopleData.SSN + "] ، ملف بإسم " + attachment.Description);

            gvContents.DataBind();

            FL.ConfirmationMessage("تم إضافة الملف بنجاح", this);
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("PeopleDataMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsSecurityAffairsUserAuthorized(3, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف مرفقات الأشخاص", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    PeopleDataAttachment attachment = ctx.PeopleDataAttachments.First(a => a.PeopleDataAttachment_Id == ID);
                    System.IO.File.Delete(Server.MapPath("../Files/SecurityAffairs/PeopleData/" + attachment.Url));
                    FL.AddSecurityAffairsUserLog(3, 4, attachment.PeopleData.FullName + " [" + attachment.PeopleData.SSN + "] ، ملف بإسم " + attachment.Description);
                    ctx.PeopleDataAttachments.DeleteObject(attachment);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
                else if (e.CommandName == "ShowCommand")
                {
                    if (!FL.IsSecurityAffairsUserAuthorized(3, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض مرفقات الأشخاص", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    PeopleDataAttachment attachment = ctx.PeopleDataAttachments.First(a => a.PeopleDataAttachment_Id == ID);
                    FL.AddSecurityAffairsUserLog(3, 1, attachment.PeopleData.FullName + " [" + attachment.PeopleData.SSN + "] ، ملف بإسم " + attachment.Description);
                    FL.RunJSFun("window.open('../Files/SecurityAffairs/PeopleData/" + attachment.Url + "', '_blank');", this);
                }
            }
            catch (Exception)
            { }
        }
    }
}