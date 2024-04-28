using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class PortalAdminUsersSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsPortalUserAuthorized(6, 1)) FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض إعدادات مسؤولين البوابة الإلكترونية", this, "Home.aspx");
            else ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnPortalAdminUsers');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "EditCommand")
                {
                    string k = gvContents.DataKeys[index].Value.ToString();
                    Response.Redirect("PortalAdminUserSettings.aspx?Mode=Edit&ID=" + k);
                }
                else if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsPortalUserAuthorized(6, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف مسؤولين البوابة الإلكترونية", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    PortalSettingsUser user = ctx.PortalSettingsUsers.First(n => n.PortalSettingsUser_Id == ID);
                    ctx.PortalSettingsUsers.DeleteObject(user);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}