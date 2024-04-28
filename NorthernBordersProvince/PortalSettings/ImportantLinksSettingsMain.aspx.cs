using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class ImportantLinksSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsPortalUserAuthorized(4, 1)) FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض إعدادات الروابط الهامة", this, "Home.aspx");
            else ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnLinks');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "EditCommand")
                {
                    string k = gvContents.DataKeys[index].Value.ToString();
                    Response.Redirect("ImportantLinkSettings.aspx?Mode=Edit&ID=" + k);
                }
                else if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsPortalUserAuthorized(4, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف الروابط الهامة", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    ImportantLink importantLinks = ctx.ImportantLinks.First(n => n.ImportantLink_Id == ID);
                    ctx.ImportantLinks.DeleteObject(importantLinks);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}