using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class ProvisionsMonitoringUsersSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(6, 1)) FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على إعدادات مستخدمين النظام", this, "SettingsMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "EditCommand")
                {
                    string k = gvContents.DataKeys[index].Value.ToString();
                    Response.Redirect("ProvisionsMonitoringUsersSettingsForm.aspx?Mode=Edit&ID=" + k);
                }
                else if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsProvisionsMonitoringUserAuthorized(6, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف مستخدمين النظام", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    ProvisionsMonitoringUser user = ctx.ProvisionsMonitoringUsers.First(n => n.ProvisionsMonitoringUser_Id == ID);
                    FL.AddProvisionsMonitoringUserLog(6, 4, user.Username);
                    ctx.ProvisionsMonitoringUsers.DeleteObject(user);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}