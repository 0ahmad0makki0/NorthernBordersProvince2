<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="PortalAdminUsersSettingsMain.aspx.cs" Inherits="NorthernBordersProvince.PortalAdminUsersSettingsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            <table width="100%">
                <tr style="vertical-align: middle;">
                    <td>
                        إعدادات مسؤولين البوابة الإلكترونية
                        <a href="../Files/UserGuide/PortalSettings/PortalUsersSettings.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
                   </td>
                    <td style="text-align:left;">
                        <a href="PortalAdminUserSettings.aspx?Mode=Add" style="border:none;"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <asp:GridView ID="gvContents" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" 
                GridLines="None" AllowPaging="True" PageSize="30"
                EmptyDataText="لا يوجد مسؤولين للبوابة الإلكترونية حاليا" 
                DataKeyNames="PortalSettingsUser_Id"
                onrowcommand="gvContents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Username" HeaderText="إسم المستخدم" 
                        SortExpression="Username" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField HeaderText="حالة المستخدم">
                        <ItemTemplate>
                                <div style="background-color:<%# Eval("Activated").ToString().Equals("مفعل") ? "rgb(157, 255, 174)" : "rgb(234, 191, 192)" %>; border-radius: 15px; width: 75px;">
                                    <%# Eval("Activated")%>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:TemplateField>
                    <asp:ButtonField ButtonType="Image" ImageUrl="../Images/GridViewImages/Edit.png" 
                        CommandName="EditCommand">
                        <ControlStyle CssClass="ManibulationButton" />
                    <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:ButtonField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnDelete" runat="server" CssClass="ManibulationButton" ImageUrl="../Images/GridViewImages/Delete.png"
                            OnClientClick="return confirm('هل تريد تأكيد حذف مسؤول البوابة الإلكترونية')" CommandName="DeleteCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                <PagerStyle CssClass="GridViewTabularPager" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetPortalAdminUsers" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter Name="CurrentUsername" SessionField="Username" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
