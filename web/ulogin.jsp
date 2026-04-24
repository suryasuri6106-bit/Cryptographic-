<%@ page import="java.sql.*, javax.crypto.*, javax.crypto.spec.SecretKeySpec, java.util.Base64, java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>
<link rel="stylesheet" type="text/css" href="css/style.css">
<%@page import="dbconnection.Dbconnection"%>

<!-- ✅ ICON LIBRARY -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
/* Animated icons */
.icon {
    margin-right: 8px;
    color: #444;
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

<%! 
    private static final String AES_KEY = "1234567890abcdef";

    public String encryptAES(String data) throws Exception {
        SecretKeySpec key = new SecretKeySpec(AES_KEY.getBytes(StandardCharsets.UTF_8), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] encrypted = cipher.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encrypted);
    }

    public static String decrypt(String strToDecrypt) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(AES_KEY.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        return new String(cipher.doFinal(Base64.getDecoder().decode(strToDecrypt)));
    }
%>

<%
    Connection con = null; 
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String inputEmail = request.getParameter("email");
        String inputPassword = request.getParameter("password");

        try {
            String encEmail = encryptAES(inputEmail);
            String encPassword = encryptAES(inputPassword);

            con = Dbconnection.getConnection();
            String sql = "SELECT id,name FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, encEmail);
            ps.setString(2, encPassword);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("username", rs.getString("name"));
                session.setAttribute("userid", rs.getInt("id"));
                session.setAttribute("email", inputEmail);

                out.println("<script>alert('Login Successfully');window.location='user/userdashboard.jsp';</script>");
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
    <h2><i class="fas fa-user icon"></i>User Login</h2>

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
        <a href="uforgotpwd.jsp">Forgot Password?</a>
      </p>

      <p class="text-small">
        <i class="fas fa-user-plus icon"></i>
        New user? <a href="register.jsp">Register here</a>
      </p>
    </form>
  </div>
</div>

<%@ include file="footer.jsp" %>