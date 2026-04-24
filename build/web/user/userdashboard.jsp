<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="session-check.jspf.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>

    <!-- CSS Files -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" type="text/css" href="css/style1.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #141e30, #243b55);
            font-family: 'Segoe UI', sans-serif;
            color: #fff;
        }

        .user-dashboard-wrapper {
            text-align: center;
            padding: 30px;
        }

        .welcome-text {
            font-size: 30px;
            margin-bottom: 25px;
            color: #00ffd5;
            animation: fadeInDown 1s ease;
        }

        .user-dashboard-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }

        .user-card {
            background: linear-gradient(145deg, rgba(0, 255, 213, 0.1), rgba(0, 0, 0, 0.4));
            backdrop-filter: blur(12px);
            border-radius: 18px;
            padding: 25px;
            transition: 0.4s;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(0,255,213,0.2);
        }

        .user-card:hover {
            transform: translateY(-12px) scale(1.04);
            box-shadow: 0px 12px 30px rgba(0,255,213,0.3);
        }

        .user-card i {
            font-size: 45px;
            margin-bottom: 12px;
            display: block;
            animation: floatIcon 3s infinite ease-in-out;
            color: #00ffd5;
        }

        .user-card h3 {
            margin: 10px 0;
            color: #ffffff;
        }

        .user-card p {
            font-size: 14px;
            margin-bottom: 15px;
            color: #cfd8dc;
        }

        .user-card a {
            text-decoration: none;
            background: linear-gradient(45deg, #00ffd5, #00bfa5);
            color: #000;
            padding: 8px 18px;
            border-radius: 25px;
            font-weight: bold;
            transition: 0.3s;
        }

        .user-card a:hover {
            background: linear-gradient(45deg, #00bfa5, #00ffd5);
            color: #000;
        }

        @keyframes floatIcon {
            0% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0); }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-25px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>

<%@ include file="header.jsp" %>

<div class="user-dashboard-wrapper">

    <h2 class="welcome-text">
        Welcome, <%= session.getAttribute("username") %>!
    </h2>

    <div class="user-dashboard-container">

        <div class="user-card">
            <i class="fas fa-key"></i>
            <h3>Generate Secure Key</h3>
            <p>Initiate cryptographic key exchange</p>
            <a href="generateKey.jsp">Generate</a>
        </div>

        <div class="user-card">
            <i class="fas fa-history"></i>
            <h3>Key History</h3>
            <p>View previously generated keys</p>
            <a href="userKeyHistory.jsp">View</a>
        </div>

        <div class="user-card">
            <i class="fas fa-user-clock"></i>
            <h3>Login Activity</h3>
            <p>Track your authentication history</p>
            <a href="userAuthLogs.jsp">View</a>
        </div>

        <div class="user-card">
            <i class="fas fa-upload"></i>
            <h3>Upload File</h3>
            <p>Encrypt & upload files securely</p>
            <a href="uploadFile.jsp">Upload</a>
        </div>

        <div class="user-card">
            <i class="fas fa-share-alt"></i>
            <h3>Shared Files</h3>
            <p>View & download files shared with you</p>
            <a href="sharedFiles.jsp">View</a>
        </div>

        <div class="user-card">
            <i class="fas fa-user-cog"></i>
            <h3>Profile Settings</h3>
            <p>Update your account info</p>
            <a href="profile.jsp">Edit</a>
        </div>

    </div>

</div>

</body>
</html>