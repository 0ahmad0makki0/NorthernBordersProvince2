<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucHijiriDatePicker.ascx.cs" Inherits="NorthernBordersProvince.ucHijiriDatePicker" %>
<style type="text/css">
    .whole_calendar /* whole Calendar Header Div Style without textboxes*/
    {
        width: 280px;
        height: 200px;
        position:absolute;            
        border-style:solid;
        border-width:1px;       
        border-color:black;       
        overflow:auto;          
        background-color: #E6E6FA;  
    }
        
    #Header_Div         /* Calendar Header Div Style */
    {
        position:relative;
	    height: 20px;
	    padding-top:5px;
	    padding-bottom:10px;
	    vertical-align: middle;
	    background-color: #E6E6FA;
    }        
    .clsText
    {
        font-family: Tahoma;
        font-size: 10pt;
        width: 100px;
        border: solid 1px #000;
    }

    .fldLabel
    {
        font-family: Tahoma;
        color: #58595b;
        font-size: 10pt;
        width: 100px;
    }

    .ctlHeader
    {
        padding-left:5px;
        padding-right:5px;
    }
    .clsDDL
    {
        font-size: 10pt;
        color: black;
        vertical-align: bottom;
        padding: 0;
        border: 1px #b5b7b9 solid;
        font-family:Tahoma;
    }
    #clsLocCalendar
    {
        padding-right:2px;
        padding-left:2px;
        text-align:center;
    }
    
    .ManibulationButton
    {
        cursor: pointer;    
    }

</style>
<script type="text/javascript">
    //To Show hide the div when user click on calendar image or the date text boxes
    function showHide(div) {
        if (document.getElementById(div).style.display == "none") {
            document.getElementById(div).style.display = "block";
        }
        else { document.getElementById(div).style.display = "none"; }
    }
</script>

<script type="text/javascript">

    //to hide the date picker when user click outside the date picker box
    document.onclick = function (e) {
        e = e || event
        var target = e.target || e.srcElement
        var box = document.getElementById('<% =this.whole_calendar.ClientID %>')
        var imgCal = document.getElementById('<% =this.imgCalendar.ClientID %>')
        var txtHijri = document.getElementById('<% =this.txtHijri.ClientID %>')
        do {
            if (box == target | imgCal == target | txtHijri == target) {
                // Click occured inside the box, do nothing.
                return
            }
            target = target.parentNode
        }
        while (target)
        // Click was outside the box, hide it.
        box.style.display = "none"
    }

</script>
<asp:UpdatePanel ID="CalendarUpdatePanel" runat="server">
    <ContentTemplate>
        <div>
            <asp:TextBox ID="txtHijri" runat="server" CssClass="FormLongCalendarTextBoxes" ReadOnly="true" placeholder="قم بإدخال التاريخ هنا" ></asp:TextBox>
            <asp:Image  ID="imgCalendar" AlternateText="calendar" 
                ImageUrl="Images/calendar.gif" runat="server" CssClass="ManibulationButton" />
        </div>
        <div id="whole_calendar" runat="server"  class="whole_calendar" >
            <div id="Header_Div">
                <table>
                    <tr>
                        <td class="ctlHeader">
                            <asp:DropDownList ID="ddlYear" runat="server" width="125px" AutoPostBack="True" 
                                OnSelectedIndexChanged="ddlYear_SelectedIndexChanged" CssClass="clsDDL">
                            </asp:DropDownList>            
                        </td>
                        <td class="ctlHeader">
                            <asp:DropDownList ID="ddlMonth" runat="server" width="125px" AutoPostBack="True" 
                                OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged" CssClass="clsDDL">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="clsLocCalendar">
                <asp:Calendar ID="ctlCalendarLocalized" runat="server" BackColor="White" 
                    BorderColor="White" 
                    Font-Names="Verdana" Font-Size="10pt" ForeColor="Black" Height="125px"  
                    Width="275px" BorderWidth="1px" NextPrevFormat="FullMonth" 
                    ShowDayHeader="True" ShowNextPrevMonth="False"
                    OnSelectionChanged="ctlCalendarLocalized_SelectionChanged">
                    <DayHeaderStyle Font-Bold="True" Font-Size="7pt"  Font-Names="Tahoma" />
                    <NextPrevStyle VerticalAlign="Bottom" Font-Bold="True" Font-Size="8pt" 
                        ForeColor="#333333" />
                    <OtherMonthDayStyle ForeColor="#999999" />
                    <SelectedDayStyle BackColor="#333399" ForeColor="White" />
                    <TitleStyle BackColor="White" BorderColor="Black" Font-Bold="True" 
                        BorderWidth="1px" Font-Size="9pt" ForeColor="#333399" BorderStyle="Ridge" Font-Names="sans-serif" />
                    <TodayDayStyle BackColor="#CCCCCC" />
                </asp:Calendar>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
