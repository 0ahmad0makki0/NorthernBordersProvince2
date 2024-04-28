using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using System.Text;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;
using System.Text;

namespace NorthernBordersProvince
{
    public class ExportFile
    {
        public static void ToExcel(GridView gv, string FileName, int LTRColumn)
        {
            if (gv.Rows.Count == 0) return;

            Page page = gv.Page;

            page.Response.Clear();
            page.Response.Buffer = true;

            page.Response.AddHeader("content-disposition",
            "attachment;filename=" + FileName + ".xls");

            page.Response.Charset = "";
            page.Response.ContentType = "application/ms-excel";
            page.Response.ContentEncoding = System.Text.Encoding.Unicode;
            page.Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            gv.AllowPaging = false;
            gv.DataBind();


            gv.Style.Add("background-color", "#F8F8F8");
            gv.Style.Add("color", "#4F4F4F");
            gv.Style.Add("font-size", "10pt");
            gv.Style.Add("font-family", "Verdana, Arial, helvetica, Geneva, sans-serif");

            //Apply style to Individual Cells
            foreach (TableCell c in gv.HeaderRow.Cells)
            {
                c.Style.Add("padding", "5px");
                c.Style.Add("border", "1px solid LightGray");
                c.Style.Add("color", "rgb(20,158,83)");
                c.Style.Add("color", "rgb(20,158,83)");
                c.Style.Add("font-weight", "bold");
                c.Style.Add("background-color", "#ffffff");
                c.BorderStyle = BorderStyle.Solid;
                c.BorderWidth = new Unit(1, UnitType.Pixel);
                c.BorderColor = System.Drawing.Color.Gray;
            }

            for (int i = 0; i < gv.Rows.Count; i++)
            {
                GridViewRow row = gv.Rows[i];
                for (int j = 0 ; j <= row.Cells.Count - 1 ; j++)
                {
                    TableCell c = row.Cells[j];
                    if (j == LTRColumn)
                        c.Style.Add("direction", "ltr");
                    c.Style.Add("background-color", "#F8F8F8");
                    c.Style.Add("color", "#4F4F4F");
                    c.Style.Add("padding", "5px");
                    c.Style.Add("border", "1px solid LightGray");
                    c.BorderStyle = BorderStyle.Solid;
                    c.BorderWidth = new Unit(1, UnitType.Pixel);
                    c.BorderColor = System.Drawing.Color.Gray;
                    c.Style.Add("vertical-align", "top");
                }
            }
            gv.RenderControl(hw);

            page.Response.Output.Write(sw.ToString());
            page.Response.Flush();
            page.Response.End();
        }

        public static void ToWord(GridView gv, string FileName, int LTRColumn)
        {
            if (gv.Rows.Count == 0) return;

            Page page = gv.Page;
            HttpResponse Response = page.Response;

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition",
            "attachment;filename=" + FileName + ".doc");
            Response.Charset = "";
            Response.ContentType = "application/ms-word";
            Response.ContentEncoding = System.Text.Encoding.Unicode;
            Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());
            Response.Write("<html>");
            Response.Write("<head>");
            Response.Write("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=UTF-8'>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content='Microsoft Word 9'>");
            Response.Write("<meta name=Originator content='Microsoft Word 9'>");
            Response.Write("<style>");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:1.0in 1.25in 1.0in 1.25in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            if (gv.Columns.Count > 7)
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            else Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:portrait;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("</style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");

            StringWriter sw = new StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            gv.AllowPaging = false;
            gv.DataBind(); gv.Style.Add("background-color", "#F8F8F8");
            gv.Style.Add("background-color", "#F8F8F8");
            gv.Style.Add("color", "#4F4F4F");
            gv.Style.Add("font-size", "10pt");
            gv.Style.Add("font-family", "Verdana, Arial, helvetica, Geneva, sans-serif");
            gv.Style.Add("direction", "rtl");
            //Apply style to Individual Cells
            foreach (TableCell c in gv.HeaderRow.Cells)
            {
                c.Style.Add("padding", "5px");
                c.Style.Add("border", "1px solid LightGray");
                c.Style.Add("color", "rgb(20,158,83)");
                c.Style.Add("color", "rgb(20,158,83)");
                c.Style.Add("font-weight", "bold");
                c.Style.Add("background-color", "#ffffff");
                c.BorderStyle = BorderStyle.Solid;
                c.BorderWidth = new Unit(1, UnitType.Pixel);
                c.BorderColor = System.Drawing.Color.Gray;
            }

            for (int i = 0; i < gv.Rows.Count; i++)
            {
                GridViewRow row = gv.Rows[i];
                for (int j = 0; j <= row.Cells.Count - 1; j++)
                {
                    TableCell c = row.Cells[j];
                    if (j == LTRColumn)
                        c.Style.Add("direction", "ltr");
                    c.Style.Add("background-color", "#F8F8F8");
                    c.Style.Add("color", "#4F4F4F");
                    c.Style.Add("padding", "5px");
                    c.Style.Add("border", "1px solid LightGray");
                    c.BorderStyle = BorderStyle.Solid;
                    c.BorderWidth = new Unit(1, UnitType.Pixel);
                    c.BorderColor = System.Drawing.Color.Gray;
                    c.Style.Add("vertical-align", "top");
                }
            }
            gv.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.Flush();
            Response.End();
        }

        public static void ToCSV(GridView gv, string FileName)
        {
            if (gv.Rows.Count == 0) return;

            Page page = gv.Page;
            page.Response.Clear();
            page.Response.Buffer = true;
            page.Response.AddHeader("content-disposition",
             "attachment;filename=" + FileName + ".csv");
            page.Response.Charset = "";
            page.Response.ContentType = "application/text";
            page.Response.ContentEncoding = System.Text.Encoding.Unicode;
            page.Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

            gv.AllowPaging = false;
            gv.DataBind();

            StringBuilder sb = new StringBuilder();
            for (int k = 0; k < gv.Columns.Count; k++)
            {
                //add separator
                sb.Append(gv.Columns[k].HeaderText + ',');
            }
            //append new line
            sb.Append("\r\n");
            for (int i = 0; i < gv.Rows.Count; i++)
            {
                for (int k = 0; k < gv.Columns.Count; k++)
                {
                    //add separator
                    sb.Append(gv.Rows[i].Cells[k].Text + ',');
                }
                //append new line
                sb.Append("\r\n");
            }
            page.Response.Output.Write(sb.ToString());
            page.Response.Flush();
            page.Response.End();
        }

        public static void Print(Page page, string PrintableDivName)
        {
            page.ClientScript.RegisterStartupScript(page.GetType(), "Print",
                "var restorepage = document.body.innerHTML;" +
                "var printcontent = document.getElementById('" + PrintableDivName + "').innerHTML;" +
                "document.body.innerHTML = printcontent;" +
                "window.onafterprint = function () { document.body.innerHTML = restorepage; };" +
                "window.print();"
                , true);
        }

        public static void ToPDF(GridView gv, string FileName, List<int> RTLHeaders, List<int> RTLColumns, bool RTLDirection)
        {
            if (gv.Rows.Count == 0) return;

            gv.AllowPaging = false;
            gv.DataBind();

            HttpResponse Response = gv.Page.Response;
            HttpServerUtility Server = gv.Page.Server;

            PdfPTable pdfTable = new PdfPTable(gv.HeaderRow.Cells.Count);

            BaseFont bf = BaseFont.CreateFont(Environment.GetEnvironmentVariable("windir") + @"\fonts\Arial.ttf", BaseFont.IDENTITY_H, true);
            iTextSharp.text.Font font = new iTextSharp.text.Font(bf, 10, iTextSharp.text.Font.NORMAL);
            int[] widths = new int[gv.Columns.Count];

            if(!RTLDirection)
                for (int x = 0; x < gv.Columns.Count; x++)
                {
                    string cellText = Server.HtmlDecode(gv.HeaderRow.Cells[x].Text);
                    Font HeaderFont = new Font(font);
                    HeaderFont.SetColor(20, 158, 83);
                    HeaderFont.SetStyle(iTextSharp.text.Font.BOLD);
                    iTextSharp.text.pdf.PdfPCell cell = new iTextSharp.text.pdf.PdfPCell(new Phrase(12, cellText, HeaderFont));
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.BackgroundColor = new BaseColor(gv.HeaderStyle.BackColor.ToArgb());
                    if (RTLHeaders.Count(c => c == x) > 0)
                        cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                    else cell.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
                    pdfTable.AddCell(cell);
                }
            else
                for (int x = gv.Columns.Count - 1; x >= 0; x--)
                {
                    string cellText = Server.HtmlDecode(gv.HeaderRow.Cells[x].Text);
                    Font HeaderFont = new Font(font);
                    HeaderFont.SetColor(20, 158, 83);
                    HeaderFont.SetStyle(iTextSharp.text.Font.BOLD);
                    iTextSharp.text.pdf.PdfPCell cell = new iTextSharp.text.pdf.PdfPCell(new Phrase(12, cellText, HeaderFont));
                    cell.HorizontalAlignment = Element.ALIGN_CENTER;
                    cell.BackgroundColor = new BaseColor(gv.HeaderStyle.BackColor.ToArgb());
                    if (RTLHeaders.Count(c => c == x) > 0)
                        cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                    else cell.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
                    pdfTable.AddCell(cell);
                }

            if (!RTLDirection)
                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    if (gv.Rows[i].RowType == DataControlRowType.DataRow)
                    {
                        for (int j = 0; j < gv.Columns.Count; j++)
                        {
                            Font ColumnFont = new Font(font);

                            string cellText = Server.HtmlDecode(gv.Rows[i].Cells[j].Text);
                            iTextSharp.text.pdf.PdfPCell cell;

                            //Set Color of Alternating row
                            if (i % 2 != 0)
                            {
                                ColumnFont.SetColor(gv.AlternatingRowStyle.ForeColor.R, gv.AlternatingRowStyle.ForeColor.G, gv.AlternatingRowStyle.ForeColor.B);
                                cell = new iTextSharp.text.pdf.PdfPCell(new Phrase(12, cellText, ColumnFont));
                                cell.BackgroundColor = new BaseColor(gv.AlternatingRowStyle.BackColor.ToArgb());
                            }
                            else
                            {
                                ColumnFont.SetColor(gv.RowStyle.ForeColor.R, gv.RowStyle.ForeColor.G, gv.RowStyle.ForeColor.B);
                                cell = new iTextSharp.text.pdf.PdfPCell(new Phrase(12, cellText, ColumnFont));
                                cell.BackgroundColor = new BaseColor(gv.RowStyle.BackColor.ToArgb());
                            }

                            if (RTLColumns.Count(c => c == j) > 0)
                                cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                            else cell.RunDirection = PdfWriter.RUN_DIRECTION_LTR;

                            cell.VerticalAlignment = Element.ALIGN_TOP;
                            
                            pdfTable.AddCell(cell);
                        }
                    }
                }
            else
                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    if (gv.Rows[i].RowType == DataControlRowType.DataRow)
                    {
                        for (int j = gv.Columns.Count - 1; j >= 0; j--)
                        {
                            Font ColumnFont = new Font(font);

                            string cellText = Server.HtmlDecode(gv.Rows[i].Cells[j].Text);
                            iTextSharp.text.pdf.PdfPCell cell;

                            //Set Color of Alternating row
                            if (i % 2 != 0)
                            {
                                ColumnFont.SetColor(gv.AlternatingRowStyle.ForeColor.R, gv.AlternatingRowStyle.ForeColor.G, gv.AlternatingRowStyle.ForeColor.B);
                                cell = new iTextSharp.text.pdf.PdfPCell(new Phrase(12, cellText, ColumnFont));
                                cell.BackgroundColor = new BaseColor(gv.AlternatingRowStyle.BackColor.ToArgb());
                            }
                            else
                            {
                                ColumnFont.SetColor(gv.RowStyle.ForeColor.R, gv.RowStyle.ForeColor.G, gv.RowStyle.ForeColor.B);
                                cell = new iTextSharp.text.pdf.PdfPCell(new Phrase(12, cellText, ColumnFont));
                                cell.BackgroundColor = new BaseColor(gv.RowStyle.BackColor.ToArgb());
                            }

                            if (RTLColumns.Count(c => c == j) > 0)
                                cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                            else cell.RunDirection = PdfWriter.RUN_DIRECTION_LTR;

                            cell.VerticalAlignment = Element.ALIGN_TOP;
                            
                            pdfTable.AddCell(cell);
                        }
                    }
                }

            //Create the PDF Document
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
            if (gv.Columns.Count > 5) pdfDoc.SetPageSize(iTextSharp.text.PageSize.A4.Rotate());
            pdfTable.WidthPercentage = 100; //table width to 100per
            PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
            pdfDoc.Open();
            pdfDoc.Add(pdfTable);
            pdfDoc.Close();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=" + FileName + ".pdf");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Write(pdfDoc);
            Response.End();
        }
    }
}