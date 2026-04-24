<%@ page import="java.sql.*" %>
<%@ page import="dbconnection.Dbconnection" %>

<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>

    <!-- KEEP YOUR ORIGINAL CSS -->
    <link rel="stylesheet" href="css/style1.css">
    <link rel="stylesheet" href="css/style.css">

    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6fb;
        }

        /* ONLY CONTENT BOX UPDATED */
        .box {
            background: #fff;
            padding: 25px;
            margin: 40px auto;
            width: 70%;
            border-radius: 12px;
            box-shadow: 0px 10px 25px rgba(0,0,0,0.1);
            animation: fadeIn 0.8s ease-in-out;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        /* FORM */
        input[type="date"] {
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            background: #5b86e5;
            color: white;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background: #36d1dc;
            transform: scale(1.05);
        }

        /* TABLE */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            animation: fadeIn 1s ease-in;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        th {
            background: #5b86e5;
            color: white;
        }

        tr {
            transition: 0.3s;
        }

        tr:hover {
            background: #f1f5ff;
            transform: scale(1.01);
        }

        /* ICON */
        .icon {
            margin-right: 5px;
            color: #5b86e5;
            animation: bounce 1.5s infinite;
        }

        /* ANIMATION */
        @keyframes fadeIn {
            from {opacity: 0;}
            to {opacity: 1;}
        }

        @keyframes bounce {
            0%,100% {transform: translateY(0);}
            50% {transform: translateY(-4px);}
        }
    </style>
</head>

<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Unauthorized Access");
        return;
    }
%>

<body>

<!-- ? YOUR HEADER + NAVBAR (UNCHANGED) -->
<header class="main-header">
    <h1>Cryptographic Key Exchange Authentication Portal</h1>
</header>

<nav class="navbar">
    <a href="admindashboard.jsp">Dashboard</a>
    <a href="manageUsers.jsp">Users</a>
    <a href="activeSessions.jsp">Sessions</a>
    <a href="keyManagement.jsp">Key Exchange</a>
    <a href="authLogs.jsp">Authentication Logs</a>
    <a href="adminBlockedIps.jsp">Blocked IPs</a>
    <a href="systemReports.jsp">Reports</a>
    <a href="../index.jsp">Logout</a>
</nav>

<!-- ? ONLY THIS PART MODIFIED -->
<div class="box">
    <h2>
        <i class="fa-solid fa-calendar-days icon"></i>
        Search Shared Files by Date
    </h2>

    <form method="post">
        <input type="date" name="search_date" required>
        <button type="submit">
            <i class="fa-solid fa-magnifying-glass"></i> Search
        </button>
    </form>

<%
    String date = request.getParameter("search_date");

    if (date != null && !date.isEmpty()) {
        try {
            Connection con = Dbconnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM secure_files WHERE upload_time LIKE ?"
            );
            ps.setString(1, date + "%");

            ResultSet rs = ps.executeQuery();
%>

    <table>
        <tr>
            <th><i class="fa-solid fa-id-badge"></i> ID</th>
            <th><i class="fa-solid fa-user"></i> Owner</th>
            <th><i class="fa-solid fa-file"></i> File Name</th>
            <th><i class="fa-solid fa-lock"></i> Encrypted Name</th>
            <th><i class="fa-solid fa-clock"></i> Upload Time</th>
        </tr>

<%
        boolean found = false;

        while (rs.next()) {
            found = true;
%>
        <tr>
            <td><%= rs.getString("id") %></td>
            <td><%= rs.getString("owner_email") %></td>
            <td><%= rs.getString("filename") %></td>
            <td><%= rs.getString("encrypted_filename") %></td>
            <td><%= rs.getString("upload_time") %></td>
        </tr>
<%
        }

        if (!found) {
%>
        <tr>
            <td colspan="5" style="color:red;">
                <i class="fa-solid fa-triangle-exclamation"></i> No records found
            </td>
        </tr>
<%
        }

        con.close();
    } catch (Exception e) {
%>
    <p style="color:red;">
        <i class="fa-solid fa-bug"></i> Error: <%= e.getMessage() %>
    </p>
<%
    }
}
%>

    </table>
</div>

</body>