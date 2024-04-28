using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class _default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string s = EncryptDecrypt.Encrypt("ep@123456");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnHome');", true);
            LoadSlides();
        }

        private void LoadSlides()
        {
            DBEntities ctx = new DBEntities();
            List<HomeSlide> slides = ctx.HomeSlides.ToList();
            string content = SlidesMaker(slides);
            if (content != "")
            {
                int N;
                lblContent.Text =
                    "<!--  Outer wrapper for presentation only, this can be anything you like -->" +
                        "<div id=\"banner-slide\" style=\"margin: 0 auto; margin-bottom:75px;\">" +
                            "<!-- start Basic Jquery Slider -->" +
                            "<ul class=\"bjqs\">" +
                                content +
                            "</ul>" +
                            "<!-- end Basic jQuery Slider -->" +
                        "</div>" +
                    "<!-- End outer wrapper -->" +
                    "<!-- attach the plug-in to the slider parent element and adjust the settings as required -->" +
                        "<script class=\"secret-source\">" +
                            "jQuery(document).ready(function ($) {" +
                                "$('#banner-slide').bjqs({" +
                                    "animtype: 'fade'," +
                                    "width: 1000," +
                                    "height: 550," +
                                    "responsive: true," +
                                    "randomstart: false," +
                                    "animspeed: 5000" +
                                "}," +
                                (Request.QueryString["SlideN"] == null ? "1" :
                                !int.TryParse(Request.QueryString["SlideN"], out N) ? "1" :
                                int.Parse(Request.QueryString["SlideN"]) > slides.Count ? "1" : Request.QueryString["SlideN"]) +
                                ");" +
                            "});" +
                        "</script>";
            }
        }

        private string SlidesMaker(List<HomeSlide> slides)
        {
            string SlideTemplate = "<li><img style=\"width: 100%;\" src=\"[L]\" title=\"[C]\"></li>";
            string SlideTemplateWithLink = "<li><a href=\"[S]\"><img style=\"width: 100%;\" src=\"[L]\" title=\"[C] ... &lt;a href=&quot;[S]&quot;&gt;المزيد&lt;/a&gt;\"></a></li>";
            string content = "";
            for (int i = 0; i < slides.Count; i++)
            {
                content +=
                    slides[i].RedirectingLink == null ?
                    SlideTemplate.Replace("[L]", slides[i].ImageUrl).Replace("[C]", slides[i].Description) :
                    SlideTemplateWithLink.Replace("[L]", slides[i].ImageUrl).Replace("[C]", slides[i].Description).Replace("[S]",slides[i].RedirectingLink);
            }
            return content;
        }
    }
}