<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="dbconnection.Dbconnection" %>
<%@ include file="session-check.jspf.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Shared Files</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

<div class="page-container">
    <h2 class="page-title">Files Shared With You</h2>

    <table class="styled-table table table-striped table-hover">
        <thead>
        <tr>
            <th>File Name</th>
            <th>Owner</th>
            <th>Uploaded On</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
<%
    String userId = (String) session.getAttribute("email");

    if(userId != null) {
 String userId1 = (String) session.getAttribute("email");
        Connection con1 = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Dbconnection.getConnection();

        /*    String sql = "SELECT f.id, f.filename, u.email AS owner_email, f.upload_time " +
                         "FROM secure_files f " +
                         "JOIN users u ON f.owner_id = u.id " +
                         "JOIN file_keys k ON f.id = k.file_id " +
                         "WHERE k.shared_with_user_id = ? AND k.status = 'ACTIVE'"; */
        
        
        String sql="select * from secure_files";
        out.println(sql+","+userId1);
            ps = con.prepareStatement(sql);
         //   ps.setString(1, userId);
            rs = ps.executeQuery();

            while(rs.next()) {
%>
        <tr>
            <td><%= rs.getString("id") %></td>
            <td><%= rs.getString("encrypted_filename") %></td>
            <td><%= rs.getString("upload_time") %></td>
            <td>
<!--                <a href="DownloadEncryptServlet?fileId=<%= rs.getString("encrypted_filename") %>" class="btn btn-primary">Download</a>-->
                <!--<a href="downloadEncrypt.jsp?fileId=<%= rs.getString("encrypted_filename") %>" class="btn btn-primary">Download</a>-->
       <a href="decrypt.jsp?fileId=<%= rs.getString("encrypted_filename") %>" 
   class="btn btn-primary">Download</a>
            </td>
        </tr>
<%
            }

        } catch(Exception e) {
            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception ex) {}
            if(ps != null) try { ps.close(); } catch(Exception ex) {}
            if(con != null) try { con.close(); } catch(Exception ex) {}
        }

    } else {
%>
<tr><td colspan="4">No user logged in.</td></tr>
<%
    }
%>
        </tbody>
    </table>
</div>

</body>
</html>
