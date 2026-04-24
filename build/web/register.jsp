<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.crypto.*, javax.crypto.spec.SecretKeySpec, java.util.Base64, java.nio.charset.StandardCharsets" %>
<%@ include file="header.jsp" %>

<%@page import="dbconnection.Dbconnection"%>

<link rel="stylesheet" type="text/css" href="css/style.css">

<!-- Font Awesome Icons -->
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>

/* animated icon style */
.form-field i{
    margin-right:8px;
    color:#0077cc;
    animation:iconBounce 1.8s infinite;
}

@keyframes iconBounce{
    0%{transform:translateY(0);}
    50%{transform:translateY(-4px);}
    100%{transform:translateY(0);}
}

</style>

<%! 
    // 16-char AES key
    private static final String AES_KEY = "1234567890abcdef";

    public String encryptAES(String data) throws Exception {
        SecretKeySpec key = new SecretKeySpec(AES_KEY.getBytes(StandardCharsets.UTF_8), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] encrypted = cipher.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encrypted);
    }
%>

<%
String message = "";
Connection con = null; 

if ("POST".equalsIgnoreCase(request.getMethod())) {

    String name = request.getParameter("name");
    String mobile = request.getParameter("mobile");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {

        String encEmail = encryptAES(email);
        String encPassword = encryptAES(password);

        con = Dbconnection.getConnection();

        if (con == null) {
            throw new SQLException("Failed to establish a database connection.");
        }

        String sql = "INSERT INTO users (name, mobile, email, password) VALUES (?, ?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, name);
        ps.setString(2, mobile);
        ps.setString(3, encEmail);
        ps.setString(4, encPassword);

        int i = ps.executeUpdate();

        message = (i > 0) ? "Registration successful!" : "Registration failed.";

        con.close();

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
}
%>

<div class="form-wrapper">
  <div class="form-box">
    <h2><i class="fa fa-user-plus"></i> Create Your Account</h2>

    <form method="post" class="form">

      <div class="form-field">
        <label for="name"><i class="fa fa-user"></i> Full Name</label>
        <input type="text" id="name" name="name" required />
      </div>

      <div class="form-field">
        <label for="mobile"><i class="fa fa-phone"></i> Mobile</label>
        <input type="text" id="mobile" name="mobile" required />
      </div>

      <div class="form-field">
        <label for="email"><i class="fa fa-envelope"></i> Email Address</label>
        <input type="email" id="email" name="email" required />
      </div>

      <div class="form-field">
        <label for="password"><i class="fa fa-lock"></i> Password</label>
        <input type="password" id="password" name="password" required />
      </div>

      <div class="form-field">
        <button type="submit">
            <i class="fa fa-user-check"></i> Register
        </button>
      </div>

      <p class="text-small" style="color: green;"><%= message %></p>
      <p class="text-small">Already registered? <a href="ulogin.jsp">Login here</a></p>

    </form>
  </div>
</div>

<%@ include file="footer.jsp" %>