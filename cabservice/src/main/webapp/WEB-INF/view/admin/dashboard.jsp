<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cab Service Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="Sidebar.jsp" />
        
        <main class="main-content" id="mainContent">
            <header class="dashboard-header">
                <h1>Dashboard</h1>
            </header>

            <!-- Stats Grid -->
            <div class="dashboard-grid stats-grid">
                <!-- Total Bookings Card -->
                <div class="card">
                    <div class="card-content">
                        <h3>Total Bookings</h3>
                        <%
                            Integer totalBookings = (Integer) request.getAttribute("totalBookings");
                            Double growthPercentage = (Double) request.getAttribute("growthPercentage");
                            DecimalFormat df = new DecimalFormat("#,###");
                            DecimalFormat pf = new DecimalFormat("#0.##");
                            String formattedTotal = (totalBookings != null) ? df.format(totalBookings) : "0";
                            String formattedGrowth = (growthPercentage != null) ? pf.format(growthPercentage) : "0";
                            String trendClass = (growthPercentage != null && growthPercentage >= 0) ? "positive" : "negative";
                            String trendIcon = (growthPercentage != null && growthPercentage >= 0) ? "trending_up" : "trending_down";
                        %>
                        <p class="stat"><%= formattedTotal %></p>
                        <span class="trend <%= trendClass %>">
					    <span class="material-icons"><%= trendIcon %></span>
					    <%= formattedGrowth %>% vs. last month
					</span>
                    </div>
                </div>

                <!-- Active Drivers Card -->
                <div class="card">
                    <div class="card-content">
                        <h3>Active Drivers</h3>
                        <%
                            Integer availableDrivers = (Integer) request.getAttribute("availableDrivers");
                            Integer totalDrivers = (Integer) request.getAttribute("totalDrivers");
                            String formattedAvailable = (availableDrivers != null) ? df.format(availableDrivers) : "0";
                            String driverStatus = (availableDrivers != null && availableDrivers > 0) ? "Online" : "Offline";
                        %>
                        <p class="stat"><%= formattedAvailable %></p>
                        <span class="trend">
                            <span class="material-icons">person</span>
                            <%= driverStatus %>
                            <% if (totalDrivers != null) { %>
                                <span>(of <%= df.format(totalDrivers) %>)</span>
                            <% } %>
                        </span>
                    </div>
                </div>

                <!-- Current Bookings Card -->
                <div class="card">
                    <div class="card-content">
                        <h3>Current Bookings</h3>
                        <%
                            Integer currentBookings = (Integer) request.getAttribute("currentBookings");
                            Integer pendingBookings = (Integer) request.getAttribute("pendingBookings");
                            Integer ongoingBookings = (Integer) request.getAttribute("ongoingBookings");
                            String formattedCurrent = (currentBookings != null) ? df.format(currentBookings) : "0";
                            String formattedPending = (pendingBookings != null) ? df.format(pendingBookings) : "0";
                            String formattedOngoing = (ongoingBookings != null) ? df.format(ongoingBookings) : "0";
                        %>
                        <p class="stat"><%= formattedCurrent %></p>
                        <span class="trend">
                            <span class="material-icons">directions_car</span>
                            In Progress
                        </span>
                        <div class="card-footer">
                            Pending: <%= formattedPending %> | Ongoing: <%= formattedOngoing %>
                        </div>
                    </div>
                </div>

                <!-- Revenue Breakdown Card -->
                <div class="card">
                    <div class="card-content">
                        <h3>Revenue Breakdown</h3>
                        <%
                            Double totalRevenue = (Double) request.getAttribute("totalRevenue");
                            Double cardRevenue = (Double) request.getAttribute("cardRevenue");
                            Double cashRevenue = (Double) request.getAttribute("cashRevenue");
                            DecimalFormat dfMoney = new DecimalFormat("#,##0.00");
                            String formattedTotalRevenue = (totalRevenue != null) ? "Rs. " + dfMoney.format(totalRevenue) : "Rs. 0.00";
                            String formattedCardRevenue = (cardRevenue != null) ? "Rs. " + dfMoney.format(cardRevenue) : "Rs. 0.00";
                            String formattedCashRevenue = (cashRevenue != null) ? "Rs. " + dfMoney.format(cashRevenue) : "Rs. 0.00";
                        %>
                        <p class="stat"><%= formattedTotalRevenue %></p>
                        <table>
                            <tr><td>Cash</td><td><%= formattedCashRevenue %></td></tr>
                            <tr><td>Card</td><td><%= formattedCardRevenue %></td></tr>
                        </table>
                    </div>
                </div>

                <!-- Customer Count Card -->
                <div class="card">
                    <div class="card-content">
                        <h3>Registered Customers</h3>
                        <%
                            Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
                            String formattedCustomers = (totalCustomers != null) ? df.format(totalCustomers) : "0";
                        %>
                        <p class="stat"><%= formattedCustomers %></p>
                        <span class="trend">
                            <span class="material-icons">people</span>
                            Total
                        </span>
                    </div>
                </div>

                <!-- Vehicle Count Card -->
                <div class="card">
                    <div class="card-content">
                        <h3>Total Vehicles</h3>
                        <%
                            Integer totalVehicles = (Integer) request.getAttribute("totalVehicles");
                            String formattedVehicles = (totalVehicles != null) ? df.format(totalVehicles) : "0";
                        %>
                        <p class="stat"><%= formattedVehicles %></p>
                        <span class="trend">
                            <span class="material-icons">local_taxi</span>
                            Total
                        </span>
                    </div>
                </div>
            </div>

            <!-- Lower Section: Table and Pie Chart Side-by-Side -->
            <div class="dashboard-grid lower-grid">
                <!-- Recent Bookings Table -->
                <div class="card">
                    <div class="card-content">
                        <h3>Recent Bookings within 3 days</h3>
                        <table class="bookings-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Customer</th>
                                    <th>Driver</th>
                                    <th>Status</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${recentBookings}">
                                    <tr>
                                        <td>${booking.bookingId}</td>
                                        <td>${booking.customerName}</td>
                                        <td>${booking.driverName}</td>
                                        <td>${booking.status}</td>
                                        <td>Rs. ${booking.amount}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentBookings}">
                                    <tr>
                                        <td colspan="5">No recent bookings found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

               
                <jsp:include page="piechart.jsp" />
            </div>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="message error">
                    <span class="material-icons">error</span>
                    <%= error %>
                </div>
            <% } %>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sidebar toggle logic
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sidebar');
            
            document.getElementById('toggleBtn').addEventListener('click', function() {
                mainContent.classList.toggle('expanded');
            });

            function handleMainContentResize() {
                if (window.innerWidth <= 768) {
                    mainContent.classList.add('expanded');
                } else {
                    mainContent.classList.remove('expanded');
                }
            }

            handleMainContentResize();
            window.addEventListener('resize', handleMainContentResize);
        });
    </script>
</body>
</html>