using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices.AccountManagement;
using System.Configuration;
using System.Security.Principal;

namespace NorthernBordersProvince
{
    public partial class LoginPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsBrowserFit(this.Page))
            {
                Response.Redirect("NotValidBrowser.aspx");
                return;
            }

            if (Request.QueryString["Mode"] == null) Response.Redirect("default.aspx");
            string Mode = Request.QueryString["Mode"];
            if (Mode != "PortalSettings" &&
                Mode != "SecurityAffairs" &&
                Mode != "ProvisionsMonitoring") Response.Redirect("default.aspx");

            if (Mode == "PortalSettings")
                Title = lblTitle.Text = "إعدادات البوابة الإلكترونية";
            else if (Mode == "SecurityAffairs")
                Title = lblTitle.Text = "قاعدة بيانات الشؤون الأمنية";
            else if (Mode == "ProvisionsMonitoring")
                Title = lblTitle.Text = "قاعدة بيانات متابعة تنفيذ الأحكام";
            if (!IsPostBack)
            {
                txtUsername.Text = HttpContext.Current.User.Identity.Name;
                if (txtUsername.Text.Split('\\').Count() == 2)
                    txtUsername.Text = txtUsername.Text.Split('\\')[1];
                Session["Username"] = null;
                Session["LocalLoginPassword"] = null;
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblStatus.Visible = false;
            if (txtUsername.Text.Trim().Length == 0 ||
                txtPassword.Text.Trim().Length == 0)
            {
                lblStatus.Visible = true;
                return;
            }

            if (!FL.Authenticate(txtUsername.Text, txtPassword.Text, Request.QueryString["Mode"], this))
                lblStatus.Visible = true;
            else
            {
                Session["Username"] = txtUsername.Text;
                Session["LocalLoginPassword"] = txtPassword.Text;
                string Mode = Request.QueryString["Mode"];
                if (Mode == "PortalSettings")
                    Response.Redirect("PortalSettings/Home.aspx");
                else if (Mode == "SecurityAffairs")
                    Response.Redirect("SecurityAffairs/default.aspx");
                else if (Mode == "ProvisionsMonitoring")
                    Response.Redirect("ProvisionsMonitoring/default.aspx");
            }
        }
    }
}