using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class PeopleDataReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsSecurityAffairsUserAuthorized(4, 1)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لعرض تقرير الأشخاص", this, "ReportsMain.aspx"); return; }
            if (!IsPostBack)
            {
                dpDOBFrom.SelectedCalendareDate = new DateTime(DateTime.Now.Year - 60, 1, 1);
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
            List<sp_GetPeopleDataReport_Result> peopleDataReport = ctx.GetPeopleDataReport(
                txtSearchName.Text,
                txtSSN.Text,
                dpDOBFrom.SelectedCalendareDate,
                dpDOBTo.SelectedCalendareDate,
                txtBirthPlace.Text,
                txtResidencePlace.Text,
                long.Parse(ddlEducationLevel.SelectedValue),
                txtJobTitle.Text,
                txtWorkPlace.Text,
                ckbShowHasNotes.Checked,
                ckbShowHasNoNotes.Checked).ToList();
            gvContents.DataSource = peopleDataReport;
            gvContents.DataBind();

            if (peopleDataReport.Count > 0) divExportButtons.Visible = true;
            else divExportButtons.Visible = false;
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("ReportsMain.aspx");
        }

        protected void btnShowReport_Click(object sender, EventArgs e)
        {
            FL.AddSecurityAffairsUserLog(4, 1, "");
        }

        protected void btnExportExcel_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.ToExcel(gvContents, "PeopleDataReport", -1);
        }

        protected void btnExportWord_Click(object sender, ImageClickEventArgs e)
        {
            ExportFile.ToWord(gvContents, "PeopleDataReport", -1);
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
            ExportFile.ToPDF(gvContents, "PeopleDataReport", RTLHeaders, RTLColumns, true);
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