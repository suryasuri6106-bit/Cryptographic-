<%@ page import="java.sql.*, java.time.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="header.jsp" %>
<%@ page import="dbconnection.Dbconnection" %>

<html>
<head>
  <title>Search Flights</title>
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <style>
    body { font-family: Arial; background: #f5f5f5; padding: 20px; }
    h2 { color: #333; }
    form { margin-bottom: 20px; background: #fff; padding: 15px; border-radius: 5px; box-shadow: 0 0 5px #ccc; width: 420px; }
    label { display: inline-block; width: 120px; }
    input, select { padding: 5px; margin: 5px 0; width: 250px; }
    table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
    th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
    th { background: #eee; }
    .error { color: red; font-weight: bold; }
    .btn-book {
      background-color: #27ae60;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 3px;
      cursor: pointer;
    }
  </style>
</head>
<body>

<h2>✈ Search Available Flights</h2>

<form method="get">
  <label>Source:</label>
  <input type="text" name="source" required><br>

  <label>Destination:</label>
  <input type="text" name="destination" required><br>

  <label>Departure Date:</label>
  <input type="date" name="departure_date" min="<%= java.time.LocalDate.now() %>" required><br>

  <label>Class:</label>
  <select name="flight_class" required>
    <option value="economy">Economy</option>
    <option value="business">Business</option>
  </select><br>

  <input type="submit" value="Search Flights">
</form>

<%
  String source = request.getParameter("source");
  String dest = request.getParameter("destination");
  String depDate = request.getParameter("departure_date");
  String flightClass = request.getParameter("flight_class");

  if (source != null && dest != null && depDate != null && flightClass != null) {
    try {
      LocalDate selectedDate = LocalDate.parse(depDate);
      LocalDate today = LocalDate.now();

      if (selectedDate.isBefore(today)) {
%>
        <p class="error">⚠ Departure date cannot be in the past.</p>
<%
      } else {
        Connection con = Dbconnection.getConnection();
        String sql = "SELECT * FROM flights WHERE source=? AND destination=? AND departure_date=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, source);
        ps.setString(2, dest);
        ps.setString(3, depDate);
        ResultSet rs = ps.executeQuery();

        boolean found = false;
%>
        <table>
          <tr>
            <th>Flight</th>
            <th>Source</th>
            <th>Destination</th>
            <th>Departure Date</th>
            <th>Departure Time</th>
            <th>Class</th>
            <th>Price</th>
            <th>Action</th>
          </tr>
<%
        while (rs.next()) {
          found = true;
          int flightId = rs.getInt("id");
          String price = flightClass.equals("economy")
                        ? "₹" + rs.getDouble("economy_price")
                        : "₹" + rs.getDouble("business_price");
%>
          <tr>
            <td><%= rs.getString("flight_name") %></td>
            <td><%= rs.getString("source") %></td>
            <td><%= rs.getString("destination") %></td>
            <td><%= rs.getString("departure_date") %></td>
            <td><%= rs.getString("departure_time") %></td>
            <td><%= flightClass.substring(0,1).toUpperCase() + flightClass.substring(1) %></td>
            <td><%= price %></td>
            <td>
              <form method="get" action="bookflight.jsp">
                <input type="hidden" name="flight_id" value="<%= flightId %>">
                <input type="hidden" name="departure_date" value="<%= depDate %>">
                <input type="hidden" name="flight_class" value="<%= flightClass %>">
                <button type="submit" class="btn-book">Book</button>
              </form>
            </td>
          </tr>
<%
        }
        if (!found) {
%>
          <tr><td colspan="8" style="color:red;">No flights found for the selected route and class.</td></tr>
<%
        }
        rs.close(); ps.close(); con.close();
%>
        </table>
<%
      }
    } catch (Exception e) {
%>
      <p class="error">❌ Error: <%= e.getMessage() %></p>
<%
    }
  }
%>

</body>
</html>
