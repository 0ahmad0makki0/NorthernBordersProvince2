<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="RuleDataForm.aspx.cs" Inherits="NorthernBordersProvince.RuleDataForm" %>
<%@ Register src="~/ucHijiriDatePicker.ascx" tagname="HijriDatePicker" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .FormFieldTitleCell
        {
            width: 140px;    
        }
        .FormLongCalendarTextBoxes
        {
            width: 91%;    
        }
    </style>
    <script type="text/javascript">
        function OnTextChanged(txt) {
            if (txt.value == "")
                txt.style.border = "5px solid red";
            else txt.style.border = "5px solid LightGray";
        }

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

        function OnSelectionChanged(ddl) {
            if (ddl.selectedIndex == "0") {
                ddl.style.border = "5px solid red";
                ddl.style.color = "Gray";
            }
            else {
                ddl.style.border = "5px solid LightGray";
                ddl.style.color = "Black";
            }
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
                        <asp:Label ID="lblTitle" runat="server"></asp:Label>
                    </td>
                    <td style="text-align:left; width: 25px;">
                        <asp:ImageButton ID="btnSave" runat="server" AlternateText="حفظ" 
                            CssClass="HeadManibulationButton" ImageUrl="../Images/GridViewImages/Save.png" 
                            OnClientClick="return confirm('هل تريد تأكيد عملية الحفظ ؟')" 
                            onclick="btnSave_Click" />
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
            <div class="FormContents">
                <table style="width:100%;">
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell FirstRow">رقم القضية <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <asp:TextBox ID="txtCaseNumber" runat="server" placeholder="قم بإدخال رقم القضية هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">نوع القضية <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:DropDownList ID="ddlRuleType" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource2" 
                                DataTextField="Title" DataValueField="RuleType_Id" AutoPostBack="True">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleTypesForSelect" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">نوع القضية الفرعي <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:DropDownList ID="ddlRuleSubType" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource3" 
                                DataTextField="Title" DataValueField="RuleSubType_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleSubTypesForSelect" 
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlRuleType" Name="RuleType_Id" 
                                        PropertyName="SelectedValue" Type="Int64" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">رقم الخطاب الصادر</td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtIssuedLetterNumber" runat="server" placeholder="قم بإدخال رقم الخطاب الصادر هنا" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">تاريخه</td>
                        <td class="FormFieldDataCell">
                            <uc1:HijriDatePicker id="dpIssuedLetterDate" placeholder="قم بإدخال تاريخ الخطاب الصادر هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">إسم المتهم <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtAccusedName" runat="server" placeholder="قم بإدخال إسم المتهم هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">الجنسية <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:DropDownList ID="ddlNationality" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource4" 
                                DataTextField="Title" DataValueField="Nationality_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource4" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetNationalitiesForSelect" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">رقم السجل المدني <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtAccusedSSN" runat="server" placeholder="قم بإدخال رقم السجل المدني هنا" MaxLength="10" onkeypress="return isNumber(event)" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">المهنة <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtOccupation" runat="server" placeholder="قم بإدخال المهنة هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">رقم القرار الشرعي</td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtLegalDecisionNumber" runat="server" placeholder="قم بإدخال رقم القرار الشرعي هنا" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">تاريخه</td>
                        <td class="FormFieldDataCell">
                            <uc1:HijriDatePicker id="dpLegalDecisionDate" placeholder="قم بإدخال تاريخ القرار الشرعي هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">رقم قرار التأييد</td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtSupportingDecisionNumber" runat="server" placeholder="قم بإدخال رقم قرار التأييد هنا" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">تاريخه</td>
                        <td class="FormFieldDataCell">
                            <uc1:HijriDatePicker id="dpSupportingDecisionDate" placeholder="قم بإدخال تاريخ قرار التأييد هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">حالة التنفيذ <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:DropDownList ID="ddlRuleStatus" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource1" 
                                DataTextField="Title" DataValueField="RuleStatus_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleStatusForSelect" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
