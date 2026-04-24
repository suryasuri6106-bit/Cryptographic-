<%@ page import="java.sql.*, javax.crypto.*, javax.crypto.spec.SecretKeySpec, java.util.Base64, java.nio.charset.StandardCharsets" %>
<%@page import="dbconnection.Dbconnection"%>
<%@ include file="header.jsp" %>

<link rel="stylesheet" type="text/css" href="css/style.css">
<html>
<head>
  <title>Forgot Password</title>
  <style>
    body { font-family: Arial; background: #f0f0f0; padding: 30px; }
    .container {
      background: white;
      max-width: 500px;
      margin: auto;
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 0 10px #ccc;
    }
    input {
      width: 100%;
      padding: 10px;
      margin: 8px 0;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    button {
      background-color: #e67e22;
      color: white;
      padding: 10px;
      border: none;
      width: 100%;
      border-radius: 4px;
      cursor: pointer;
    }
    h2 { text-align: center; }
    .msg { padding: 10px; border-radius: 4px; margin-top: 10px; text-align: center; }
    .success { background: #d4edda; color: #155724; }
    .error { background: #f8d7da; color: #721c24; }
  </style>
</head>
<body>
<div class="container">
  <h2>? Forgot Password</h2>

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
String msg = "";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    String inputEmail = request.getParameter("email");
    String newPassword = request.getParameter("new_password");
    String confirmPassword = request.getParameter("confirm_password");

    if (inputEmail == null || newPassword == null || confirmPassword == null ||
        inputEmail.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
        msg = "<div class='error'>? All fields are required.</div>";
    } else if (!newPassword.equals(confirmPassword)) {
        msg = "<div class='error'>? Passwords do not match.</div>";
    } else {
        try {
            Connection con = Dbconnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT id, email FROM users");
            ResultSet rs = ps.executeQuery();
                
            boolean found = false;
            int userId = -1;

            while (rs.next()) {
                String encryptedEmail = rs.getString("email");
                String decryptedEmail = decrypt(encryptedEmail);

                if (inputEmail.equalsIgnoreCase(decryptedEmail)) {
                    found = true;
                    userId = rs.getInt("id");
                    break;
                }
            }

            if (!found) {
                msg = "<div class='error'>? Email not found in records.</div>";
            } else {
                
            //   String email=(String)session.getAttribute("email");
                String encryptedPassword = encryptAES(newPassword);
                PreparedStatement update = con.prepareStatement("UPDATE users SET password=? WHERE id=?");
                update.setString(1, encryptedPassword);
                 //    update.setString(1, newPassword);
                update.setInt(2, userId);
                update.executeUpdate();
               // out.println("pwd="+newPassword+"<br>");
                 //out.println("email="+userId);
                msg = "<div class='success'>? Password reset successfully!</div>";
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            msg = "<div class='error'>? Error: " + e.getMessage() + "</div>";
        }
    }
}
%>

<%= msg %>

<form method="post">
  <label>Email (Registered):</label>
  <input type="email" name="email" required placeholder="Enter your registered email">

  <label>New Password:</label>
  <input type="password" name="new_password" required>

  <label>Confirm Password:</label>
  <input type="password" name="confirm_password" required>

  <button type="submit">Reset Password</button>
</form>
</div>
</body>
</html>