<%@ Page Title="" Language="C#" MasterPageFile="~/PortalMaster.Master" AutoEventWireup="true" CodeBehind="NewsPage.aspx.cs" Inherits="NorthernBordersProvince.NewsPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="NewsPageTitle">
            <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
        </div>
        <div class="NewDateAndViewCount">
            <asp:Label ID="lblDateAndViewCount" runat="server" Text=""></asp:Label>
        </div>
        <div id="divNewsContent" runat="server" class="NewsContent">
            <asp:Label ID="lblContents" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
