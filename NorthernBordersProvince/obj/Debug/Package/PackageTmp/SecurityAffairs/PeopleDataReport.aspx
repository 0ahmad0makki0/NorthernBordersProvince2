<%@ Page Title="" Language="C#" MasterPageFile="~/SecurityAffairs/SecurityAffairs.Master" AutoEventWireup="true" CodeBehind="PeopleDataReport.aspx.cs" Inherits="NorthernBordersProvince.PeopleDataReport" %>
<%@ Register src="~/ucHijiriDatePicker.ascx" tagname="HijriDatePicker" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .FormFieldTitleCell
        {
            width: 130px;    
        }
    </style>
    <script type="text/javascript">
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var caller = document.getElementById(event.target.id);
            var selectedText;
            // IE version
            if (caller.selection != undefined) {
                caller.focus();
                var sel = caller.selection.createRange();
                selectedText = sel.text;
            }
            // Mozilla version
            else if (caller.selectionStart != undefined) {
                var startPos = caller.selectionStart;
                var endPos = caller.selectionEnd;
                selectedText = caller.value.substring(startPos, endPos)
            }
            var LastValue = caller.value;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31
                    &&
                    (charCode < 48 || charCode > 57)
                    ) {
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="PageContainer">
        <div class="PageTitle">
            <table width="100%">
                <tr style="vertical-align: middle;">
                    <td>
                        <label style="color:rgb(20,158,83); font-size: 12pt;">تقرير معلومات الأشخاص </label>
                        <label style="color:rgba(0,0,0,0.65); font-weight: normal; font-style: italic;">(برجاء تعبئة الحقول أو تركها كما هي ومن ثم النقر على عرض التقرير)</label>
                    </td>
                    <td style="text-align:left; width: 25px;">
                        <asp:ImageButton ID="btnCancel" runat="server" AlternateText="إلغاء الأمر" 
                            CssClass="HeadManibulationButton" ImageUrl="../Images/GridViewImages/Close.png" 
                            OnClientClick="return confirm('هل تريد تأكيد إلغاء الأمر ؟')" 
                            onclick="btnCancel_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <div id="divNotes" class="FormContents">
                <table style="width:100%;">
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">الإسم الرباعي</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtSearchName" runat="server" placeholder="قم بإدخال الإسم الرباعي أو جزئ منه هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">السجل المدني</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtSSN" runat="server" placeholder="قم بإدخال السجل المدني أو بعض الأرقام من بدايته هنا"  CssClass="FormLongTextBoxes"  MaxLength="10" onkeypress="return isNumber(event)" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ الميلاد من</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpDOBFrom" placeholder="قم بإدخال تاريخ الميلاد هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ الميلاد إلى</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpDOBTo" placeholder="قم بإدخال تاريخ الميلاد هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">مكان الميلاد</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtBirthPlace" runat="server" placeholder="قم بإدخال مكان الميلاد أو جزئ منه هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">مكان الإقامة</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtResidencePlace" runat="server" placeholder="قم بإدخال مكان الإقامة أو جزئ منه هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">المؤهل الدراسي</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlEducationLevel" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource1" 
                                DataTextField="Title" DataValueField="EducationLevel_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetEducationLevelsForFilter" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">العمل</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtJobTitle" runat="server" placeholder="قم بإدخال العمل أو جزئ منه هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">مقر العمل</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtWorkPlace" runat="server" placeholder="قم بإدخال مقر العمل أو جزئ منه هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">المؤهل الدراسي</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="DropDownList1" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" DataSourceID="SqlDataSource1" 
                                DataTextField="Title" DataValueField="EducationLevel_Id">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">الملاحظة</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:CheckBox ID="ckbShowHasNotes" runat="server" Text="عرض الأشخاص الذين عليهم ملاحظات" Checked="true"/>
                            <br />
                            <asp:CheckBox ID="ckbShowHasNoNotes" runat="server" Text="عرض الأشخاص الذين ليست عليهم ملاحظات" Checked="true"/>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;"></td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:Button ID="btnShowReport" runat="server" CssClass="FormButtons" Text="عرض التقرير" onclick="btnShowReport_Click" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td colspan="2">
                            <div id="divExportButtons" runat="server" visible="false" style="border-top: 2px solid gray; margin-top: 15px; padding-top: 15px; text-align: left;">
                                <asp:ImageButton ID="btnExportExcel" runat="server" 
                                    CssClass="HeadManibulationButton" ImageUrl="~/Images/Excel.png" 
                                    onclick="btnExportExcel_Click" />
                                <asp:ImageButton ID="btnExportWord" runat="server" 
                                    CssClass="HeadManibulationButton" ImageUrl="~/Images/Word.png" 
                                    onclick="btnExportWord_Click" />
                                <asp:ImageButton ID="btnExportPDF" runat="server" 
                                    CssClass="HeadManibulationButton" ImageUrl="~/Images/PDF.png" 
                                    onclick="btnExportPDF_Click" />
                                <asp:ImageButton ID="btnPrint" runat="server" CssClass="HeadManibulationButton" 
                                    ImageUrl="~/Images/Print.png" onclick="btnPrint_Click" />
                            </div>
                            <div id="divPrintArea">
                                <asp:GridView ID="gvContents" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False"
                                    GridLines="None" 
                                    EmptyDataText="لا يوجد نتائج" >
                                    <Columns>
                                        <asp:BoundField DataField="PeopleDate_Id_string" HeaderText="رقم الحاسب" 
                                            SortExpression="PeopleDate_Id" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="FullName" HeaderText="الإسم الرباعي" 
                                            SortExpression="FullName" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="SSN" HeaderText="السجل المدني" 
                                            SortExpression="SSN" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="DOB_string" HeaderText="تاريخ الميلاد" 
                                            SortExpression="DOB" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="BirthPlace" HeaderText="مكان الميلاد" 
                                            SortExpression="BirthPlace" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="ResidencePlace" HeaderText="مكان الإقامة" 
                                            SortExpression="ResidencePlace" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="EducationLevelString" HeaderText="المؤهل الدراسي" 
                                            SortExpression="EducationLevelString" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="JobTitle" HeaderText="العمل" 
                                            SortExpression="JobTitle" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="WorkPlace" HeaderText="مقر العمل" 
                                            SortExpression="WorkPlace" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="HasNotes" HeaderText="عليه ملاحظات" 
                                            SortExpression="HasNotes" ItemStyle-HorizontalAlign="Right" />
                                    </Columns>
                                    <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                                    <PagerStyle CssClass="GridViewTabularPager" HorizontalAlign="Center" />
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
