using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class RuleSubTypeSettingsForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsProvisionsMonitoringUserAuthorized(8, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة نوع القضية الفرعي", this, "RuleSubTypesSettingsMain.aspx"); return; }
                    lblTitle.Text = "صفحة إضافة نوع القضية الفرعي"; break;
                case "edit":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(8, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل نوع القضية الفرعي", this, "RuleSubTypesSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleSubTypes.Count(s => s.RuleSubType_Id == TestID) == 0) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل نوع القضية الفرعي";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(8, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض نوع القضية الفرعي", this, "RuleSubTypesSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleSubTypes.Count(s => s.RuleSubType_Id == TestID) == 0) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض نوع القضية الفرعي";
                        if (!IsPostBack) LoadData();
                        txtTitle.ReadOnly = true;
                        ddlRuleType.Enabled = false;
                        btnSave.Visible = false;
                        break;
                    }
                default: Response.Redirect("RuleSubTypesSettingsMain.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleSubTypesSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            RuleSubType ruleSubType = ctx.RuleSubTypes.First(s => s.RuleSubType_Id == TestID);
            txtTitle.Text = ruleSubType.Title;
            ddlRuleType.SelectedValue = ruleSubType.RuleType_Id.ToString();
            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddProvisionsMonitoringUserLog(8, 1, ruleSubType.Title);
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            RuleSubType ruleSubType = new RuleSubType();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة نوع القضية الفرعي بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل نوع القضية الفرعي بنجاح";
                long RuleSubType_Id = long.Parse(Request.QueryString["ID"]);
                ruleSubType = ctx.RuleSubTypes.First(s => s.RuleSubType_Id == RuleSubType_Id);
            }
            if (txtTitle.Text.Replace(" ", "") == "")
            {
                txtTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (ddlRuleType.SelectedIndex == 0)
            {
                ddlRuleType.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال نوع القضية الفرعي", this);
            }
            else
            {
                if (Mode.ToLower() == "edit") FL.AddProvisionsMonitoringUserLog(8, 3, "من " + ruleSubType.Title + " إلى " + txtTitle.Text + " ، ونوع القضية من " + ruleSubType.RuleType.Title + "  إلى " + ddlRuleType.SelectedItem.Text);

                ruleSubType.Title = txtTitle.Text;
                ruleSubType.RuleType_Id = long.Parse(ddlRuleType.SelectedValue);

                if (Mode.ToLower() == "add")
                {
                    ctx.RuleSubTypes.AddObject(ruleSubType);
                }

                ctx.SaveChanges();

                if (Mode.ToLower() == "add") FL.AddProvisionsMonitoringUserLog(8, 2, ruleSubType.Title);

                FL.ConfirmationMessage(CompletedMsg, this, "RuleSubTypesSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("RuleSubTypesSettingsMain.aspx");
        }
    }
}