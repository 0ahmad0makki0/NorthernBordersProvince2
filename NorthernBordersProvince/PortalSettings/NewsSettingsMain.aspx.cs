using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class NewsSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsPortalUserAuthorized(2, 1)) FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض إعدادات الأخبار", this, "Home.aspx");
            else ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnNews');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "EditCommand")
                {
                    string k = gvContents.DataKeys[index].Value.ToString();
                    Response.Redirect("NewsSettings.aspx?Mode=Edit&ID=" + k);
                }
                else if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsPortalUserAuthorized(2, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف الأخبار", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    News news = ctx.News.First(n => n.News_Id == ID);
                    if (news.ImageUrl != null)
                        System.IO.File.Delete(Server.MapPath("../" + news.ImageUrl));
                    ctx.News.DeleteObject(news);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            {
            }
        }
    }
}