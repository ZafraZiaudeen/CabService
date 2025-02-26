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
    <title>Book a Ride - CabService</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css" rel="stylesheet" />
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customerBooking.css'/>">
    <style>
        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: 'Poppins', sans-serif;
        }
    </style>
</head>
<body>
   <jsp:include page="/Header.jsp" />
    <main>
        <div class="booking-container">
            <div class="booking-header">
                <h1>Book Your Ride</h1>
                <p>Fill in the details below to book your cab</p>
            </div>
            
            <%-- Display error message if present --%>
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message">
                    <span class="material-icons">error</span>
                    <%= error %>
                </div>
            <% } %>
            
            <section class="booking-section">
                <div class="booking-steps">
                    <div class="step">
                        <div class="step-number">1</div>
                        <div class="step-label">Location</div>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-label">Vehicle</div>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-label">Confirmation</div>
                    </div>
                </div>
                
                <%
                    Integer customerId = null;
                    if (session != null && session.getAttribute("customerId") != null) {
                        customerId = (Integer) session.getAttribute("customerId");
                    }
                    
                    Booking tempBooking = (Booking) request.getAttribute("tempBookingData");
                    String selectedPickupLocation = tempBooking != null ? tempBooking.getPickupLocation() : "";
                    String selectedDropoffLocation = tempBooking != null ? tempBooking.getDropoffLocation() : "";
                    String selectedVehicleId = tempBooking != null ? String.valueOf(tempBooking.getVehicleId()) : "";
                    
                    Map<String, String> selectedVehicle = null;
                    if (tempBooking != null && tempBooking.getVehicleId() > 0) {
                        try (Connection conn = DBConnectionFactory.getConnection()) {
                            BookingDAO bookingDAO = new BookingDAO(conn);
                            selectedVehicle = bookingDAO.getVehicleById(tempBooking.getVehicleId());
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
                
                <form id="booking-form" action="<%= request.getContextPath() %>/customerBooking?action=save" method="post">
                    <input type="hidden" name="customer_id" value="<%= customerId %>">
                    
                    <div class="form-group">
                        <label for="pickup_location">Pickup Location</label>
                        <select id="pickup_location" name="pickup_location" class="form-control select2" required>
                            <option value="">Select Pickup Location</option>
                            <%
                                try (Connection conn = DBConnectionFactory.getConnection()) {
                                    BookingDAO bookingDAO = new BookingDAO(conn);
                                    List<String> locations = bookingDAO.getLocations();
                                    for (String location : locations) {
                                        boolean isSelected = location.equals(selectedPickupLocation);
                            %>
                                        <option value="<%= location %>" <%= isSelected ? "selected" : "" %>><%= location %></option>
                            <% 
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dropoff_location">Drop-off Location</label>
                        <select id="dropoff_location" name="dropoff_location" class="form-control select2" required>
                            <option value="">Select Drop-off Location</option>
                            <%
                                try (Connection conn = DBConnectionFactory.getConnection()) {
                                    BookingDAO bookingDAO = new BookingDAO(conn);
                                    List<String> locations = bookingDAO.getLocations();
                                    for (String location : locations) {
                                        boolean isSelected = location.equals(selectedDropoffLocation);
                            %>
                                        <option value="<%= location %>" <%= isSelected ? "selected" : "" %>><%= location %></option>
                            <% 
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="vehicle_id">Select Vehicle</label>
                        <select class="form-control select2" id="vehicle_id" name="vehicle_id" required>
                            <option value="">Choose your preferred vehicle</option>
                            <%
                                try (Connection conn = DBConnectionFactory.getConnection()) {
                                    BookingDAO bookingDAO = new BookingDAO(conn);
                                    List<Map<String, String>> vehicles = bookingDAO.getAvailableVehicles();
                                    
                                    boolean selectedVehicleInList = false;
                                    if (!selectedVehicleId.isEmpty()) {
                                        for (Map<String, String> vehicle : vehicles) {
                                            if (vehicle.get("vehicleId").equals(selectedVehicleId)) {
                                                selectedVehicleInList = true;
                                                break;
                                            }
                                        }
                                        if (!selectedVehicleInList && selectedVehicle != null) {
                            %>
                                            <option value="<%= selectedVehicleId %>" selected>
                                                <%= selectedVehicle.get("model") %> - <%= selectedVehicle.get("plateNumber") %> 
                                                (Rate: Rs.<%= selectedVehicle.get("ratePerKm") %>/km)
                                            </option>
                            <%
                                        }
                                    }
                                    
                                    for (Map<String, String> vehicle : vehicles) {
                                        String vehicleId = vehicle.get("vehicleId");
                                        boolean isSelected = vehicleId.equals(selectedVehicleId);
                            %>
                                        <option value="<%= vehicleId %>" <%= isSelected ? "selected" : "" %>>
                                            <%= vehicle.get("model") %> - <%= vehicle.get("plateNumber") %> 
                                            (Rate: Rs.<%= vehicle.get("ratePerKm") %>/km)
                                        </option>
                            <%
                                    }
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-footer">
                        <div class="booking-info">
                            <span class="material-icons">info</span>
                            Your booking will be confirmed instantly
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <span class="material-icons">directions_car</span>
                            Book Now
                        </button>
                    </div>
                </form>
                
                <div class="booking-features">
                    <div class="booking-feature">
                        <span class="material-icons">verified</span>
                        <h4>Verified Drivers</h4>
                        <p>All our drivers are thoroughly vetted and trained</p>
                    </div>
                    <div class="booking-feature">
                        <span class="material-icons">payments</span>
                        <h4>No Hidden Fees</h4>
                        <p>Transparent pricing with no surprise charges</p>
                    </div>
                    <div class="booking-feature">
                        <span class="material-icons">schedule</span>
                        <h4>24/7 Service</h4>
                        <p>Book anytime, day or night, we're always available</p>
                    </div>
                    <div class="booking-feature">
                        <span class="material-icons">security</span>
                        <h4>Safe & Secure</h4>
                        <p>Your safety is our top priority</p>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <jsp:include page="/Footer.jsp" />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.min.js"></script>

    <script>
    $(document).ready(function() {
        $('.select2').select2({
            placeholder: "Select an option",
            allowClear: true,
            width: '100%'
        });
        
        $('#dropoff_location').on('change', function() {
            var pickup = $('#pickup_location').val();
            var dropoff = $(this).val();
            
            if (pickup === dropoff) {
                alert("Pickup and drop-off locations cannot be the same.");
                $(this).val('').trigger('change');
            }
        });
        
        $('#pickup_location').on('change', function() {
            var pickup = $(this).val();
            var dropoff = $('#dropoff_location').val();
            
            if (pickup === dropoff && dropoff !== '') {
                alert("Pickup and drop-off locations cannot be the same.");
                $('#dropoff_location').val('').trigger('change');
            }
        });
        
        $('#booking-form').on('submit', function(e) {
            var pickup = $('#pickup_location').val();
            var dropoff = $('#dropoff_location').val();
            var vehicleId = $('#vehicle_id').val();
            
            if (!pickup || !dropoff || !vehicleId) {
                e.preventDefault();
                alert("Please fill in all required fields.");
                return false;
            }
            
            if (pickup === dropoff) {
                e.preventDefault();
                alert("Pickup and drop-off locations cannot be the same.");
                return false;
            }
            
            return true;
        });
    });
    </script>
</body>
</html>