using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class NewsSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("NewsSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsPortalUserAuthorized(2, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة الأخبار", this, "NewsSettingsMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة خبر";
                    if (!IsPostBack) txtDate.Text = FL.GetHijiriDateNow();
                    break;
                case "edit":
                    {
                        if (!FL.IsPortalUserAuthorized(2, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل الأخبار", this, "NewsSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("NewsSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("NewsSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.News.Count(s => s.News_Id == TestID) == 0) { Response.Redirect("NewsSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل خبر";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                default: Response.Redirect("NewsSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {

            if (Request.QueryString["ID"] == null) { Response.Redirect("NewsSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("NewsSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            News news = ctx.News.First(s => s.News_Id == TestID);
            txtTitle.Text = news.Title;
            txtContents.Text = news.Contents;
            txtDate.Text = FL.GetHijiriDate(news.NewsDate);
            if (news.ImageUrl != null)
            {
                LoadImage(news.ImageUrl);
                hfLastAction.Value = "default";
            }
        }

        private void LoadImage(string p)
        {
            imgPicture.Src = "../" + p;
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            News news = new News();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة الخبر بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل الخبر بنجاح";
                long News_Id = long.Parse(Request.QueryString["ID"]);
                news = ctx.News.First(s => s.News_Id == News_Id);
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
            if (txtContents.Text.Replace(" ", "") == "")
            {
                txtContents.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                if (Mode.ToLower() == "edit")
                {
                    if (hfLastAction.Value == "default")
                    {
                        LoadImage(news.ImageUrl);
                        hfLastAction.Value = "default";
                    }
                    else hfLastAction.Value = "empty";
                }
                else hfLastAction.Value = "empty";
                FL.ConfirmationMessage("الرجاء إدخال جميع الحقول الإلزامية", this);
            }
            else
            {
                news.Title = txtTitle.Text;
                news.Contents = txtContents.Text;
                news.NewsDate = FL.GetGeorgianDate(txtDate.Text);

                if (Mode.ToLower() == "add")
                {
                    news.ViewCount = 0;
                    ctx.News.AddObject(news);
                }

                ctx.SaveChanges();

                if (hfLastAction.Value == "new")
                {
                    if (Mode.ToLower() == "edit" && news.ImageUrl != null) System.IO.File.Delete(Server.MapPath("../" + news.ImageUrl));
                    string PictureFile = news.News_Id.ToString() + Path.GetExtension(Fud_Pic.PostedFile.FileName);
                    Fud_Pic.PostedFile.SaveAs(Server.MapPath("../Images/NewsImages/" + PictureFile));
                    news.ImageUrl = "Images/NewsImages/" + PictureFile;
                }
                else if (hfLastAction.Value == "empty")
                {
                    if (Mode.ToLower() == "edit" && news.ImageUrl != null) System.IO.File.Delete(Server.MapPath("../" + news.ImageUrl));
                    news.ImageUrl = null;
                }

                ctx.SaveChanges();

                FL.ConfirmationMessage(CompletedMsg, this, "NewsSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("NewsSettingsMain.aspx");
        }
    }
}