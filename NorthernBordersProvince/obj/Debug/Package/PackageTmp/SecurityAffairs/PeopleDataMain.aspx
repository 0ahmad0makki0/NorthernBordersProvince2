<%@ Page Title="" Language="C#" MasterPageFile="~/SecurityAffairs/SecurityAffairs.Master" AutoEventWireup="true" CodeBehind="PeopleDataMain.aspx.cs" Inherits="NorthernBordersProvince.PeopleDataMain" %>
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
                        بيانات الأشخاص
                        <a href="../Files/UserGuide/SecurityAffairs/PeopleData.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
                   </td>
                    <td style="text-align:left;">
                        <a href="PeopleDataForm.aspx?Mode=Add" style="border:none;"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
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
                EmptyDataText="لا يوجد بيانات للأشخاص" 
                DataKeyNames="PeopleData_Id"
                onrowcommand="gvContents_RowCommand">
                <Columns>
                    <asp:BoundField DataField="PeopleData_Id_string" HeaderText="رقم الحاسب" 
                        SortExpression="PeopleData_Id" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="FullName" HeaderText="الإسم الرباعي" 
                        SortExpression="FullName" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="SSN" HeaderText="السجل المدني" 
                        SortExpression="SSN" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="DOB_string" HeaderText="تاريخ الميلاد" 
                        SortExpression="DOB" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="BirthPlace" HeaderText="مكان الميلاد" 
                        SortExpression="BirthPlace" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="ResidencePlace" HeaderText="مكان الإقامة" 
                        SortExpression="ResidencePlace" ItemStyle-HorizontalAlign="Right" />
                    <asp:TemplateField HeaderText="عليه ملاحظات" SortExpression="HasNotes">
                        <ItemTemplate>
                                <div style="background-color:<%# Eval("HasNotes").ToString().Equals("لا") ? "rgb(157, 255, 174)" : "rgb(234, 191, 192)" %>; border-radius: 15px; width: 75px;">
                                    <%# Eval("HasNotes")%>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="PeopleDataNotes.aspx?ID=<%# Eval("PeopleData_Id") %>" style="border:none;"><img class="ManibulationButton" src="../Images/GridViewImages/Notes.png" alt="ملاحظات"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="PeopleDataAttachments.aspx?ID=<%# Eval("PeopleData_Id") %>" style="border:none;"><img class="ManibulationButton" src="../Images/Link.png" alt="مرفقات"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="PeopleDataForm.aspx?Mode=Show&ID=<%# Eval("PeopleData_Id") %>" style="border:none;"><img class="ManibulationButton" src="../Images/GridViewImages/Show.png" alt="عرض"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                                <div>
                                    <a href="PeopleDataForm.aspx?Mode=Edit&ID=<%# Eval("PeopleData_Id") %>" style="border:none;"><img class="ManibulationButton" src="../Images/GridViewImages/Edit.png" alt="عرض"></a>
                                </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnDelete" runat="server" CssClass="ManibulationButton" ImageUrl="../Images/GridViewImages/Delete.png"
                            OnClientClick="return confirm('هل تريد تأكيد حذف معلومات الشخص')" CommandName="DeleteCommand" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"/>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Width="30px" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRow" HorizontalAlign="Center" />
                <PagerStyle CssClass="GridViewTabularPager" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:NorthernBordersProvinceDBConnectionString %>" 
                SelectCommand="sp_GetPeopleData" SelectCommandType="StoredProcedure">
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
