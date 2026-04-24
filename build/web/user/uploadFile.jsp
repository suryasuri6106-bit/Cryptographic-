<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="session-check.jspf.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Secure File Upload</title>

    <!-- CSS ORDER -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style1.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style2.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

<div class="upload-page">

    <div class="form-wrapper">
        <div class="form-box upload-box">

            <h2 class="upload-title">
                <i class="fa-solid fa-shield-halved pulse-icon"></i>
                Secure File Upload
            </h2>

            <form action="<%= request.getContextPath() %>/UploadEncryptServlet"
                  method="post"
                  enctype="multipart/form-data"
                  class="upload-form">

                <!-- FILE INPUT -->
                <div class="form-field">
                    <label>
                        <i class="fa-solid fa-file-arrow-up bounce-icon"></i>
                        Select File
                    </label>
                    <input type="file" name="secureFile" required>
                </div>

                <!-- SHARE EMAIL -->
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

</div>

</body>
</html>
