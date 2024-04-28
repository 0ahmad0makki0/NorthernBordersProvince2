using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class EducationLevelSettingsForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsSecurityAffairsUserAuthorized(6, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة المؤهلات الدراسية", this, "EducationLevelSettingsMain.aspx"); return; }
                    lblTitle.Text = "صفحة إضافة مؤهل دراسي"; break;
                case "edit":
                    {
                        if (!FL.IsSecurityAffairsUserAuthorized(6, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل المؤهلات الدراسية", this, "EducationLevelSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.EducationLevels.Count(s => s.EducationLevel_Id == TestID) == 0) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل مؤهل دراسي";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsSecurityAffairsUserAuthorized(6, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض المؤهلات الدراسية", this, "EducationLevelSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.EducationLevels.Count(s => s.EducationLevel_Id == TestID) == 0) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض مؤهل دراسي";
                        if (!IsPostBack) LoadData();
                        txtTitle.ReadOnly = true;
                        btnSave.Visible = false;

                        break;
                    }
                default: Response.Redirect("EducationLevelSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("EducationLevelSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            EducationLevel educationLevel = ctx.EducationLevels.First(s => s.EducationLevel_Id == TestID);
            txtTitle.Text = educationLevel.Title;

            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddSecurityAffairsUserLog(6, 1, educationLevel.Title);
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            EducationLevel educationLevel = new EducationLevel();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة المؤهل الدراسي بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل المؤهل الدراسي بنجاح";
                long EducationLevel_Id = long.Parse(Request.QueryString["ID"]);
                educationLevel = ctx.EducationLevels.First(s => s.EducationLevel_Id == EducationLevel_Id);
            }
            if (txtTitle.Text.Replace(" ", "") == "")
            {
                txtTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال المؤهل الدراسي", this);
            }
            else
            {
                if (Mode.ToLower() == "edit") FL.AddSecurityAffairsUserLog(6, 3, "من " + educationLevel.Title + " إلى " + txtTitle.Text);

                educationLevel.Title = txtTitle.Text;

                if (Mode.ToLower() == "add")
                {
                    ctx.EducationLevels.AddObject(educationLevel);
                }

                ctx.SaveChanges();

                if (Mode.ToLower() == "add") FL.AddSecurityAffairsUserLog(6, 2, educationLevel.Title);

                FL.ConfirmationMessage(CompletedMsg, this, "EducationLevelSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("EducationLevelSettingsMain.aspx");
        }
    }
}