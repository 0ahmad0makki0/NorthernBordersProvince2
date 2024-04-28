<%@ Page Title="" Language="C#" MasterPageFile="~/PortalMaster.Master" AutoEventWireup="true" CodeBehind="AnnouncementsMain.aspx.cs" Inherits="NorthernBordersProvince.AnnouncementsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            التعاميم
        </div>
        <div class="PageContents">
            <asp:GridView ID="gvContents" CssClass="GridViewContents" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" ShowHeader="false" PageSize="10" 
                GridLines="None" AllowPaging="True"
                EmptyDataText="لا يوجد تعاميم لعرضها">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <table class="AnnouncementsTable">
                                <tr class="AnnouncementTableRow">
                                    <td style="vertical-align: top;">
                                        <div>
                                            <div class="AnnouncementTableTitleDiv">
                                                <%# Eval("Title")%>
                                                <a href="<%# Eval("Link")%>">
                                                    <img src="Images/Link.png" alt="عرض التعميم"  style="border: none;">
                                                </a>
                                            </div>
                                            <div class="AnnouncementTableDateAndViewCountDiv">
                                                تعميم رقم : <%# Eval("Number")%> ، بتاريخ : <%# Eval("AnnouncementDate")%> ، عدد المشاهدات <%# Eval("ViewCount")%>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                <PagerStyle CssClass="GridViewPager" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetAnnouncements" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
