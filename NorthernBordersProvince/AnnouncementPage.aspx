<%@ Page Title="" Language="C#" MasterPageFile="~/PortalMaster.Master" AutoEventWireup="true" CodeBehind="AnnouncementPage.aspx.cs" Inherits="NorthernBordersProvince.AnnouncementPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="AnnouncementPageTitle">
            <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
        </div>
        <div class="AnnouncementDateAndViewCount">
            <asp:Label ID="lblDateAndViewCount" runat="server" Text=""></asp:Label>
        </div>
        <div class="AnnouncementContent">
            <asp:Label ID="lblContents" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
