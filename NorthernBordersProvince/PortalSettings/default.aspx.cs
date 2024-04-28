using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class PortalSettingsDefault : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsPortalUserAuthorized(1, 1)) FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض إعدادات شرائح عرض الصفحة الرئيسية", this, "Home.aspx");
            else ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnHome');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "EditCommand")
                {
                    string k = gvContents.DataKeys[index].Value.ToString();
                    Response.Redirect("HomeSlideSettings.aspx?Mode=Edit&ID=" + k);
                }
                else if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsPortalUserAuthorized(1, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف شرائح العرض بالصفحة الرئيسية", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    HomeSlide slide = ctx.HomeSlides.First(s => s.HomeSlide_Id == ID);
                    System.IO.File.Delete(Server.MapPath("../" + slide.ImageUrl));
                    ctx.HomeSlides.DeleteObject(slide);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}