<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Timestamp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    HttpSession sessionCheck = request.getSession(false);
    if (sessionCheck == null || sessionCheck.getAttribute("customerUser") == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Booking History - CabService</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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

        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <div class="success-message">
                <span class="material-icons">check_circle</span>
                <%= message %>
            </div>
        <% } %>

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
            List<Map<String, Object>> bookingHistory = (List<Map<String, Object>>) request.getAttribute("bookingHistory");
            if (bookingHistory != null && !bookingHistory.isEmpty()) {
                int count = 1;
        %>
        <div class="filters">
            <button class="filter-button active" data-filter="all">All Bookings</button>
            <button class="filter-button" data-filter="pending">Pending</button>
            <button class="filter-button" data-filter="ongoing">Active</button>
            <button class="filter-button" data-filter="completed">Completed</button>
            <button class="filter-button" data-filter="cancelled">Cancelled</button>
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
                        <% 
                            for (Map<String, Object> booking : bookingHistory) {
                                String status = (String) booking.get("status");
                                String statusClass = "";
                                
                                if (status.equalsIgnoreCase("completed")) {
                                    statusClass = "status-completed";
                                } else if (status.equalsIgnoreCase("ongoing")) {
                                    statusClass = "status-active";
                                } else if (status.equalsIgnoreCase("cancelled")) {
                                    statusClass = "status-cancelled";
                                } else {
                                    statusClass = "status-pending";
                                }
                                
                                String paymentType = (String) booking.get("payment_type");
                                String paymentIcon = paymentType != null && paymentType.equalsIgnoreCase("Card") ? "credit_card" : "local_atm";

                                boolean canCancel = "Pending".equalsIgnoreCase(status) || "Ongoing".equalsIgnoreCase(status);
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
                                <td data-label="Amount" class="amount">
                                    Rs.<%= booking.get("total_amount") != null ? String.format("%.2f", booking.get("total_amount")) : "N/A" %>
                                </td>
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
                                        <% if ("Pending".equalsIgnoreCase(status)) { %>
                                            <button class="btn-action btn-pay" 
                                                    data-booking-id="<%= booking.get("booking_id") %>"
                                                    onclick="payBooking(<%= booking.get("booking_id") %>)"
                                                    title="Pay for this booking">
                                                <span class="material-icons">payment</span>
                                                Pay
                                            </button>
                                        <% } %>
                                        <% if ("Ongoing".equalsIgnoreCase(status)) { %>
                                            <button class="btn-action btn-complete" 
                                                    data-booking-id="<%= booking.get("booking_id") %>"
                                                    title="Mark as Completed">
                                                <span class="material-icons">check_circle</span>
                                            </button>
                                        <% } %>
                                        <!-- Add Receipt Button -->
                                        <button class="btn-action btn-receipt" 
                                                data-booking-id="<%= booking.get("booking_id") %>"
                                                onclick="generateReceipt(<%= booking.get("booking_id") %>)"
                                                title="Download Receipt">
                                            <span class="material-icons">receipt</span>
                                            Print
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
            const filterButtons = document.querySelectorAll('.filter-button');
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    const filter = this.getAttribute('data-filter');
                    const rows = document.querySelectorAll('.booking-table tbody tr');
                    
                    rows.forEach(row => {
                        const statusCell = row.querySelector('td:nth-child(4)');
                        const statusText = statusCell.textContent.trim().toLowerCase();
                        
                        if (filter === 'all' || 
                            (filter === 'pending' && statusText === 'pending') || 
                            (filter === 'ongoing' && statusText === 'ongoing') || 
                            (filter === 'completed' && statusText === 'completed') || 
                            (filter === 'cancelled' && statusText === 'cancelled')) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            });

            const completeButtons = document.querySelectorAll('.btn-complete');
            completeButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const bookingId = this.getAttribute('data-booking-id');
                    if (confirm('Are you sure you want to mark this ride as completed?')) {
                        window.location.href = '<%= request.getContextPath() %>/booking/complete?id=' + bookingId;
                    }
                });
            });

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

        function payBooking(bookingId) {
            window.location.href = '<%= request.getContextPath() %>/customerBilling?action=view&booking_id=' + bookingId;
        }

        // Function to generate receipt
        function generateReceipt(bookingId) {
            window.location.href = '<%= request.getContextPath() %>/customerBilling?action=generateReceipt&booking_id=' + bookingId;
        }
    </script>
</body>
</html>