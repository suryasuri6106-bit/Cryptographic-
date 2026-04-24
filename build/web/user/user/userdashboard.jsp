<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="session-check.jspf.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" type="text/css" href="css/style1.css">
</head>

<body>

<%@ include file="header.jsp" %>

<div class="user-dashboard-wrapper">

    <h2 class="welcome-text">
        Welcome, <%= session.getAttribute("username") %>!
    </h2>

    <div class="user-dashboard-container">

        <!-- Card 1 -->
        <div class="user-card">
            <h3>Generate Secure Key</h3>
            <p>Initiate cryptographic key exchange</p>
            <a href="generateKey.jsp">Generate</a>
        </div>

        <!-- Card 2 -->
        <div class="user-card">
            <h3>Key History</h3>
            <p>View previously generated keys</p>
            <a href="userKeyHistory.jsp">View</a>
        </div>

        <!-- Card 3 -->
        <div class="user-card">
            <h3>Login Activity</h3>
            <p>Track your authentication history</p>
            <a href="userAuthLogs.jsp">View</a>
        </div>

    </div>

</div>

</body>
</html>
