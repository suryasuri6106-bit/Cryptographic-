<%@ page import="java.sql.*, javax.crypto.*, javax.crypto.spec.SecretKeySpec, java.util.Base64, java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>
<link rel="stylesheet" type="text/css" href="css/style.css">
<%@page import="dbconnection.Dbconnection"%>

<!-- ✅ ICON LIBRARY -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
/* Animated icon style */
.icon {
    margin-right: 8px;
    color: #333;
    animation: float 2s infinite ease-in-out;
}

@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-5px); }
    100% { transform: translateY(0px); }
}

button {
    transition: 0.3s;
}

button:hover {
    background: #333;
    color: #fff;
    transform: scale(1.05);
}
</style>

<%
    Connection con = null; 
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String inputEmail = request.getParameter("email");
        String inputPassword = request.getParameter("password");

        try {
            con = Dbconnection.getConnection();
            String sql = "SELECT u FROM admin WHERE u=? AND p=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, inputEmail);
            ps.setString(2, inputPassword);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("username", rs.getString("u"));
                out.println("<script>alert('Login Successfully');window.location='admin/admindashboard.jsp';</script> ");
                return;
            } else {
                message = "Invalid email or password.";
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<div class="form-wrapper">
  <div class="form-box">
    <h2><i class="fas fa-user-shield icon"></i>Admin Login</h2>

    <form method="post" class="form">
      <div class="form-field">
        <label><i class="fas fa-envelope icon"></i>Email Address</label>
        <input type="email" name="email" required />
      </div>

      <div class="form-field">
        <label><i class="fas fa-lock icon"></i>Password</label>
        <input type="password" name="password" required />
      </div>

      <div class="form-field">
        <button type="submit">
            <i class="fas fa-sign-in-alt icon"></i> Login
        </button>
      </div>

      <p class="text-small" style="color:red;"><%= message %></p>
      <p class="text-small">
        <i class="fas fa-key icon"></i>
        <a href="aforgotpwd.jsp">Forgot Password?</a>
      </p>
    </form>
  </div>
</div>

<%@ include file="footer.jsp" %>