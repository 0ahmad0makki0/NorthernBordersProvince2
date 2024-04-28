<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="AnnouncementSettings.aspx.cs" Inherits="NorthernBordersProvince.AnnouncementSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var Fud_Pic, hfLastAction, btnClear, imgPicture, btnUpload, divFileUpload;

        function LoadingControls() {
            Fud_Pic = document.getElementById("<%= Fud_Pic.ClientID %>");
            hfLastAction = document.getElementById("<%= hfLastAction.ClientID %>");
            btnClear = document.getElementById('btnClear');
            btnUpload = document.getElementById("<%= btnUpload.ClientID %>");
            divFileUpload = document.getElementById("<%= divFileUpload.ClientID %>");
        }

        function ClearImg() {
            LoadingControls();

            Fud_Pic.value = null;
            btnClear.style.position = "absolute";
            btnClear.style.visibility = "hidden";
            hfLastAction.value = "empty";
            btnUpload.className = 'EnabledFileUploadButton';
            btnUpload.value = "رفع ملف التعميم";
            btnUpload.disabled = false;
        };

        function PreviewImg() {
            LoadingControls();

            var ext = Fud_Pic.value.split(".")[Fud_Pic.value.split(".").length - 1];
            var acceptable_extensions = "pdf،PDF";
            var alertContent = "";

            if (acceptable_extensions.indexOf(ext) < 0) {
                alertContent = alertContent + "صيغة ملف غير مدعومة ، الصيغ المدعومة هي : \r\n(pdf)";
            }

            var file = Fud_Pic.files[0];
            if (alertContent != "") {
                alert(alertContent);
                ClearImg();
                return;
            } 
            if (Fud_Pic.files && Fud_Pic.files[0]) {
                hfLastAction.value = "new";
                ImageShown();
            }
            else {
                ClearImg();
            }
        };

        function ImageShown() {
            LoadingControls();

            btnClear.style.visibility = "visible";
            btnClear.style.position = "inherit";
            divFileUpload.style.backgroundColor = "LightGray";
            btnUpload.className = 'DisabledFileUploadButton';
            btnUpload.value = "تم رفع ملف التعميم";
            btnUpload.disabled = true;
        }

        function HyperLinkClicked() {
            document.getElementById('<%= Fud_Pic.ClientID %>').click();
        }

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
                        <td class="FormFieldTitleCell FirstRow">رقم التعميم <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <asp:TextBox ID="txtNumber" runat="server" placeholder="قم بإدخال رقم التعميم هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">تاريخ التعميم <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtDate" runat="server" onchange="OnTextChanged(this)" placeholder="تاريخ هجري (يوم/شهر/سنة)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr>
                        <td class="FormFieldTitleCell">ملف التعميم</td>
                        <td class="FormFieldDataCell">
                            <div id="divFileUpload" runat="server" class="FileUploadDiv">
                                <table style="width:100%;" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width:100%;"><input type="button" id="btnUpload" class="EnabledFileUploadButton" runat="server" style="width:100%;" value="رفع ملف التعميم" onclick="HyperLinkClicked(); return false;" /></td>
                                        <td><input type="button" id="btnClear" class="CancelFileUploadButton" value="X" onclick="ClearImg();" style="visibility:hidden; position:absolute;" /></td>
                                    </tr>
                                </table>
                                <asp:FileUpload id="Fud_Pic" CssClass="FormsFileUpload" runat="server" onchange="PreviewImg();" class="DropDownListInput" style="padding:5px; margin-left:0px; margin-right:0px; font-size:16px; width: 425px; cursor:pointer;"></asp:FileUpload>
                                <asp:HiddenField ID="hfLastAction" runat="server" Value="empty" />
                            </div>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">عنوان التعميم <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtTitle" runat="server" placeholder="قم بإدخال عنوان التعميم هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        LoadingControls();
        if (hfLastAction.value == "exists" || hfLastAction.value == "default") ImageShown();
    </script>
</asp:Content>
