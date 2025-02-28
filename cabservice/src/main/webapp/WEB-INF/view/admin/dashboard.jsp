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
                            <%= formattedGrowth %>%
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
               <!-- Replace the existing "Recent Bookings Table" section with this -->
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
                <!-- Fallback if no data -->
                <c:if test="${empty recentBookings}">
                    <tr>
                        <td colspan="5">No recent bookings found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

                <!-- Booking Status Card -->
                <div class="card booking-status-card">
                    <div class="card-content">
                        <h3>Booking Status</h3>
                        <p>All time bookings</p>
                        <div class="filter-container">
                            <!-- Add filter options here if needed -->
                        </div>
                        <canvas id="bookingStatusChart" class="booking-status-canvas" width="200" height="200"></canvas>
                        <div class="booking-status-legend" id="chartLegend"></div>
                    </div>
                </div>
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

            // Pie Chart Data (initial load with "All Time" data)
            const allTimeData = {
                pending: <%= request.getAttribute("pendingBookings") != null ? request.getAttribute("pendingBookings") : 0 %>,
                ongoing: <%= request.getAttribute("ongoingBookings") != null ? request.getAttribute("ongoingBookings") : 0 %>,
                completed: <%= request.getAttribute("completedBookings") != null ? request.getAttribute("completedBookings") : 0 %>,
                cancelled: <%= request.getAttribute("cancelledBookings") != null ? request.getAttribute("cancelledBookings") : 0 %>
            };

            // Placeholder for filtered data (to be fetched dynamically)
            let filteredData = {
                all: allTimeData,
                today: { pending: 0, ongoing: 0, completed: 0, cancelled: 0 },
                week: { pending: 0, ongoing: 0, completed: 0, cancelled: 0 },
                month: { pending: 0, ongoing: 0, completed: 0, cancelled: 0 }
            };

            // Pie Chart Drawing Function
            function drawPieChart(data) {
                const canvas = document.getElementById('bookingStatusChart');
                const ctx = canvas.getContext('2d');
                const legendContainer = document.getElementById('chartLegend');

                // Clear canvas
                ctx.clearRect(0, 0, canvas.width, canvas.height);

                const chartData = [data.pending, data.ongoing, data.completed, data.cancelled];
                const labels = ['Pending', 'Ongoing', 'Completed', 'Cancelled'];
                const colors = ['#fbd38d', '#63b3ed', '#68d391', '#f687b3'];

                const total = chartData.reduce((sum, value) => sum + value, 0) || 1;
                let startAngle = 0;
                const radius = 80;
                const centerX = canvas.width / 2;
                const centerY = canvas.height / 2;

                chartData.forEach((value, index) => {
                    const sliceAngle = (value / total) * 2 * Math.PI;
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
                    ctx.lineTo(centerX, centerY);
                    ctx.fillStyle = colors[index];
                    ctx.fill();
                    ctx.lineWidth = 1;
                    ctx.strokeStyle = '#ffffff';
                    ctx.stroke();
                    startAngle += sliceAngle;
                });

                // Generate legend
                legendContainer.innerHTML = '';
                labels.forEach((label, index) => {
                    const legendItem = document.createElement('div');
                    legendItem.className = 'legend-item';
                    legendItem.innerHTML = `
                        <span class="legend-color" style="background-color: ${colors[index]};"></span>
                        ${label}: ${chartData[index]}
                    `;
                    legendContainer.appendChild(legendItem);
                });
            }

            // Initial Pie Chart Render
            drawPieChart(allTimeData);

            // Update Pie Chart on Filter Change
            window.updatePieChart = function() {
                const period = document.getElementById('timeFilter')?.value || 'all';
                if (filteredData[period].pending === 0 && filteredData[period].ongoing === 0 && 
                    filteredData[period].completed === 0 && filteredData[period].cancelled === 0) {
                    // Placeholder for fetchFilteredData if implemented later
                    drawPieChart(filteredData[period]);
                } else {
                    drawPieChart(filteredData[period]);
                }
            };
        });
    </script>
</body>
</html>