 <%-- 
    Document   : newjspsession-check.jspf
    Created on : 21 Jun, 2025, 9:51:07 AM
    Author     : DELL
--%>

<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>
<%@ page import="java.util.*, java.text.*, java.sql.*" %>
<%@page import="dbconnection.Dbconnection"%>
<%
    Connection con=null;
    String ip = request.getRemoteAddr();
    String url = request.getRequestURL().toString();
    String browser = request.getHeader("User-Agent");
    String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());

    try {
        Class.forName("com.mysql.jdbc.Driver");
           con = DriverManager.getConnection("jdbc:mysql://localhost:3306/crypto", "root", "");
        // Check if IP is currently blocked (within last 15 mins)
        PreparedStatement blockCheck = con.prepareStatement(
            "SELECT block_time FROM blocked_ips WHERE ip_address = ? AND block_time > NOW() - INTERVAL 5 MINUTE");
        blockCheck.setString(1, ip);
        ResultSet blockRS = blockCheck.executeQuery();

        if (blockRS.next()) {
            response.sendRedirect("blocked.jsp");
            return;
        }

        // Log this unauthorized access
        //PreparedStatement log = con.prepareStatement(
           // "INSERT INTO unauthorized_access (ip_address, accessed_url, browser_info, timestamp) VALUES (?, ?, ?, ?)");
        //log.setString(1, ip);
        //log.setString(2, url);
        //log.setString(3, browser);
        //log.setString(4, now);
        //log.executeUpdate();

        // Count number of attempts in last 5 minutes
        PreparedStatement countStmt = con.prepareStatement(
            "SELECT COUNT(*) FROM unauthorized_access WHERE ip_address = ? AND timestamp >= NOW() - INTERVAL 5 MINUTE");
        countStmt.setString(1, ip);
        ResultSet countRS = countStmt.executeQuery();
        int attempts = 0;
        if (countRS.next()) {
            attempts = countRS.getInt(1);
        }

        // If attempts exceed 3, block IP
        if (attempts >= 3) {
            PreparedStatement block = con.prepareStatement(
                "REPLACE INTO blocked_ips (ip_address, block_time) VALUES (?, NOW())");
            block.setString(1, ip);
            block.executeUpdate();
            block.close();
            response.sendRedirect("blocked.jsp");
            return;
        }

        // Cleanup
        blockRS.close();
        blockCheck.close();
        //log.close();
        countRS.close();
        countStmt.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // If not logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("accessDenied.jsp");
        return;
    }
%>