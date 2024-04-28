<%@ Page Title="" Language="C#" MasterPageFile="~/SecurityAffairs/SecurityAffairs.Master" AutoEventWireup="true" CodeBehind="PeopleDataNotes.aspx.cs" Inherits="NorthernBordersProvince.PeopleDataNotes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .FormFieldTitleCell
        {
            width: 130px;    
        }
    </style>
    <script type="text/javascript">
        function OnTextChanged(txt) {
            if (txt.value == "")
                txt.style.border = "5px solid red";
            else txt.style.border = "5px solid LightGray";
        }

        function GetNextNoteID() {
            var hfNotesTableData = document.getElementById('<%= hfNotesTableData.ClientID %>');
            if (hfNotesTableData.value.replace(' ', '') == '') return '1';
            else {
                var notesLines = hfNotesTableData.value.split('#0$%');
                var lastNote = notesLines[notesLines.length - 1];
                var lastID = lastNote.split('&^9%')[0];
                var nextID = (Number(lastID) + 1).toString();
                return nextID;
            }
        }

        function ManibulateNote(mode, noteID) {
            var hfNotesTableData = document.getElementById('<%= hfNotesTableData.ClientID %>');
            if (mode.toLowerCase() == 'add') {
                var txtNote = document.getElementById('<%= txtNote.ClientID %>');
                if (txtNote.value.replace(' ', '') == '') { txtNote.focus(); return; }
                var new_noteID = '1';
                if (noteID == '0') new_noteID = GetNextNoteID();
                if (hfNotesTableData.value.replace(' ', '') != '') hfNotesTableData.value += '#0$%';
                else hfNotesTableData.value = '';
                if (noteID == '0') {
                    hfNotesTableData.value += new_noteID + '&^9%' + txtNote.value + '&^9%' + 'new';
                }
                else {
                    hfNotesTableData.value += noteID + '&^9%' + txtNote.value + '&^9%' + 'exists';
                }
                txtNote.value = '';
                txtNote.focus();
            }
            else if (mode.toLowerCase() == 'delete') {
                if (!confirm('هل تريد تأكيد حذف الملاحظة')) return false;
                var contents = hfNotesTableData.value;
                var new_contents = '';
                var notesLines = contents.split('#0$%');

                for (var i = 0; i <= notesLines.length - 1; i++) {
                    var sID = notesLines[i].split('&^9%')[0];
                    if (sID == noteID) {
                        var sContent = sID + '&^9%' + notesLines[i].split('&^9%')[1] + '&^9%' + notesLines[i].split('&^9%')[2];
                        if (notesLines[i].split('&^9%')[2] == 'exists') {
                            new_contents = contents.replace(sContent, sID + '&^9%' + notesLines[i].split('&^9%')[1] + '&^9%' + 'deleted');
                        }
                        else {
                            if (notesLines.length > 1) {
                                if (i < notesLines.length - 1) sContent += '#0$%';
                                else if (i == notesLines.length - 1) sContent = '#0$%' + sContent;
                            }
                            new_contents = contents.replace(sContent, '');
                        }
                        break;
                    }
                }
                hfNotesTableData.value = new_contents;
            }
            RestructureNotes();
        }

        function RestructureNotes() {

            var insertedLines = 0;

            var lblNotesTabe = document.getElementById('lblNotesTable');
            var hfNotesTableData = document.getElementById('<%= hfNotesTableData.ClientID %>');
            var txtNote = document.getElementById('<%= txtNote.ClientID %>');
            lblNotesTabe.innerHTML = '';
            var s = hfNotesTableData.value;
            if (s.replace(' ', '') != '') {
                if (s.indexOf('&^9%new') != -1 || s.indexOf('&^9%exists') != -1) {
                    var notesLines = s.split('#0$%');
                    content = '<table class="GridViewTabular" style="width:100%;" cellpadding="0" cellspacing="0">';
                    content += '<tr>';
                    content += '<th style="width:34px;">';
                    content += '</th>';
                    content += '<th style="text-align:center;">';
                    content += 'الملاحظات';
                    content += '</th>';
                    content += '</tr>';

                    for (var i = 0; i <= notesLines.length - 1; i++) {
                        var sStatus = notesLines[i].split('&^9%')[2];
                        if (sStatus != 'deleted') {
                            var sID = notesLines[i].split('&^9%')[0];
                            var sContent = notesLines[i].split('&^9%')[1];
                            content += '<tr>';
                            content += '<td style="text-align:center;">';
                            content += '<div>' +
                                        '<a style="border:none;" onclick="ManibulateNote(\'delete\',\'' + sID + '\');">' +
                                            '<img class="ManibulationButton" src="../Images/GridViewImages/Delete.png" alt="عرض"></img>' +
                                        '</a>' +
                                    '</div>';
                            content += '</td>';
                            content += '<td style="text-align:right; padding-right:15px;">';
                            content += sContent;
                            content += '</td>';
                            content += '</tr>';
                            insertedLines++;
                        }
                    }

                    content += '</table>';

                    lblNotesTabe.innerHTML = content;

                    if (insertedLines > 0)
                    document.getElementById('divNotes').style.height = (100 + insertedLines * 37.5).toString() + 'px';
                }
            }
            if (insertedLines == 0)
                document.getElementById('divNotes').style.height = '75px';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="PageContainer">
        <div class="PageTitle">
            <table width="100%">
                <tr style="vertical-align: middle;">
                    <td>
                        <asp:Label ID="lblTitle" runat="server"></asp:Label>
                        <a href="../Files/UserGuide/SecurityAffairs/PeopleDataNotes.pdf" style="border:none;" target="_blank"><img class="HeadManibulationButton" src="../Images/Help.png" alt="دليل الإستخدام"/></a>
                   </td>
                    <td style="text-align:left; width: 25px;">
                        <asp:ImageButton ID="btnSave" runat="server" AlternateText="حفظ" 
                            CssClass="HeadManibulationButton" ImageUrl="../Images/GridViewImages/Save.png" 
                            OnClientClick="return confirm('هل تريد تأكيد عملية الحفظ ؟')" 
                            onclick="btnSave_Click" />
                    </td>
                    <td style="text-align:left; width: 25px;">
                        <asp:ImageButton ID="btnCancel" runat="server" AlternateText="إلغاء الأمر" 
                            CssClass="HeadManibulationButton" ImageUrl="../Images/GridViewImages/Close.png" 
                            OnClientClick="return confirm('هل تريد تأكيد إلغاء الأمر ؟')" 
                            onclick="btnCancel_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="PageContents">
            <div id="divNotes" class="FormContents">
                <table style="width:100%;">
                    <tr class="FormRow">
                        <td class="FormFieldTitleCell" style="width: 75px; vertical-align: middle; border:none;">الملاحظة <label class="ValidationLabel">*</label></td>
                        <td class="FormFieldDataCell" style="border:none; background: none;">
                            <asp:TextBox ID="txtNote" runat="server" placeholder="قم بإدخال نص الملاحظة هنا" onkeypress="if (event.keyCode == 13) { ManibulateNote('Add', '0'); return false; }" CssClass="FormLongTextBoxes" Width="95%" />
                        </td>
                        <td style="text-align:left; width: 25px;">
                            <a style="border:none;" onclick="ManibulateNote('Add', '0');"><img class="HeadManibulationButton" src="../Images/GridViewImages/Add.png" alt="إضافة"/></a>
                        </td>
                    </tr>
                    <tr class="FormRow">
                        <td colspan="3">
                            <asp:HiddenField ID="hfNotesTableData" runat="server" Value=" " />
                            <label id="lblNotesTable" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var hfNotesTableData = document.getElementById('<%= hfNotesTableData.ClientID %>');
        if (hfNotesTableData.value != "") 
            RestructureNotes();
    </script>
</asp:Content>
