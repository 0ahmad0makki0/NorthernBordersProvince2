<%@ Page Title="" Language="C#" MasterPageFile="~/SecurityAffairs/SecurityAffairs.Master" AutoEventWireup="true" CodeBehind="ReportsMain.aspx.cs" Inherits="NorthernBordersProvince.ReportsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="PageContainer">
        <div class="PageTitle">
            التقارير
            <a href="../Files/UserGuide/SecurityAffairs/Reports.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
        </div>
        <div id="divPageContents" class="PageContents" runat="server">
            <asp:Label ID="lblContents" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
