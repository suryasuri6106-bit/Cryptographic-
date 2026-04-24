<%-- 
    Document   : adminOnly.jsp
    Created on : 21 Jun, 2025, 10:01:13 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<html>
<head><title>Unauthorized Access Log</title>
   <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
    body { font-family: Arial; background: #f9f9f9; padding: 20px; }
    h2 { color: #333; }
    table { width: 100%; border-collapse: collapse; background: #fff; }
    th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
    th { background-color: #eee; }
    form { display: inline; }
    .btn-unblock {
      background-color: #e74c3c;
      border: none;
      color: white;
      padding: 5px 10px;
      cursor: pointer;
    }
  </style>
</head>
<body>
<h2>Unauthorized Access Attempts</h2>
<table border="1">
<tr><th>IP</th><th>Page</th><th>Browser</th><th>Time</th></tr>

<%
   Connection con=null;
     Class.forName("com.mysql.jdbc.Driver");
           con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "root", "");
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM unauthorized_access ORDER BY timestamp DESC");

    while(rs.next()) {
%>
<tr>
  <td><%= rs.getString("ip_address") %></td>
  <td><%= rs.getString("accessed_url") %></td>
  <td><%= rs.getString("browser_info") %></td>
  <td><%= rs.getString("timestamp") %></td>
</tr>
<% } con.close(); %>
</table>
</body>
</html>
