<%-- 
    Document   : bookingreport.jsp
    Created on : 2 Jul, 2025, 11:40:24 AM
    Author     : DELL
--%>

<%@ page import="java.sql.*, dbconnection.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>

<html>
<head>
  <title>Booking Report</title>
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <style>
    body { font-family: Arial; background: #f4f4f4; padding: 20px; }
    table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
    th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
    th { background-color: #3498db; color: white; }
    h2 { text-align: center; color: #333; }
    .subtable { margin: 10px auto; border: 1px solid #ddd; }
  </style>
</head>
<body>
<h2>📋 All Bookings Report</h2>

<%
try {
    Connection con = Dbconnection.getConnection();
    String sql = "SELECT b.booking_id, b.flight_class, b.booked_at, b.ticket_count,  " +
                 "f.flight_name, f.source, f.destination, f.departure_date, f.departure_time " +
                 "FROM booking_master b JOIN flights f ON b.flight_id = f.id ORDER BY b.booked_at DESC";
    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        int bookingId = rs.getInt("booking_id");
%>

<table>
  <tr><th colspan="7">Booking ID: <%= bookingId %> | Date: <%= rs.getString("booked_at") %></th></tr>
  <tr>
    <th>Flight</th>
    <th>Route</th>
    <th>Departure</th>
    <th>Class</th>
    <th>Tickets</th>
    <th>Total</th>
    <th>Passengers</th>
  </tr>
  <tr>
    <td><%= rs.getString("flight_name") %></td>
    <td><%= rs.getString("source") %> → <%= rs.getString("destination") %></td>
    <td><%= rs.getString("departure_date") %> @ <%= rs.getString("departure_time") %></td>
    <td><%= rs.getString("flight_class") %></td>
    <td><%= rs.getInt("ticket_count") %></td>
    
    <td>
      <table class="subtable">
        <tr><th>Name</th><th>Age</th><th>Gender</th></tr>
<%
        PreparedStatement ps2 = con.prepareStatement("SELECT passenger_name, age, gender FROM booking_passengers WHERE booking_id=?");
        ps2.setInt(1, bookingId);   
        ResultSet prs = ps2.executeQuery();
        while (prs.next()) {
%>
        <tr>
          <td><%= prs.getString("passenger_name") %></td>
          <td><%= prs.getInt("age") %></td>
          <td><%= prs.getString("gender") %></td>
        </tr>
<%
        }
        prs.close(); ps2.close();
%>
      </table>
    </td>
  </tr>
</table>

<%
    }
    rs.close(); ps.close(); con.close();
} catch (Exception e) {
    out.println("<p style='color:red;'>❌ Error: " + e.getMessage() + "</p>");
}
%>

</body>
</html>
