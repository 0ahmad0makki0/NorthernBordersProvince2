using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NorthernBordersProvince
{
    public partial class EducationLevelSettingsMain : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsSecurityAffairsUserAuthorized(6, 1) &&
                !FL.IsSecurityAffairsUserAuthorized(6, 2) &&
                !FL.IsSecurityAffairsUserAuthorized(6, 3) &&
                !FL.IsSecurityAffairsUserAuthorized(6, 4)) FL.ConfirmationMessage("لا توجد لديك صلاحية على إعدادات المؤهلات الدراسية", this, "SettingsMain.aspx");
        }

        protected void gvContents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (e.CommandName == "DeleteCommand")
                {
                    if (!FL.IsSecurityAffairsUserAuthorized(6, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف المؤهلات الدراسية", this); return; }
                    string k = gvContents.DataKeys[index].Value.ToString();
                    long ID = long.Parse(k);
                    DBEntities ctx = new DBEntities();
                    EducationLevel educationLevel = ctx.EducationLevels.First(a => a.EducationLevel_Id == ID);

                    if (educationLevel.PeopleDatas.Count > 0)
                    {
                        FL.ConfirmationMessage("لا يمكن حذف هذا المؤهل الدراسي لإرتباطه ببيانات أشخاص", this);
                        return;
                    }

                    FL.AddSecurityAffairsUserLog(6, 4, educationLevel.Title);

                    ctx.EducationLevels.DeleteObject(educationLevel);
                    ctx.SaveChanges();
                    gvContents.DataBind();
                }
            }
            catch (Exception)
            { }
        }
    }
}