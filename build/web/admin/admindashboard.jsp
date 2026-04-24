<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@page import="dbconnection.Dbconnection"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

    <link rel="stylesheet" href="css/style1.css">
    <link rel="stylesheet" href="css/style.css">

    <!-- 🔥 MODERN COLOR DESIGN -->
    <style>
        body {
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #ffffff;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
        }

        .welcome-text {
            text-align: center;
            font-size: 34px;
            margin: 20px 0;
            color: #ff4ecd;
            font-weight: bold;
        }

        .dashboard-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 20px;
        }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(10px);
            margin: 15px;
            padding: 20px;
            border-radius: 15px;
            width: 260px;
            text-align: center;
            transition: 0.4s ease;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .dashboard-card:hover {
            transform: translateY(-8px) scale(1.03);
            box-shadow: 0 15px 35px rgba(0,0,0,0.6);
        }

        .dashboard-card h2 {
            color: #00eaff;
            margin: 10px 0;
            font-size: 28px;
        }

        .dashboard-card h3 {
            color: #ffffff;
        }

        .dashboard-card p {
            color: #d1d1d1;
        }

        .dashboard-card a {
            background: linear-gradient(45deg, #00eaff, #ff4ecd);
            color: white;
            padding: 10px 18px;
            border-radius: 25px;
            text-decoration: none;
            display: inline-block;
            margin-top: 12px;
            font-weight: bold;
            transition: 0.3s;
        }

        .dashboard-card a:hover {
            opacity: 0.8;
            transform: scale(1.05);
        }
    </style>
</head>

<body>

<%@ include file="header.jsp" %>

<h2 class="welcome-text">
    Welcome, <%= session.getAttribute("username") %>!
</h2>

<div class="dashboard-container">

    <!-- Total Users -->
    <div class="dashboard-card">
        <%
            int totalUsers = 0;
            try {
                Connection con = Dbconnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users");
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    totalUsers = rs.getInt(1);
                }
        %>
        <h3>Total Users Registered</h3>
        <h2><%= totalUsers %></h2>
        <p>Manage registered users</p>
        <a href="manageUsers.jsp">View</a>
    </div>
        <%
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

    <!-- Active Sessions -->
    <div class="dashboard-card">
        <%
            int totalactive_sessions = 0;
            try {
                Connection con = Dbconnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM active_sessions");
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    totalactive_sessions = rs.getInt(1);
                }
        %>
        <h3>Reports</h3>
        <p>Monitor login sessions</p>
        <a href="activeSessions.jsp">View</a>
    </div>
        <%
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

    <!-- Key Exchange -->
    <div class="dashboard-card">
        <%
            int totalkeyManagement = 0;
            try {
                Connection con = Dbconnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM secure_files");
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    totalkeyManagement = rs.getInt(1);
                }
        %>
        <h3>Key Exchange</h3>
        <h2><%= totalkeyManagement %></h2>
        <p>Cryptographic key management</p>
        <a href="keyManagement.jsp">View</a>
    </div>
        <%
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

    <!-- Auth Logs -->
    <div class="dashboard-card">
        <%
            int totalauth_logs = 0;
            try {
                Connection con = Dbconnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM auth_logs");
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    totalauth_logs = rs.getInt(1);
                }
        %>
        <h3>Authentication Logs</h3>
        <h2><%= totalauth_logs %></h2>
        <p>View login & security logs</p>
        <a href="authLogs.jsp">View</a>
    </div>
        <%
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

    <!-- Blocked IPs -->
    <div class="dashboard-card">
        <%
            int totalblocked_ips = 0;
            try {
                Connection con = Dbconnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM blocked_ips");
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    totalblocked_ips = rs.getInt(1);
                }
        %>
        <h3>Blocked IPs</h3>
        <h2><%= totalblocked_ips %></h2>
        <p>Unblock suspicious IPs</p>
        <a href="adminBlockedIps.jsp">View</a>
    </div>
        <%
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

    <!-- User Key History -->
    <div class="dashboard-card">
        <%
            int totalUserKeyHistory = 0;
            try {
                Connection con = Dbconnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM file_keys");
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    totalUserKeyHistory = rs.getInt(1);
                }
        %>
        <h3>User Key History</h3>
        <h2><%= totalUserKeyHistory %></h2>
        <p>View generated cryptographic keys</p>
        <a href="userKeyHistory.jsp">View</a>
    </div>
        <%
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

</div>

</body>
</html>