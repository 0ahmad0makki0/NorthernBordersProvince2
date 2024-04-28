<%@ Page Title="" Language="C#" MasterPageFile="~/PortalSettings/PortalSettings.Master" AutoEventWireup="true" CodeBehind="ImportantLinksSettingsMain.aspx.cs" Inherits="NorthernBordersProvince.ImportantLinksSettingsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            <table width="100%">
                <tr style="vertical-align: middle;">
                    <td>
                        إعدادات الروابط الهامة
                        <a href="../Files/UserGuide/PortalSettings/ImportantLinks.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
                   </td>
                    <td style="text-align:left;">
                        <a href="ImportantLinkSettings.aspx?Mode=Add" style="border:none;"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <asp:GridView ID="gvContents" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" 
                GridLines="None" AllowPaging="True" PageSize="30"
                EmptyDataText="لا يوجد روابط هامة مضافة حاليا" 
                DataKeyNames="ImportantLink_Id"
                onrowcommand="gvContents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Title" HeaderText="النص" 
                        SortExpression="Title" />
                    <asp:TemplateField HeaderText="الرابط">
                        <ItemTemplate>
                                <div>
                                    <a href="<%# Eval("Link")%>" target="_blank">الإنتقال إلى الرابط</a>
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
                            OnClientClick="return confirm('هل تريد تأكيد حذف الرابط الهام')" CommandName="DeleteCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="../ImportantLinksMain.aspx" style="border:none;" target="_blank"><img class="ManibulationButton" src="../Images/GridViewImages/Show.png" alt="عرض"></a>
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
                SelectCommand="sp_GetImportantLinks2" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
