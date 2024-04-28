using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class RuleStatusSettingsForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsProvisionsMonitoringUserAuthorized(5, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة حالة التنفيذ", this, "RuleStatusSettingsMain.aspx"); return; }
                    lblTitle.Text = "صفحة إضافة حالة التنفيذ"; break;
                case "edit":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(5, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل حالة التنفيذ", this, "RuleStatusSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleStatus.Count(s => s.RuleStatus_Id == TestID) == 0) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل حالة التنفيذ";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(5, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض حالة التنفيذ", this, "RuleStatusSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleStatus.Count(s => s.RuleStatus_Id == TestID) == 0) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض حالة التنفيذ";
                        if (!IsPostBack) LoadData();
                        txtTitle.ReadOnly = true;
                        btnSave.Visible = false;

                        break;
                    }
                default: Response.Redirect("RuleStatusSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleStatusSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            RuleStatu ruleStatus = ctx.RuleStatus.First(s => s.RuleStatus_Id == TestID);
            txtTitle.Text = ruleStatus.Title;

            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddProvisionsMonitoringUserLog(5, 1, ruleStatus.Title);
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            RuleStatu ruleStatus = new RuleStatu();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة حالة التنفيذ بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل حالة التنفيذ بنجاح";
                long RuleStatus_Id = long.Parse(Request.QueryString["ID"]);
                ruleStatus = ctx.RuleStatus.First(s => s.RuleStatus_Id == RuleStatus_Id);
            }
            if (txtTitle.Text.Replace(" ", "") == "")
            {
                txtTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال حالة التنفيذ", this);
            }
            else
            {
                if (Mode.ToLower() == "edit") FL.AddProvisionsMonitoringUserLog(5, 3, "من " + ruleStatus.Title + " إلى " + txtTitle.Text);

                ruleStatus.Title = txtTitle.Text;

                if (Mode.ToLower() == "add")
                {
                    ctx.RuleStatus.AddObject(ruleStatus);
                }

                ctx.SaveChanges();

                if (Mode.ToLower() == "add") FL.AddProvisionsMonitoringUserLog(5, 2, ruleStatus.Title);

                FL.ConfirmationMessage(CompletedMsg, this, "RuleStatusSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("RuleStatusSettingsMain.aspx");
        }
    }
}