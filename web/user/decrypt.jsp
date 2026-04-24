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



<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String fileId = request.getParameter("fileId");

    if(fileId == null || fileId.isEmpty()){
%>
        <h3>Invalid File</h3>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Decrypt File</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body style="background:#f4f6f8;">

<div class="container mt-5">
    <div class="card shadow p-4">

        <h3 class="mb-3">Decrypt File</h3>

        <p><strong>File:</strong> <%= fileId %></p>

        <form action="downloadEncrypt.jsp" method="post">
            
            <!-- pass fileId -->
            <input type="hidden" name="fileId" value="<%= fileId %>">

            <div class="form-group">
                <label>Enter Session Key</label>
                <input type="text" name="sessionKey" class="form-control" required>
            </div>

            <button class="btn btn-success">Decrypt & Download</button>
        </form>

    </div>
</div>

</body>
</html>

