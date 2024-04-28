<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="RuleDataAttachments.aspx.cs" Inherits="NorthernBordersProvince.RuleDataAttachments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Styles/PopupWindowStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .FormFieldTitleCell
        {
            width: 130px;    
        }
        .ClearStyle
        {
            background-color: rgba(0,0,0,0);
            border: none;    
        }
    </style>
    <script type="text/javascript">
        function OnTextChanged(txt) {
            if (txt.value == "")
                txt.style.border = "5px solid red";
            else txt.style.border = "5px solid LightGray";
        }

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
            btnUpload.value = "رفع الملف";
            btnUpload.disabled = false;
        };

        function PreviewImg() {
            LoadingControls();

            var ext = Fud_Pic.value.split(".")[Fud_Pic.value.split(".").length - 1];
            var alertContent = "";

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
            btnUpload.value = "تم رفع الملف";
            btnUpload.disabled = true;
        }

        function HyperLinkClicked() {
            document.getElementById('<%= Fud_Pic.ClientID %>').click();
        }

        function OnUploadAttachment() {
            var lblNotes = document.getElementById('lblNotes');
            if (document.getElementById('<%= Fud_Pic.ClientID %>').value && document.getElementById('<%= txtFileName.ClientID %>').value) {
                HideNotes();
                return confirm('هل تريد تأكيد رفع الملف');
            }
            else {
                
                lblNotes.style['visibility'] = 'visible';
                lblNotes.style['position'] = 'inherit';
                return false;
            }
        }

        function HideNotes()
        { 
            var lblNotes = document.getElementById('lblNotes');
            lblNotes.style['visibility'] = 'hidden';
            lblNotes.style['position'] = 'absolute';
        }
    </script>
    <script type="text/javascript">
        
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
                        <a href="../Files/UserGuide/ProvisionsMonitoring/RuleDataAttachments.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
                    </td>
                    <td style="text-align:left; width: 25px;">
                        <asp:ImageButton ID="btnCancel" runat="server" AlternateText="إلغاء الأمر" 
                            CssClass="HeadManibulationButton" ImageUrl="../Images/GridViewImages/Close.png" 
                            OnClientClick="return confirm('هل تريد تأكيد إغلاق الصفحة ؟')" 
                            onclick="btnCancel_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <div style="text-align: center; margin: 10px 0px;">
                <a style="border:none;" onclick="ShowPopup('0'); HideNotes();"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
            </div>
            <asp:GridView ID="gvContents" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" 
                GridLines="None" AllowPaging="True" PageSize="30" AllowSorting="true"
                EmptyDataText="لا يوجد مرفقات" 
                DataKeyNames="RuleDataAttachment_Id"
                onrowcommand="gvContents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="UploadDate" HeaderText="تاريخ الرفع" 
                        SortExpression="UploadDate" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="UploadTime" HeaderText="وقت الرفع" 
                        SortExpression="UploadTime" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Description" HeaderText="إسم الملف" 
                        SortExpression="Description" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnShow" runat="server" CssClass="ManibulationButton" ImageUrl="../Images/Link.png" AlternateText="عرض الملف" CommandName="ShowCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnDelete" runat="server" CssClass="ManibulationButton" ImageUrl="../Images/GridViewImages/Delete.png"
                            OnClientClick="return confirm('هل تريد تأكيد حذف الملف المرفق')" CommandName="DeleteCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                <PagerStyle CssClass="GridViewTabularPager" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetRuleDataAttachments" 
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="RuleData_Id" QueryStringField="ID" 
                        Type="Int64" />
                </SelectParameters>
            </asp:SqlDataSource>
            <div id="myModal" class="modal">
                <!-- Modal content -->
                <div class="modal-content"  style="border-radius: 10px;">
                    <div class="modal-header" style="border-radius: 10px 10px 0px 0px;">
                        <span class="close" style="visibility: hidden; position: absolute;">×</span>
                        <table width="100%">
                            <tr style="vertical-align: middle;">
                                <td style="font-size: 12pt; font-family: MyFontBold; font-weight: bold;">
                                    <asp:Label ID="Label2" runat="server">الرجاء إدخال بيانات الملف المرفق</asp:Label>
                                </td>
                                <td style="text-align:left; width: 25px;">
                                    <asp:ImageButton id="btnSave" runat="server" 
                                        OnClientClick="return OnUploadAttachment();" 
                                        ImageUrl="../Images/GridViewImages/Save.png" AlternateText="إضافة" 
                                        CssClass="HeadManibulationButton" onclick="btnSave_Click" />
                                </td>
                                <td style="text-align:left; width: 25px;">
                                    <a style="border:none;" onclick="if(document.getElementById('<%= Fud_Pic.ClientID %>').value || document.getElementById('<%= txtFileName.ClientID %>').value) { if(confirm('هل تريد إلغاء الأمر') == true) ClosePopupWindow(); } else  ClosePopupWindow();"><img class="HeadManibulationButton" src="../Images/GridViewImages/Close.png" alt="إضافة" style="cursor: pointer;"/></a>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-body" style="font-size: 10pt;">
                        <table style="width: 105%;">
                            <tr id="lblNotes" class="ValidationLabel" style="visibility: hidden; position: absolute;">
                                <td colspan="2" style="padding: 10px; text-align: center;">
                                    الرجاء إدخال جميع البيانات أولا
                                </td>
                            </tr>
                            <tr class="FormRow">
                                <td class="FormFieldTitleCell ClearStyle" style="width: 100px;">إسم الملف <label class="ValidationLabel">*</label></td>
                                <td class="FormFieldDataCell ClearStyle">
                                    <asp:TextBox ID="txtFileName" runat="server" placeholder="قم بإدخال إسم الملف هنا" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes"  Width="88.5%" />
                                </td>

                            </tr>
                            <tr class="FormRow">
                                <td class="FormFieldTitleCell ClearStyle" style="width: 100px;">رفع الملف <label class="ValidationLabel">*</label></td>
                                <td class="FormFieldDataCell ClearStyle">
                                    <div id="divFileUpload" runat="server" class="FileUploadDiv" style="width: 97%;">
                                        <table style="width:100%;" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width:100%;"><input type="button" id="btnUpload" class="EnabledFileUploadButton" runat="server" style="width:100%;" value="رفع الملف" onclick="HyperLinkClicked(); return false;" /></td>
                                                <td><input type="button" id="btnClear" class="CancelFileUploadButton" value="X" onclick="ClearImg();" style="visibility:hidden; position:absolute;" /></td>
                                            </tr>
                                        </table>
                                        <asp:FileUpload id="Fud_Pic" CssClass="FormsFileUpload" runat="server" onchange="PreviewImg();" class="DropDownListInput" style="padding:5px; margin-left:0px; margin-right:0px; font-size:16px; width: 425px; cursor:pointer;"></asp:FileUpload>
                                        <asp:HiddenField ID="hfLastAction" runat="server" Value="empty" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <h3>Modal Footer</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="../js/PopupWindowScript.js" type="text/javascript"></script>
</asp:Content>
