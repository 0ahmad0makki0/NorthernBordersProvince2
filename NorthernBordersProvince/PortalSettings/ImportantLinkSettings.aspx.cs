using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class ImportantLinkSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("ImportantLinksSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsPortalUserAuthorized(4, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة الروابط الهامة", this, "ImportantLinksSettingsMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة رابط هام"; break;
                case "edit":
                    {
                        if (!FL.IsPortalUserAuthorized(4, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل الروابط الهامة", this, "ImportantLinksSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("ImportantLinksSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("ImportantLinksSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.ImportantLinks.Count(s => s.ImportantLink_Id == TestID) == 0) { Response.Redirect("ImportantLinksSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل رابط هام";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                default: Response.Redirect("ImportantLinksSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {

            if (Request.QueryString["ID"] == null) { Response.Redirect("ImportantLinksSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("ImportantLinksSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            ImportantLink importantLink = ctx.ImportantLinks.First(s => s.ImportantLink_Id == TestID);
            txtTitle.Text = importantLink.Title;
            txtLink.Text = importantLink.Link;
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            ImportantLink importantLink = new ImportantLink();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة الرابط الهام بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل الرابط الهام بنجاح";
                long ImportantLink_Id = long.Parse(Request.QueryString["ID"]);
                importantLink = ctx.ImportantLinks.First(s => s.ImportantLink_Id == ImportantLink_Id);
            }
            if (txtTitle.Text.Replace(" ", "") == "")
            {
                txtTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtLink.Text.Replace(" ", "") == "")
            {
                txtLink.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال جميع الحقول الإلزامية", this);
            }
            else
            {
                importantLink.Title = txtTitle.Text;
                importantLink.Link = txtLink.Text.StartsWith("http://") ? txtLink.Text : (txtLink.Text.StartsWith("https://") ? txtLink.Text : txtLink.Text.StartsWith("~") ? txtLink.Text :
                    txtLink.Text.StartsWith("..") ? txtLink.Text : txtLink.Text.StartsWith("/") ? txtLink.Text : txtLink.Text.StartsWith("\\") ? txtLink.Text : "http://" + txtLink.Text);

                if (Mode.ToLower() == "add")
                {
                    ctx.ImportantLinks.AddObject(importantLink);
                }

                ctx.SaveChanges();

                FL.ConfirmationMessage(CompletedMsg, this, "ImportantLinksSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("ImportantLinksSettingsMain.aspx");
        }
    }
}