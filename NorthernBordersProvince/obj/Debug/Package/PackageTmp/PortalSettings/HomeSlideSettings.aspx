<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="HomeSlideSettings.aspx.cs" Inherits="NorthernBordersProvince.HomeSlideSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var Fud_Pic, hfLastAction, btnClear, imgPicture, btnUpload, divFileUpload;

        function LoadingControls() {
            Fud_Pic = document.getElementById("<%= Fud_Pic.ClientID %>");
            hfLastAction = document.getElementById("<%= hfLastAction.ClientID %>");
            btnClear = document.getElementById('btnClear');
            imgPicture = document.getElementById("<%= imgPicture.ClientID %>");
            btnUpload = document.getElementById("<%= btnUpload.ClientID %>");
            divFileUpload = document.getElementById("<%= divFileUpload.ClientID %>");
        }

        function ClearImg() {
            LoadingControls();

            Fud_Pic.value = null;
            imgPicture.style.position = "absolute";
            imgPicture.style.visibility = "hidden";
            imgPicture.src = "";
            btnClear.style.position = "absolute";
            btnClear.style.visibility = "hidden";
            hfLastAction.value = "empty";
        };

        function PreviewImg() {
            LoadingControls();

            var ext = Fud_Pic.value.split(".")[Fud_Pic.value.split(".").length - 1];
            var acceptable_extensions = "JPG,GIF,PNG,BMP,jpg,gif,png,bmp";
            var alertContent = "";
            
            if (acceptable_extensions.indexOf(ext) < 0) {
                alertContent = alertContent + "صيغة ملف غير مدعومة ، الصيغ المدعومة هي : \r\n(jpg،gif،png،bmp)";
            }

            var file = Fud_Pic.files[0];
            if (alertContent != "") {
                alert(alertContent);
                ClearImg();
                return;
            }

            if (Fud_Pic.files && Fud_Pic.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    hfLastAction.value = "new";
                    ImageShown();
                    imgPicture.src = e.target.result;
                }

                reader.readAsDataURL(Fud_Pic.files[0]);
            }
            else {
                ClearImg();
            }
        };

        function ImageShown() {
            LoadingControls();

            imgPicture.style.visibility = "visible";
            imgPicture.style.position = "inherit";
            btnClear.style.visibility = "visible";
            btnClear.style.position = "inherit";
            divFileUpload.style.backgroundColor = "LightGray";
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
                    <tr>
                        <td class="FormFieldTitleCell FirstRow">صورة شريحة العرض <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <div id="divFileUpload" runat="server" class="FileUploadDiv">
                                <table style="width:100%;" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width:100%;"><input type="button" id="btnUpload" class="EnabledFileUploadButton" runat="server" style="width:100%;" value="رفع صورة لشريحة العرض" onclick="HyperLinkClicked(); return false;" /></td>
                                        <td><input type="button" id="btnClear" class="CancelFileUploadButton" value="X" onclick="ClearImg();" style="visibility:hidden; position:absolute;" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><img id="imgPicture" runat="server" src="" class="FileUploadImage" alt="عرض الصورة"/></td>
                                    </tr>
                                </table>
                                <asp:FileUpload id="Fud_Pic" CssClass="FormsFileUpload" runat="server" onchange="PreviewImg();" class="DropDownListInput" style="padding:5px; margin-left:0px; margin-right:0px; font-size:16px; width: 425px; cursor:pointer;"></asp:FileUpload>
                                <asp:HiddenField ID="hfLastAction" runat="server" Value="empty" />
                            </div>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">الوصف <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtDescription" runat="server" placeholder="قم بإدخال وصف لشريحة العرض هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">الرابط</td>
                        <td class="FormFieldDataCell">
                            <asp:TextBox ID="txtLink" runat="server" placeholder="قم بإدخال رابط للصورة والنص هنا (إختياري)" CssClass="FormLongTextBoxes" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        LoadingControls();
        if (hfLastAction.value == "exists") ImageShown();
    </script>
</asp:Content>
