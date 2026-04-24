<%-- 
    Document   : downloadEncrypt
    Created on : 18 Feb, 2026, 10:19:33 AM
    Author     : sridh
--%>

<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="util.AESUtil" %>

<%
    String UPLOAD_DIR = "C:\\Users\\lenovo\\Desktop\\2026\\secure uploads";
    String fileId = request.getParameter("fileId");

    if (fileId == null || fileId.isEmpty()) {
        out.println("Invalid file ID");
        return;
    }

    try {
            out.println("t1");
        /* ? Hardcoded Session Key */
        String sessionKey = "fcf04f00-247d-4ce5-81e9-a50b3b64c0a4";

        /* 1?? Derive AES-128 key */
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] key = sha.digest(sessionKey.getBytes("UTF-8"));
        byte[] aesKey = Arrays.copyOf(key, 16);

        /* 2?? Read encrypted file */
        File file = new File(UPLOAD_DIR + File.separator + fileId);
out.println("Looking for file at: " + file.getAbsolutePath() + "<br>");

        if (!file.exists()) {
            out.println("Encrypted file not found.");
            return;
        }
  out.println("t2");
        byte[] encryptedBytes = new byte[(int) file.length()];
        FileInputStream fis = new FileInputStream(file);

        int totalRead = 0;
        while (totalRead < encryptedBytes.length) {
            int bytesRead = fis.read(encryptedBytes, totalRead,
                    encryptedBytes.length - totalRead);
            if (bytesRead == -1) break;
            totalRead += bytesRead;
        }
        fis.close();
  out.println("t3");
        /* 3?? Decrypt */
        byte[] decryptedBytes = AESUtil.decrypt(encryptedBytes, aesKey);

        /* 4?? Send file to browser */
        response.reset();
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"decrypted_file\"");
        response.setContentLength(decryptedBytes.length);

        OutputStream os = response.getOutputStream();
        os.write(decryptedBytes);
        os.flush();
        os.close();
  out.println("t4");
       // return;

    } catch (Exception e) {
        out.println("Decryption failed: " + e.getMessage());
        e.printStackTrace();
    }
%>
