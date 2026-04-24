package user;

import dbconnection.Dbconnection;
import util.AESUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.security.MessageDigest;
import java.sql.*;
import java.util.Arrays;

@WebServlet("/DownloadEncryptServlet")
public class DownloadEncryptServlet extends HttpServlet {

    // Persistent folder for encrypted files
    private static final String UPLOAD_DIR = "C:\\Users\\lenovo\\Desktop\\2026\\secure uploads";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int fileId = Integer.parseInt(request.getParameter("fileId"));
        String ownerEmail = (String) request.getSession().getAttribute("email");
        if (ownerEmail == null) {
            response.sendRedirect("ulogin.jsp");
            return;
        }

        try (Connection con = Dbconnection.getConnection()) {

            // Get file info
            PreparedStatement ps = con.prepareStatement(
                    "SELECT encrypted_filename, filename FROM secure_files WHERE id=? AND owner_email=?"
            );
            ps.setInt(1, fileId);
            ps.setString(2, ownerEmail);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                response.getWriter().println("File not found or access denied");
                return;
            }

            String encryptedFileName = rs.getString("encrypted_filename");
            String originalFileName = rs.getString("filename");

            // Get session key
            PreparedStatement ps2 = con.prepareStatement(
                    "SELECT session_key FROM file_keys WHERE file_id=? AND status='ACTIVE'"
            );
            ps2.setInt(1, fileId);
            ResultSet rs2 = ps2.executeQuery();
            if (!rs2.next()) {
                response.getWriter().println("Session key not found");
                return;
            }

            String sessionKey = rs2.getString("session_key");

            // Derive AES key
            MessageDigest sha = MessageDigest.getInstance("SHA-256");
            byte[] aesKey = Arrays.copyOf(sha.digest(sessionKey.getBytes("UTF-8")), 16);

            // Read encrypted file from persistent folder
            String filePath = UPLOAD_DIR + File.separator + encryptedFileName;
            File file = new File(filePath);
            if (!file.exists()) {
                response.getWriter().println("Encrypted file not found on server");
                return;
            }

            byte[] encryptedBytes = new byte[(int) file.length()];
            try (FileInputStream fis = new FileInputStream(file)) {
                fis.read(encryptedBytes);
            }

            // Decrypt
            byte[] decryptedBytes = AESUtil.decrypt(encryptedBytes, aesKey);

            // Send file to client
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + originalFileName + "\"");
            response.setContentLength(decryptedBytes.length);

            try (OutputStream os = response.getOutputStream()) {
                os.write(decryptedBytes);
            }

        } catch (Exception e) {
            throw new ServletException("Error downloading/decrypting file", e);
        }
    }
}
