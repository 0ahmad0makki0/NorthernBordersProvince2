using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class AnnouncementsSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsPortalUserAuthorized(3, 1)) FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض إعدادات التعاميم", this, "Home.aspx");
            else ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnAnnouncements');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "EditCommand")
                {
                    string k = gvContents.DataKeys[index].Value.ToString();
                    Response.Redirect("AnnouncementSettings.aspx?Mode=Edit&ID=" + k);
                }
                else if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsPortalUserAuthorized(3, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف التعاميم", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    Announcement announement = ctx.Announcements.First(a => a.Announcement_Id == ID);
                    System.IO.File.Delete(Server.MapPath("../" + announement.Link));
                    ctx.Announcements.DeleteObject(announement);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}