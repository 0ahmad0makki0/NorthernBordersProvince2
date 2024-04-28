using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class RuleDataForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.MaintainScrollPositionOnPostBack = true;
            if (Request.QueryString["Mode"] == null) { Response.Redirect("RuleDataMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsProvisionsMonitoringUserAuthorized(1, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة معلومات الحكم", this, "RuleDataMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة معلومات الحكم"; break;
                case "edit":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(1, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل معلومات الحكم", this, "RuleDataMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleDataMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleDataMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleDatas.Count(s => s.RuleData_Id == TestID) == 0) { Response.Redirect("RuleDataMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل معلومات الحكم";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(1, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض معلومات الحكم", this, "RuleDataMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("RuleDataMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleDataMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.RuleDatas.Count(s => s.RuleData_Id == TestID) == 0) { Response.Redirect("RuleDataMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض معلومات الحكم";
                        if (!IsPostBack) LoadData();
                        txtOccupation.ReadOnly = txtAccusedName.ReadOnly = txtAccusedSSN.ReadOnly = txtCaseNumber.ReadOnly = txtIssuedLetterNumber.ReadOnly = txtLegalDecisionNumber.ReadOnly = txtSupportingDecisionNumber.ReadOnly = true;
                        ddlNationality.Enabled = ddlRuleStatus.Enabled = ddlRuleSubType.Enabled = ddlRuleType.Enabled = false;
                        dpIssuedLetterDate.ReadOnly = dpLegalDecisionDate.ReadOnly = dpSupportingDecisionDate.ReadOnly = true;
                        btnSave.Visible = false;
                        break;
                    }
                default: Response.Redirect("RuleDataMain.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("RuleDataMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("RuleDataMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            RuleData ruleData = ctx.RuleDatas.First(s => s.RuleData_Id == TestID);
            txtCaseNumber.Text = ruleData.CaseNumber;
            txtIssuedLetterNumber.Text = ruleData.IssuedLetterNumber;
            if (ruleData.IssuedLetterDate != null) dpIssuedLetterDate.SelectedCalendareDate = ruleData.IssuedLetterDate.Value;
            txtAccusedName.Text = ruleData.AccusedName;
            txtAccusedSSN.Text = ruleData.AccusedSSN;
            txtLegalDecisionNumber.Text = ruleData.LegalDecisionNumber;
            if (ruleData.LegalDecisionDate != null) dpLegalDecisionDate.SelectedCalendareDate = ruleData.LegalDecisionDate.Value;
            txtSupportingDecisionNumber.Text = ruleData.SupportingDecisionNumber;
            if (ruleData.SupportingDecisionDate != null) dpSupportingDecisionDate.SelectedCalendareDate = ruleData.SupportingDecisionDate.Value;
            ddlRuleStatus.SelectedValue = ruleData.RuleStatus_Id.ToString();
            ddlRuleType.DataBound += (s, e) =>
            {
                ddlRuleType.SelectedValue = ruleData.RuleSubType_Id == null ? "0" : ruleData.RuleSubType.RuleType_Id.ToString();
                ddlRuleSubType.DataBound += (s1, e1) =>
                {
                    ddlRuleSubType.SelectedValue = ruleData.RuleSubType_Id == null ? "0" : ruleData.RuleSubType_Id.ToString();
                };
            };
            ddlNationality.SelectedValue = ruleData.Nationality_Id == null ? "0" : ruleData.Nationality_Id.ToString();
            txtOccupation.Text = ruleData.Occupation;
            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddProvisionsMonitoringUserLog(1, 1, "قضية رقم : " + ruleData.CaseNumber + " ، على المتهم " + ruleData.AccusedName + " [" + ruleData.AccusedSSN + "]");
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            RuleData ruleData = new RuleData();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة معلومات الحكم بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل معلومات الحكم بنجاح";
                long RuleData_Id = long.Parse(Request.QueryString["ID"]);
                ruleData = ctx.RuleDatas.First(s => s.RuleData_Id == RuleData_Id);
            }
            if (txtCaseNumber.Text.Replace(" ", "") == "")
            {
                txtCaseNumber.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            else
            {
                if (Mode.ToLower() == "add") { if (ctx.RuleDatas.Count(p => p.CaseNumber.ToLower() == txtCaseNumber.Text.ToLower()) > 0) { FL.ConfirmationMessage("رقم القضية من قبل", this); return; } }
                else if (Mode.ToLower() == "edit") { if (ctx.RuleDatas.Count(p => p.CaseNumber.ToLower() == txtCaseNumber.Text.ToLower() && p.RuleData_Id != ruleData.RuleData_Id) > 0) { FL.ConfirmationMessage("رقم القضية من قبل", this); return; } }
            }
            if (txtAccusedName.Text.Replace(" ", "") == "")
            {
                txtAccusedName.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtAccusedSSN.Text.Replace(" ", "") == "")
            {
                txtAccusedSSN.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            else
            {
                if (Mode.ToLower() == "add") { if (ctx.RuleDatas.Count(p => p.AccusedSSN == txtAccusedSSN.Text) > 0) { FL.ConfirmationMessage("رقم السجل المدني مسجل من قبل", this); return; } }
                else if (Mode.ToLower() == "edit") { if (ctx.RuleDatas.Count(p => p.AccusedSSN == txtAccusedSSN.Text && p.RuleData_Id != ruleData.RuleData_Id) > 0) { FL.ConfirmationMessage("رقم السجل المدني مسجل من قبل", this); return; } }
                if (txtAccusedSSN.Text.Length < 10) { FL.ConfirmationMessage("رقم السجل المدني يجب أن يتكون من 10 أرقام", this); return; }
            }
            if (ddlRuleStatus.SelectedIndex == 0)
            {
                ddlRuleStatus.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (ddlRuleType.SelectedIndex == 0)
            {
                ddlRuleType.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (ddlRuleSubType.SelectedIndex == 0)
            {
                ddlRuleSubType.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (ddlNationality.SelectedIndex == 0)
            {
                ddlNationality.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtOccupation.Text.Replace(" ", "") == "")
            {
                txtOccupation.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال جميع الحقول الإلزامية", this);
            }
            else
            {
                if (Mode.ToLower() == "edit")
                {
                    string changedData = "";
                    if (ruleData.CaseNumber != txtCaseNumber.Text) changedData += "رقم القضية من " + ruleData.CaseNumber + " إلى " + txtCaseNumber.Text;
                    if (ruleData.RuleSubType_Id != long.Parse(ddlRuleSubType.SelectedValue)) { if (changedData != "") changedData += "<br/>"; changedData += "نوع القضية من " + (ruleData.RuleSubType_Id == null ? "غير محدد" : ruleData.RuleSubType.RuleType.Title + " - " + ruleData.RuleSubType.Title) + " إلى " + ddlRuleType.SelectedItem.Text + " - " + ddlRuleSubType.SelectedItem.Text; }
                    if (ruleData.IssuedLetterNumber != txtIssuedLetterNumber.Text) { if (changedData != "") changedData += "<br/>"; changedData += "رقم الخطاب الصادر من " + ruleData.IssuedLetterNumber + " إلى " + txtIssuedLetterNumber.Text; }
                    if (ruleData.IssuedLetterDate != dpIssuedLetterDate.SelectedCalendareDate) { if (changedData != "") changedData += "<br/>"; changedData += "تاريخ الخطاب الصادر من " + (ruleData.IssuedLetterDate == null ? "" : FL.GetHijiriDate(ruleData.IssuedLetterDate)) + " إلى " + (dpIssuedLetterDate.SelectedCalendareDate == null ? "" : FL.GetHijiriDate(dpIssuedLetterDate.SelectedCalendareDate)); }
                    if (ruleData.AccusedName != txtAccusedName.Text) { if (changedData != "") changedData += "<br/>"; changedData += "اسم المتهم من " + ruleData.AccusedName + " إلى " + txtAccusedName.Text; }
                    if (ruleData.Nationality_Id != long.Parse(ddlNationality.SelectedValue)) { if (changedData != "") changedData += "<br/>"; changedData += "الجنسية من " + ruleData.Nationality_Id == null ? "غير محدد" : ruleData.Nationality.Title + " إلى " + ddlNationality.SelectedItem.Text; }
                    if (ruleData.AccusedSSN != txtAccusedSSN.Text) { if (changedData != "") changedData += "<br/>"; changedData += "رقم السجل المدني من " + ruleData.AccusedSSN + " إلى " + txtAccusedSSN.Text; }
                    if (ruleData.Occupation != txtOccupation.Text) { if (changedData != "") changedData += "<br/>"; changedData += "المهنة من " + ruleData.Occupation + " إلى " + txtOccupation.Text; }
                    if (ruleData.LegalDecisionNumber != txtLegalDecisionNumber.Text) { if (changedData != "") changedData += "<br/>"; changedData += "رقم القرار الشرعي من " + ruleData.LegalDecisionNumber + " إلى " + txtLegalDecisionNumber.Text; }
                    if (ruleData.LegalDecisionDate != dpLegalDecisionDate.SelectedCalendareDate) { if (changedData != "") changedData += "<br/>"; changedData += "تاريخ القرار الشرعي من " + (ruleData.LegalDecisionDate == null ? "" : FL.GetHijiriDate(ruleData.LegalDecisionDate)) + " إلى " + (dpLegalDecisionDate.SelectedCalendareDate == null ? "" : FL.GetHijiriDate(dpLegalDecisionDate.SelectedCalendareDate)); }
                    if (ruleData.SupportingDecisionNumber != txtSupportingDecisionNumber.Text) { if (changedData != "") changedData += "<br/>"; changedData += "رقم قرار التاييد من " + ruleData.SupportingDecisionNumber + " إلى " + txtSupportingDecisionNumber.Text; }
                    if (ruleData.SupportingDecisionDate != dpSupportingDecisionDate.SelectedCalendareDate) { if (changedData != "") changedData += "<br/>"; changedData += "تاريخ قرار التاييد من " + (ruleData.LegalDecisionDate == null ? "" : FL.GetHijiriDate(ruleData.LegalDecisionDate)) + " إلى " + (dpLegalDecisionDate.SelectedCalendareDate == null ? "" : FL.GetHijiriDate(dpLegalDecisionDate.SelectedCalendareDate)); }
                    if (ruleData.RuleStatus_Id != long.Parse(ddlRuleStatus.SelectedValue)) { if (changedData != "") changedData += "<br/>"; changedData += "المؤهل الدراسي من " + ruleData.RuleStatu.Title + " إلى " + ddlRuleStatus.SelectedItem.Text; }

                    if (changedData != "") FL.AddProvisionsMonitoringUserLog(1, 3, "<label style=\"font-weight:bold;\">رقم القضية : " + txtCaseNumber.Text + " ، على المتهم : " + txtAccusedName.Text + " [" + txtAccusedSSN.Text + "]</label>" + "<br/><label style=\"font-weight:bold;\">البيانات التي تم تعديلها : </label><br/>" + changedData);
                }

                ruleData.CaseNumber = txtCaseNumber.Text;
                ruleData.IssuedLetterNumber = txtIssuedLetterNumber.Text;
                ruleData.IssuedLetterDate = dpIssuedLetterDate.SelectedCalendareDate;
                ruleData.AccusedName = txtAccusedName.Text;
                ruleData.AccusedSSN = txtAccusedSSN.Text;
                ruleData.LegalDecisionNumber = txtLegalDecisionNumber.Text;
                ruleData.LegalDecisionDate = dpLegalDecisionDate.SelectedCalendareDate;
                ruleData.SupportingDecisionNumber = txtSupportingDecisionNumber.Text;
                ruleData.SupportingDecisionDate = dpSupportingDecisionDate.SelectedCalendareDate;
                ruleData.RuleStatus_Id = long.Parse(ddlRuleStatus.SelectedValue);
                ruleData.RuleSubType_Id = long.Parse(ddlRuleSubType.SelectedValue);
                ruleData.Occupation = txtOccupation.Text;
                ruleData.Nationality_Id = long.Parse(ddlNationality.SelectedValue);

                if (Mode.ToLower() == "add")
                {
                    ctx.RuleDatas.AddObject(ruleData);
                }

                ctx.SaveChanges();

                if (Mode.ToLower() == "add") FL.AddProvisionsMonitoringUserLog(1, 2, "قضية رقم : " + ruleData.CaseNumber + " ، على المتهم " + ruleData.AccusedName + " [" + ruleData.AccusedSSN + "]");

                FL.ConfirmationMessage(CompletedMsg, this, "RuleDataMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("RuleDataMain.aspx");
        }
    }
}