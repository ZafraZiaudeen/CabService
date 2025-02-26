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
    <style>
        /* Booking History Page Styles */
        .booking-history-page {
            max-width: 1200px;
            margin: 120px auto 60px;
            padding: 0 20px;
        }

        .page-header {
            margin-bottom: 30px;
            position: relative;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .page-subtitle {
            color: #666;
            font-size: 16px;
            font-family: 'Poppins', sans-serif;
        }

        .booking-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            margin-bottom: 40px;
        }

        .booking-table {
            width: 100%;
            border-collapse: collapse;
        }

        .booking-table th {
            background-color: #f9f9f9;
            color: #333;
            font-weight: 600;
            text-align: left;
            padding: 16px 20px;
            font-family: 'Poppins', sans-serif;
            font-size: 15px;
            border-bottom: 1px solid #eee;
        }

        .booking-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #eee;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: #555;
        }

        .booking-table tr:last-child td {
            border-bottom: none;
        }

        .booking-table tr:hover td {
            background-color: #f9f9f9;
        }

        .booking-id {
            font-weight: 600;
            color: #333;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            min-width: 100px;
        }

        .status-completed {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-active {
            background-color: #e3f2fd;
            color: #1565c0;
        }

        .status-cancelled {
            background-color: #ffebee;
            color: #c62828;
        }

        .status-pending {
            background-color: #fff8e1;
            color: #f57f17;
        }

        .amount {
            font-weight: 500;
            color: #333;
        }

        .payment-type {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .payment-type .material-icons {
            font-size: 18px;
        }

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

        .success-message {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        .empty-state .material-icons {
            font-size: 60px;
            color: #FFC107;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .empty-state p {
            color: #666;
            font-size: 16px;
            max-width: 500px;
            margin: 0 auto 20px;
            font-family: 'Poppins', sans-serif;
        }

        .btn-primary {
            background-color: #FFC107;
            color: #000;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 15px;
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary:hover {
            background-color: #FFD54F;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(255, 193, 7, 0.3);
        }

        .booking-actions {
            display: flex;
            gap: 10px;
        }

        .btn-action {
            background: none;
            border: none;
            cursor: pointer;
            color: #555;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
        }

        .btn-action:hover {
            background-color: rgba(255, 193, 7, 0.1);
            color: #FFC107;
        }

        .btn-action.disabled {
            color: #ccc;
            cursor: not-allowed;
            pointer-events: none;
        }

        .btn-view {
            color: #1976d2;
        }

        .btn-view:hover {
            background-color: rgba(25, 118, 210, 0.1);
            color: #1976d2;
        }

        .filters {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-button {
            background-color: #f5f5f5;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
            color: #555;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-button.active {
            background-color: #FFC107;
            color: #000;
        }

        .filter-button:hover:not(.active) {
            background-color: #eee;
        }

        /* Confirmation Popover Styles */
        .popover-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .popover-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        .confirmation-popover {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            padding: 24px;
            transform: translateY(20px);
            transition: all 0.3s ease;
        }

        .popover-overlay.active .confirmation-popover {
            transform: translateY(0);
        }

        .popover-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
        }

        .popover-icon {
            background-color: #FFF3E0;
            color: #FF9800;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .popover-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            font-family: 'Poppins', sans-serif;
        }

        .popover-content {
            margin-bottom: 24px;
            color: #555;
            font-family: 'Poppins', sans-serif;
        }

        .popover-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn-secondary {
            background-color: #f5f5f5;
            color: #333;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 14px;
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: #e0e0e0;
        }

        .btn-danger {
            background-color: #f44336;
            color: white;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 14px;
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            background-color: #e53935;
        }

        @media (max-width: 768px) {
            .booking-table {
                display: block;
                overflow-x: auto;
            }
            
            .booking-history-page {
                margin-top: 100px;
                padding: 0 15px;
            }
            
            .page-title {
                font-size: 24px;
            }
            
            .filters {
                justify-content: center;
            }
        }

        @media (max-width: 640px) {
            .booking-card {
                padding: 0;
            }
            
            .booking-table thead {
                display: none;
            }
            
            .booking-table, 
            .booking-table tbody, 
            .booking-table tr, 
            .booking-table td {
                display: block;
                width: 100%;
            }
            
            .booking-table tr {
                margin-bottom: 15px;
                border-bottom: 2px solid #eee;
                position: relative;
            }
            
            .booking-table tr:last-child {
                margin-bottom: 0;
            }
            
            .booking-table td {
                text-align: right;
                padding: 10px 15px;
                position: relative;
                padding-left: 50%;
            }
            
            .booking-table td:before {
                content: attr(data-label);
                position: absolute;
                left: 15px;
                width: 45%;
                font-weight: 600;
                text-align: left;
                color: #333;
            }
        }
    </style>
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