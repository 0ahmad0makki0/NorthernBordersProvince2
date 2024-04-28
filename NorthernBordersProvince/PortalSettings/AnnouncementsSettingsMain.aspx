<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="AnnouncementsSettingsMain.aspx.cs" Inherits="NorthernBordersProvince.AnnouncementsSettingsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            <table width="100%">
                <tr style="vertical-align: middle;">
                    <td>
                        إعدادات التعاميم
                        <a href="../Files/UserGuide/PortalSettings/AnnouncementsSettings.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
                   </td>
                    <td style="text-align:left;">
                        <a href="AnnouncementSettings.aspx?Mode=Add" style="border:none;"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <asp:GridView ID="gvContents" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" 
                GridLines="None" AllowPaging="True" PageSize="30"
                EmptyDataText="لا يوجد تعاميم مضافة حاليا" 
                DataKeyNames="Announcement_Id"
                onrowcommand="gvContents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Number" HeaderText="رقم التعميم" 
                        SortExpression="Number" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="AnnouncementDate" HeaderText="التاريخ" 
                        SortExpression="AnnouncementDate" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Title" HeaderText="عنوان التعميم" 
                        SortExpression="Title" />
                    <asp:TemplateField HeaderText="ملف التعميم">
                        <ItemTemplate>
                                <div>
                                    <a href="../<%# Eval("FileLink")%>" target="_blank">عرض الملف</a>
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
                            OnClientClick="return confirm('هل تريد تأكيد حذف التعميم')" CommandName="DeleteCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="../AnnouncementPage.aspx?ID=<%# Eval("Announcement_Id") %>" style="border:none;" target="_blank"><img class="ManibulationButton" src="../Images/GridViewImages/Show.png" alt="عرض"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                <PagerStyle CssClass="GridViewTabularPager" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetAnnouncements" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
