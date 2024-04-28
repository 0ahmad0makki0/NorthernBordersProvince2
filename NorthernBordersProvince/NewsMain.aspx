<%@ Page Title="" Language="C#" MasterPageFile="~/PortalMaster.Master" AutoEventWireup="true" CodeBehind="NewsMain.aspx.cs" Inherits="NorthernBordersProvince.NewsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            الأخبار
        </div>
        <div class="PageContents">
            <asp:GridView ID="gvContents" CssClass="GridViewContents" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" ShowHeader="false" PageSize="10" 
                GridLines="None" AllowPaging="True"
                EmptyDataText="لا يوجد أخبار لعرضها">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <table class="NewsTable">
                                <tr class="NewsTableRow">
                                    <td>
                                        <div class="NewsTableImageDiv">
                                            <a href="<%# Eval("Link")%>"><img class="NewsTableImage" src="<%# Eval("ImageUrl")%>" alt="NewsImage"/></a>
                                        </div>
                                    </td>
                                    <td style="vertical-align: top;">
                                        <div>
                                            <div class="NewsTableTitleDiv">
                                                <a href="<%# Eval("Link")%>"><%# Eval("Title")%></a>
                                            </div>
                                            <div class="NewTableDateAndViewCountDiv">
                                                بتاريخ : <%# Eval("NewsDate")%> ، عدد المشاهدات <%# Eval("ViewCount")%>
                                            </div>
                                            <div class="NewTableContentsDiv">
                                                <%# Eval("Contents")%> ... <a href="<%# Eval("Link")%>">المزيد</a>
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
                SelectCommand="sp_GetNews" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
