<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ch.heigvd.cld.lab.DatastoreWrite" %>
<html>
<head>
    <link href='//fonts.googleapis.com/css?family=Marmelad' rel='stylesheet' type='text/css'>
    <title>Datastore write example</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('CLD.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }

        h1 {
            font-size: 36px;
            margin-bottom: 10px;
        }

        a {
            color: white;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        form {
            background-color: rgba(0, 0, 0, 0.6);
            padding: 20px;
            border-radius: 10px;
            width: 300px;
        }

        label {
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"] {
            width: 100%;
            padding: 5px;
            margin-bottom: 10px;
        }

        input[type="submit"] {
            padding: 10px 20px;
            background-color: white;
            color: black;
            border: none;
            cursor: pointer;
            font-weight: bold;
            border-radius: 5px;
        }

        input[type="submit"]:hover {
            background-color: lightgray;
        }
    </style>
</head>
<body>
<h1>Welcome to my web application!</h1>
<p>Available features:</p>
<ul>
    <li><a href="/datastorewrite">Datastore Write Servlet</a></li>
    <!-- Add more links to other servlets or pages here. -->
</ul>

<h2>Add a new entity:</h2>
<form action="/datastorewrite" method="get">
    <label for="_kind">Kind:</label>
    <input type="text" id="_kind" name="_kind" required>
    <br>
    <label for="Key">Key:</label>
    <input type="text" id="Key" name="_key" required>
    <br>
    <label for="Value">Value:</label>
    <input type="text" id="Value" name="_value" required>
    <br>
    <input type="submit" value="Add Entity">
</form>
</body>
</html>
