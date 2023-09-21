<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Drawing.Imaging" %>

<%@ Page Language="c#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string fileName = Request.Params["fileName"];
        string outputName = Path.GetFileName(fileName);

        MemoryStream memoryStream = new MemoryStream(File.ReadAllBytes(fileName));

        byte[] bytes = createdImagePdf(memoryStream).ToArray();
        Response.Buffer = true;
        Response.Clear();
        Response.ContentType = "application/pdf";
        Response.AddHeader("content-disposition", "filename=" + outputName + ".pdf");
        Response.BinaryWrite(bytes);
        Response.Flush();
    }

    public MemoryStream createdImagePdf(Stream memoryStream)
    {
        iTextSharp.text.Document document = new iTextSharp.text.Document(iTextSharp.text.PageSize.LETTER, 0, 0, 0, 0);

        MemoryStream returnStream = new MemoryStream();

        iTextSharp.text.pdf.PdfWriter writer = iTextSharp.text.pdf.PdfWriter.GetInstance(document, returnStream);

        System.Drawing.Bitmap bm = new System.Drawing.Bitmap(memoryStream);
        int total = bm.GetFrameCount(System.Drawing.Imaging.FrameDimension.Page);

        document.Open();
        iTextSharp.text.pdf.PdfContentByte cb = writer.DirectContent;
        for (int k = 0; k < total; ++k)
        {
            bm.SelectActiveFrame(System.Drawing.Imaging.FrameDimension.Page, k);

            iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(bm, ImageFormat.Tiff);
            img.SetAbsolutePosition(0, 0);
            img.ScaleAbsoluteHeight(document.PageSize.Height);
            img.ScaleAbsoluteWidth(document.PageSize.Width);
            cb.AddImage(img);

            document.NewPage();
        }
        document.Close();

        return returnStream;
    }

</script>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <title></title>
</head>
<body>
</body>
</html>
