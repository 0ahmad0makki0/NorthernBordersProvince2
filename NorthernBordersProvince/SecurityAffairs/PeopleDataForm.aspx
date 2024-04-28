<%@ Page Title="" Language="C#" MasterPageFile="~/SecurityAffairs/SecurityAffairs.Master" AutoEventWireup="true" CodeBehind="PeopleDataForm.aspx.cs" Inherits="NorthernBordersProvince.PeopleDataForm" %>
<%@ Register src="~/ucHijiriDatePicker.ascx" tagname="HijriDatePicker" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .FormFieldTitleCell
        {
            width: 130px;    
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
                        <td class="FormFieldTitleCell FirstRow">الإسم الرباعي <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <asp:TextBox ID="txtFullName" runat="server" placeholder="قم بإدخال الإسم الرباعي هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">السجل المدني <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtSSN" runat="server" placeholder="قم بإدخال السجل المدني هنا" MaxLength="10" onkeypress="return isNumber(event)" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">تاريخ الميلاد <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <uc1:HijriDatePicker id="dpDOB" placeholder="قم بإدخال تاريخ الميلاد هنا" runat="server" EnableTheming="True" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">مكان الميلاد <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtBirthPlace" runat="server" placeholder="قم بإدخال مكان الميلاد هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">مقر الإقامة <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtResidencePlace" runat="server" placeholder="قم بإدخال مقر الإقامة هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">المؤهل الدراسي <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:DropDownList ID="ddlEducationLevel" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource1" 
                                DataTextField="Title" DataValueField="EducationLevel_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetEducationLevelsForSelect" 
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">العمل <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtJobTitle" runat="server" placeholder="قم بإدخال العمل هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">مقر العمل <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtWorkPlace" runat="server" placeholder="قم بإدخال مقر العمل هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
