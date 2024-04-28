<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="ReportsMain.aspx.cs" Inherits="NorthernBordersProvince.ProvisionsMonitoringReportsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style type="text/css">
    .EServicesDiv
    {
        font-size: 11pt;    
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            التقارير
            <a href="../Files/UserGuide/ProvisionsMonitoring/Reports.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
        </div>
        <div id="divPageContents" class="PageContents" runat="server">
            <asp:Label ID="lblContents" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
