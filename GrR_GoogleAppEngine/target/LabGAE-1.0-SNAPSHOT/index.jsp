<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <link href='//fonts.googleapis.com/css?family=Marmelad' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" type="text/css" href="resources/css/styles.css">
    <link rel="shortcut icon" href="resources/img/cloud.ico" type="image/x-icon">
    <link rel="icon" href="resources/img/cloud.ico" type="image/x-icon">

    <title>HEIG-VD - Cloud computing</title>
</head>
<body>
    <header>
        <a href="https://heig-vd.ch" class="header-logo">
            <img src="https://heig-vd.ch/images/heig-vd-logo.gif" alt="Logo HEIG VD" width="112" height="112">
        </a>
        <div>
            Cloud computing - Labo 4
        </div>
    </header>
    <div>
        <h1>Welcome to our web application!</h1>
    </div>
    <h2>Add a new entity:</h2>
    <form id="addEntityForm" method="get">
        <label for="_kind">Kind:</label>
        <input type="text" id="_kind" name="_kind" required>
        <br>
        <label for="Key">Key:</label>
        <input type="text" id="Key" name="_key" required>
        <br>
        <label for="Value">Value:</label>
        <input type="text" id="Value" name="_value" required>
        <br>
        <input type="submit" value="Add Entity" >
        <br>
    </form>
    <div id="lastAddedEntity" class="last-added-entity"></div>

    <footer>
        <p class="left">Authors: Anthony David - Timothée Van Hove</p>
        <p class="right">
        <a href="https://github.com/DrC0okie/HEIG_CLD_Labo4.git">
            <img src="resources/img/github-mark-white.svg" alt="Logo Github" width="24" height="24">
            Check out our repo!
        </a>
    </footer>
</body>
<script src="${pageContext.request.contextPath}/resources/js/addEntity.js"></script>
</html>
