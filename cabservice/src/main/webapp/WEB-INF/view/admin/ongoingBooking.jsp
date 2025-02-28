<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ongoing Bookings - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Ongoing Bookings</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by Booking Number, Customer, or Vehicle">
                <button onclick="searchBookings()">
                    <span class="material-icons">search</span>
                </button>
            </div>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Booking Number</th>
                            <th>Customer Name</th>
                            <th>Phone Number</th>
                            <th>Pickup Location</th>
                            <th>Dropoff Location</th>
                            <th>Distance (km)</th>
                            <th>Status</th>
                            <th>Booked At</th>
                            <th>Final Amount</th>
                            <th>Vehicle</th>
                            <th>Rate/Km</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="bookingsTableBody">
                        <% 
                            List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                            if (bookings != null && !bookings.isEmpty()) {
                                int totalBookings = bookings.size();
                                for (int i = 0; i < totalBookings; i++) { 
                                    Map<String, Object> booking = bookings.get(i);
                                    int displayNumber = totalBookings - i;
                        %>
                        <tr>
                            <td><%= displayNumber %></td>
                            <td><%= booking.get("bookingNumber") %></td>
                            <td><%= booking.get("customerName") %></td>
                            <td><%= booking.get("customerPhone") %></td>
                            <td><%= booking.get("pickupLocation") %></td>
                            <td><%= booking.get("dropoffLocation") %></td>
                            <td><%= booking.get("distanceKm") %></td>
                            <td><%= booking.get("status") %></td>
                            <td><%= booking.get("bookedAt") %></td>
                            <td><%= booking.get("finalAmount") != null ? String.format("%.2f", booking.get("finalAmount")) : "N/A" %></td>
                            <td><%= booking.get("vehiclePlate") + " (" + booking.get("vehicleModel") + ")" %></td>
                            <td><%= String.format("%.2f", booking.get("vehicleRatePerKm")) %></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="window.location.href='<%= request.getContextPath() %>/booking?action=edit&bookingId=<%= booking.get("bookingId") %>'">
                                        <span class="material-icons">edit</span>
                                    </button>
                                    <button class="action-btn delete" onclick="showDeleteModal(<%= booking.get("bookingId") %>)">
                                        <span class="material-icons">delete</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="13">No ongoing bookings found.</td>
                        </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null) { %>
            <div class="message success">
                <span class="material-icons">check_circle</span>
                <%= success %>
            </div>
        <% } %>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="message error">
                <span class="material-icons">error</span>
                <%= error %>
            </div>
        <% } %>
        <div class="modal-backdrop" id="deleteModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 class="modal-title">Confirm Delete</h3>
                    <button class="modal-close" onclick="closeDeleteModal()">
                        <span class="material-icons">close</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this booking? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="search-btn secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="search-btn primary" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>
    <script>
        let bookingToDelete = null;

        function showDeleteModal(bookingId) {
            bookingToDelete = bookingId;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            bookingToDelete = null;
        }

        function confirmDelete() {
            if (bookingToDelete !== null) {
                window.location.href = "<%= request.getContextPath() %>/booking?action=delete&bookingId=" + bookingToDelete;
            }
        }

        function searchBookings() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const rows = document.getElementById('bookingsTableBody').getElementsByTagName('tr');
            for (let row of rows) {
                const bookingNumber = row.cells[1].textContent.toLowerCase();
                const customerName = row.cells[2].textContent.toLowerCase();
                const vehicle = row.cells[10].textContent.toLowerCase();
                if (bookingNumber.includes(searchValue) || customerName.includes(searchValue) || vehicle.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
        }
    </script>
</body>
</html>