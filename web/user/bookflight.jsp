<%@ page import="java.sql.*, dbconnection.Dbconnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<html>
<head>
  <title>Book Flight</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    body { font-family: Arial; padding: 20px; background-color: #f2f2f2; }
    .form-box { background: #fff; padding: 20px; max-width: 700px; margin: auto; border-radius: 8px; box-shadow: 0 0 10px #ccc; }
    input, select { padding: 10px; margin-bottom: 15px; width: 100%; }
    button { background-color: #2ecc71; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px; }
    .error { color: red; font-weight: bold; }
    .message { color: green; font-weight: bold; }
    .passenger { background: #f9f9f9; padding: 10px; margin-bottom: 10px; border-radius: 5px; }
  </style>
  <script>
    function showPassengerFields() {
      let count = parseInt(document.getElementById("tickets").value);
      let container = document.getElementById("passengerContainer");
      container.innerHTML = "";
      if (count > 5) count = 5;
      for (let i = 1; i <= count; i++) {
        container.innerHTML += `
          <div class="passenger">
            <h4>Passenger ${i}</h4>
            <input type="text" name="name${i}" placeholder="Full Name" required>
            <select name="gender${i}" required>
              <option value="">Select Gender</option>
              <option>Male</option>
              <option>Female</option>
              <option>Other</option>
            </select>
            <input type="number" name="age${i}" placeholder="Age" required>
          </div>`;
      }
    }

    window.onload = function () {
      const t = document.getElementById("tickets");
      if (t && t.value) showPassengerFields();
    };

    function validatePassengerFields() {
      const count = parseInt(document.getElementById("tickets").value);
      for (let i = 1; i <= count; i++) {
        const name = document.querySelector(`[name='name${i}']`);
        const gender = document.querySelector(`[name='gender${i}']`);
        const age = document.querySelector(`[name='age${i}']`);
        if (!name || !gender || !age || !name.value || !gender.value || !age.value) {
          alert(`Please fill all fields for Passenger ${i}`);
          return false;
        }
      }
      return true;
    }
  </script>
</head>
<body>

<%
String flightId = request.getParameter("flight_id");
String depDate = request.getParameter("departure_date");
String flightClass = request.getParameter("flight_class");

if ("POST".equalsIgnoreCase(request.getMethod())) {
    int tickets = Integer.parseInt(request.getParameter("tickets"));
    Connection con = null;

    try {
        con = Dbconnection.getConnection();

        PreparedStatement ps = con.prepareStatement("SELECT * FROM flights WHERE id=?");
        ps.setInt(1, Integer.parseInt(flightId));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            int availableSeats = flightClass.equals("economy") ?
                rs.getInt("economy_capacity") : rs.getInt("business_capacity");

            if (tickets <= 0 || tickets > 5) {
%><p class="error">❌ You can book between 1 to 5 tickets.</p><%
            } else if (tickets > availableSeats) {
%><p class="error">❌ Only <%= availableSeats %> seats available in <%= flightClass %> class.</p><%
            } else {
                PreparedStatement insertMaster = con.prepareStatement(
                    "INSERT INTO booking_master (flight_id, departure_date, flight_class, ticket_count) VALUES (?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
                );
                insertMaster.setInt(1, Integer.parseInt(flightId));
                insertMaster.setDate(2, Date.valueOf(depDate));
                insertMaster.setString(3, flightClass);
                insertMaster.setInt(4, tickets);
                insertMaster.executeUpdate();

                ResultSet genKeys = insertMaster.getGeneratedKeys();
                int bookingId = 0;
                if (genKeys.next()) {
                    bookingId = genKeys.getInt(1);
                } else {
                    throw new SQLException("Failed to retrieve booking ID.");
                }

                PreparedStatement insertPassengers = con.prepareStatement(
                    "INSERT INTO booking_passengers (booking_id, passenger_name, gender, age) VALUES (?, ?, ?, ?)"
                );

                for (int i = 1; i <= tickets; i++) {
                    String name = request.getParameter("name" + i);
                    String gender = request.getParameter("gender" + i);
                    String ageStr = request.getParameter("age" + i);

                    if (name == null || gender == null || ageStr == null || name.trim().isEmpty()) {
%><p class="error">❌ Passenger <%= i %> info missing. Check all fields.</p><%
                        continue;
                    }

                    insertPassengers.setInt(1, bookingId);
                    insertPassengers.setString(2, name);
                    insertPassengers.setString(3, gender);
                    insertPassengers.setInt(4, Integer.parseInt(ageStr));
                    insertPassengers.addBatch();
                }
                insertPassengers.executeBatch();

                String updateSeats = flightClass.equals("economy") ?
                    "UPDATE flights SET economy_capacity = economy_capacity - ? WHERE id=?" :
                    "UPDATE flights SET business_capacity = business_capacity - ? WHERE id=?";
                PreparedStatement update = con.prepareStatement(updateSeats);
                update.setInt(1, tickets);
                update.setInt(2, Integer.parseInt(flightId));
                update.executeUpdate();

%>
<p class="message">✅ Booking Confirmed. Booking ID: <%= bookingId %>. <%= tickets %> Passenger(s) booked in <%= flightClass %> class.</p>
<a href="userdashboard.jsp">Go to Dashboard</a>
<%
            }
        } else {
%><p class="error">❌ Flight not found.</p><%
        }

        rs.close(); ps.close(); con.close();
    } catch (Exception e) {
%><p class="error">❌ Error: <%= e.getMessage() %></p><%
    }
} else {
%>

<div class="form-box">
  <h2>Book Your Flight</h2>
  <form method="post" onsubmit="return validatePassengerFields();">
    <input type="hidden" name="flight_id" value="<%= flightId %>">
    <input type="hidden" name="departure_date" value="<%= depDate %>">
    <input type="hidden" name="flight_class" value="<%= flightClass %>">

    <label>No. of Tickets (1–5):</label>
    <input type="number" id="tickets" name="tickets" min="1" max="5" required onchange="showPassengerFields()">

    <div id="passengerContainer"></div>

    <button type="submit">Confirm Booking</button>
  </form>
</div>

<% } %>

</body>
</html>
