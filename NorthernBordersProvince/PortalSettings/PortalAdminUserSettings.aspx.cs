using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class PortalAdminUserSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["Mode"] == null) { Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return; }
            string Mode = Request.QueryString["Mode"];
            switch (Mode.ToLower())
            {
                case "add":
                    if (!FL.IsPortalUserAuthorized(6, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة مسؤولين البوابة الإلكترونية", this, "PortalAdminUsersSettingsMain.aspx"); return; } 
                    lblTitle.Text = "صفحة إضافة مسؤول البوابة الإلكترونية"; break;
                case "edit":
                    {
                        if (!FL.IsPortalUserAuthorized(6, 3)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لتعديل مسؤولين البوابة الإلكترونية", this, "PortalAdminUsersSettingsMain.aspx"); return; } 
                        if (Request.QueryString["ID"] == null) { Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return; }
                        long TestID;
                        if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return; }
                        DBEntities ctx = new DBEntities();
                        if (ctx.PortalSettingsUsers.Count(s => s.PortalSettingsUser_Id == TestID) == 0) { Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return; }
                        lblTitle.Text = "صفحة تعديل مسؤول البوابة الإلكترونية";
                        if (!IsPostBack) LoadData();
                        break;
                    }
                default: Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return;
            }
            if (Mode.ToLower() == "edit")
                hfReadyStatus.Value = "1";
            else hfReadyStatus.Value = "2";

            if (!IsPostBack) FL.RunJSFun("onReady();", this);
        }

        private void LoadData()
        {

            if (Request.QueryString["ID"] == null) { Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PortalAdminUsersSettingsMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            PortalSettingsUser user = ctx.PortalSettingsUsers.First(s => s.PortalSettingsUser_Id == TestID);
            txtUsername.Text = user.Username;
            ddlStatus.SelectedIndex = user.Activated.Value ? 1 : 2;
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            bool IsValid = true;
            DBEntities ctx = new DBEntities();
            PortalSettingsUser user = new PortalSettingsUser();
            string Mode = Request.QueryString["Mode"];
            string CompletedMsg = "تم إضافة مسؤول البوابة الإلكترونية بنجاح";
            if (Mode.ToLower() == "edit")
            {
                CompletedMsg = "تم تعديل مسؤول البوابة الإلكترونية بنجاح";
                long PortalSettingsUser_Id = long.Parse(Request.QueryString["ID"]);
                user = ctx.PortalSettingsUsers.First(s => s.PortalSettingsUser_Id == PortalSettingsUser_Id);
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

                FL.RunJSFun("onReady();", this);
            }
            else if ((ctx.PortalSettingsUsers.Count(u => u.Username == txtUsername.Text) > 0 && Mode.ToLower() == "add") ||
                    (ctx.PortalSettingsUsers.Count(u => u.Username == txtUsername.Text && u.PortalSettingsUser_Id != user.PortalSettingsUser_Id) > 0 && Mode.ToLower() == "edit"))
            {
                FL.ConfirmationMessage("إسم المستخدم تمت إضافته مسبقا", this);
                txtUsername.Style["border"] = "5px solid Red";
                txtUsername.Focus();


                if (ddlStatus.SelectedIndex > 0)
                    hfReadyStatus.Value = "1";

                FL.RunJSFun("onReady();", this);
            }
            else
            {
                user.Username = txtUsername.Text.ToUpper();
                user.Activated = ddlStatus.SelectedIndex == 1;

                if (Mode.ToLower() == "add")
                {
                    ctx.PortalSettingsUsers.AddObject(user);
                }

                ctx.SaveChanges();

                for (int i = 0; i <= gvPermissions.Rows.Count - 1; i++)
                {
                    GridViewRow row = gvPermissions.Rows[i];
                    string k = gvPermissions.DataKeys[i].Value.ToString();
                    long ID = long.Parse(k);
                    long Page_Id = long.Parse(((HiddenField)row.FindControl("hfPageId")).Value);
                    CheckBox ckbView = (CheckBox)row.FindControl("ckbView");
                    CheckBox ckbAdd = (CheckBox)row.FindControl("ckbAdd");
                    CheckBox ckbEdit = (CheckBox)row.FindControl("ckbEdit");
                    CheckBox ckbDelete = (CheckBox)row.FindControl("ckbDelete");
                    bool IsNew  = (ctx.PortalSettingsUserPermissions.Count(p => p.PortalSettingsUserPermission_Id == ID) == 0);
                    PortalSettingsUserPermission permission = new PortalSettingsUserPermission();
                    if (!IsNew) permission = ctx.PortalSettingsUserPermissions.First(p => p.PortalSettingsUserPermission_Id == ID);

                    permission.CanAdd = ckbAdd.Checked;
                    permission.CanDelete = ckbDelete.Checked;
                    permission.CanEdit = ckbEdit.Checked;
                    permission.CanView = ckbView.Checked;
                    permission.PortalSettingsPage_Id = Page_Id;
                    permission.PortalSettingsUser_Id = user.PortalSettingsUser_Id;

                    if(IsNew) ctx.AddToPortalSettingsUserPermissions(permission);

                    ctx.SaveChanges();
                }

                FL.ConfirmationMessage(CompletedMsg, this, "PortalAdminUsersSettingsMain.aspx");
            }
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("PortalAdminUsersSettingsMain.aspx");
        }
    }
}