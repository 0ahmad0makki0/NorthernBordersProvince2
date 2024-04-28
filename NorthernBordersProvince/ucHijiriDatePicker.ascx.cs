using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.ComponentModel;
using NorthernBordersProvince;

namespace NorthernBordersProvince
{
    public partial class ucHijiriDatePicker : System.Web.UI.UserControl
    {
        // I used these classes for date conversion between Hijri and Gregorian
        private UmAlQuraCalendar hijriCal = new UmAlQuraCalendar();
        private GregorianCalendar gregCal = new GregorianCalendar(GregorianCalendarTypes.USEnglish);

        private CultureInfo arabicCulture = new CultureInfo("ar-SA");
        private CultureInfo englishCulture = new CultureInfo("en-US");

        private CultureInfo selected_culture;

        // the date format
        private string strFormat = "dd/MM/yyyy";

        // expose the selected Date (read/write)
        public DateTime? SelectedCalendareDate
        {
            set
            {
                ctlCalendarLocalized.SelectedDate = value.Value;
                ctlCalendarLocalized.VisibleDate = value.Value;
                ctlCalendarLocalized_SelectionChanged(null, null);
                ddlYear.SelectedValue = ctlCalendarLocalized.SelectedDate.ToString(strFormat).Substring(6, 4).ToString();
                ddlMonth.SelectedIndex = int.Parse(ctlCalendarLocalized.SelectedDate.ToString(strFormat).Substring(3, 2).ToString()) - 1;
            }
            get
            {
                if (ctlCalendarLocalized.SelectedDate.Date.Year == 1) return null;
                else return ctlCalendarLocalized.SelectedDate;
            }
        }

        public bool ReadOnly
        {
            set
            {
                txtHijri.Style["pointer-events"] = "none";
                imgCalendar.Style["pointer-events"] = "none";
                whole_calendar.Style["pointer-events"] = "none";
                txtHijri.Style["cursor"] = "default";
                imgCalendar.Style["cursor"] = "default";
                whole_calendar.Style["cursor"] = "default";
                txtHijri.ReadOnly = true;
            }
            get
            {
                return txtHijri.ReadOnly;
            }
        }

        //I used Enum to show the little Intellisense box pop up with your options for culture
        public enum DefaultCultureOption
        {
            Hijri,
            Grgorian
        }
        public DefaultCultureOption DefaultCalendarCulture { get; set; }

        // expose the property to get Hijri text date
        public string getHijriDateText
        {
            get { return txtHijri.Text; }
        }

        private int m_minValue = -100;
        private int m_maxValue = 100;

        //expose the property Minimum Year before current Year (Read/Write)
        public int MinYearCountFromNow
        {
            get
            {
                return m_minValue;
            }
            set
            {
                if (value >= this.MaxYearCountFromNow)
                {
                    throw new Exception("MinValue must be less than MaxValue.");
                }
                else
                {
                    m_minValue = value;
                }
            }
        }

        //expose the property Maximum Year After current Year (Read/Write)
        public int MaxYearCountFromNow
        {
            get
            {
                return m_maxValue;
            }
            set
            {
                if (value <= this.MinYearCountFromNow)
                {
                    throw new
                        Exception("MaxValue must be greater than MinValue.");
                }
                else
                {
                    m_maxValue = value;
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //incase the DefaultCalendarCulture=null the user control will take the first item in the dropdown list
                selected_culture = new System.Globalization.CultureInfo(arabicCulture.Name);
                System.Threading.Thread.CurrentThread.CurrentCulture = selected_culture;
                System.Threading.Thread.CurrentThread.CurrentUICulture = selected_culture;

                //to populate the dropdown lists according to the selected culture
                Populate_Hijri_Month_ddl();
                Populate_Hijri_Years_ddl();

                // to show hide the date picker div when user click on textbox or calendar image
                txtHijri.Attributes.Add("onclick", "showHide('" + this.whole_calendar.ClientID + "');");
                imgCalendar.Attributes.Add("onclick", "showHide('" + this.whole_calendar.ClientID + "');");

                //To set the default view of date picker div to hidden
                ScriptManager.RegisterStartupScript(CalendarUpdatePanel, typeof(string), "ShowPopup" + this.whole_calendar.ClientID,
                                                    "document.getElementById('" + this.whole_calendar.ClientID + "').style.display = 'none';", true);

                //set the default calendar date to today
                ctlCalendarLocalized.TodaysDate = DateTime.Now;

                //in case the calendar control have selected date, populate the year and month drop down lists according to it
                if (ctlCalendarLocalized.SelectedDate.Date == DateTime.MinValue)
                {
                    ddlYear.SelectedValue = DateTime.Now.ToString(strFormat, selected_culture.DateTimeFormat).Substring(6, 4).ToString();
                    ddlMonth.SelectedIndex = int.Parse(DateTime.Now.ToString(strFormat).Substring(3, 2).ToString()) - 1;
                }

            }
            else
            {
                var senderAsControl = sender as Control;
                string ParentUCname = senderAsControl.UniqueID;

                //To get the potpack control name
                string strPostBackControlName = getPostBackControlName();

                //If the post back triggered from LocaleCalendar dropdown list, year dropdown list or month dropdown list the calendar div 
                //will stay visible but if triggered by other controls the calendar div will be changed to hidden.
                if (strPostBackControlName != ParentUCname + "$" + "ddlYear" && strPostBackControlName != ParentUCname + "$" + "ddlMonth"
                    && strPostBackControlName != ParentUCname + "$" + "ddlLocaleChoice")
                {
                    //to manage multiple instances of user control postback, incase the postback happend due to culture changeed in current control,
                    //the other user contrls culture drop down list to be changed accordingly. Also year and month dropdown lists according to culture 
                    if (strPostBackControlName != "" && strPostBackControlName.Substring(strPostBackControlName.LastIndexOf("$")) == "$ddlLocaleChoice")
                    {
                        ddlMonth.Items.Clear();
                        ddlYear.Items.Clear();
                        Populate_Hijri_Month_ddl();
                        Populate_Hijri_Years_ddl();
                    }
                    //To hide the calendar div in case of any postback other than the three controls (Culture ddl, Year ddl, Month ddl)
                    ScriptManager.RegisterStartupScript(CalendarUpdatePanel, typeof(string), "ShowPopup" + this.whole_calendar.ClientID,
                                                        "document.getElementById('" + this.whole_calendar.ClientID + "').style.display = 'none';", true);
                }

                //to keep the selected culture in case the post back triggered by any control    
                selected_culture = new System.Globalization.CultureInfo(arabicCulture.Name);
                System.Threading.Thread.CurrentThread.CurrentCulture = selected_culture;
                System.Threading.Thread.CurrentThread.CurrentUICulture = selected_culture;

            }
        }

        //when culture changed in drodon list 
        protected void ddlLocaleChoice_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlMonth.Items.Clear();
            ddlYear.Items.Clear();
            Populate_Hijri_Month_ddl();
            Populate_Hijri_Years_ddl();

            try
            {
                //Sates are represented by DateTime type in .NET. And DateTime is a struct e.g a value type, not a reference type and therefore it can never 
                //be null reference. Instead with valuer types, there's always a default value, which in this case is DateTime.MinValue
                if (ctlCalendarLocalized.SelectedDate.Date != DateTime.MinValue)
                {
                    // to change the year and month when the user change the locale calendar
                    //ddlYear.SelectedValue = ctlCalendarLocalized.SelectedDate.ToString(strFormat).Substring(6, 4).ToString();
                    ddlYear.SelectedValue = ctlCalendarLocalized.SelectedDate.ToString(strFormat, selected_culture.DateTimeFormat).Substring(6, 4).ToString();

                    ddlMonth.SelectedIndex = int.Parse(ctlCalendarLocalized.SelectedDate.ToString(strFormat).Substring(3, 2).ToString()) - 1;
                }
                else
                {
                    // to set current date as default date incase of the user did not select 
                    //ddlYear.SelectedValue = DateTime.Now.ToString(strFormat).Substring(6, 4).ToString();
                    ddlYear.SelectedValue = DateTime.Now.ToString(strFormat, selected_culture.DateTimeFormat).Substring(6, 4).ToString();
                    ddlMonth.SelectedIndex = int.Parse(DateTime.Now.ToString(strFormat).Substring(3, 2).ToString()) - 1;
                }
            }
            catch (System.ArgumentOutOfRangeException ex)
            {
                //this error happened when the selected year in one calendar does not have equivalant in the year dropdwon list
                //but the result will not be affected
                //do nothing
            }
            finally
            {

            }
        }

        //to populate hijri and gregorian textboxes when user select the day
        protected void ctlCalendarLocalized_SelectionChanged(object sender, EventArgs e)
        {
            txtHijri.Text = ctlCalendarLocalized.SelectedDate.ToString("yyyy/MM/dd", new CultureInfo("ar-SA").DateTimeFormat);
            try
            {
                DBEntities ctx = new DBEntities();
                ctx.GetGeorgianDate(txtHijri.Text);
            }
            catch (Exception)
            {
                SelectedCalendareDate = SelectedCalendareDate.Value.AddDays(-1);
            }
        }

        //to change the year in calendar control according to the selected month in the dropdown list 
        protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
        {
            ctlCalendarLocalized.SelectedDate = new DateTime(int.Parse(ddlYear.SelectedValue), ddlMonth.SelectedIndex + 1, 1, hijriCal);
            ctlCalendarLocalized.VisibleDate = ctlCalendarLocalized.SelectedDate;

        }

        //to change the year in calendar control according to the selected year in the dropdown list 
        protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
        {
            ctlCalendarLocalized.SelectedDate = new DateTime(int.Parse(ddlYear.SelectedValue), ddlMonth.SelectedIndex + 1, 1, hijriCal);
            ctlCalendarLocalized.VisibleDate = ctlCalendarLocalized.SelectedDate;

        }

        //To populate the Higri Months in dropdown list
        private void Populate_Hijri_Month_ddl()
        {
            ddlMonth.Items.Add("01 - محرم");
            ddlMonth.Items.Add("02 - صفر");
            ddlMonth.Items.Add("03 - ربيع الأول");
            ddlMonth.Items.Add("04 - ربيع الثاني");
            ddlMonth.Items.Add("05 - جمادي الأول");
            ddlMonth.Items.Add("06 - جمادي الثاني");
            ddlMonth.Items.Add("07 - رجب");
            ddlMonth.Items.Add("08 - شعبان");
            ddlMonth.Items.Add("09 - رمضان");
            ddlMonth.Items.Add("10 - شوال");
            ddlMonth.Items.Add("11 - ذو القعدة");
            ddlMonth.Items.Add("12 - ذو الحجة");
        }

        //To populate the Hijri Years in dropdown list
        private void Populate_Hijri_Years_ddl()
        {
            //To Get the year according to Hijri Calendar
            string strCurrentYear = DateTime.Now.ToString("yyyy", new System.Globalization.CultureInfo(arabicCulture.Name));

            //Year list can be extended
            int intYear;
            for (intYear = Convert.ToInt16(strCurrentYear) + MinYearCountFromNow; intYear <= Convert.ToInt16(strCurrentYear) + MaxYearCountFromNow; intYear++)
            {
                ddlYear.Items.Add(Convert.ToString(intYear));
            }
            ddlYear.Items.FindByValue(strCurrentYear).Selected = true;
        }

        //To get the potpack control name
        private string getPostBackControlName()
        {
            Control control = null;
            //first we will check the "__EVENTTARGET" because if post back made by the controls
            //which used "_doPostBack" function also available in Request.Form collection.
            string ctrlname = Page.Request.Params["__EVENTTARGET"];
            if (ctrlname != null && ctrlname != String.Empty)
            {
                control = Page.FindControl(ctrlname);
            }

            if (control == null)
            {
                return string.Empty;
            }
            else
            {
                //to catch the control name in case of multiple instances
                return control.UniqueID;
            }
        }
    }
}