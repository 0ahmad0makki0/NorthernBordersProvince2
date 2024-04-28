using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class PeopleDataMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsSecurityAffairsUserAuthorized(1, 1) &&
                !FL.IsSecurityAffairsUserAuthorized(1, 2) &&
                !FL.IsSecurityAffairsUserAuthorized(1, 3) &&
                !FL.IsSecurityAffairsUserAuthorized(1, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على معلومات الأشخاص", this, "default.aspx"); return; } 
            //else 
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ntmtch", "DisableMenuButton('btnPeopleData');", true);
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsSecurityAffairsUserAuthorized(1, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف معلومات الأشخاص", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    PeopleData peopleData = ctx.PeopleDatas.First(a => a.PeopleData_Id == ID);

                    List<PeopleDataAttachment> attachments = peopleData.PeopleDataAttachments.ToList();
                    for (int i = 0; i < attachments.Count ; i++)
                    {
                        System.IO.File.Delete(Server.MapPath("../Files/SecurityAffairs/PeopleData/" + attachments[i].Url));
                    }

                    FL.AddSecurityAffairsUserLog(1, 4, peopleData.FullName + " [" + peopleData.SSN + "]");

                    ctx.PeopleDatas.DeleteObject(peopleData);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}