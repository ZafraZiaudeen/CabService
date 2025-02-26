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
      <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminBooking.css'/>">
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
        
        <%
		    Booking tempBooking = (Booking) request.getAttribute("tempBookingData");
		    String selectedCustomerId = tempBooking != null ? String.valueOf(tempBooking.getCustomerId()) : "";
		    String pickupLocation = tempBooking != null ? tempBooking.getPickupLocation() : "";
		    String dropoffLocation = tempBooking != null ? tempBooking.getDropoffLocation() : "";
		    String vehicleId = tempBooking != null ? String.valueOf(tempBooking.getVehicleId()) : "";
		%>

        <form class="booking-form" action="<%= request.getContextPath() %>/booking?action=save" method="post">
    <div class="section-title">
        <span class="material-icons">person</span>
        Customer Information
    </div>
    <div class="form-group">
        <label for="customer_id">Select Customer</label>
        
        <%
	    Map<String, String> selectedCustomer = null;
	    if (tempBooking != null) {
	        try (Connection conn = DBConnectionFactory.getConnection()) {
	            BookingDAO bookingDAO = new BookingDAO(conn);
	            selectedCustomer = bookingDAO.getCustomerById(tempBooking.getCustomerId());
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	%>
	
	<select class="form-control" id="customer_id" name="customer_id" required>
	    <option value="">Select Customer</option>
	    <% if (selectedCustomer != null) { %>
	        <option value="<%= selectedCustomer.get("customerId") %>" selected>
	            <%= selectedCustomer.get("name") %> - <%= selectedCustomer.get("phoneNumber") %>
	        </option>
	    <% } %>
	    <% 
	        try (Connection conn = DBConnectionFactory.getConnection()) {
	            BookingDAO bookingDAO = new BookingDAO(conn);
	            List<Map<String, String>> customers = bookingDAO.getCustomers();
	            for (Map<String, String> customer : customers) {
	                String customerId = customer.get("customerId");
	                if (selectedCustomer == null || !customerId.equals(selectedCustomer.get("customerId"))) { 
	    %>
	        <option value="<%= customerId %>">
	            <%= customer.get("name") %> - <%= customer.get("phoneNumber") %>
	        </option>
	    <%      } } 
	        } catch (SQLException e) { e.printStackTrace(); } 
	    %>
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
            <% if (tempBooking != null && !pickupLocation.isEmpty()) { %>
                <option value="<%= pickupLocation %>" selected><%= pickupLocation %></option>
            <% } %>
            <%
                try (Connection conn = DBConnectionFactory.getConnection()) {
                    BookingDAO bookingDAO = new BookingDAO(conn);
                    List<String> locations = bookingDAO.getLocations();
                    for (String location : locations) {
                        if (tempBooking == null || !location.equals(pickupLocation)) {
            %>
                <option value="<%= location %>"><%= location %></option>
            <%      } } 
                } catch (SQLException e) { e.printStackTrace(); } 
            %>
        </select>
    </div>

    <div class="form-group">
        <label for="dropoffLocation">Drop-off Location</label>
        <select class="form-control" id="dropoffLocation" name="dropoff_location" required>
            <option value="">Select Drop-off Location</option>
            <% if (tempBooking != null && !dropoffLocation.isEmpty()) { %>
                <option value="<%= dropoffLocation %>" selected><%= dropoffLocation %></option>
            <% } %>
            <%
                try (Connection conn = DBConnectionFactory.getConnection()) {
                    BookingDAO bookingDAO = new BookingDAO(conn);
                    List<String> locations = bookingDAO.getLocations();
                    for (String location : locations) {
                        if (tempBooking == null || !location.equals(dropoffLocation)) {
            %>
                <option value="<%= location %>"><%= location %></option>
            <%      } } 
                } catch (SQLException e) { e.printStackTrace(); } 
            %>
        </select>
    </div>

    <div class="section-title">
        <span class="material-icons">directions_car</span>
        Vehicle Selection
    </div>
    <div class="form-group">
        <label for="vehicle_id">Select Vehicle</label>
        <%
		    Map<String, String> selectedVehicle = null;
		    if (tempBooking != null) {
		        try (Connection conn = DBConnectionFactory.getConnection()) {
		            BookingDAO bookingDAO = new BookingDAO(conn);
		            selectedVehicle = bookingDAO.getVehicleById(tempBooking.getVehicleId());
		        } catch (SQLException e) {
		            e.printStackTrace();
		        }
		    }
		%>
		
		<select class="form-control" id="vehicle_id" name="vehicle_id" required>
		    <option value="">Select Vehicle</option>
		    <% if (selectedVehicle != null) { %>
		        <option value="<%= selectedVehicle.get("vehicleId") %>" selected>
		            <%= selectedVehicle.get("model") %> - <%= selectedVehicle.get("plateNumber") %> 
		            (Rate: Rs.<%= selectedVehicle.get("ratePerKm") %>/km)
		        </option>
		    <% } %>
		    <%
		        try (Connection conn = DBConnectionFactory.getConnection()) {
		            BookingDAO bookingDAO = new BookingDAO(conn);
		            List<Map<String, String>> vehicles = bookingDAO.getAvailableVehicles();
		            for (Map<String, String> vehicle : vehicles) {
		                String currentVehicleId = vehicle.get("vehicleId");
		                if (selectedVehicle == null || !currentVehicleId.equals(selectedVehicle.get("vehicleId"))) {
		    %>
		        <option value="<%= currentVehicleId %>">
		            <%= vehicle.get("model") %> - <%= vehicle.get("plateNumber") %> 
		            (Rate: Rs.<%= vehicle.get("ratePerKm") %>/km)
		        </option>
		    <%      } } 
		        } catch (SQLException e) { e.printStackTrace(); } 
		    %>
		</select>
        
    </div>

    <div class="form-footer">
        <button type="submit" class="btn btn-primary">
            <span class="material-icons">check</span>
            Create Booking
        </button>
    </div>
</form>
        
    </main>
</body>
</html>

