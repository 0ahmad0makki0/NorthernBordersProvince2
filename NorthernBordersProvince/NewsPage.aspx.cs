using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class NewsPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            long News_Id;
            if (Request.QueryString["ID"] == null) { RedirectToDefault();  return; }
            if (!long.TryParse(Request.QueryString["ID"], out News_Id)) { RedirectToDefault(); return; }
            DBEntities ctx = new DBEntities();
            if (ctx.News.Count(n => n.News_Id == News_Id) == 0) { RedirectToDefault(); return; }
            ctx.IncreaseNewsViewCount(News_Id);
            GetNewsById_Result result = ctx.GetNewsById(News_Id).First();
            lblTitle.Text = result.Title;
            lblDateAndViewCount.Text = "بتاريخ : " + result.NewsDate + " ، عدد المشاهدات " + result.ViewCount.ToString();
            lblContents.Text = "<P>" + result.Contents.Replace(Environment.NewLine, "<br />") +"</P>";
            if (result.ImageUrl != null)
            {
                lblContents.Text = "<img class=\"NewPageImage\" src=\"" + result.ImageUrl + "\">" + lblContents.Text;
                divNewsContent.Style["min-height"] = "225px";
            }
        }

        private void RedirectToDefault()
        {
            Response.Redirect("default.aspx");
        }
    }
}