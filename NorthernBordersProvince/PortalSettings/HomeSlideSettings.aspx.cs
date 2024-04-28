using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class HomeSlideSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("default.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsPortalUserAuthorized(1, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة شرائح العرض بالصفحة الرئيسية", this, "default.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة شريحة عرض للصفحة الرئيسية"; break;
                case "edit":
                    {
                        if (!FL.IsPortalUserAuthorized(1, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل شرائح العرض بالصفحة الرئيسية", this, "default.aspx"); return; }
                        if (Request.QueryString["ID"] == null) { Response.Redirect("default.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("default.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.HomeSlides.Count(s => s.HomeSlide_Id == TestID) == 0) { Response.Redirect("default.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل شريحة عرض للصفحة الرئيسية";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                default: Response.Redirect("default.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("default.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("default.aspx"); return; }
            DBEntities ctx = new DBEntities();
            HomeSlide slide = ctx.HomeSlides.First(s => s.HomeSlide_Id == TestID);
            txtDescription.Text = slide.Description;
            txtLink.Text = slide.RedirectingLink == null ? "" : slide.RedirectingLink;
            LoadImage(slide.ImageUrl);
        }

        private void LoadImage(string p)
        {
            imgPicture.Src = "../" + p;
            hfLastAction.Value = "exists";
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            HomeSlide slide = new HomeSlide();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة شريحة العرض للصفحة الرئيسية بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل شريح العرض للصفحة الرئيسية بنجاح";
                long Slide_Id = long.Parse(Request.QueryString["ID"]);
                slide = ctx.HomeSlides.First(s => s.HomeSlide_Id == Slide_Id);
            }
            if (hfLastAction.Value == "empty")
            {
                divFileUpload.Style["background-color"] = "Red";
                IsValid = false;
            }
            if (txtDescription.Text.Replace(" ", "") == "")
            {
                txtDescription.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                if (Mode.ToLower() == "edit") LoadImage(slide.ImageUrl);
                else hfLastAction.Value = "empty";
                FL.ConfirmationMessage("الرجاء إدخال جميع الحقول الإلزامية", this);
            }
            else
            {
                slide.Description = txtDescription.Text;
                slide.RedirectingLink = txtLink.Text.StartsWith("http://") ? txtLink.Text : (txtLink.Text.StartsWith("https://") ? txtLink.Text : txtLink.Text.StartsWith("~") ? txtLink.Text :
                    txtLink.Text.StartsWith("..") ? txtLink.Text : txtLink.Text.StartsWith("/") ? txtLink.Text : txtLink.Text.StartsWith("\\") ? txtLink.Text : "http://" + txtLink.Text);

                if (Mode.ToLower() == "add")
                {
                    ctx.HomeSlides.AddObject(slide);
                }

                ctx.SaveChanges();

                if (hfLastAction.Value == "new")
                {
                    if (Mode.ToLower() == "edit") System.IO.File.Delete(Server.MapPath("../" + slide.ImageUrl));
                    string PictureFile = slide.HomeSlide_Id.ToString() + Path.GetExtension(Fud_Pic.PostedFile.FileName);
                    Fud_Pic.PostedFile.SaveAs(Server.MapPath("../Images/Slides/" + PictureFile));
                    slide.ImageUrl = "Images/Slides/" + PictureFile;
                }

                ctx.SaveChanges();
                
                FL.ConfirmationMessage(CompletedMsg, this, "default.aspx");
            }
        }

        private void LoadImage()
        {
            throw new NotImplementedException();
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("default.aspx");
        }
    }
}