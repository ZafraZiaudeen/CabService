<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cab Service Dashboard</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include the sidebar -->
        <jsp:include page="Sidebar.jsp" />
        
        <main class="main-content" id="mainContent">
            <header class="dashboard-header">
                <h1>Dashboard</h1>
                <div class="header-actions">
                    <button class="notification-btn">
                        <span class="material-icons">notifications</span>
                        <span class="notification-badge">3</span>
                    </button>
                </div>
            </header>

            <div class="dashboard-grid">
                <!-- Stats Cards -->
                <div class="card">
                    <div class="card-content">
                        <h3>Total Bookings</h3>
                        <p class="stat">1,234</p>
                        <span class="trend positive">
                            <span class="material-icons">trending_up</span>
                            +15%
                        </span>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <h3>Active Drivers</h3>
                        <p class="stat">48</p>
                        <span class="trend">
                            <span class="material-icons">person</span>
                            Online
                        </span>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <h3>Revenue</h3>
                        <p class="stat">$12,345</p>
                        <span class="trend positive">
                            <span class="material-icons">trending_up</span>
                            +8%
                        </span>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <h3>Customer Rating</h3>
                        <p class="stat">4.8</p>
                        <span class="trend">
                            <span class="material-icons">star</span>
                            Excellent
                        </span>
                    </div>
                </div>

                <!-- Recent Bookings Table -->
                <div class="card full-width">
                    <div class="card-content">
                        <h3>Recent Bookings</h3>
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
                                <tr>
                                    <td>#12345</td>
                                    <td>John Doe</td>
                                    <td>Mike Smith</td>
                                    <td><span class="status completed">Completed</span></td>
                                    <td>$25.00</td>
                                </tr>
                                <tr>
                                    <td>#12344</td>
                                    <td>Jane Smith</td>
                                    <td>David Wilson</td>
                                    <td><span class="status active">Active</span></td>
                                    <td>$18.50</td>
                                </tr>
                                <tr>
                                    <td>#12343</td>
                                    <td>Robert Johnson</td>
                                    <td>Sarah Davis</td>
                                    <td><span class="status cancelled">Cancelled</span></td>
                                    <td>$0.00</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sidebar');
            
            // Listen for sidebar toggle events
            document.getElementById('toggleBtn').addEventListener('click', function() {
                mainContent.classList.toggle('expanded');
            });

            // Handle responsive behavior for main content
            function handleMainContentResize() {
                if (window.innerWidth <= 768) {
                    mainContent.classList.add('expanded');
                } else {
                    mainContent.classList.remove('expanded');
                }
            }

            // Initial check and event listener for window resize
            handleMainContentResize();
            window.addEventListener('resize', handleMainContentResize);
        });
    </script>
</body>
</html>