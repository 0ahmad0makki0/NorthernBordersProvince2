using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class PeopleDataForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsSecurityAffairsUserAuthorized(1, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة معلومات الأشخاص", this, "PeopleDataMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة معلومات شخص";
                    break;
                case "edit":
                    {
                        if (!FL.IsSecurityAffairsUserAuthorized(1, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل معلومات الأشخاص", this, "PeopleDataMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PeopleDataMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.PeopleDatas.Count(s => s.PeopleData_Id == TestID) == 0) { Response.Redirect("PeopleDataMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل معلومات شخص";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsSecurityAffairsUserAuthorized(1, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض معلومات الأشخاص", this, "PeopleDataMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PeopleDataMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.PeopleDatas.Count(s => s.PeopleData_Id == TestID) == 0) { Response.Redirect("PeopleDataMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض معلومات شخص";
                        if (!IsPostBack) LoadData();
                        txtBirthPlace.ReadOnly = txtFullName.ReadOnly = txtJobTitle.ReadOnly = txtResidencePlace.ReadOnly = txtSSN.ReadOnly = txtWorkPlace.ReadOnly = true;
                        ddlEducationLevel.Enabled = false;
                        dpDOB.ReadOnly = true;
                        btnSave.Visible = false;
                        break;
                    }
                default: Response.Redirect("PeopleDataMain.aspx"); return;
            }
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PeopleDataMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            PeopleData peopleData = ctx.PeopleDatas.First(s => s.PeopleData_Id == TestID);
            txtFullName.Text = peopleData.FullName;
            txtSSN.Text = peopleData.SSN;
            dpDOB.SelectedCalendareDate = peopleData.DOB.Value;
            txtBirthPlace.Text = peopleData.BirthPlace;
            txtResidencePlace.Text = peopleData.ResidencePlace;
            ddlEducationLevel.SelectedValue = peopleData.EducationLevel_Id.Value.ToString();
            txtJobTitle.Text = peopleData.JobTitle;
            txtWorkPlace.Text = peopleData.WorkPlace;
            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddSecurityAffairsUserLog(1, 1, peopleData.FullName + " [" + peopleData.SSN + "]");
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            PeopleData peopleData = new PeopleData();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة معلومات الشخص بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل معلومات الشخص بنجاح";
                long PeopleData_Id = long.Parse(Request.QueryString["ID"]);
                peopleData = ctx.PeopleDatas.First(s => s.PeopleData_Id == PeopleData_Id);
            }
            if (txtFullName.Text.Replace(" ", "") == "")
            {
                txtFullName.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtSSN.Text.Replace(" ", "") == "")
            {
                txtSSN.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            else
            {
                if (Mode.ToLower() == "add") { if (ctx.PeopleDatas.Count(p => p.SSN == txtSSN.Text) > 0) { FL.ConfirmationMessage("رقم السجل المدني مسجل من قبل", this); return; } }
                else if (Mode.ToLower() == "edit") { if (ctx.PeopleDatas.Count(p => p.SSN == txtSSN.Text && p.PeopleData_Id != peopleData.PeopleData_Id) > 0) { FL.ConfirmationMessage("رقم السجل المدني مسجل من قبل", this); return; } }
                if (txtSSN.Text.Length < 10) { FL.ConfirmationMessage("رقم السجل المدني يجب أن يتكون من 10 أرقام", this); return; }
            }
            if (dpDOB.SelectedCalendareDate == null)
            {
                IsValid = false;
            }
            if (txtBirthPlace.Text.Replace(" ", "") == "")
            {
                txtBirthPlace.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtResidencePlace.Text.Replace(" ", "") == "")
            {
                txtResidencePlace.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (ddlEducationLevel.SelectedIndex == 0)
            {
                ddlEducationLevel.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtJobTitle.Text.Replace(" ", "") == "")
            {
                txtJobTitle.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (txtWorkPlace.Text.Replace(" ", "") == "")
            {
                txtWorkPlace.Style["border"] = "5px solid Red";
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
                    if (peopleData.FullName != txtFullName.Text) changedData += "الإسم الرباعي من " + peopleData.FullName + " إلى " + txtFullName.Text;
                    if (peopleData.SSN != txtSSN.Text) { if (changedData != "") changedData += "<br/>"; changedData += "السجل المدني من " + peopleData.SSN + " إلى " + txtSSN.Text; }
                    if (peopleData.DOB != dpDOB.SelectedCalendareDate) { if (changedData != "") changedData += "<br/>"; changedData += "تاريخ الميلاد من " + FL.GetHijiriDate(peopleData.DOB) + " إلى " + FL.GetHijiriDate(dpDOB.SelectedCalendareDate); }
                    if (peopleData.BirthPlace != txtBirthPlace.Text) { if (changedData != "") changedData += "<br/>"; changedData += "مكان الميلاد من " + peopleData.BirthPlace + " إلى " + txtBirthPlace.Text; }
                    if (peopleData.ResidencePlace != txtResidencePlace.Text) { if (changedData != "") changedData += "<br/>"; changedData += "مكان الإقامة من " + peopleData.ResidencePlace + " إلى " + txtResidencePlace.Text; }
                    if (peopleData.EducationLevel_Id != long.Parse(ddlEducationLevel.SelectedValue)) { if (changedData != "") changedData += "<br/>"; changedData += "المؤهل الدراسي من " + peopleData.EducationLevel.Title + " إلى " + ddlEducationLevel.SelectedItem.Text; }
                    if (peopleData.JobTitle != txtJobTitle.Text) { if (changedData != "") changedData += "<br/>"; changedData += "العمل من " + peopleData.JobTitle + " إلى " + txtJobTitle.Text; }
                    if (peopleData.WorkPlace != txtWorkPlace.Text) { if (changedData != "") changedData += "<br/>"; changedData += "مقر العمل من " + peopleData.WorkPlace + " إلى " + txtWorkPlace.Text; }

                    if (changedData != "") FL.AddSecurityAffairsUserLog(1, 3, "<label style=\"font-weight:bold;\">" + txtFullName.Text + " [" + txtSSN.Text + "]</label>" + "<br/><label style=\"font-weight:bold;\">البيانات التي تم تعديلها : </label><br/>" + changedData);
                }

                peopleData.FullName = txtFullName.Text;
                peopleData.SSN = txtSSN.Text;
                peopleData.DOB = dpDOB.SelectedCalendareDate;
                peopleData.BirthPlace = txtBirthPlace.Text;
                peopleData.ResidencePlace = txtResidencePlace.Text;
                peopleData.EducationLevel_Id = long.Parse(ddlEducationLevel.SelectedValue);
                peopleData.JobTitle = txtJobTitle.Text;
                peopleData.WorkPlace = txtWorkPlace.Text;

                if (Mode.ToLower() == "add")
                {
                    ctx.PeopleDatas.AddObject(peopleData);
                }

                ctx.SaveChanges();

                if (Mode.ToLower() == "add") FL.AddSecurityAffairsUserLog(1, 2, peopleData.FullName + " [" + peopleData.SSN + "]");

                FL.ConfirmationMessage(CompletedMsg, this, "PeopleDataMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("PeopleDataMain.aspx");
        }
    }
}