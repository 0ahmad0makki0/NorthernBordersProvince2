using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.DirectoryServices.AccountManagement;
using System.Configuration;

namespace NorthernBordersProvince
{
    public class FL
    {
        public static bool IsBrowserFit(Page page)
        {
            return true;
            HttpRequest Request = page.Request;
            if (Request.Browser.Type.ToUpper().Contains("FIREFOX"))
            {
                if (Request.Browser.MajorVersion < 49) return false;
                return true;
            }
            else if (Request.Browser.Type.ToUpper().Contains("IE") || Request.Browser.Type.ToUpper().Contains("INTERNET"))
            {
                if (Request.Browser.MajorVersion < 9) return false;
                return true;
            }
            else { return false; }
        }

        public static bool IsPortalUserAuthorized(long Page_Id, long PermissionType_Id)
        {
            //1:View, 2:Add, 3:Edit, 4:Delete

            DBEntities ctx = new DBEntities();

            long User_Id;
            string Username = (string)HttpContext.Current.Session["Username"];
            if (Username == null) return false;
            string LocalUserPassword = null;
            LocalUserPassword = EncryptDecrypt.Encrypt((string)HttpContext.Current.Session["LocalLoginPassword"]);
            if (ctx.PortalSettingsUsers.Count(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword) > 0)
                User_Id = ctx.PortalSettingsUsers.First(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword).PortalSettingsUser_Id;
            else User_Id = ctx.PortalSettingsUsers.First(p => p.Username == Username).PortalSettingsUser_Id;

            return ctx.GetPortalSettingsUserPermission(User_Id, Page_Id, PermissionType_Id).First().IsAuthorized.Value;
        }

        public static bool IsSecurityAffairsUserAuthorized(long Page_Id, long Role_Id)
        {
            //1:View, 2:Add, 3:Edit, 4:Delete

            DBEntities ctx = new DBEntities();

            long User_Id;
            string Username = (string)HttpContext.Current.Session["Username"];
            if (Username == null) return false;
            string LocalUserPassword = null;
            LocalUserPassword = EncryptDecrypt.Encrypt((string)HttpContext.Current.Session["LocalLoginPassword"]);
            if (ctx.SecurityAffairsUsers.Count(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword) > 0)
                User_Id = ctx.SecurityAffairsUsers.First(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword).SecurityAffairsUser_Id;
            else User_Id = ctx.SecurityAffairsUsers.First(p => p.Username == Username).SecurityAffairsUser_Id;

            SecurityAffairsPageRole pageRole = ctx.SecurityAffairsPageRoles.First(pr => pr.SecurityAffairsPage_Id == Page_Id && pr.SecurityAffairsRole_Id == Role_Id);

            return ctx.GetSecurityAffairsUserPermission(User_Id, pageRole.SecurityAffairsPageRole_Id).First().IsAuthorized.Value;
        }

        public static void AddSecurityAffairsUserLog(long Page_Id, long Role_Id, string Note)
        {
            DBEntities ctx = new DBEntities();

            long User_Id;
            string Username = (string)HttpContext.Current.Session["Username"];
            if (Username == null) return;
            string LocalUserPassword = null;
            LocalUserPassword = EncryptDecrypt.Encrypt((string)HttpContext.Current.Session["LocalLoginPassword"]);
            if (ctx.SecurityAffairsUsers.Count(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword) > 0)
                User_Id = ctx.SecurityAffairsUsers.First(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword).SecurityAffairsUser_Id;
            else User_Id = ctx.SecurityAffairsUsers.First(p => p.Username == Username).SecurityAffairsUser_Id;

            SecurityAffairsPageRole pageRole = ctx.SecurityAffairsPageRoles.First(pr => pr.SecurityAffairsPage_Id == Page_Id && pr.SecurityAffairsRole_Id == Role_Id);

            ctx.AddSecurityAffairsUserLog(User_Id, pageRole.SecurityAffairsPageRole_Id, Note);
        }

        public static bool IsProvisionsMonitoringUserAuthorized(long Page_Id, long Role_Id)
        {
            //1:View, 2:Add, 3:Edit, 4:Delete

            DBEntities ctx = new DBEntities();

            long User_Id;
            string Username = (string)HttpContext.Current.Session["Username"];
            if (Username == null) return false;
            string LocalUserPassword = null;
            LocalUserPassword = EncryptDecrypt.Encrypt((string)HttpContext.Current.Session["LocalLoginPassword"]);
            if (ctx.ProvisionsMonitoringUsers.Count(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword) > 0)
                User_Id = ctx.ProvisionsMonitoringUsers.First(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword).ProvisionsMonitoringUser_Id;
            else User_Id = ctx.ProvisionsMonitoringUsers.First(p => p.Username == Username).ProvisionsMonitoringUser_Id;

            ProvisionsMonitoringPageRole pageRole = ctx.ProvisionsMonitoringPageRoles.First(pr => pr.ProvisionsMonitoringPage_Id == Page_Id && pr.ProvisionsMonitoringRole_Id == Role_Id);

            return ctx.GetProvisionsMonitoringUserPermission(User_Id, pageRole.ProvisionsMonitoringPageRole_Id).First().IsAuthorized.Value;
        }

        public static void AddProvisionsMonitoringUserLog(long Page_Id, long Role_Id, string Note)
        {
            DBEntities ctx = new DBEntities();

            long User_Id;
            string Username = (string)HttpContext.Current.Session["Username"];
            if (Username == null) return;
            string LocalUserPassword = null;
            LocalUserPassword = EncryptDecrypt.Encrypt((string)HttpContext.Current.Session["LocalLoginPassword"]);
            if (ctx.ProvisionsMonitoringUsers.Count(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword) > 0)
                User_Id = ctx.ProvisionsMonitoringUsers.First(p => p.Username == Username && p.LocalLoginPassword == LocalUserPassword).ProvisionsMonitoringUser_Id;
            else User_Id = ctx.ProvisionsMonitoringUsers.First(p => p.Username == Username).ProvisionsMonitoringUser_Id;

            ProvisionsMonitoringPageRole pageRole = ctx.ProvisionsMonitoringPageRoles.First(pr => pr.ProvisionsMonitoringPage_Id == Page_Id && pr.ProvisionsMonitoringRole_Id == Role_Id);

            ctx.AddProvisionsMonitoringUserLog(User_Id, pageRole.ProvisionsMonitoringPageRole_Id, Note);
        }

        public static DateTime GetGeorgianDate(string Hijiri)
        {
            DBEntities ctx = new DBEntities();
            return ctx.GetGeorgianDate(Hijiri).First().Date.Value;
        }

        public static bool ValidateHijiriDate(string Hijiri)
        {
            DBEntities ctx = new DBEntities();
            try
            {
                DateTime dt = ctx.GetGeorgianDate(Hijiri).First().Date.Value;
                return true;
            }
            catch (Exception) { return false; }
        }

        public static string GetHijiriDate(DateTime? Georgian)
        {
            DBEntities ctx = new DBEntities();
            return ctx.GetHijiriDate(Georgian).First().Date;
        }

        public static string GetHijiriDateNow()
        {
            DBEntities ctx = new DBEntities();
            return ctx.GetHijiriDate(DateTime.Now).First().Date;
        }

        public static void ConfirmationMessage(string msg, Control page)
        {
            ScriptManager.RegisterClientScriptBlock(page, page.GetType(), "alertMessage", "alert('" + msg + "');", true);
        }

        public static void ConfirmationMessage(string msg, Control page, string url)
        {
            ScriptManager.RegisterClientScriptBlock(page, page.GetType(), "alertMessage", "alert('" + msg + "'); document.location.href='" + url + "';", true);
        }

        public static void RunJSFun(string fun, Control page)
        {
            ScriptManager.RegisterClientScriptBlock(page, page.GetType(), "fun", fun + ";", true);
        }

        public static bool Authenticate(string Username, string Password, string Mode, Page page)
        {
            DBEntities ctx = new DBEntities();
            if (Mode == "PortalSettings")
            {
                if (ctx.PortalSettingsAuthentication(Username, EncryptDecrypt.Encrypt(Password)).Count() > 0) return true;
                if (IsDomainAuthenticated(Username, Password, page)) return ctx.PortalSettingsAuthentication(Username, null).Count() > 0;
            }
            else if (Mode == "SecurityAffairs")
            {
                if (ctx.SecurityAffairsAuthentication(Username, EncryptDecrypt.Encrypt(Password)).Count() > 0) return true;
                if (IsDomainAuthenticated(Username, Password, page)) return ctx.SecurityAffairsAuthentication(Username, null).Count() > 0;
            }
            else if (Mode == "ProvisionsMonitoring")
            {
                if (ctx.ProvisionsMonitoringAuthentication(Username, EncryptDecrypt.Encrypt(Password)).Count() > 0) return true;
                if (IsDomainAuthenticated(Username, Password, page)) return ctx.ProvisionsMonitoringAuthentication(Username, null).Count() > 0;
            }
            return false;
        }

        public static bool IsDomainAuthenticated(string Username , string Password, Page page) 
        {
            try
            {
                using (PrincipalContext PrincipalContext = new PrincipalContext(ContextType.Domain, ConfigurationManager.AppSettings["DomainName"]))
                {
                    if (PrincipalContext.ValidateCredentials(Username, Password))
                    {
                        return true;
                    }
                }
            }
            catch (Exception)
            {
                ConfirmationMessage(ConfigurationManager.AppSettings["DomainConnetionErrorMSG"], page);
                return false;
            }
            return false;
        }
    }
}