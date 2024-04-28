using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class ProvisionsMonitoringUsersLogsReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsProvisionsMonitoringUserAuthorized(4, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض تقرير سجلات (عمليات) المستخدمين", this, "ReportsMain.aspx"); return; }
            if (!IsPostBack)
            {
                dpDOBFrom.SelectedCalendareDate = new DateTime(2016, 10, 24);
                dpDOBTo.SelectedCalendareDate = DateTime.Now;
            }
            else
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            DBEntities ctx = new DBEntities();
            List<sp_GetProvisionsMonitoringUsersLogsReport_Result> logsReport = ctx.GetProvisionsMonitoringUsersLogsReport(
                    long.Parse(ddlUser.SelectedValue),
                    long.Parse(ddlPage.SelectedValue),
                    long.Parse(ddlRole.SelectedValue),
                    dpDOBFrom.SelectedCalendareDate,
                    dpDOBTo.SelectedCalendareDate
                ).ToList();
            gvContents.DataSource = logsReport;
            gvContents.DataBind();

            if (logsReport.Count > 0) divExportButtons.Visible = true;
            else divExportButtons.Visible = false;
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("ReportsMain.aspx");
        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            FL.AddProvisionsMonitoringUserLog(4, 1, "");
        }

        protected void btnExportExcel_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.ToExcel(gvContents, "UsersLogsReport", 2);
        }

        protected void btnExportWord_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.ToWord(gvContents, "UsersLogsReport", 2);
        }

        protected void btnExportPDF_Click(object sender, ImageClickEventArgs e)
        {
            List<int> RTLHeaders = new List<int>();
            List<int> RTLColumns = new List<int>();
            for (int i = 0; i <= gvContents.Columns.Count - 1; i++)
            {
                RTLHeaders.Add(i);
                RTLColumns.Add(i);
            }
            ExportFile.ToPDF(gvContents, "UsersLogsReport", RTLHeaders, RTLColumns, true);
        }

        protected void btnPrint_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.Print(this, "divPrintArea");
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Verifies that the control is rendered */
        }
    }
}