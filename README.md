# CLD - LAB04 : Google App Engine

**Group U : A. David, T. Van Hove**

**Date : 04.05.2023**

**Teacher : Prof. Marcel Graf**

**Assistant : Rémi Poulard**

## Step 0 : Set up the development environment on your machine

No deliverables in this step.

## Step 1 : Deployement of a simple web application

HelloAppEngine.java:  Java Servlet, which is a Java class that extends the functionality of a server. The code receives HTTP requests from clients, processes them, and returns an HTTP response. The Servlet is responsible for handling the logic of our application by  listenning HTTP GET requests at the "/hello" endpoint and sends a request to the "/hello" endpoint. When the `doGet` method is called, the servlet retrieves system properties, sets the content type of the response to plain text, and writes a response message containing the App Engine version, Java specification version. The response message is then sent back to the client as plain text.

web.xml: Also known as the deployment descriptor, it's an XML configuration file for Java web applications. It contains information about the application's servlets, filters, listeners, context parameters, and other configurations. The web.xml file is used by the server to deploy and configure the application. The `<welcome-file-list>` specifies the default file to be served when a client requests a directory without specifying a file.

appengine-web.xml: This file configures App Engine-specific settings  like application ID, version, and runtime. It helps manage resources and indicates if the app is thread-safe (`<threadsafe>` element). The `<runtime>` element sets the environment (e.g., Java 8), and the `<property>` element defines the logging configuration file location, such as `WEB-INF/logging.properties`.

index.jsp: This file is a JavaServer Pages file that allows embedding Java code within HTML to create dynamic web pages. When a client requests the application's root URL without specifying a particular file, the server will look for a "welcome file" specified in web.xml, which is usually index.jsp.

## Step 2 : Develop a servlet that uses the datastore



Here is the code of our DatastoreWrite servlet:

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

This servlet listens for incoming HTTP GET requests at the "/datastorewrite" endpoint. When a GET request is received, the servlet does the following:

1. Retrieves the `_kind` and `_key` parameters from the request.
2. Validates that the `_kind` parameter is present.
3. Creates a new Entity instance with the specified kind and key.
4. Iterates over all the other request parameters and adds them as properties to the Entity.
5. Stores the Entity in Google Datastore.
6. Constructs a JSON object containing the kind, key, and properties of the stored Entity.
7. Sets the response content type to "application/json" and sends the JSON object back to the client.



Note that for the sake of our tests with jmeter, we had to change the response `HttpServletResponse.SC_BAD_REQUEST` by `HttpServletResponse.SC_OK`. 

### Going further

We wanted to make our web app a little more user friendly and more graphically appealing. So we decorated our main page (index.jsp), and added a form to send elements in the datastore directly in the web app. When an element is added in the datastore, we notify the user what is the last element that has been added using the fetch api. We probably wasted a lot of time doing this but it was fun.

![](figures/webApp.png)

Link to our app: https://20230502t213614-dot-grr-vanhove.ew.r.appspot.com/

Check our code on [github](https://github.com/DrC0okie/HEIG_CLD_Labo4).

## Step 3 : Test the performance of datastore writes

The following 2 test have been done with jmeter 5.5. For each test we sent 1500 requests to the app engine server, with a ramp-up period of 1 second. For the first test we sent the requests to the servlet without giving any parameters in the url, so no data has been written to the datastore. For the second test we sent the requests with the following parameters: `?_kind=test&_value=test`. We have waited the active instances to be at 0 before launching the second test for more consistency. The goal of those 2 tests is to observe weather the write to the datastore has an impact on the performance or not.

We have conducted multiple series of tests, e.g. with 200 requests polling the server during 5 minutes (to have more consistent data), but unfortunately, those tests made our machines crash systematically. We decided to include only one series of tests on one specific machine and network to be more consistent.

## Burst tests

### Not writing in the datastore - jmeter data

As we can see in the 2 charts below, after a certain amount of requests the server is not able to respond to them. We hit the threshold.

![](figures/ResponseTimeGraph_withoutData.png)

![](figures/GraphResult_WithoutData.png)

### Not writing in the datastore - Google dashboard data



![](figures/Burst_InstancesVS_Latency_withoutData.png)



![](figures/Burst_InstancesVS_ReceivedBytes_withoutData.png)



### Writing in the datastore - jmeter data

In the jmeter side, we cannot see significant differences between the requests with and without writing data in the datastore. The only difference we can see is that the latency before hitting the requests threshold is a lot smoother than the test done before.

![](figures/ResponseTimeGraph_withData.png)

![](figures/GraphResult_WithData.png)

### Writing in the datastore - Google dashboard data

![](figures/Burst_InstancesVS_Latency_withData.png)



![](figures/Burst_InstancesVS_ReceivedBytes_withData.png)


## Conclusion

## Constant load test

Those 2 tests have been done with a constant load of 50 threads for 1000 loops with different users for each iteration. It is important to note that for those tests it is useless to show the jmeter results graph because with 50'000 requests the graph is unreadable. Instead wi will append an aggregate report as a table.

### Not writing in the datastore - jmeter data

As we can see in the graph and the table below, using a constant load with less users gives us much more consistent results because we do not hit the threshold where the requests time-out. Thus the average latency is much lower with an average of 58 ms.

![](C:\Users\timot\Documents\HEIG\CLD\HEIG_CLD_Labo4\figures\ConstantLoadResponseTimeGraph_withoutData.png)

| Samples | Average | Median | Min   | Max     | Error | Throughput  | Duration    |
| ------- | ------- | ------ | ----- | ------- | ----- | ----------- | ----------- |
| 50'000  | 58 ms   | 40 ms  | 27 ms | 4178 ms | 0%    | 768.2 req/s | 1 min 4 sec |

### Not writing in the datastore - Google dashboard data



![](figures/InstancesVS_Latency_withoutData.png)

![](figures/InstancesVS_ReceivedBytes_withoutData.png)



### Writing in the datastore - jmeter data



![](figures/ConstantLoadResponseTimeGraph_withData.png)

| Samples | Average | Median | Min   | Max     | Error | Throughput  | Duration    |
| ------- | ------- | ------ | ----- | ------- | ----- | ----------- | ----------- |
| 50'000  | 114 ms  | 70 ms  | 47 ms | 5538 ms | 0%    | 411.2 req/s | 2 min 1 sec |



### Writing in the datastore - Google dashboard data

![](figures/InstancesVS_Latency_withData.png)

![](figures/InstancesVS_ReceivedBytes_withData.png)

# Conclusion
The main limiting factor of this analysis is the lack of granularity and control in the Google Metrics Explorer. This first problem is the sample rate. When we are trying to conduct a burst test to evaluate the service capability like we did, we do not have enough metrics data to properly evaluate the test. The second problem is the lack of control over the graphical interface on the Metrics explorer. In fact, we cannot export a graph as image and cannot change the graphs fontsize and line width. This result in unreadable graphs in our report. A solution to this would be to download the CSV data and to plot it in Excel, but we did not have the time to do it. In the other hand, Jmeter allows a lot more control in the reports and graphs.

The second limiting factor is that we can not properly trust the latency metrics because we have very different results on the google side and on the jmeter side. We do not understand why the latency is twice as high in the Google Metrics Explorer. We have done a lot of different tests, on different machines and different networks, but we can not get enough details and consistency to draw a proper performance conclusion. What we can say is that *most of the time*, writing into the datastore induces more latency and more instances are created.

