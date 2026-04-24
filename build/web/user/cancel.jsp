<%@ page import="java.sql.*, dbconnection.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<html>
<head>
  <title>Cancel Booking</title>
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <style>
    body { font-family: Arial; padding: 20px; background: #f4f4f4; }
    .box { background: white; padding: 20px; max-width: 600px; margin: auto; border-radius: 8px; box-shadow: 0 0 10px #ccc; }
    label, input { display: block; margin: 10px 0; width: 100%; padding: 8px; }
    button { background-color: #e74c3c; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
    .success { background: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-top: 10px; }
    .error { background: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-top: 10px; }
  </style>
</head>
<body>

<div class="box">
  <h2>✈ Cancel Booking</h2>

  <form method="post">
    <label for="flight_id">Flight ID:</label>
    <input type="number" name="flight_id" id="flight_id" required>

    <label for="booking_id">Booking ID:</label>
    <input type="number" name="booking_id" id="booking_id" required>

    <button type="submit">Cancel Booking</button>
  </form>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String flightIdParam = request.getParameter("flight_id");
    String bookingIdParam = request.getParameter("booking_id");

    try {
        int flightId = Integer.parseInt(flightIdParam);
        int bookingId = Integer.parseInt(bookingIdParam);

        Connection con = Dbconnection.getConnection();

        // Check if booking exists and matches the flight ID
        PreparedStatement ps = con.prepareStatement("SELECT * FROM booking_master WHERE booking_id=? AND flight_id=?");
        ps.setInt(1, bookingId);
        ps.setInt(2, flightId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            int ticketCount = rs.getInt("ticket_count");
            String flightClass = rs.getString("flight_class");

            // Delete passengers
            PreparedStatement delPass = con.prepareStatement("DELETE FROM booking_passengers WHERE booking_id=?");
            delPass.setInt(1, bookingId);
            delPass.executeUpdate();

            // Delete booking
            PreparedStatement delBook = con.prepareStatement("DELETE FROM booking_master WHERE booking_id=?");
            delBook.setInt(1, bookingId);
            delBook.executeUpdate();

            // Restore seat capacity
            String updateSQL = flightClass.equalsIgnoreCase("economy")
                ? "UPDATE flights SET economy_capacity = economy_capacity + ? WHERE id=?"
                : "UPDATE flights SET business_capacity = business_capacity + ? WHERE id=?";
            PreparedStatement updSeats = con.prepareStatement(updateSQL);
            updSeats.setInt(1, ticketCount);
            updSeats.setInt(2, flightId);
            updSeats.executeUpdate();

            con.close();
%>
  <div class="success">✅ Booking ID <%= bookingId %> on Flight ID <%= flightId %> cancelled successfully.</div>
<%
        } else {
%>
  <div class="error">❌ Booking ID <%= bookingId %> not found for Flight ID <%= flightId %>.</div>
<%
        }
    } catch (Exception e) {
%>
  <div class="error">❌ Error: <%= e.getMessage() %></div>
<%
    }
}
%>

</div>
</body>
</html>
