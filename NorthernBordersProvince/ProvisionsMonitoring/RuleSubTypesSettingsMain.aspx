<%@ Page Title="" Language="C#" MasterPageFile="~/ProvisionsMonitoring/ProvisionsMonitoring.Master" AutoEventWireup="true" CodeBehind="RuleSubTypesSettingsMain.aspx.cs" Inherits="NorthernBordersProvince.RuleSubTypesSettingsMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
    <div class="PageContainer">
        <div class="PageTitle">
            <table width="100%">
                <tr style="vertical-align: middle;">
                    <td>
                        إعدادات أنواع القضايا الفرعية
                        <%--<a href="../Files/UserGuide/ProvisionsMonitoring/RuleStatus.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>--%>
                    </td>
                    <td style="text-align:left;">
                        <a href="RuleSubTypeSettingsForm.aspx?Mode=Add" style="border:none;"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <div style="margin: 15px 0px;">
                <table width="96.7%">
                    <tr style="vertical-align: middle; font-size: 10pt;">
                        <td style="width: 50px;">بحث :</td>
                        <td>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="FormLongTextBoxes" 
                                Width="100%" placeholder="الرجاء إدخال نص البحث هنا ومن ثم النقر على زر الإدخال (Enter)" AutoPostBack="True"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:GridView ID="gvContents" CssClass="GridViewTabular" runat="server" AutoGenerateColumns="False" 
                DataSourceID="SqlDataSource1" 
                GridLines="None" AllowPaging="True" PageSize="30" AllowSorting="true"
                EmptyDataText="لا يوجد بيانات لأنواع القضايا الفرعية" 
                DataKeyNames="RuleSubType_Id"
                onrowcommand="gvContents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="RuleSubType_Id_string" HeaderText="رقم الحاسب" 
                        SortExpression="RuleSubType_Id" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" />
                    <asp:BoundField DataField="RTTitle" HeaderText="نوع القضية" 
                        SortExpression="RTTitle" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="Title" HeaderText="نوع القضية الفرعي" 
                        SortExpression="Title" ItemStyle-HorizontalAlign="Right" />
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="RuleSubTypeSettingsForm.aspx?Mode=Show&ID=<%# Eval("RuleSubType_Id") %>" style="border:none;"><img class="ManibulationButton" src="../Images/GridViewImages/Show.png" alt="عرض"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="RuleSubTypeSettingsForm.aspx?Mode=Edit&ID=<%# Eval("RuleSubType_Id") %>" style="border:none;"><img class="ManibulationButton" src="../Images/GridViewImages/Edit.png" alt="عرض"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnDelete" runat="server" CssClass="ManibulationButton" ImageUrl="../Images/GridViewImages/Delete.png"
                            OnClientClick="return confirm('هل تريد تأكيد حذف نوع القضية الفرعي')" CommandName="DeleteCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                <PagerStyle CssClass="GridViewTabularPager" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetRuleSubTypes" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtSearch" Name="Search" DefaultValue="Empty%%^^&*(("
                        PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>
    </div>
        </ContentTemplate>
        </asp:UpdatePanel>
</asp:Content>
