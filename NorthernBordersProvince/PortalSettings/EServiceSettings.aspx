<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="EServiceSettings.aspx.cs" Inherits="NorthernBordersProvince.EServiceSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnTextChanged(txt) {
            if (txt.value == "")
                txt.style.border = "5px solid red";
            else txt.style.border = "5px solid LightGray";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                        <td class="FormFieldTitleCell FirstRow">إسم الخدمة الإلكترونية <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <asp:TextBox ID="txtTitle" runat="server" placeholder="قم بإدخال عنوان الخدمة الإلكترونية" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">رابط الخدمة الإلكترونية<label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtLink" runat="server" placeholder="قم بإدخال رابط الخدمة الإلكترونية هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes LinkText" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
