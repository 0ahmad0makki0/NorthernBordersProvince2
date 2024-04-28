using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class AnnouncementPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            long Announcement_Id;
            if (Request.QueryString["ID"] == null) { RedirectToDefault();  return; }
            if (!long.TryParse(Request.QueryString["ID"], out Announcement_Id)) { RedirectToDefault(); return; }
            DBEntities ctx = new DBEntities();
            if (ctx.Announcements.Count(n => n.Announcement_Id == Announcement_Id) == 0) { RedirectToDefault(); return; }
            ctx.IncreaseAnnouncementViewCount(Announcement_Id);
            GetAnnouncementById_Result result = ctx.GetAnnouncementById(Announcement_Id).First();
            lblTitle.Text = result.Title;
            lblDateAndViewCount.Text = "تعميم رقم : " + result.Number + " ، بتاريخ : " + result.AnnounementDate + " ، عدد المشاهدات " + result.ViewCount.ToString();
            lblContents.Text =
                "<object data=\"" + result.Link + "\" type=\"application/pdf\" class=\"PDFViewer\">" +
                    "<p>تعميم رقم : " + result.Number + " - " + result.Link + "<a href=\"" + result.Link + "\">to the PDF!</a></p>" +
                "</object>";
        }

        private void RedirectToDefault()
        {
            Response.Redirect("default.aspx");
        }
    }
}