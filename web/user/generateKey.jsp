<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="session-check.jspf.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Secure File Upload</title>
    
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="stylesheet" type="text/css" href="css/style1.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- INTERNAL CSS -->
    <style>

        /* ===== PAGE BACKGROUND ===== */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #141e30, #243b55);
        }

        .upload-page {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* ===== FORM BOX ===== */
        .form-box {
            width: 400px;
            padding: 35px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(15px);
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
            animation: fadeIn 1s ease-in-out;
        }

        /* ===== TITLE ===== */
        .upload-title {
            text-align: center;
            color: white;
            margin-bottom: 25px;
        }

        /* ===== FORM FIELD ===== */
        .form-field {
            margin-bottom: 20px;
        }

        .form-field label {
            color: #ddd;
            font-size: 14px;
            display: block;
            margin-bottom: 5px;
        }

        .form-field input {
            width: 100%;
            padding: 10px;
            border-radius: 10px;
            border: none;
            outline: none;
            background: rgba(255,255,255,0.2);
            color: white;
        }

        .form-field input:focus {
            box-shadow: 0 0 10px #00c6ff;
        }

        /* ===== BUTTON ===== */
        .upload-btn {
            width: 100%;
            padding: 12px;
            border-radius: 30px;
            border: none;
            background: linear-gradient(45deg, #00c6ff, #0072ff);
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .upload-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 0 15px #00c6ff;
        }

        /* ===== ICON ANIMATION ===== */
        .pulse-icon {
            animation: pulse 1.5s infinite;
            color: #00c6ff;
        }

        .bounce-icon {
            animation: bounce 1.5s infinite;
            color: #00ffcc;
        }

        .form-field i {
            margin-right: 8px;
            transition: 0.3s;
        }

        .form-field:hover i {
            transform: rotate(10deg) scale(1.2);
            color: #00c6ff;
        }

        /* ===== KEYFRAMES ===== */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }

        @keyframes bounce {
            0%,100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

    </style>

</head>

<body>

<div class="upload-page">

    <div class="form-box">

        <h2 class="upload-title">
            <i class="fa-solid fa-shield-halved pulse-icon"></i>
            Secure File Upload
        </h2>

        <form action="<%= request.getContextPath() %>/UploadEncryptServlet"
              method="post"
              enctype="multipart/form-data">

            <!-- FILE -->
            <div class="form-field">
                <label>
                    <i class="fa-solid fa-file-arrow-up bounce-icon"></i>
                    Select File
                </label>
                <input type="file" name="secureFile" required>
            </div>

            <!-- EMAIL -->
            <div class="form-field">
                <label>
                    <i class="fa-solid fa-user-lock"></i>
                    Share With
                </label>
                <input type="email" name="shareWith"
                       placeholder="user@example.com" required>
            </div>

            <!-- BUTTON -->
            <div class="form-field">
                <button type="submit" class="upload-btn">
                    <i class="fa-solid fa-cloud-arrow-up"></i>
                    Encrypt & Upload
                </button>
            </div>

        </form>

    </div>

</div>

</body>
</html>