<%-- 
    Document   : logout
    Created on : 23 Jan, 2026, 11:41:58 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dbconnection.Dbconnection" %>
<%
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");
    String ipAddress = request.getRemoteAddr();

    if(username != null) {
        Connection con = Dbconnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO auth_logs(username, email, ip_address, status, remarks) VALUES (?,?,?,?,?)"
        );
        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, ipAddress);
        ps.setString(4, "LOGOUT");
        ps.setString(5, "User logged out");
        ps.executeUpdate();
        ps.close();
        con.close();
    }

    session.invalidate();
    response.sendRedirect("../index.jsp");
%>
