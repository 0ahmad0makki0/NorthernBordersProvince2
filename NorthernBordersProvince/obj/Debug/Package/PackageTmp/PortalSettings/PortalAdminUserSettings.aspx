<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="PortalAdminUserSettings.aspx.cs" Inherits="NorthernBordersProvince.PortalAdminUserSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnTextChanged(txt) {
            if (txt.value == "")
                txt.style.border = "5px solid red";
            else txt.style.border = "none";
        }
        function OnSelectionChanged(ddl) {
            if (ddl.selectedIndex == "0") {
                ddl.style.border = "5px solid red";
                ddl.style.backgroundColor = "White";
                ddl.style.color = "Gray";
            }
            else {
                ddl.style.border = "5px solid LightGray";
                ddl.style.color = "Black";
                if (ddl.selectedIndex == "1") ddl.style.backgroundColor = "rgb(157, 255, 174)";
                else ddl.style.backgroundColor = "rgb(234, 191, 192)";
            }
        }

        function onReady() {
            var readyCheck = setInterval(function () {
                var hfReadyStatus = document.getElementById('<%= hfReadyStatus.ClientID %>');
                if (hfReadyStatus.value == "1" || hfReadyStatus.value == "2") {
                    if (hfReadyStatus.value == "1") {
                        var ddlStatus = document.getElementById('<%= ddlStatus.ClientID %>');
                        OnSelectionChanged(ddlStatus);
                    }
                    clearInterval(readyCheck);
                }
            }, 1);
        };

        function AllPermissionsSelectionChanged(ckbAllPermissions)
        {
            var row = ckbAllPermissions.parentNode.parentNode;
            var inputList = row.getElementsByTagName("input");
            for (var i=0; i < inputList.length ; i++)
            {
                if(inputList[i].type == "checkbox"  && ckbAllPermissions != inputList[i])
                {
                    if (ckbAllPermissions.checked)
                    {
                        inputList[i].checked=true;
                    }
                    else
                    {
                        inputList[i].checked=false;
                    }
                }
            }
        }

        function OnCheckBoxChanged(ckb) {
            var row = ckb.parentNode.parentNode;
            var inputList = row.getElementsByTagName("input");
            if (ckb.id == inputList[2].id) {
                if (ckb.checked == false) {
                    for (var i = 0; i < inputList.length; i++) {
                        if (inputList[i].type == "checkbox" && i != 1 && i != 2) {
                            inputList[i].checked = false;
                        }
                    }
                }
            }
            else {
                if (ckb.checked == true) {
                    inputList[2].checked = true;
                }
            }

            var bAllChecked = true;

            for (var i = 0; i < inputList.length; i++) {
                if (inputList[i].type == "checkbox" && i != 1) {
                    if (inputList[i].checked == false) {
                        bAllChecked = false;
                        break;
                    }
                }
            }
            if (bAllChecked) inputList[1].checked = true;
            else inputList[1].checked = false;
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
                        <td class="FormFieldTitleCell FirstRow">إسم المستخدم <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell FirstRow">
                            <asp:TextBox ID="txtUsername" runat="server" placeholder="قم بإدخال إسم مستخدم من الدليل النشط" onchange="OnTextChanged(this)" CssClass="FormLongTextBoxes UpperCase" />
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">حالة المستخدم<label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell">
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="FormLongTextBoxes FormDropDownList" onchange="OnSelectionChanged(this)">
                                <asp:ListItem Selected="True" Text="-- الرجاء إختيار حالة المستخدم --" Value="-1"></asp:ListItem>
                                <asp:ListItem Text="مفعل" Value="1"></asp:ListItem>
                                <asp:ListItem Text="معطل" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell">صلاحيات المستخدم</td>
                        <td class="FormFieldDataCell">
                            <div class="GridViewContainerDiv">
                            <asp:GridView ID="gvPermissions" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False" 
                                DataSourceID="SqlDataSource1" 
                                GridLines="None" ShowHeader="false" ShowFooter="false"
                                DataKeyNames="PortalSettingsUserPermission_Id">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                                    <asp:Label ID="lblPage" runat="server" Text='<%# Eval("PortalSettingsPageTitle")%>' />
                                                    <asp:HiddenField ID="hfPageId" runat="server" Value='<%# Eval("PortalSettingsPage_Id") %>'/>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="right" VerticalAlign="Middle" Font-Bold="true" />
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                                    <asp:CheckBox ID="ckbAllPermissions" runat="server" Text="جميع الصلاحيات" Checked='<%# Eval("AllPermissions") %>' onclick="AllPermissionsSelectionChanged(this);" />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                                    <asp:CheckBox ID="ckbView" runat="server" Text="عرض" Checked='<%# Eval("CanView") %>' onclick="OnCheckBoxChanged(this);"/>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                                    <asp:CheckBox ID="ckbAdd" runat="server" Text="إضافة" Checked='<%# Eval("CanAdd") %>' onclick="OnCheckBoxChanged(this);"/>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                                    <asp:CheckBox ID="ckbEdit" runat="server" Text="تعديل" Checked='<%# Eval("CanEdit") %>' onclick="OnCheckBoxChanged(this);"/>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                                    <asp:CheckBox ID="ckbDelete" runat="server" Text="حذف" Checked='<%# Eval("CanDelete") %>' onclick="OnCheckBoxChanged(this);"/>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>"
                                SelectCommand="sp_GetPortalSettingsUserPermissions" SelectCommandType="StoredProcedure">
                                    <SelectParameters>
                                        <asp:QueryStringParameter Name="PortalSettingsUser_Id" ConvertEmptyStringToNull="true" QueryStringField="ID" Type="Int64" DefaultValue="0" />
                                    </SelectParameters>
                            </asp:SqlDataSource>
                            </div>
                        </td>
                    </tr>
                </table>
                <asp:HiddenField ID="hfReadyStatus" runat="server" Value="0" />
            </div>
        </div>
    </div>
</asp:Content>
