<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="NorthernBordersProvince.LoginPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server" lang="en">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta content="width=device-width, initial-scale=1" name="viewport" />
    <link href="Styles/LoginPageStyle.css" rel="stylesheet" type="text/css" />
    <title>صصفحة تسجيل الدخول</title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="MainDiv">
        <div class="HeaderDiv">
            <img src="Images/Logo2.jpg" alt="Logo"/>
            <br />
            <asp:Label ID="lblTitle" CssClass="TitleLabel" runat="server"></asp:Label>
        </div>
        <div class="ContentsDiv">
            <label class="SubTitleLabel">صفحة تسجيل الدخول</label>
            <asp:TextBox ID="txtUsername" CssClass="TextBoxes" runat="server" placeholder="إسم مستخدم الشبكة"></asp:TextBox>
            <asp:TextBox ID="txtPassword" CssClass="TextBoxes" runat="server" TextMode="Password" placeholder="كلمة المرور"></asp:TextBox>
            <asp:Button ID="btnLogin" CssClass="Buttons" runat="server" Text="تسجيل الدخول" onclick="btnLogin_Click" />
            <div class="StatusLabel">
                <asp:Label ID="lblStatus" runat="server" Visible="false" Text="خطأ في إسم المستخدم أو كلمة المرور"></asp:Label>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
