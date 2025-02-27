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
    <link href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
</head>
<body>
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content">
        <!-- Display Success/Error Message -->
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

        <div class="booking-container">
            <div class="map-container">
                <div id="map"></div>
            </div>
            <div class="booking-section">
                <form class="booking-form" action="<%= request.getContextPath() %>/booking?action=save" method="post">
                    <input type="hidden" id="distance" name="distance_km" value="0">

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
                        <select class="form-control select2" id="customer_id" name="customer_id" required>
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
                        <label for="pickup_location">Pickup Location</label>
                        <input type="text" class="form-control" id="pickup_location" name="pickup_location" 
                               value="<%= pickupLocation %>" required placeholder="Type or click on map">
                    </div>

                    <div class="form-group">
                        <label for="dropoff_location">Drop-off Location</label>
                        <input type="text" class="form-control" id="dropoff_location" name="dropoff_location" 
                               value="<%= dropoffLocation %>" required placeholder="Type or click on map">
                    </div>

                    <div class="distance-display">
                        <span class="material-icons">straighten</span>
                        Distance: <span id="distance-value">0</span> km
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
                        <select class="form-control select2" id="vehicle_id" name="vehicle_id" required>
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
            </div>
        </div>
    </main>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var map = L.map('map').setView([7.8731, 80.7718], 7); // Center of Sri Lanka
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);

        var pickupMarker = null;
        var dropMarker = null;
        var routeLine = null;
        var distanceValueElement = document.getElementById('distance-value');
        var distanceField = document.getElementById('distance');

        function calculateDistance() {
            if (pickupMarker && dropMarker) {
                var pickup = pickupMarker.getLatLng();
                var drop = dropMarker.getLatLng();
                if (routeLine) map.removeLayer(routeLine);
                routeLine = L.polyline([pickup, drop], { color: '#0984e3', weight: 4 }).addTo(map);
                var bounds = L.latLngBounds([pickup, drop]);
                map.fitBounds(bounds, { padding: [50, 50] });
                var distance = pickup.distanceTo(drop) / 1000; // Distance in km
                distanceValueElement.textContent = distance.toFixed(1);
                distanceField.value = distance.toFixed(1);
                return distance;
            }
            return 0;
        }

        map.on('click', function(e) {
            var lat = e.latlng.lat;
            var lng = e.latlng.lng;
            fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&countrycodes=LK`)
                .then(response => response.json())
                .then(data => {
                    if (!pickupMarker) {
                        document.getElementById('pickup_location').value = data.display_name;
                        pickupMarker = L.marker([lat, lng], { draggable: true }).addTo(map);
                        pickupMarker.on('dragend', updatePickupFromMarker);
                    } else if (!dropMarker) {
                        document.getElementById('dropoff_location').value = data.display_name;
                        dropMarker = L.marker([lat, lng], {
                            draggable: true,
                            icon: L.icon({
                                iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
                                iconSize: [25, 41],
                                iconAnchor: [12, 41]
                            })
                        }).addTo(map);
                        dropMarker.on('dragend', updateDropFromMarker);
                    }
                    calculateDistance();
                });
        });

        function updatePickupFromMarker(e) {
            var position = e.target.getLatLng();
            fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.lat}&lon=${position.lng}&countrycodes=LK`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('pickup_location').value = data.display_name;
                    calculateDistance();
                });
        }

        function updateDropFromMarker(e) {
            var position = e.target.getLatLng();
            fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.lat}&lon=${position.lng}&countrycodes=LK`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('dropoff_location').value = data.display_name;
                    calculateDistance();
                });
        }

        function setupAddressSearch(input, isPickup) {
            input.addEventListener('input', function() {
                clearTimeout(input.dataset.timeout);
                input.dataset.timeout = setTimeout(function() {
                    var query = input.value;
                    if (query.length > 3) {
                        fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&countrycodes=LK`)
                            .then(response => response.json())
                            .then(data => {
                                if (data.length > 0) {
                                    var lat = parseFloat(data[0].lat);
                                    var lng = parseFloat(data[0].lon);
                                    if (isPickup) {
                                        if (pickupMarker) map.removeLayer(pickupMarker);
                                        pickupMarker = L.marker([lat, lng], { draggable: true }).addTo(map);
                                        pickupMarker.on('dragend', updatePickupFromMarker);
                                    } else {
                                        if (dropMarker) map.removeLayer(dropMarker);
                                        dropMarker = L.marker([lat, lng], {
                                            draggable: true,
                                            icon: L.icon({
                                                iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
                                                iconSize: [25, 41],
                                                iconAnchor: [12, 41]
                                            })
                                        }).addTo(map);
                                        dropMarker.on('dragend', updateDropFromMarker);
                                    }
                                    map.setView([lat, lng], 15);
                                    calculateDistance();
                                }
                            });
                    }
                }, 100);
            });
        }

        function initializeMapFromPrefilledData() {
            var pickupLocation = document.getElementById('pickup_location').value;
            var dropoffLocation = document.getElementById('dropoff_location').value;

            if (pickupLocation && dropoffLocation) {
                fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(pickupLocation)}&countrycodes=LK`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.length > 0) {
                            var lat = parseFloat(data[0].lat);
                            var lng = parseFloat(data[0].lon);
                            pickupMarker = L.marker([lat, lng], { draggable: true }).addTo(map);
                            pickupMarker.on('dragend', updatePickupFromMarker);

                            fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(dropoffLocation)}&countrycodes=LK`)
                                .then(response => response.json())
                                .then(data => {
                                    if (data.length > 0) {
                                        var lat = parseFloat(data[0].lat);
                                        var lng = parseFloat(data[0].lon);
                                        dropMarker = L.marker([lat, lng], {
                                            draggable: true,
                                            icon: L.icon({
                                                iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
                                                iconSize: [25, 41],
                                                iconAnchor: [12, 41]
                                            })
                                        }).addTo(map);
                                        dropMarker.on('dragend', updateDropFromMarker);
                                        calculateDistance();
                                    }
                                });
                        }
                    });
            } else if (pickupLocation) {
                fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(pickupLocation)}&countrycodes=LK`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.length > 0) {
                            var lat = parseFloat(data[0].lat);
                            var lng = parseFloat(data[0].lon);
                            pickupMarker = L.marker([lat, lng], { draggable: true }).addTo(map);
                            pickupMarker.on('dragend', updatePickupFromMarker);
                            map.setView([lat, lng], 15);
                        }
                    });
            }
        }

        setupAddressSearch(document.getElementById('pickup_location'), true);
        setupAddressSearch(document.getElementById('dropoff_location'), false);

        $('#booking-form').on('submit', function(e) {
            var pickup = $('#pickup_location').val();
            var dropoff = $('#dropoff_location').val();
            var vehicleId = $('#vehicle_id').val();
            var customerId = $('#customer_id').val();
            var distance = parseFloat($('#distance').val());

            if (!pickup || !dropoff || !vehicleId || !customerId) {
                e.preventDefault();
                alert("Please fill in all required fields.");
                return false;
            }
            if (pickup === dropoff) {
                e.preventDefault();
                alert("Pickup and drop-off locations cannot be the same.");
                return false;
            }
            if (distance <= 0) {
                e.preventDefault();
                alert("Please select valid locations to calculate the distance.");
                return false;
            }
        });

        $('.select2').select2({
            placeholder: "Select an option",
            allowClear: true,
            width: '100%'
        });

        setTimeout(function() { map.invalidateSize(); }, 500);
        initializeMapFromPrefilledData();
    });
    </script>
</body>
</html>