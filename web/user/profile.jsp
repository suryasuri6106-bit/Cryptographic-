<%-- 
    Document   : profile.jsp
    Created on : 30 Jun, 2025, 11:28:12 AM
    Author     : DELL
--%>
<%@ page import="java.sql.*, dbconnection.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, javax.crypto.*, javax.crypto.spec.SecretKeySpec, java.util.Base64, java.nio.charset.StandardCharsets" %>


<html>
<head>
  <title>Profile</title>
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <style>
    body { font-family: Arial; background: #f5f5f5; padding: 20px; }
    .box { background: white; padding: 20px; max-width: 600px; margin: auto; border-radius: 8px; box-shadow: 0 0 10px #ccc; }
    input { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; }
    button { background: #3498db; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
    .msg { padding: 10px; border-radius: 5px; margin: 10px 0; }
    .success { background: #d4edda; color: #155724; }
    .error { background: #f8d7da; color: #721c24; }
  </style>
</head>
<body>
<div class="box">
  <h2>👤 Your Profile</h2>
  
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
String userId = encryptAES((String)(session.getAttribute("email")));
//out.println(userId);
String name = "", mobile = "", email = "";


if (userId.equals("")) 
{
  msg = "<div class='error'>❌ You must be logged in to view this page.</div>";
  //out.println("test1");
} 
else 
{
    //out.println("test2");
  try {
    Connection con = Dbconnection.getConnection();

    // If update requested
    if ("POST".equalsIgnoreCase(request.getMethod())) {
      //  out.println("test3");
      String newName = request.getParameter("name");
      String newMobile = request.getParameter("mobile");
      String oldPwd = request.getParameter("old_password");
      String newPwd = request.getParameter("new_password");
      String confirmPwd = request.getParameter("confirm_password");

      PreparedStatement check = con.prepareStatement("SELECT * FROM users WHERE email=?");
      check.setString(1, userId);
      ResultSet rs = check.executeQuery();

      if (rs.next())
      {
        String currentPwd = decrypt(rs.getString("password"));
 out.println(currentPwd);
        if (!oldPwd.isEmpty() || !newPwd.isEmpty()) {
          if (!oldPwd.equals(currentPwd)) {
            msg = "<div class='error'>❌ Old password is incorrect.</div>";
          } else if (!newPwd.equals(confirmPwd)) {
            msg = "<div class='error'>❌ New and confirm passwords do not match.</div>";
          } else {
             // out.println(currentPwd);
          //   Update name, mobile and password
            PreparedStatement upd = con.prepareStatement("UPDATE users SET name=?, mobile=?, password=? WHERE email=?");
            upd.setString(1, newName);
            upd.setString(2, newMobile);
            upd.setString(3, encryptAES(newPwd));
            upd.setString(4, userId);
            upd.executeUpdate();
            msg = "<div class='success'>✅ Profile and password updated successfully!</div>";
          }
        } else {
          // Update only name and mobile
         //  out.println(currentPwd);
          PreparedStatement upd = con.prepareStatement("UPDATE users SET name=?, mobile=? WHERE email=?");
          upd.setString(1, newName);
          upd.setString(2, newMobile);
          upd.setString(3, userId);
          upd.executeUpdate();
          msg = "<div class='success'>✅ Profile updated successfully!</div>";
        }
      }

      rs.close();
      check.close();
    }

    // Always load current profile
    PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?");
    ps.setString(1, userId);
    ResultSet user = ps.executeQuery();

    if (user.next()) {
      name = user.getString("name");
      mobile = user.getString("mobile");
      email = user.getString("email");
    }

    user.close();
    ps.close();
    con.close();
  } catch (Exception e) {
    msg = "<div class='error'>❌ Error: " + e.getMessage() + "</div>";
  }
}
%>

<%= msg %>

<form method="post" action="">
  <label>Name:</label>
  <input type="text" name="name" value="<%= name %>" required>

  <label>Mobile:</label>
  <input type="text" name="mobile" value="<%= mobile %>" required>

  <label>Email (read-only):</label>
  <input type="email" value="<%=userId %>" readonly>

  <hr>

  <label>Old Password:</label>
  <input type="password" name="old_password" placeholder="Enter old password if changing">

  <label>New Password:</label>
  <input type="password" name="new_password" placeholder="New password">

  <label>Confirm Password:</label>
  <input type="password" name="confirm_password" placeholder="Confirm new password">

  <button type="submit">Update Profile</button>
</form>

</div>
</body>
</html>
