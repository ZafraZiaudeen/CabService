<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="com.cabservice.model.*" %>
<%@ page import="com.cabservice.service.*" %>
<%@ page import="com.cabservice.dao.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Booking - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body { background: #f5f6fa; }

        .main-content {
            margin-left: 260px;
            padding: 20px;
        }

        .booking-form {
            max-width: 600px;
            margin: 20px auto;
            background: #fff;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #2d3436;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #dfe6e9;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-control:focus {
            outline: none;
            border-color: #0984e3;
            box-shadow: 0 0 0 3px rgba(9, 132, 227, 0.1);
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
            color: #2d3436;
            font-size: 18px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
        }

        .btn-primary {
            background: #0984e3;
            color: white;
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #64748b;
        }

        .form-footer {
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid #dfe6e9;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .success { background: #00b894; color: white; }
        .error { background: #d63031; color: white; }

        @media (max-width: 768px) {
            .main-content { margin-left: 0; }
            .form-footer { flex-direction: column; }
            .btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content">
    <!-- Display Success Message -->
        
        <%
            String successMessage = (String) request.getAttribute("success");
            String errorMessage = (String) request.getAttribute("error");
            if (successMessage != null) {
        %>
            <div class="message success">
                <span class="material-icons">check_circle</span>
                <%= successMessage %>
            </div>
        <% } else if (errorMessage != null) { %>
            <div class="message error">
                <span class="material-icons">error</span>
                <%= errorMessage %>
            </div>
        <% } %>

        <form class="booking-form" action="<%= request.getContextPath() %>/booking?action=save" method="post">
            <div class="section-title">
                <span class="material-icons">person</span>
                Customer Information
            </div>
            <div class="form-group">
                <label for="customer_id">Select Customer</label>
                <select class="form-control" id="customer_id" name="customer_id" required>
                    <option value="">Select Customer</option>
                    <%
                        try (Connection conn = DBConnectionFactory.getConnection()) {
                            BookingDAO bookingDAO = new BookingDAO(conn);
                            List<Map<String, String>> customers = bookingDAO.getCustomers();
                            for (Map<String, String> customer : customers) {
                    %>
                        <option value="<%= customer.get("customerId") %>">
                            <%= customer.get("name") %> - <%= customer.get("phoneNumber") %>
                        </option>
                    <% } } catch (SQLException e) { e.printStackTrace(); } %>
                </select>
            </div>

            <div class="section-title">
                <span class="material-icons">location_on</span>
                Trip Details
            </div>
            <div class="form-group">
                <label for="pickupLocation">Pickup Location</label>
                <select class="form-control" id="pickupLocation" name="pickup_location" required>
                    <option value="">Select Pickup Location</option>
                    <%
                        try (Connection conn = DBConnectionFactory.getConnection()) {
                            BookingDAO bookingDAO = new BookingDAO(conn);
                            List<String> locations = bookingDAO.getLocations();
                            for (String location : locations) {
                    %>
                        <option value="<%= location %>"><%= location %></option>
                    <% } } catch (SQLException e) { e.printStackTrace(); } %>
                </select>
            </div>

            <div class="form-group">
                <label for="dropoffLocation">Drop-off Location</label>
                <select class="form-control" id="dropoffLocation" name="dropoff_location" required>
                    <option value="">Select Drop-off Location</option>
                    <%
                        try (Connection conn = DBConnectionFactory.getConnection()) {
                            BookingDAO bookingDAO = new BookingDAO(conn);
                            List<String> locations = bookingDAO.getLocations();
                            for (String location : locations) {
                    %>
                        <option value="<%= location %>"><%= location %></option>
                    <% } } catch (SQLException e) { e.printStackTrace(); } %>
                </select>
            </div>

            <div class="section-title">
                <span class="material-icons">directions_car</span>
                Vehicle Selection
            </div>
            <div class="form-group">
                <label for="vehicle_id">Select Vehicle</label>
                <select class="form-control" id="vehicle_id" name="vehicle_id" required>
                    <option value="">Select Vehicle</option>
                    <%
                        try (Connection conn = DBConnectionFactory.getConnection()) {
                            BookingDAO bookingDAO = new BookingDAO(conn);
                            List<Map<String, String>> vehicles = bookingDAO.getAvailableVehicles();
                            for (Map<String, String> vehicle : vehicles) {
                    %>
                        <option value="<%= vehicle.get("vehicleId") %>">
                            <%= vehicle.get("model") %> - <%= vehicle.get("plateNumber") %>
                            (Rate: Rs.<%= vehicle.get("ratePerKm") %>/km)
                        </option>
                    <% } } catch (SQLException e) { e.printStackTrace(); } %>
                </select>
            </div>

            <div class="form-footer">
                <button type="button" class="btn btn-secondary" onclick="window.location.href='active-bookings.jsp'">
                    <span class="material-icons">close</span>
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    <span class="material-icons">check</span>
                    Create Booking
                </button>
            </div>
        </form>
    </main>
</body>
</html>

