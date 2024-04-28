<%@ Page Title="" Language="C#" MasterPageFile="~/PortalMaster.Master" AutoEventWireup="true" CodeBehind="ImportantLinksMain.aspx.cs" Inherits="NorthernBordersProvince.ImportantLinksMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            روابط هامة
        </div>
        <div class="PageContents">
            <asp:GridView ID="gvContents" CssClass="GridViewContents" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" ShowHeader="false" PageSize="10" 
                GridLines="None" AllowPaging="True" 
                EmptyDataText="لا يوجد روابط هامة لعرضها">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <div class="ImportantLinkTitleDiv">
                                <a href="<%# Eval("Link")%>" target="_blank">
                                    <%# Eval("Title")%>
                                </a>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="GridViewPager" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetImportantLinks" SelectCommandType="StoredProcedure">
            </asp:SqlDataSource>
        </div>
    </div>
</asp:Content>
