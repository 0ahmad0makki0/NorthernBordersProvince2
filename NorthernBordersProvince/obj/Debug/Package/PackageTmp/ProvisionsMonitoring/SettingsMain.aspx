<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="SettingsMain.aspx.cs" Inherits="NorthernBordersProvince.ProvisionsMonitoringSettingsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            الإعدادات
        </div>
        <div id="divPageContents" class="PageContents" runat="server">
            <asp:Label ID="lblContents" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
