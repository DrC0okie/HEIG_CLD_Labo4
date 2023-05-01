<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <link href='//fonts.googleapis.com/css?family=Marmelad' rel='stylesheet'
          type='text/css'>
    <link rel="stylesheet" type="text/css" href="resources/css/styles.css">
    <title>HEIG-VD - Cloud computing</title>
</head>
<body>
    <header class="header">
        <a class="absolute left-0 top-0 z-40 no-desktop:w-[75px] transition-all is-search:opacity-0 is-search:invisible is-search:lg:opacity-100 is-search:lg:visible" href="https://heig-vd.ch">
            <img src="https://heig-vd.ch/images/heig-vd-logo.gif" alt="Logo HEIG VD" width="112" height="112">
        </a>
    </header>
    <div>
        <h1>Welcome to our web application!</h1>
    </div>
    <p>Available features:</p>
    <ul>
        <li><a href="${pageContext.request.contextPath}/datastorewrite">Datastore Write
            Servlet</a></li>
        <!-- Add more links to other servlets or pages here. -->
    </ul>
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
    <div id="lastAddedEntity" style="display: none; background-color: rgba(0, 0,
    0, 0.5); padding: 20px; border-radius: 10px; margin-top: 20px; width: 300px;"></div>

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
