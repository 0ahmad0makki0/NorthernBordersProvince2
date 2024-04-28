using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NorthernBordersProvince
{
    public partial class PeopleDataNotes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!FL.IsSecurityAffairsUserAuthorized(2, 2) &&
                !FL.IsSecurityAffairsUserAuthorized(2, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية للدخول على الملاحظات على الأشخاص", this, "PeopleDataMain.aspx"); return; }
            if (Request.QueryString["ID"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PeopleDataMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            if (ctx.PeopleDatas.Count(s => s.PeopleData_Id == TestID) == 0) { Response.Redirect("PeopleDataMain.aspx"); return; }
            PeopleData peopleData = ctx.PeopleDatas.First(pd => pd.PeopleData_Id == TestID);
            lblTitle.Text = "صفحة الملاحظات على "  + peopleData.FullName + " [" + peopleData.SSN + "]";
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            if (Request.QueryString["ID"] == null) { Response.Redirect("PeopleDataMain.aspx"); return; }
            long TestID;
            if (!long.TryParse(Request.QueryString["ID"], out TestID)) { Response.Redirect("PeopleDataMain.aspx"); return; }
            DBEntities ctx = new DBEntities();
            PeopleData peopleData = ctx.PeopleDatas.First(pd => pd.PeopleData_Id == TestID);
            List<PeopleDataNote> notes = peopleData.PeopleDataNotes.ToList();
            hfNotesTableData.Value = "";
            for (int i = 0; i < notes.Count; i++)
            {
                string s1 = "#0$%", s2 = "&^9%";
                if (i > 0) hfNotesTableData.Value += s1;
                hfNotesTableData.Value += notes[i].PeopeDataNote_Id.ToString() + s2 + notes[i].Content + s2 + "exists";
            }
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (hfNotesTableData.Value.Contains("new"))
                if (!FL.IsSecurityAffairsUserAuthorized(2, 2)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لإضافة الملاحظات على الأشخاص", this); return; }

            if (hfNotesTableData.Value.Contains("deleted"))
                if (!FL.IsSecurityAffairsUserAuthorized(2, 4)) { FL.ConfirmationMessage("لا توجد لديك صلاحية لحذف الملاحظات على الأشخاص", this); return; }

            if (hfNotesTableData.Value == "")
            {
                FL.ConfirmationMessage("لا يوجد ملاحظات لحفظها", this);
                return;
            }
            DBEntities ctx = new DBEntities();
            List<PeopleDataNote> notes = new List<PeopleDataNote>();
            long PeopleData_Id = long.Parse(Request.QueryString["ID"]);
            string[] RowsSplitter = { "#0$%" };
            string[] sRows = hfNotesTableData.Value.Split(RowsSplitter, StringSplitOptions.RemoveEmptyEntries);
            for(int i = 0 ; i <= sRows.Length - 1 ; i++)
            {
                string[] ValuesSplitter = { "&^9%" };
                string[] sValues = sRows[i].Split(ValuesSplitter , StringSplitOptions.RemoveEmptyEntries);
                if(sValues.Length == 3)
                {
                    string content = sValues[1];
                    string status = sValues[2];
                    if(status == "new")
                    {
                        PeopleDataNote note = new PeopleDataNote()
                        {
                            Content = content,
                            PeopleData_Id = PeopleData_Id
                        };
                        ctx.PeopleDataNotes.AddObject(note);
                        ctx.SaveChanges();
                        FL.AddSecurityAffairsUserLog(2, 2, note.PeopleData.FullName + " [" + note.PeopleData.SSN + "] ، النص : " + note.Content);
                    }
                    else if(status == "deleted")
                    {
                        long id = long.Parse(sValues[0]);
                        PeopleDataNote note = ctx.PeopleDataNotes.First(pdn => pdn.PeopeDataNote_Id == id);

                        FL.AddSecurityAffairsUserLog(2, 4, note.PeopleData.FullName + " [" + note.PeopleData.SSN + "] ، النص : " + note.Content);

                        ctx.PeopleDataNotes.DeleteObject(note);
                        ctx.SaveChanges();
                    }
                }
            }

            FL.ConfirmationMessage("تم حفظ الملاحظات بنجاح", this, "PeopleDataMain.aspx");
        }

        protected void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("PeopleDataMain.aspx");
        }
    }
}