using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class AnnouncementSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("AnnouncementsSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsPortalUserAuthorized(3, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة التعاميم", this, "AnnouncementsSettingsMain.aspx"); return; }
                    lblTitle.Text = "صفحة إضافة تعميم";
                    if (!IsPostBack) txtDate.Text = FL.GetHijiriDateNow();
                    break;
                case "edit":
                    {
                        if (!FL.IsPortalUserAuthorized(3, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل التعاميم", this, "AnnouncementsSettingsMain.aspx"); return; }
                        if (Request.QueryString["ID"] == null) { Response.Redirect("AnnouncementsSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("AnnouncementsSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.Announcements.Count(s => s.Announcement_Id == TestID) == 0) { Response.Redirect("AnnouncementsSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل تعميم";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                default: Response.Redirect("AnnouncementsSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {

            if (Request.QueryString["ID"] == null) { Response.Redirect("AnnouncementsSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("AnnouncementsSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            Announcement announement = ctx.Announcements.First(s => s.Announcement_Id == TestID);
            txtTitle.Text = announement.Title;
            txtNumber.Text = announement.Number;
            txtDate.Text = FL.GetHijiriDate(announement.Date);
            hfLastAction.Value = "default";
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            Announcement announement = new Announcement();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة التعميم بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل التعميم بنجاح";
                long Announcement_Id = long.Parse(Request.QueryString["ID"]);
                announement = ctx.Announcements.First(s => s.Announcement_Id == Announcement_Id);
            }
            if (txtTitle.Text.Replace(" ", "") == "")
            {
                txtTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!FL.ValidateHijiriDate(txtDate.Text))
            {
                txtDate.Style["border"] = "5px solid Red";
                IsValid = false;
                txtDate.Text = "";
            }
            if (txtNumber.Text.Replace(" ", "") == "")
            {
                txtNumber.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (hfLastAction.Value == "empty")
            {
                divFileUpload.Style["background-color"] = "Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                if (Mode.ToLower() == "edit")
                {
                    if (hfLastAction.Value != "default") hfLastAction.Value = "empty";
                }
                else hfLastAction.Value = "empty";
                FL.ConfirmationMessage("الرجاء إدخال جميع الحقول الإلزامية", this);
            }
            else
            {
                announement.Title = txtTitle.Text;
                announement.Number = txtNumber.Text;
                announement.Date = FL.GetGeorgianDate(txtDate.Text);

                if (Mode.ToLower() == "add")
                {
                    announement.ViewCount = 0;
                    ctx.Announcements.AddObject(announement);
                }

                ctx.SaveChanges();

                if (hfLastAction.Value == "new")
                {
                    if (Mode.ToLower() == "edit") System.IO.File.Delete(Server.MapPath("../" + announement.Link));
                    string PictureFile = announement.Announcement_Id.ToString() + Path.GetExtension(Fud_Pic.PostedFile.FileName);
                    Fud_Pic.PostedFile.SaveAs(Server.MapPath("../Files/Announcements/" + PictureFile));
                    announement.Link = "Files/Announcements/" + PictureFile;
                }

                ctx.SaveChanges();

                FL.ConfirmationMessage(CompletedMsg, this, "AnnouncementsSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("AnnouncementsSettingsMain.aspx");
        }
    }
}