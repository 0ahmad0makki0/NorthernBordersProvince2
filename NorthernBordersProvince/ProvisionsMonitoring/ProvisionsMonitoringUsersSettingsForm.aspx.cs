using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class ProvisionsMonitoringUsersSettingsForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsProvisionsMonitoringUserAuthorized(6, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة مستخدم للنظام", this, "ProvisionsMonitoringUsersSettingsMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة مستخدم للنظام"; break;
                case "edit":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(6, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل مستخدمين النظام", this, "ProvisionsMonitoringUsersSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.ProvisionsMonitoringUsers.Count(s => s.ProvisionsMonitoringUser_Id == TestID) == 0) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل مستخدم النظام";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                case "show":
                    {
                        if (!FL.IsProvisionsMonitoringUserAuthorized(6, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض مستخدمين النظام", this, "ProvisionsMonitoringUsersSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.ProvisionsMonitoringUsers.Count(s => s.ProvisionsMonitoringUser_Id == TestID) == 0) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة عرض مستخدم النظام";
                        if (!IsPostBack) LoadData();
                        txtUsername.ReadOnly = true;
                        ddlStatus.Enabled = false;
                        gvPermissions.Enabled = false;
                        btnSave.Visible = false;
                        break;
                    }
                default: Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return;
            }
            if (Mode.ToLower() == "add")
                hfReadyStatus.Value = "2";
            else hfReadyStatus.Value = "1";

            if (!IsPostBack) FL.RunJSFun("onReady();", this);
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            ProvisionsMonitoringUser user = ctx.ProvisionsMonitoringUsers.First(s => s.ProvisionsMonitoringUser_Id == TestID);
            txtUsername.Text = user.Username;
            ddlStatus.SelectedIndex = user.Activated.Value ? 1 : 2;
            string Mode = Request.QueryString["Mode"];
            if (Mode.ToLower() == "show") FL.AddProvisionsMonitoringUserLog(6, 1, user.Username);
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            ProvisionsMonitoringUser user = new ProvisionsMonitoringUser();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة مستخدم للنظام بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل مستخدم النظام بنجاح";
                long ProvisionsMonitoringUser_Id = long.Parse(Request.QueryString["ID"]);
                user = ctx.ProvisionsMonitoringUsers.First(s => s.ProvisionsMonitoringUser_Id == ProvisionsMonitoringUser_Id);
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
            else if ((ctx.ProvisionsMonitoringUsers.Count(u => u.Username == txtUsername.Text) > 0 && Mode.ToLower() == "add") ||
                    (ctx.ProvisionsMonitoringUsers.Count(u => u.Username == txtUsername.Text && u.ProvisionsMonitoringUser_Id != user.ProvisionsMonitoringUser_Id) > 0 && Mode.ToLower() == "edit"))
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
                    ctx.ProvisionsMonitoringUsers.AddObject(user);
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
                        ProvisionsMonitoringPageRole pageRole = ctx.ProvisionsMonitoringPageRoles.First(pr => pr.ProvisionsMonitoringPage_Id == Page_Id && pr.ProvisionsMonitoringRole_Id == 1);
                        long PageRole_Id = pageRole.ProvisionsMonitoringPageRole_Id;
                        if (ctx.ProvisionsMonitoringUserRoles.Count(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbView.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = ctx.ProvisionsMonitoringUserRoles.First(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbView.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = new ProvisionsMonitoringUserRole() { ProvisionsMonitoringPageRole_Id = PageRole_Id, ProvisionsMonitoringUser_Id = user.ProvisionsMonitoringUser_Id };
                                ctx.ProvisionsMonitoringUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                            }
                        }
                    }

                    if (ckbAdd.Visible)
                    {
                        ProvisionsMonitoringPageRole pageRole = ctx.ProvisionsMonitoringPageRoles.First(pr => pr.ProvisionsMonitoringPage_Id == Page_Id && pr.ProvisionsMonitoringRole_Id == 2);
                        long PageRole_Id = pageRole.ProvisionsMonitoringPageRole_Id;
                        if (ctx.ProvisionsMonitoringUserRoles.Count(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbAdd.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = ctx.ProvisionsMonitoringUserRoles.First(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id);
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbAdd.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = new ProvisionsMonitoringUserRole() { ProvisionsMonitoringPageRole_Id = PageRole_Id, ProvisionsMonitoringUser_Id = user.ProvisionsMonitoringUser_Id };
                                ctx.ProvisionsMonitoringUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                            }
                        }
                    }

                    if (ckbEdit.Visible)
                    {
                        ProvisionsMonitoringPageRole pageRole = ctx.ProvisionsMonitoringPageRoles.First(pr => pr.ProvisionsMonitoringPage_Id == Page_Id && pr.ProvisionsMonitoringRole_Id == 3);
                        long PageRole_Id = pageRole.ProvisionsMonitoringPageRole_Id;
                        if (ctx.ProvisionsMonitoringUserRoles.Count(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbEdit.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = ctx.ProvisionsMonitoringUserRoles.First(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id);
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbEdit.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = new ProvisionsMonitoringUserRole() { ProvisionsMonitoringPageRole_Id = PageRole_Id, ProvisionsMonitoringUser_Id = user.ProvisionsMonitoringUser_Id };
                                ctx.ProvisionsMonitoringUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                            }
                        }
                    }

                    if (ckbDelete.Visible)
                    {
                        ProvisionsMonitoringPageRole pageRole = ctx.ProvisionsMonitoringPageRoles.First(pr => pr.ProvisionsMonitoringPage_Id == Page_Id && pr.ProvisionsMonitoringRole_Id == 4);
                        long PageRole_Id = pageRole.ProvisionsMonitoringPageRole_Id;
                        if (ctx.ProvisionsMonitoringUserRoles.Count(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id) > 0)
                        {
                            if (!ckbDelete.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = ctx.ProvisionsMonitoringUserRoles.First(ur => ur.ProvisionsMonitoringUser_Id == user.ProvisionsMonitoringUser_Id && ur.ProvisionsMonitoringPageRole_Id == PageRole_Id);
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                if (removed_permissions != "") removed_permissions += "<br/>";
                                removed_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
                                ctx.ProvisionsMonitoringUserRoles.DeleteObject(userRole);
                                ctx.SaveChanges();
                            }
                        }
                        else
                        {
                            if (ckbDelete.Checked)
                            {
                                ProvisionsMonitoringUserRole userRole = new ProvisionsMonitoringUserRole() { ProvisionsMonitoringPageRole_Id = PageRole_Id, ProvisionsMonitoringUser_Id = user.ProvisionsMonitoringUser_Id };
                                ctx.ProvisionsMonitoringUserRoles.AddObject(userRole);
                                ctx.SaveChanges();
                                if (new_permissions != "") new_permissions += "<br/>";
                                new_permissions += "الصفحة " + pageRole.ProvisionsMonitoringPage.Title + " ، الصلاحية " + pageRole.ProvisionsMonitoringRole.Title;
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
                if (Mode.ToLower() == "add") FL.AddProvisionsMonitoringUserLog(6, 2, noteContent);
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

                    FL.AddProvisionsMonitoringUserLog(6, 3, noteContent);
                }

                FL.ConfirmationMessage(CompletedMsg, this, "ProvisionsMonitoringUsersSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("ProvisionsMonitoringUsersSettingsMain.aspx");
        }
    }
}