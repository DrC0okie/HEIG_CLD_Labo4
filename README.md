# CLD - LAB04 : Google App Engine

**Group U : A. David, T. Van Hove**

**Date : 04.05.2023**

**Teacher : Prof. Marcel Graf**

**Assistant : Rémi Poulard**

## Step 0 : Set up the development environment on your machine

No deliverables in this step.

## Step 1 : Deployement of a simple web application





## Step 2 : Develop a servlet that uses the datastore





````java
package ch.heigvd.cld.lab;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;

/**
 * Writes a key-value pair in the Google datastore based on the GET request parameters
 * Returns the written pair as a JSON object as a response
 *
 * @author Anthony David
 */
@WebServlet(name = "DatastoreWrite", value = "/datastorewrite")
public class DatastoreWrite extends HttpServlet {

    private static final DatastoreService DATASTORE = DatastoreServiceFactory.getDatastoreService();
    private static final Gson GSON = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        // Get the _kind and _key parameters from the request
        String kind = req.getParameter("_kind");
        String key = req.getParameter("_key");

        // Check if _kind parameter is present
        if (kind == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing _kind parameter.");
            return;
        }

        // Create an Entity instance for the given kind and key
        Entity entity = key == null ? new Entity(kind) : new Entity(kind, key);

        // Iterate over all the parameters in the request, and add them to the entity
        Enumeration<String> parameterNames = req.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();

            if (!paramName.equals("_kind") && !paramName.equals("_key")) {
                String paramValue = req.getParameter(paramName);
                entity.setProperty(paramName, paramValue);
            }
        }

        // Add the entity to the Datastore
        DATASTORE.put(entity);

        // Return the added entity data as a JSON object to be displayed in the page
        JsonObject response = new JsonObject();
        response.addProperty("kind", entity.getKind());
        response.addProperty("key", entity.getKey().getName());
        response.add("properties", GSON.toJsonTree(entity.getProperties()));

        resp.setContentType("application/json");
        resp.getWriter().println(GSON.toJson(response));
    }
}

````



````jsp
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

````



````js
// Get references to the form and the lastAddedEntity div
const addEntityForm = document.getElementById('addEntityForm');
const lastAddedEntity = document.getElementById('lastAddedEntity');

// Add an event listener to submit the form
addEntityForm.addEventListener('submit', (e) => {
    e.preventDefault(); // Prevent the form from submitting normally

    // Send the form data to the server using the fetch api
    fetch('/datastorewrite?' + new URLSearchParams(new FormData(addEntityForm)), {
        method: 'GET'
    })
        .then((response) => response.json()).then((data) => {
            // Update the lastAddedEntity div with the returned data and show it
            lastAddedEntity.innerHTML = "<h2>Last Added Entity:</h2>" +
                "<p>Kind: " + data.kind + "</p>" +
                "<p>Key: " + data.key + "</p>" +
                "<ul>" + Object.entries(data.properties).map(
                    ([property, value]) => "<li>" + property.replace(
                        "_value", "Value") + ": " + value + "</li>").join('') + "</ul>";

            lastAddedEntity.style.display = 'block';
        })
        .catch((error) => {
            console.error('Error:', error);
        });
});
````





Link of our app: https://20230502t210108-dot-grr-vanhove.ew.r.appspot.com/

## Step 3 : Test the performance of datastore writes





## Conlusion











