<%@ page import="java.sql.*" %>
<%@ page import="dbconnection.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>
<html>
<head>
  <title>Manage Flights</title>
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <style>
    body { font-family: Arial; padding: 20px; background: #f2f2f2; }
    table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
    th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
    th { background: #eee; }
    input { padding: 5px; width: 100%; }
    .form-row { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 20px; background: #fff; padding: 15px; border-radius: 5px; }
    .form-row input { flex: 1; min-width: 200px; }
    .btn { padding: 5px 10px; margin-top: 10px; cursor: pointer; }
    .btn-delete { color: white; background: red; border: none; text-decoration: none; padding: 5px 10px; }
    .btn-edit { color: white; background: #3498db; border: none; }
  </style>
</head>
<body>

<h2>&#9992; Manage Flights</h2>

<%
String action = request.getParameter("action");
String id = request.getParameter("id");
Connection con = null;

try {
    con = Dbconnection.getConnection();

    // DELETE
    if ("delete".equals(action) && id != null) {
        PreparedStatement ps = con.prepareStatement("DELETE FROM flights WHERE id=?");
        ps.setInt(1, Integer.parseInt(id));
        ps.executeUpdate();
        response.sendRedirect("adminflights.jsp");
        return;
    }

    // ADD
    if ("add".equals(action)) {
        String name = request.getParameter("flight_name");
        String source = request.getParameter("source");
        String dest = request.getParameter("destination");
        String depDate = request.getParameter("departure_date");
        String depTime = request.getParameter("departure_time");
        String economyCapacity = request.getParameter("economy_capacity");
        String businessCapacity = request.getParameter("business_capacity");
        String economyPrice = request.getParameter("economy_price");
        String businessPrice = request.getParameter("business_price");

        PreparedStatement ps = con.prepareStatement(
          "INSERT INTO flights (flight_name, source, destination, departure_date, departure_time, economy_capacity, business_capacity, economy_price, business_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        ps.setString(1, name);
        ps.setString(2, source);
        ps.setString(3, dest);
        ps.setString(4, depDate);
        ps.setString(5, depTime);
        ps.setInt(6, Integer.parseInt(economyCapacity));
        ps.setInt(7, Integer.parseInt(businessCapacity));
        ps.setDouble(8, Double.parseDouble(economyPrice));
        ps.setDouble(9, Double.parseDouble(businessPrice));
        ps.executeUpdate();
        response.sendRedirect("adminflights.jsp");
        return;
    }

    // UPDATE
    if ("update".equals(action) && id != null) {
        String name = request.getParameter("flight_name");
        String source = request.getParameter("source");
        String dest = request.getParameter("destination");
        String depDate = request.getParameter("departure_date");
        String depTime = request.getParameter("departure_time");
        String economyCapacity = request.getParameter("economy_capacity");
        String businessCapacity = request.getParameter("business_capacity");
        String economyPrice = request.getParameter("economy_price");
        String businessPrice = request.getParameter("business_price");

        PreparedStatement ps = con.prepareStatement(
          "UPDATE flights SET flight_name=?, source=?, destination=?, departure_date=?, departure_time=?, economy_capacity=?, business_capacity=?, economy_price=?, business_price=? WHERE id=?");
        ps.setString(1, name);
        ps.setString(2, source);
        ps.setString(3, dest);
        ps.setString(4, depDate);
        ps.setString(5, depTime);
        ps.setInt(6, Integer.parseInt(economyCapacity));
        ps.setInt(7, Integer.parseInt(businessCapacity));
        ps.setDouble(8, Double.parseDouble(economyPrice));
        ps.setDouble(9, Double.parseDouble(businessPrice));
        ps.setInt(10, Integer.parseInt(id));
        ps.executeUpdate();
        response.sendRedirect("adminflights.jsp");
        return;
    }

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM flights");
%>

<table>
<tr>
  <th>ID</th>
  <th>Flight</th>
  <th>Source</th>
  <th>Destination</th>
  <th>Departure Date</th>
  <th>Departure Time</th>
  <th>Economy Seats</th>
  <th>Business Seats</th>
  <th>Economy Price</th>
  <th>Business Price</th>
  <th>Actions</th>
</tr>

<%
    while(rs.next()) {
      String depDate = rs.getString("departure_date");
      String depTime = rs.getString("departure_time");

      if (depDate == null || depDate.equals("0000-00-00")) depDate = "2025-01-01";
      if (depTime == null || depTime.equals("00:00:00")) depTime = "00:00";
%>
<tr>
  <form method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
    <td><%= rs.getInt("id") %></td>
    <td><input type="text" name="flight_name" value="<%= rs.getString("flight_name") %>" required></td>
    <td><input type="text" name="source" value="<%= rs.getString("source") %>" required></td>
    <td><input type="text" name="destination" value="<%= rs.getString("destination") %>" required></td>
    <td><input type="date" name="departure_date" value="<%= depDate %>" required></td>
    <td><input type="time" name="departure_time" value="<%= depTime %>" required></td>
    <td><input type="number" name="economy_capacity" value="<%= rs.getInt("economy_capacity") %>" required></td>
    <td><input type="number" name="business_capacity" value="<%= rs.getInt("business_capacity") %>" required></td>
    <td><input type="number" step="0.01" name="economy_price" value="<%= rs.getDouble("economy_price") %>" required></td>
    <td><input type="number" step="0.01" name="business_price" value="<%= rs.getDouble("business_price") %>" required></td>
    <td>
      <button type="submit" class="btn btn-edit">Update</button>
      <a href="adminflights.jsp?action=delete&id=<%= rs.getInt("id") %>" class="btn btn-delete" onclick="return confirm('Delete this flight?');">Delete</a>
    </td>
  </form>
</tr>
<%
    }
    rs.close(); con.close();
} catch (Exception e) {
    out.println("<p style='color:red;'>❌ Error: " + e.getMessage() + "</p>");
}
%>
</table>

<!-- Add New Flight -->
<h3>Add New Flight</h3>
<form method="post" class="form-row">
  <input type="hidden" name="action" value="add">
  <input name="flight_name" placeholder="Flight Name" required>
  <input name="source" placeholder="Source" required>
  <input name="destination" placeholder="Destination" required>
  <input name="departure_date" type="date" required>
  <input name="departure_time" type="time" required>
  <input name="economy_capacity" type="number" placeholder="Economy Seats" required>
  <input name="business_capacity" type="number" placeholder="Business Seats" required>
  <input name="economy_price" type="number" step="0.01" placeholder="Economy Price" required>
  <input name="business_price" type="number" step="0.01" placeholder="Business Price" required>
  <button type="submit" class="btn btn-edit">Add</button>
</form>

</body>
</html>
