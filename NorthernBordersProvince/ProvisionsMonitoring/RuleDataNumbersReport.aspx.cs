using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class RuleDataNumbersReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.MaintainScrollPositionOnPostBack = true;
            if (!FL.IsProvisionsMonitoringUserAuthorized(9, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض تقرير عدد الأحكام بالفئات", this, "ReportsMain.aspx"); return; }
            if (!IsPostBack)
            {
                //ViewState["ShowCommand"] = false;
            }
            else
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            //if ((bool)ViewState["ShowCommand"] == false) return;
            DBEntities ctx = new DBEntities();

            gvContents.DataBound += (s, e) => { /*ViewState["ShowCommand"] = false;*/ gvContents.Columns[0].HeaderText = ddlGroupBy.SelectedItem.Text; };
            List<GetRuleDataReportByGrouping_Result> ruleDataReport = ctx.GetRuleDataReportByGrouping(long.Parse(ddlGroupBy.SelectedValue), dpIssuedLetterDateFrom.SelectedCalendareDate, dpIssuedLetterDateTo.SelectedCalendareDate).ToList();
            gvContents.DataSource = ruleDataReport;
            gvContents.DataBind();

            if (ruleDataReport.Count > 0) divExportButtons.Visible = true;
            else divExportButtons.Visible = false;
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("ReportsMain.aspx");
        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            //ViewState["ShowCommand"] = true;
            LoadData();
            FL.AddProvisionsMonitoringUserLog(3, 1, "");
        }

        protected void btnExportExcel_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.ToExcel(gvContents, "RuleDataReport", -1);
        }

        protected void btnExportWord_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.ToWord(gvContents, "RuleDataReport", -1);
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
            ExportFile.ToPDF(gvContents, "RuleDataReport", RTLHeaders, RTLColumns, true);
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