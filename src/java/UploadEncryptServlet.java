//package user;
//
//import dbconnection.Dbconnection;
//import util.AESUtil;
//
//import javax.servlet.*;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.*;
//import java.security.MessageDigest;
//import java.sql.*;
//import java.util.*;
//import java.sql.*;
//import javax.mail.*;
//import javax.mail.internet.*;
//import javax.activation.*;
//import java.util.Random.*;
//import javax.swing.JOptionPane.*;
//import java.util.Properties.*;
//
//import java.io.*;
//import java.sql.*;
//import java.text.SimpleDateFormat.*;
//import java.util.Date.*;
//import java.util.Properties.*;
//import javax.mail.Message.*;
//import javax.mail.MessagingException.*;
//import javax.mail.PasswordAuthentication.*;
//import javax.mail.Session.*;
//import javax.mail.Transport.*;
//import javax.mail.internet.InternetAddress.*;
//import javax.mail.internet.MimeMessage.*;
//import java.util.Random.*;
//import Emailpackage.*;
//  
//
//@WebServlet("/UploadEncryptServlet")
//@MultipartConfig(
//        fileSizeThreshold = 1024*1024*1,
//        maxFileSize = 1024*1024*50,
//        maxRequestSize = 1024*1024*60
//)
//public class UploadEncryptServlet extends HttpServlet {
//
//    // Persistent folder for encrypted files
//    private static final String UPLOAD_DIR = "C:\\Users\\lenovo\\Desktop\\2026\\secure uploads";
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String ownerEmail = (String) request.getSession().getAttribute("email");
//        if (ownerEmail == null) {
//            response.sendRedirect("ulogin.jsp");
//            return;
//        }
//
//        Part filePart = request.getPart("secureFile");
//        String sharedWith = request.getParameter("shareWith");
//        String fileName = filePart.getSubmittedFileName();
//
//        // Ensure upload directory exists
//        File dir = new File(UPLOAD_DIR);
//        if (!dir.exists()) dir.mkdirs();
//
//        String encryptedFileName = System.currentTimeMillis() + "_" + fileName + ".enc";
//        String filePath = UPLOAD_DIR + File.separator + encryptedFileName;
//
//        // Read file bytes
//        InputStream is = filePart.getInputStream();
//        ByteArrayOutputStream bos = new ByteArrayOutputStream();
//        byte[] buffer = new byte[4096];
//        int bytesRead;
//        while ((bytesRead = is.read(buffer)) != -1) bos.write(buffer, 0, bytesRead);
//        byte[] fileBytes = bos.toByteArray();
//
//        try {
//            // Generate session key
//            String sessionKey = UUID.randomUUID().toString();
//
//            // Derive AES key
//            MessageDigest sha = MessageDigest.getInstance("SHA-256");
//            byte[] aesKey = Arrays.copyOf(sha.digest(sessionKey.getBytes("UTF-8")), 16); // 128-bit key
//
//            // Encrypt
//            byte[] encryptedData = AESUtil.encrypt(fileBytes, aesKey);
//
//            // Save to persistent folder
//            try (FileOutputStream fos = new FileOutputStream(filePath)) {
//                fos.write(encryptedData);
//            }
//
//            // Store metadata in DB
//            try (Connection con = Dbconnection.getConnection()) {
//                PreparedStatement ps = con.prepareStatement(
//                        "INSERT INTO secure_files(owner_email, filename, encrypted_filename) VALUES (?,?,?)",
//                        Statement.RETURN_GENERATED_KEYS
//                );
//                ps.setString(1, ownerEmail);
//                ps.setString(2, fileName);
//                ps.setString(3, encryptedFileName);
//                ps.executeUpdate();
//
//                ResultSet rs = ps.getGeneratedKeys();
//                int fileId = rs.next() ? rs.getInt(1) : 0;
//
//                PreparedStatement ps2 = con.prepareStatement(
//                        "INSERT INTO file_keys(file_id, session_key, shared_with, status) VALUES (?,?,?,?)"
//                );
//                ps2.setInt(1, fileId);
//                ps2.setString(2, sessionKey);
//                ps2.setString(3, sharedWith);
//                ps2.setString(4, "ACTIVE");
//                ps2.executeUpdate();
//            }
//
//        } catch (Exception e) {
//            throw new ServletException("Error encrypting/uploading file", e);
//        }
//
////        response.sendRedirect("../user/uploadSuccess.jsp");
//String emailto="suryamsuryam2007@gmail.com";
//Emailclass new1=new Emailclass();
//
//
//new1.SendMail(emailto,"test");
//out.println("t2");
//out.println("Sent Mail Successfully to your registered Email Id.....");
//
//response.sendRedirect(request.getContextPath() + "/user/uploadSuccess.jsp");
//
//    }
//}




package user;

import dbconnection.Dbconnection;
import util.AESUtil;
import Emailpackage.Emailclass;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.security.MessageDigest;
import java.sql.*;
import java.util.Arrays;
import java.util.UUID;

@WebServlet("/UploadEncryptServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,
        maxFileSize = 1024 * 1024 * 50,
        maxRequestSize = 1024 * 1024 * 60
)
public class UploadEncryptServlet extends HttpServlet {

    private static final String UPLOAD_DIR =
            "C:\\Users\\lenovo\\Desktop\\2026\\secure_uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ownerEmail = (String) request.getSession().getAttribute("email");

        if (ownerEmail == null) {
            response.sendRedirect("ulogin.jsp");
            return;
        }

        Part filePart = request.getPart("secureFile");
        String sharedWith = request.getParameter("shareWith");
        String fileName = filePart.getSubmittedFileName();

        if (fileName == null || fileName.isEmpty()) {
            response.sendRedirect("upload.jsp?error=NoFile");
            return;
        }

        // Ensure upload directory exists
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String encryptedFileName =
                System.currentTimeMillis() + "_" + fileName + ".enc";
        String filePath = UPLOAD_DIR + File.separator + encryptedFileName;

        try (InputStream is = filePart.getInputStream();
             ByteArrayOutputStream bos = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = is.read(buffer)) != -1) {
                bos.write(buffer, 0, bytesRead);
            }

            byte[] fileBytes = bos.toByteArray();

            // Generate session key
            String sessionKey = UUID.randomUUID().toString();

            // Derive AES key (128-bit)
            MessageDigest sha = MessageDigest.getInstance("SHA-256");
            byte[] aesKey = Arrays.copyOf(
                    sha.digest(sessionKey.getBytes("UTF-8")), 16);

            // Encrypt file
            byte[] encryptedData = AESUtil.encrypt(fileBytes, aesKey);

            // Save encrypted file
            try (FileOutputStream fos = new FileOutputStream(filePath)) {
                fos.write(encryptedData);
            }

            // Store metadata in DB
            try (Connection con = Dbconnection.getConnection()) {

                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO secure_files(owner_email, filename, encrypted_filename) VALUES (?,?,?)",
                        Statement.RETURN_GENERATED_KEYS
                );

                ps.setString(1, ownerEmail);
                ps.setString(2, fileName);
                ps.setString(3, encryptedFileName);
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                int fileId = rs.next() ? rs.getInt(1) : 0;

                PreparedStatement ps2 = con.prepareStatement(
                        "INSERT INTO file_keys(file_id, session_key, shared_with, status) VALUES (?,?,?,?)"
                );

                ps2.setInt(1, fileId);
                ps2.setString(2, sessionKey);
                ps2.setString(3, sharedWith);
                ps2.setString(4, "ACTIVE");
                ps2.executeUpdate();
            }

            // Send Email Notification
            if (sharedWith != null && !sharedWith.isEmpty()) {
                Emailclass mail = new Emailclass();
                mail.SendMail(sharedWith,
                        "A file has been shared with you.\n\nFile Name: " + fileName+","+sessionKey);
            }
	String emailto="suryamsuryam2007@gmail.com";
Emailclass new1=new Emailclass();


new1.SendMail(emailto,sessionKey);
//out.println("t2");
//out.println("Sent Mail Successfully to your registered Email Id.....");
            // Redirect success
            response.sendRedirect(request.getContextPath()
                    + "/user/uploadSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("upload.jsp?error=UploadFailed");
        }
    }
}
