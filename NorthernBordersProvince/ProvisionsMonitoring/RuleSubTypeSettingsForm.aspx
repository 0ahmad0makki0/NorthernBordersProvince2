<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="RuleSubTypeSettingsForm.aspx.cs" Inherits="NorthernBordersProvince.RuleSubTypeSettingsForm" %>
<%@ Register src="~/ucHijiriDatePicker.ascx" tagname="HijriDatePicker" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .FormFieldTitleCell
        {
            width: 180px;    
        }
    </style>
    <script type="text/javascript">
        function OnTextChanged(txt) {
            if (txt.value == "")
                txt.style.border = "5px solid red";
            else txt.style.border = "5px solid LightGray";
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
                        <td class="FormFieldTitleCell FirstRow">نوع القضية <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <asp:DropDownList ID="ddlRuleType" runat="server" 
                                CssClass="FormLongTextBoxes FormDropDownList" 
                                onchange="OnSelectionChanged(this)" DataSourceID="SqlDataSource1" 
                                DataTextField="Title" DataValueField="RuleType_Id">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                                SelectCommand="sp_GetRuleTypesForSelect"
                                SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">إسم نوع القضية الفرعي <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtTitle" runat="server" placeholder="قم بإدخال إسم نوع القضية الفرعي هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
