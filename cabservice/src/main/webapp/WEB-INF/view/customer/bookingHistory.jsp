<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Timestamp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Booking History - CabService</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
<link rel="stylesheet" href="<c:url value='/css/bookingHistory.css'/>">
</head>
<body>
    <jsp:include page="/Header.jsp" />

    <main class="booking-history-page">
        <div class="page-header">
            <h1 class="page-title">
                <span class="material-icons">history</span>
                Your Booking History
            </h1>
            <p class="page-subtitle">View and manage all your past and upcoming rides</p>
        </div>

        <%-- Display success message if any --%>
        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <div class="success-message">
                <span class="material-icons">check_circle</span>
                <%= message %>
            </div>
        <% } %>

        <%-- Display error messages if any --%>
        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error-message">
                <span class="material-icons">error</span>
                <%= error %>
            </div>
        <% } %>

        <%-- Display booking history if available --%>
        <% 
    List<Map<String, Object>> bookingHistory = (List<Map<String, Object>>) request.getAttribute("bookingHistory");

    if (bookingHistory != null && !bookingHistory.isEmpty()) {
        int count = 1;
%>
    <div class="filters">
        <button class="filter-button active">All Bookings</button>
        <button class="filter-button">Active</button>
        <button class="filter-button">Completed</button>
        <button class="filter-button">Cancelled</button>
    </div>
    
    <div class="booking-card">
        <div class="table-wrapper">
            <table class="booking-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Date & Time</th>
                        <th>Route</th>
                        <th>Status</th>
                        <th>Amount</th>
                        <th>Payment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Iterate over each booking and display the details --%>
                    <%
                        for (Map<String, Object> booking : bookingHistory) {
                            String status = (String) booking.get("status");
                            String statusClass = "";
                            
                            if (status.equalsIgnoreCase("completed")) {
                                statusClass = "status-completed";
                            } else if (status.equalsIgnoreCase("active")) {
                                statusClass = "status-active";
                            } else if (status.equalsIgnoreCase("cancelled")) {
                                statusClass = "status-cancelled";
                            } else {
                                statusClass = "status-pending";
                            }
                            
                            String paymentType = (String) booking.get("payment_type");
                            String paymentIcon = paymentType != null && paymentType.equalsIgnoreCase("Card") ? "credit_card" : "local_atm";

                            // Check if booking is cancellable (Pending and within 5 minutes)
                            boolean canCancel = "Completed".equalsIgnoreCase(status);
                            if (canCancel) {
                                Timestamp bookedAt = (Timestamp) booking.get("booked_at");
                                long currentTime = System.currentTimeMillis();
                                long bookedTime = bookedAt.getTime();
                                long diffInMinutes = (currentTime - bookedTime) / (1000 * 60);
                                canCancel = diffInMinutes <= 5;
                            }
                    %>
                        <tr>
                            <td data-label="Booking ID" class="booking-id">#<%= count %></td> 
                            <td data-label="Date & Time"><%= booking.get("booked_at") %></td>
                            <td data-label="Route">
                                <%= booking.get("pickup_location") %> 
                                <span class="material-icons" style="font-size: 16px; vertical-align: middle;">arrow_forward</span> 
                                <%= booking.get("dropoff_location") %>
                            </td>
                            <td data-label="Status">
                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                            </td>
                            <td data-label="Amount" class="amount">Rs.<%= booking.get("total_amount") %></td>
                            <td data-label="Payment">
                                <span class="payment-type">
                                    <span class="material-icons"><%= paymentIcon %></span>
                                    <%= paymentType != null ? paymentType : "N/A" %>
                                </span>
                            </td>
                            <td data-label="Actions">
                                <div class="booking-actions">
                                    <button class="btn-action btn-view cancel-booking <%= canCancel ? "" : "disabled" %>" 
                                            data-booking-id="<%= booking.get("booking_id") %>" 
                                            title="<%= canCancel ? "Cancel Booking" : "Cancellation not allowed" %>">
                                        <span class="material-icons">cancel</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    <%
                            count++;
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
<%
    } else {
%>
    <div class="empty-state">
        <span class="material-icons">directions_car</span>
        <h3>No Booking History Found</h3>
        <p>You haven't made any bookings yet. Start your journey with us by booking your first ride.</p>
        <a href="<%= request.getContextPath() %>/customerBooking" class="btn-primary">
            <span class="material-icons">add</span>
            Book a Ride
        </a>
    </div>
<%
    }
%>
    </main>

    <!-- Confirmation Popover -->
    <div class="popover-overlay" id="cancelPopover">
        <div class="confirmation-popover">
            <div class="popover-header">
                <div class="popover-icon">
                    <span class="material-icons">help_outline</span>
                </div>
                <h3 class="popover-title">Cancel Ride</h3>
            </div>
            <div class="popover-content">
                <p>Do you want to cancel this ride? This action cannot be undone.</p>
            </div>
            <div class="popover-actions">
                <button class="btn-secondary" id="cancelNo">No, Keep It</button>
                <button class="btn-danger" id="cancelYes">Yes, Cancel Ride</button>
            </div>
        </div>
    </div>

    <jsp:include page="/Footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Filter functionality
            const filterButtons = document.querySelectorAll('.filter-button');
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    const filter = this.textContent.toLowerCase();
                    const rows = document.querySelectorAll('.booking-table tbody tr');
                    
                    rows.forEach(row => {
                        const statusCell = row.querySelector('td:nth-child(4)');
                        const statusText = statusCell.textContent.trim().toLowerCase();
                        
                        if (filter === 'all bookings' || statusText.includes(filter)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            });

            // Cancel booking confirmation
            const cancelButtons = document.querySelectorAll('.cancel-booking:not(.disabled)');
            const popoverOverlay = document.getElementById('cancelPopover');
            const cancelYesBtn = document.getElementById('cancelYes');
            const cancelNoBtn = document.getElementById('cancelNo');
            let currentBookingId = null;

            cancelButtons.forEach(button => {
                button.addEventListener('click', function() {
                    currentBookingId = this.getAttribute('data-booking-id');
                    popoverOverlay.classList.add('active');
                });
            });

            cancelNoBtn.addEventListener('click', function() {
                popoverOverlay.classList.remove('active');
                currentBookingId = null;
            });

            cancelYesBtn.addEventListener('click', function() {
                if (currentBookingId) {
                    window.location.href = '<%= request.getContextPath() %>/booking/cancel?id=' + currentBookingId;
                }
            });

            popoverOverlay.addEventListener('click', function(e) {
                if (e.target === popoverOverlay) {
                    popoverOverlay.classList.remove('active');
                    currentBookingId = null;
                }
            });
        });
    </script>
</body>
</html>