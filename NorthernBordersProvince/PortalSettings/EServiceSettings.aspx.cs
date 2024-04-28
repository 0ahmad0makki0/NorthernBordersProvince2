using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class EServiceSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("EServicesSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsPortalUserAuthorized(5, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة الخدمات الإلكترونية", this, "EServicesSettingsMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة رابط خدمة إلكترونية"; break;
                case "edit":
                    {
                        if (!FL.IsPortalUserAuthorized(5, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل الخدمات الإلكترونية", this, "EServicesSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("EServicesSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("EServicesSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.EServices.Count(s => s.EService_Id == TestID) == 0) { Response.Redirect("EServicesSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل رابط خدمة إلكترونية";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                default: Response.Redirect("EServicesSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {

            if (Request.QueryString["ID"] == null) { Response.Redirect("EServicesSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("EServicesSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            EService eService = ctx.EServices.First(s => s.EService_Id == TestID);
            txtTitle.Text = eService.Title;
            txtLink.Text = eService.Link;
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            EService eService = new EService();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة رابط الخدمة الإلكترونية بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل رابط الخدمة الإلكترونية بنجاح";
                long EService_Id = long.Parse(Request.QueryString["ID"]);
                eService = ctx.EServices.First(s => s.EService_Id == EService_Id);
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
                eService.Title = txtTitle.Text;
                eService.Link = txtLink.Text.StartsWith("http://") ? txtLink.Text : (txtLink.Text.StartsWith("https://") ? txtLink.Text : txtLink.Text.StartsWith("~") ? txtLink.Text : 
                    txtLink.Text.StartsWith("..") ? txtLink.Text : txtLink.Text.StartsWith("/") ? txtLink.Text : txtLink.Text.StartsWith("\\") ? txtLink.Text : "http://" + txtLink.Text);

                if (Mode.ToLower() == "add")
                {
                    ctx.EServices.AddObject(eService);
                }

                ctx.SaveChanges();

                FL.ConfirmationMessage(CompletedMsg, this, "EServicesSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("EServicesSettingsMain.aspx");
        }
    }
}