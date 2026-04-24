<%-- 
    Document   : cleanupLogs.jsp
    Created on : 21 Jun, 2025, 10:10:38 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
     Connection con = null;
    try {
        
        Class.forName("com.mysql.jdbc.Driver");
           con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "root", "");

        PreparedStatement ps = con.prepareStatement(
            "DELETE FROM unauthorized_access WHERE timestamp < NOW() - INTERVAL 30 DAY");
        int deleted = ps.executeUpdate();

        ps.close();
        con.close();

        out.println("<h3 style='color:green;'>Deleted " + deleted + " old log(s).</h3>");
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
    }
%>
