<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="RuleDataReport.aspx.cs" Inherits="NorthernBordersProvince.RuleDataReport" %>
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
                        <label style="color:rgb(20,158,83); font-size: 12pt;">تقرير متابعة الأحكام </label>
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
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">رقم القضية</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtCaseNumber" runat="server" placeholder="قم بإدخال رقم الأقضية أو جزئ منه من بدايته هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">نوع القضية</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlRuleType" runat="server"  AutoPostBack="true"
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                DataSourceID="SqlDataSource2" 
                                DataTextField="Title" DataValueField="RuleType_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleTypeForFilter" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">نوع القضية الفرعي</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlRuleSubType" runat="server"
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                DataSourceID="SqlDataSource3" 
                                DataTextField="Title" DataValueField="RuleSubType_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleSubTypeForFilter" 
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlRuleType" Name="RuleType_Id" 
                                        PropertyName="SelectedValue" Type="Int64" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">رقم الخطاب الصادر</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtIssuedLetterNumber" runat="server" placeholder="قم بإدخال رقم الخطاب الصادر أو جزئ من بدايته هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ الخطاب الصادر من</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpIssuedLetterDateFrom" placeholder="قم بإدخال تاريخ الخطاب الصادر هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ الخطاب الصادر إلى</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpIssuedLetterDateTo" placeholder="قم بإدخال تاريخ الخطاب الصادر هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">إسم المتهم</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtAccusedName" runat="server" placeholder="قم بإدخال إسم المتهم أو جزئ منه هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">الجنسية</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlNationality" runat="server"
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                DataSourceID="SqlDataSource4" 
                                DataTextField="Title" DataValueField="Nationality_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetNationalityForFilter" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">رقم السجل المدني</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtAccusedSSN" runat="server" placeholder="قم بإدخال رقم السجل المدني أو جزئ من بدايته هنا"  CssClass="FormLongTextBoxes"  MaxLength="10" onkeypress="return isNumber(event)" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">المنهة</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtOccupation" runat="server" placeholder="قم بإدخال المنهة أو جزئ من النص هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">رقم القرار الشرعي</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtLegalDecisionNumber" runat="server" placeholder="قم بإدخال رقم القرار الشرعي أو جزئ من بدايته هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ القرار الشرعي من</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpLegalDecisionDateFrom" placeholder="قم بإدخال تاريخ القرار الشرعي هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ القرار الشرعي إلى</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpLegalDecisionDateTo" placeholder="قم بإدخال تاريخ القرار الشرعي هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">رقم قرار التأييد</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtSupportingDecisionNumber" runat="server" placeholder="قم بإدخال رقم قرار التأييد أو جزئ من بدايته هنا"  CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ قرار التأييد من</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpSupportingDecisionDateFrom" placeholder="قم بإدخال تاريخ قرار التأييد هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ قرار التأييد إلى</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpSupportingDecisionDateTo" placeholder="قم بإدخال تاريخ قرار التأييد هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">حالة التنفيذ</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlRuleStatus" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                DataSourceID="SqlDataSource1" 
                                DataTextField="Title" DataValueField="RuleStatus_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleStatusesForFilter" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
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
                                        <asp:BoundField DataField="RuleDate_Id_string" HeaderText="رقم الحاسب" 
                                            SortExpression="RuleDate_Id" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="CaseNumber" HeaderText="رقم القضية" 
                                            SortExpression="CaseNumber" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="RuleTypeTitle" HeaderText="نوع القضية" 
                                            SortExpression="RuleTypeTitle" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="IssuedLetterNumber" HeaderText="رقم الخطاب الصادر" 
                                            SortExpression="IssuedLetterNumber" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="IssuedLetterDate_string" HeaderText="تاريخ الخطاب الصادر" 
                                            SortExpression="IssuedLetterDate" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="AccusedName" HeaderText="إسم المتهم" 
                                            SortExpression="AccusedName" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="NationalityTitle" HeaderText="الجنسية" 
                                            SortExpression="NationalityTitle" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="AccusedSSN" HeaderText="رقم السجل المدني" 
                                            SortExpression="AccusedSSN" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="Occupation" HeaderText="المهنة" 
                                            SortExpression="Occupation" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="LegalDecisionNumber" HeaderText="رقم القرار الشرعي" 
                                            SortExpression="LegalDecisionNumber" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="LegalDecisionDate_string" HeaderText="تاريخ القرار الشرعي" 
                                            SortExpression="LegalDecisionDate" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="SupportingDecisionNumber" HeaderText="رقم قرار التأييد" 
                                            SortExpression="SupportingDecisionNumber" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="SupportingDecisionDate_string" HeaderText="تاريخ قرار التأييد" 
                                            SortExpression="SupportingDecisionDate" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="RuleStatusTitle" HeaderText="حالة التنفيذ" 
                                            SortExpression="RuleStatusTitle" ItemStyle-HorizontalAlign="Right" />
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
