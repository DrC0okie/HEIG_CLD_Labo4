package ch.heigvd.cld.lab;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

@WebServlet(name = "DatastoreWrite", value = "/datastorewrite")
public class DatastoreWrite extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain");
        PrintWriter pw = resp.getWriter();

        String kind = req.getParameter("_kind");
        String key = req.getParameter("_key");

        if (kind == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            pw.println("Missing _kind parameter.");
            return;
        }

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

        Entity entity;

        if (key != null) {
            entity = new Entity(kind, key);
        } else {
            entity = new Entity(kind);
        }

        Enumeration<String> parameterNames = req.getParameterNames();

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();

            if (!paramName.equals("_kind") && !paramName.equals("_key")) {
                String paramValue = req.getParameter(paramName);
                entity.setProperty(paramName, paramValue);
            }
        }

        datastore.put(entity);
        // Return the added entity data as a JSON object
        resp.setContentType("application/json");
        Gson gson = new Gson();
        JsonObject responseObject = new JsonObject();
        responseObject.addProperty("kind", entity.getKind());
        responseObject.addProperty("key", entity.getKey().getName());
        JsonObject properties = new JsonObject();
        for (String property : entity.getProperties().keySet()) {
            properties.addProperty(property, String.valueOf(entity.getProperty(property)));
        }
        responseObject.add("properties", properties);
        PrintWriter out = resp.getWriter();
        out.print(gson.toJson(responseObject));
    }
}
