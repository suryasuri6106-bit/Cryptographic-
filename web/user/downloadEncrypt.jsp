<%-- 
    Document   : downloadEncrypt
    Updated to accept session key from UI
--%>

<%@ page import="java.io.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="util.AESUtil" %>

<%
    String UPLOAD_DIR = "C:\\Users\\lenovo\\Desktop\\2026\\secure_uploads";

    String fileId = request.getParameter("fileId");
    String sessionKey = request.getParameter("sessionKey");

    if (fileId == null || fileId.trim().isEmpty()) {
        out.println("Invalid file ID");
        return;
    }

    if (sessionKey == null || sessionKey.trim().isEmpty()) {
        out.println("Session key missing");
        return;
    }

    try {

        /* ? 1?? Derive AES-128 key from session key */
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] key = sha.digest(sessionKey.getBytes("UTF-8"));
        byte[] aesKey = Arrays.copyOf(key, 16);

        /* ? 2?? Read encrypted file */
        File file = new File(UPLOAD_DIR + File.separator + fileId);

        if (!file.exists()) {
            out.println("Encrypted file not found.");
            return;
        }

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

        /* ? 3?? Decrypt file */
        byte[] decryptedBytes = AESUtil.decrypt(encryptedBytes, aesKey);

        /* ?? 4?? Send file to browser */
        response.reset();
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + fileId + "\"");
        response.setContentLength(decryptedBytes.length);

        OutputStream os = response.getOutputStream();
        os.write(decryptedBytes);
        os.flush();
        os.close();
        return;

    } catch (Exception e) {
        out.println("Decryption failed: " + e.getMessage());
    }
%>