using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class RuleTypeSettingsForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsProvisionsMonitoringUserAuthorized(7, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة نوع القضية", this, "RuleTypesSettingsMain.aspx"); return; }
                    lblTitle.Text = "صفحة إضافة نوع القضية"; break;
                case "edit":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(7, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل نوع القضية", this, "RuleTypesSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleTypes.Count(s => s.RuleType_Id == TestID) == 0) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل نوع القضية";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(7, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض نوع القضية", this, "RuleTypesSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleTypes.Count(s => s.RuleType_Id == TestID) == 0) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض نوع القضية";
                        if (!IsPostBack) LoadData();
                        txtTitle.ReadOnly = true;
                        btnSave.Visible = false;

                        break;
                    }
                default: Response.Redirect("RuleTypesSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleTypesSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            RuleType ruleType = ctx.RuleTypes.First(s => s.RuleType_Id == TestID);
            txtTitle.Text = ruleType.Title;

            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddProvisionsMonitoringUserLog(7, 1, ruleType.Title);
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            RuleType ruleType = new RuleType();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة نوع القضية بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل نوع القضية بنجاح";
                long RuleType_Id = long.Parse(Request.QueryString["ID"]);
                ruleType = ctx.RuleTypes.First(s => s.RuleType_Id == RuleType_Id);
            }
            if (txtTitle.Text.Replace(" ", "") == "")
            {
                txtTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال نوع القضية", this);
            }
            else
            {
                if (Mode.ToLower() == "edit") FL.AddProvisionsMonitoringUserLog(7, 3, "من " + ruleType.Title + " إلى " + txtTitle.Text);

                ruleType.Title = txtTitle.Text;

                if (Mode.ToLower() == "add")
                {
                    ctx.RuleTypes.AddObject(ruleType);
                }

                ctx.SaveChanges();

                if (Mode.ToLower() == "add") FL.AddProvisionsMonitoringUserLog(7, 2, ruleType.Title);

                FL.ConfirmationMessage(CompletedMsg, this, "RuleTypesSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("RuleTypesSettingsMain.aspx");
        }
    }
}