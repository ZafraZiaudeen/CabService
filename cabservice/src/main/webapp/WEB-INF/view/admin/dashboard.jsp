<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cab Service Dashboard</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        /* Dashboard specific styles */
        .dashboard-container {
            display: flex;
        }

        .main-content {
            margin-left: 260px;
            padding: 20px;
            width: calc(100% - 260px);
            transition: margin-left 0.3s ease, width 0.3s ease;
        }

        .main-content.expanded {
            margin-left: 70px;
            width: calc(100% - 70px);
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .notification-btn {
            background: none;
            border: none;
            position: relative;
            cursor: pointer;
            padding: 8px;
            border-radius: 50%;
        }

        .notification-btn:hover {
            background-color: #e2e8f0;
        }

        .notification-badge {
            position: absolute;
            top: 0;
            right: 0;
            background-color: #e74c3c;
            color: white;
            font-size: 12px;
            padding: 2px 6px;
            border-radius: 10px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .card-content h3 {
            color: #636e72;
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .stat {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .trend {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9rem;
            color: #636e72;
        }

        .trend.positive {
            color: #00b894;
        }

        .bookings-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .bookings-table th,
        .bookings-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .bookings-table th {
            font-weight: 600;
            color: #636e72;
        }

        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .status.completed {
            background-color: #00b894;
            color: white;
        }

        .status.active {
            background-color: #0984e3;
            color: white;
        }

        .status.cancelled {
            background-color: #e74c3c;
            color: white;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 70px;
                width: calc(100% - 70px);
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
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