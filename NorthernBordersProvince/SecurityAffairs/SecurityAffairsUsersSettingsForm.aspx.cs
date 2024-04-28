using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class SecurityAffairsUsersSettingsForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsSecurityAffairsUserAuthorized(7, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة مستخدم للنظام", this, "SecurityAffairsUsersSettingsMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة مستخدم للنظام"; break;
                case "edit":
                    {
                        if (!FL.IsSecurityAffairsUserAuthorized(7, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل مستخدمين النظام", this, "SecurityAffairsUsersSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.SecurityAffairsUsers.Count(s => s.SecurityAffairsUser_Id == TestID) == 0) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل مستخدم النظام";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsSecurityAffairsUserAuthorized(7, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض مستخدمين النظام", this, "SecurityAffairsUsersSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.SecurityAffairsUsers.Count(s => s.SecurityAffairsUser_Id == TestID) == 0) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض مستخدم النظام";
                        if (!IsPostBack) LoadData();
                        txtUsername.ReadOnly = true;
                        ddlStatus.Enabled = false;
                        gvPermissions.Enabled = false;
                        btnSave.Visible = false;
                        break;
                    }
                default: Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return;
            }
            if (Mode.ToLower() == "add")
                hfReadyStatus.Value = "2";
            else hfReadyStatus.Value = "1";

            if (!IsPostBack) FL.RunJSFun("onReady();", this);
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("SecurityAffairsUsersSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            SecurityAffairsUser user = ctx.SecurityAffairsUsers.First(s => s.SecurityAffairsUser_Id == TestID);
            txtUsername.Text = user.Username;
            ddlStatus.SelectedIndex = user.Activated.Value ? 1 : 2;
            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddSecurityAffairsUserLog(7, 1, user.Username);
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            SecurityAffairsUser user = new SecurityAffairsUser();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة مستخدم للنظام بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل مستخدم النظام بنجاح";
                long SecurityAffairsUser_Id = long.Parse(Request.QueryString["ID"]);
                user = ctx.SecurityAffairsUsers.First(s => s.SecurityAffairsUser_Id == SecurityAffairsUser_Id);
            }
            if (txtUsername.Text.Replace(" ", "") == "")
            {
                txtUsername.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (ddlStatus.SelectedIndex == 0)
            {
                ddlStatus.Style["border"] = "5px solid Red";
                IsValid = false;
            }
            if (!IsValid)
            {
                FL.ConfirmationMessage("الرجاء إدخال جميع الحقول الإلزامية", this);

                if (ddlStatus.SelectedIndex > 0)
                    hfReadyStatus.Value = "1";
                else hfReadyStatus.Value = "2";

                FL.RunJSFun("onReady();", this);
            }
            else if ((ctx.SecurityAffairsUsers.Count(u => u.Username == txtUsername.Text) > 0 && Mode.ToLower() == "add") ||
                    (ctx.SecurityAffairsUsers.Count(u => u.Username == txtUsername.Text && u.SecurityAffairsUser_Id != user.SecurityAffairsUser_Id) > 0 && Mode.ToLower() == "edit"))
            {
                FL.ConfirmationMessage("إسم المستخدم تمت إضافته مسبقا", this);
                txtUsername.Style["border"] = "5px solid Red";
                txtUsername.Focus();


                if (ddlStatus.SelectedIndex > 0)
                    hfReadyStatus.Value = "1";
                else hfReadyStatus.Value = "2";

                FL.RunJSFun("onReady();", this);
            }
            else
            {
                string perviousUserName = "";
                string previousStatus = "";

                if (Mode.ToLower() == "edit")
                {
                    perviousUserName = user.Username;
                    previousStatus = user.Activated.Value ? "مفعل" : "معطل";
                }

                user.Username = txtUsername.Text.ToUpper();
                user.Activated = ddlStatus.SelectedIndex == 1;

                string new_permissions = "";
                string removed_permissions = "";

                if (Mode.ToLower() == "add")
                {
                    ctx.SecurityAffairsUsers.AddObject(user);
                }

                ctx.SaveChanges();

                for (int i = 0; i <= gvPermissions.Rows.Count - 1; i++)
                {
                    GridViewRow row = gvPermissions.Rows[i];
                    string k = gvPermissions.DataKeys[i].Value.ToString();
                    long Page_Id = long.Parse(k);
                    CheckBox ckbView = (CheckBox)row.FindControl("ckbView");
                    CheckBox ckbAdd = (CheckBox)row.FindControl("ckbAdd");
                    CheckBox ckbEdit = (CheckBox)row.FindControl("ckbEdit");
                    CheckBox ckbDelete = (CheckBox)row.FindControl("ckbDelete");

                    if (ckbView.Visible)
                    {
                        SecurityAffairsPageRole pageRole = ctx.SecurityAffairsPageRoles.First(pr => pr.SecurityAffairsPage_Id == Page_Id && pr.SecurityAffairsRole_Id == 1);
                        long PageRole_Id = pageRole.SecurityAffairsPageRole_Id;
                        if (ctx.SecurityAffairsUserRoles.Count(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbView.Checked)
                            {
                                SecurityAffairsUserRole userRole = ctx.SecurityAffairsUserRoles.First(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbView.Checked)
                            {
                                SecurityAffairsUserRole userRole = new SecurityAffairsUserRole() { SecurityAffairsPageRole_Id = PageRole_Id, SecurityAffairsUser_Id = user.SecurityAffairsUser_Id };
                                ctx.SecurityAffairsUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                            }
                        }
                    }

                    if (ckbAdd.Visible)
                    {
                        SecurityAffairsPageRole pageRole = ctx.SecurityAffairsPageRoles.First(pr => pr.SecurityAffairsPage_Id == Page_Id && pr.SecurityAffairsRole_Id == 2);
                        long PageRole_Id = pageRole.SecurityAffairsPageRole_Id;
                        if (ctx.SecurityAffairsUserRoles.Count(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbAdd.Checked)
                            {
                                SecurityAffairsUserRole userRole = ctx.SecurityAffairsUserRoles.First(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id);
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbAdd.Checked)
                            {
                                SecurityAffairsUserRole userRole = new SecurityAffairsUserRole() { SecurityAffairsPageRole_Id = PageRole_Id, SecurityAffairsUser_Id = user.SecurityAffairsUser_Id };
                                ctx.SecurityAffairsUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                            }
                        }
                    }

                    if (ckbEdit.Visible)
                    {
                        SecurityAffairsPageRole pageRole = ctx.SecurityAffairsPageRoles.First(pr => pr.SecurityAffairsPage_Id == Page_Id && pr.SecurityAffairsRole_Id == 3);
                        long PageRole_Id = pageRole.SecurityAffairsPageRole_Id;
                        if (ctx.SecurityAffairsUserRoles.Count(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbEdit.Checked)
                            {
                                SecurityAffairsUserRole userRole = ctx.SecurityAffairsUserRoles.First(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id);
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbEdit.Checked)
                            {
                                SecurityAffairsUserRole userRole = new SecurityAffairsUserRole() { SecurityAffairsPageRole_Id = PageRole_Id, SecurityAffairsUser_Id = user.SecurityAffairsUser_Id };
                                ctx.SecurityAffairsUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                            }
                        }
                    }

                    if (ckbDelete.Visible)
                    {
                        SecurityAffairsPageRole pageRole = ctx.SecurityAffairsPageRoles.First(pr => pr.SecurityAffairsPage_Id == Page_Id && pr.SecurityAffairsRole_Id == 4);
                        long PageRole_Id = pageRole.SecurityAffairsPageRole_Id;
                        if (ctx.SecurityAffairsUserRoles.Count(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbDelete.Checked)
                            {
                                SecurityAffairsUserRole userRole = ctx.SecurityAffairsUserRoles.First(ur => ur.SecurityAffairsUser_Id == user.SecurityAffairsUser_Id && ur.SecurityAffairsPageRole_Id == PageRole_Id);
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                                ctx.SecurityAffairsUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbDelete.Checked)
                            {
                                SecurityAffairsUserRole userRole = new SecurityAffairsUserRole() { SecurityAffairsPageRole_Id = PageRole_Id, SecurityAffairsUser_Id = user.SecurityAffairsUser_Id };
                                ctx.SecurityAffairsUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.SecurityAffairsPage.Title + " ، الصلاحية " + pageRole.SecurityAffairsRole.Title;
                            }
                        }
                    }
                }

                string note = "";
                if (new_permissions != "") note = "<br/><label style=\"font-weight:bold;\">الصلاحيات المضافة :</label><br/>" + new_permissions;
                if (removed_permissions != "") { if (note != "") note += "<br/>"; note += "<br/><label style=\"font-weight:bold;\">الصلاحيات الملغاة :</label><br/>" + removed_permissions; }
                string noteContent = "";
                if (note == "") noteContent = user.Username;
                else noteContent = "<label style=\"font-weight:bold;\">" + user.Username + "</label>" + note;
                if (Mode.ToLower() == "add") FL.AddSecurityAffairsUserLog(7, 2, noteContent);
                else if (Mode.ToLower() == "edit")
                {
                    string CurrentStatus = ddlStatus.SelectedIndex == 1 ? "مفعل" : "معطل";
                    string changedUsernameContents = "";
                    string changedStatusContents = "";
                    if (perviousUserName != user.Username)
                        changedUsernameContents += "<br/><label style=\"font-weight:bold;\">تم تغيير إسم المستخدم من " + perviousUserName + " إلى " + user.Username + "<label>";
                    if (previousStatus != CurrentStatus)
                        changedStatusContents += "<br/><label style=\"font-weight:bold;\">تم تغيير الحالة من " + previousStatus + " إلى " + CurrentStatus + "<label>";
                    if (note == "" && changedUsernameContents == "" && changedStatusContents == "") noteContent = user.Username;
                    else noteContent = "<label style=\"font-weight:bold;\">" + user.Username + "</label>" + changedUsernameContents + changedStatusContents + note;
                        
                    FL.AddSecurityAffairsUserLog(7, 3, noteContent);
                }

                FL.ConfirmationMessage(CompletedMsg, this, "SecurityAffairsUsersSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("SecurityAffairsUsersSettingsMain.aspx");
        }
    }
}