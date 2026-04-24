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
    <h2 class="page-title">Registered Users</h2>

    <table class="styled-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Mobile</th>
                <th>Email</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Connection con = Dbconnection.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM users");

                while(rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("mobile") %></td>
                <td><%= rs.getString("email") %></td>
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
