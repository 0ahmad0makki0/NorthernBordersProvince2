<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="ProvisionsMonitoringUsersLogsReport.aspx.cs" Inherits="NorthernBordersProvince.ProvisionsMonitoringUsersLogsReport" %>
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
                        <label style="color:rgb(20,158,83); font-size: 12pt;">تقرير سجلات (عمليات) المستخدمين على النظام </label>
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
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">المستخدم</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlUser" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" DataSourceID="SqlDataSource2" 
                                DataTextField="Title" DataValueField="ProvisionsMonitoringUser_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetProvisionsMonitoringUsersForFilter" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">صفحة النظام</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlPage" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" DataSourceID="SqlDataSource3" 
                                DataTextField="Title" DataValueField="ProvisionsMonitoringPage_Id" 
                                AutoPostBack="True">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetProvisionsMonitoringPagesForFilter" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">العملية</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:DropDownList ID="ddlRole" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" DataSourceID="SqlDataSource4" 
                                DataTextField="Title" DataValueField="ProvisionsMonitoringRole_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetProvisionsMonitoringRolesForFilter" 
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlPage" Name="Page_Id" 
                                        PropertyName="SelectedValue" Type="Int64" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ العملية من</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpDOBFrom" placeholder="قم بإدخال تاريخ العملية هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 120px; vertical-align: middle; border:none;">تاريخ العملية إلى</td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <uc1:HijriDatePicker id="dpDOBTo" placeholder="قم بإدخال تاريخ العملية هنا" runat="server" EnableTheming="True" />
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
                                    GridLines="None" DataKeyNames="UserLog_Id"
                                    EmptyDataText="لا يوجد نتائج">
                                    <Columns>
                                        <asp:BoundField DataField="Date_string" HeaderText="تاريخ العملية" 
                                            SortExpression="Date_string" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="Time_string" HeaderText="وقت العملية" 
                                            SortExpression="Time_string" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="Username" HeaderText="إسم المستخدم"
                                            SortExpression="Username" ItemStyle-HorizontalAlign="Center" />
                                        <asp:BoundField DataField="PageTitle" HeaderText="إسم الصفحة" 
                                            SortExpression="PageTitle" ItemStyle-HorizontalAlign="Right" />
                                        <asp:BoundField DataField="RoleTitle" HeaderText="العملية" 
                                            SortExpression="RoleTitle" ItemStyle-HorizontalAlign="Right" />
                                        <asp:TemplateField ItemStyle-HorizontalAlign="Right" HeaderText="الملاحظات">
                                            <ItemTemplate>
                                                <div id="lblNote"><%# Eval("Note") %></div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
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
