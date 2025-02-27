<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="com.cabservice.model.*" %>
<%@ page import="com.cabservice.service.*" %>
<%@ page import="com.cabservice.dao.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Ride - CabService</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/customerBooking.css'/>">
    <style>
       
    </style>
</head>
<body>
    <jsp:include page="/Header.jsp" />
    <main>
        <div class="booking-container">
            <div class="map-container">
                <div id="map"></div>
            </div>
            <div class="booking-section">
                <div class="booking-header">
                    <h1>Book Your Ride</h1>
                    <p>Select or type your locations to book your cab</p>
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

                <%
                    Integer customerId = (Integer) session.getAttribute("customerId");
                    Booking tempBooking = (Booking) request.getAttribute("tempBookingData");
                    String selectedPickupLocation = tempBooking != null ? tempBooking.getPickupLocation() : "";
                    String selectedDropoffLocation = tempBooking != null ? tempBooking.getDropoffLocation() : "";
                    String selectedVehicleId = tempBooking != null ? String.valueOf(tempBooking.getVehicleId()) : "";
                %>

                <form id="booking-form" action="<%= request.getContextPath() %>/customerBooking?action=save" method="post">
                    <input type="hidden" name="customer_id" value="<%= customerId %>">
                    <input type="hidden" id="distance" name="distance_km" value="0">

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

                    <div class="form-group">
                        <label for="pickup_location">Pickup Location</label>
                        <input type="text" id="pickup_location" name="pickup_location" class="form-control" 
                               value="<%= selectedPickupLocation %>" required placeholder="Type or click on map">
                        <button type="button" id="useMyLocation" class="btn btn-primary" style="margin-top: 10px;">
                            <span class="material-icons">my_location</span>
                            Use My Location
                        </button>
                    </div>

                    <div class="form-group">
                        <label for="dropoff_location">Drop-off Location</label>
                        <input type="text" id="dropoff_location" name="dropoff_location" class="form-control" 
                               value="<%= selectedDropoffLocation %>" required placeholder="Type or click on map">
                    </div>

                    <div class="form-group">
                        <label for="vehicle_id">Select Vehicle</label>
                        <select class="form-control select2" id="vehicle_id" name="vehicle_id" required>
                            <option value="">Choose your preferred vehicle</option>
                            <%
                                try (Connection conn = DBConnectionFactory.getConnection()) {
                                    BookingDAO bookingDAO = new BookingDAO(conn);
                                    List<Map<String, String>> vehicles = bookingDAO.getAvailableVehicles();
                                    for (Map<String, String> vehicle : vehicles) {
                                        String vehicleId = vehicle.get("vehicleId");
                                        boolean isSelected = vehicleId.equals(selectedVehicleId);
                            %>
                                        <option value="<%= vehicleId %>" <%= isSelected ? "selected" : "" %>>
                                            <%= vehicle.get("model") %> - <%= vehicle.get("plateNumber") %> 
                                            (Rate: Rs.<%= vehicle.get("ratePerKm") %>/km)
                                        </option>
                            <%      } 
                                } catch (SQLException e) { e.printStackTrace(); } 
                            %>
                        </select>
                    </div>

                    <div class="distance-display">
                        <span class="material-icons">straighten</span>
                        Distance: <span id="distance-value">0</span> km
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
            </div>
        </div>
    </main>

    <jsp:include page="/Footer.jsp" />
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
            routeLine = L.polyline([pickup, drop], { color: '#FFC107', weight: 4 }).addTo(map);
            var bounds = L.latLngBounds([pickup, drop]);
            map.fitBounds(bounds, { padding: [50, 50] });
            var distance = pickup.distanceTo(drop) / 1000; // Distance in km
            distanceValueElement.textContent = distance.toFixed(1);
            distanceField.value = distance.toFixed(1);
            return distance;
        }
        return 0;
    }

    document.getElementById('useMyLocation').addEventListener('click', function() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude;
                var lng = position.coords.longitude;
                fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&countrycodes=LK`)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('pickup_location').value = data.display_name;
                        if (pickupMarker) map.removeLayer(pickupMarker);
                        pickupMarker = L.marker([lat, lng], { draggable: true }).addTo(map);
                        pickupMarker.on('dragend', updatePickupFromMarker);
                        map.setView([lat, lng], 15);
                        calculateDistance();
                    });
            }, function(error) {
                alert("Could not get your location. Please allow location access.");
            });
        } else {
            alert("Geolocation is not supported by your browser.");
        }
    });

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

    // Function to initialize map with prefilled locations
    function initializeMapFromPrefilledData() {
        var pickupLocation = document.getElementById('pickup_location').value;
        var dropoffLocation = document.getElementById('dropoff_location').value;

        if (pickupLocation && dropoffLocation) {
            // Fetch coordinates for pickup location
            fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(pickupLocation)}&countrycodes=LK`)
                .then(response => response.json())
                .then(data => {
                    if (data.length > 0) {
                        var lat = parseFloat(data[0].lat);
                        var lng = parseFloat(data[0].lon);
                        pickupMarker = L.marker([lat, lng], { draggable: true }).addTo(map);
                        pickupMarker.on('dragend', updatePickupFromMarker);

                        // Fetch coordinates for dropoff location
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

                                    // Calculate distance and draw route
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

    // Set up address search for inputs
    setupAddressSearch(document.getElementById('pickup_location'), true);
    setupAddressSearch(document.getElementById('dropoff_location'), false);

    // Form validation on submit
    $('#booking-form').on('submit', function(e) {
        var pickup = $('#pickup_location').val();
        var dropoff = $('#dropoff_location').val();
        var vehicleId = $('#vehicle_id').val();
        var distance = parseFloat($('#distance').val());

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
        if (distance <= 0) {
            e.preventDefault();
            alert("Please select valid locations to calculate the distance.");
            return false;
        }
    });

    // Initialize Select2
    $('.select2').select2({
        placeholder: "Select an option",
        allowClear: true,
        width: '100%'
    });

    // Fix map size and initialize prefilled data
    setTimeout(function() { map.invalidateSize(); }, 500);
    initializeMapFromPrefilledData(); // Call to restore map state
});
</script>
</body>
</html>