<%@ page import="java.sql.*" %>
<%@ page import="dbconnection.Dbconnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <link rel="stylesheet" href="css/manageUsers.css">
    
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<%@ include file="header.jsp" %>

<div class="page-container">
    <h2 class="page-title">Login Activity</h2>

    <table class="styled-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>User Name</th>
                <th>Email</th>
                <th>IP Address</th>
                <th>Login Time</th>
                <th>Status</th>
                <th>Remarks</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection con = Dbconnection.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM auth_logs");

                while(rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("ip_address") %></td>
                <td><%= rs.getString("login_time") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getString("remarks") %></td>
            </tr>
        <%
                }
                con.close();
            } catch(Exception e) {
                out.println("<tr><td colspan='4'>"+e+"</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
