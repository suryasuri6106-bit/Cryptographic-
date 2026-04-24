<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="session-check.jspf.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Upload Successful</title>

    <!-- SAME CSS USED EVERYWHERE -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style1.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style2.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>

<body>

<div class="form-wrapper">
    <div class="form-box upload-box">

        <h2 class="upload-title">
            <i class="fa-solid fa-circle-check success-icon"></i>
            Upload Successful
        </h2>

        <p style="text-align:center; color:#444; margin-bottom:25px;">
            Your file has been <b>encrypted</b> and shared securely.
        </p>

        <div class="form-field">
            <a href="uploadFile.jsp" class="upload-btn">
                <i class="fa-solid fa-upload"></i>
                Upload Another File
            </a>
        </div>

        <div class="form-field" style="margin-top:15px;">
            <a href="sharedFiles.jsp" class="upload-btn"
               style="background:linear-gradient(135deg,#2c5364,#203a43);">
                <i class="fa-solid fa-folder-open"></i>
                View Shared Files
            </a>
        </div>

    </div>
</div>

</body>
</html>
