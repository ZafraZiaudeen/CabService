<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.cabservice.model.Driver, com.cabservice.model.Vehicle, com.cabservice.service.AssignmentService" %>
<%
    AssignmentService service = new AssignmentService();

    // Ensure drivers list is properly retrieved
    List<Driver> drivers = service.getUnassignedDrivers();
    if (drivers == null) {
        drivers = new ArrayList<>();  // Prevents null errors
    }

    // Ensure vehicles list is properly retrieved
    List<Vehicle> vehicles = service.getAvailableVehicles();
    if (vehicles == null) {
        vehicles = new ArrayList<>();  // Prevents null errors
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Vehicle - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        :root {
            --primary-color: #0984e3;
            --secondary-color: #2d3436;
            --background-color: #f5f6fa;
            --surface-color: #ffffff;
            --border-color: #dfe6e9;
            --text-primary: #2d3436;
            --text-secondary: #636e72;
            --success-color: #00b894;
        }

        body {
            background-color: var(--background-color);
            color: var(--text-primary);
            min-height: 100vh;
        }

        .main-content {
            margin-left: 260px;
            padding: 20px;
            transition: margin-left 0.3s ease;
        }

        .main-content.expanded {
            margin-left: 70px;
        }

        .page-header {
            display: flex;
            align-items: center;
            margin-bottom: 24px;
            gap: 16px;
        }

        .back-button {
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-secondary);
            padding: 8px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            transition: background-color 0.2s;
        }

        .back-button:hover {
            background-color: #e2e8f0;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }

        .assignment-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .selection-panel {
            background-color: var(--surface-color);
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            height: calc(100vh - 140px);
        }

        .panel-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
        }

        .panel-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
        }

        .search-box {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 10px 16px 10px 40px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.2s;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(9, 132, 227, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .panel-content {
            flex: 1;
            overflow-y: auto;
            padding: 12px;
        }

        .list-item {
            padding: 16px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: all 0.2s;
            background-color: white;
        }

        .list-item:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .list-item.selected {
            border-color: var(--primary-color);
            background-color: #ebf8ff;
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .item-title {
            font-weight: 600;
            color: var(--text-primary);
        }

        .item-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            background-color: #e1f8e9;
            color: var(--success-color);
        }

        .item-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
            font-size: 13px;
            color: var(--text-secondary);
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .detail-item .material-icons {
            font-size: 16px;
        }

        .form-buttons {
            position: fixed;
            bottom: 0;
            left: 260px;
            right: 0;
            padding: 16px;
            background-color: white;
            border-top: 1px solid var(--border-color);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            transition: left 0.3s ease;
        }

        .main-content.expanded .form-buttons {
            left: 70px;
        }

        .form-button {
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .form-button.primary {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }

        .form-button.secondary {
            background-color: #e2e8f0;
            color: var(--text-secondary);
            border: none;
        }

        .form-button:hover:not(:disabled) {
            transform: translateY(-1px);
        }

        .form-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        @media (max-width: 1024px) {
            .assignment-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 70px;
                padding: 16px;
            }

            .form-buttons {
                left: 70px;
                padding: 12px;
            }

            .selection-panel {
                height: calc(50vh - 100px);
            }
        }
    </style>
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <button class="back-button" onclick="window.location.href='<%= request.getContextPath() %>/assignment?action=list'">
                <span class="material-icons">arrow_back</span>
            </button>
            <h1 class="page-title">Assign Vehicle to Driver</h1>
        </div>

        <form id="assignmentForm" action="<%= request.getContextPath() %>/assignment?action=assign" method="post">
            <div class="assignment-grid">
                <div class="selection-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">
                            <span class="material-icons">person</span>
                            Select Driver
                        </h2>
                        <div class="search-box">
                            <span class="material-icons search-icon">search</span>
                            <input type="text" 
                                   class="search-input" 
                                   id="driverSearch" 
                                   placeholder="Search by name or phone number..."
                                   oninput="filterDrivers(this.value)">
                        </div>
                    </div>
                    <div class="panel-content" id="driversContainer">
                        <% for (Driver driver : drivers) { %>
                            <div class="list-item" onclick="selectDriver(this, '<%= driver.getDriverId() %>')">
                                <div class="item-header">
                                    <span class="item-title"><%= driver.getName() %></span>
                                    <span class="item-badge">Available</span>
                                </div>
                                <div class="item-details">
                                    <span class="detail-item">
                                        <span class="material-icons">phone</span>
                                        <%= driver.getPhoneNumber() %>
                                    </span>
                                    <span class="detail-item">
                                        <span class="material-icons">badge</span>
                                        ID: <%= driver.getDriverId() %>
                                    </span>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="selection-panel">
                    <div class="panel-header">
                        <h2 class="panel-title">
                            <span class="material-icons">directions_car</span>
                            Select Vehicle
                        </h2>
                        <div class="search-box">
                            <span class="material-icons search-icon">search</span>
                            <input type="text" 
                                   class="search-input" 
                                   id="vehicleSearch" 
                                   placeholder="Search by model or plate number..."
                                   oninput="filterVehicles(this.value)">
                        </div>
                    </div>
                    <div class="panel-content" id="vehiclesContainer">
                        <% for (Vehicle vehicle : vehicles) { %>
                            <div class="list-item" onclick="selectVehicle(this, '<%= vehicle.getId() %>')">
                                <div class="item-header">
                                    <span class="item-title"><%= vehicle.getModel() %></span>
                                    <span class="item-badge">Available</span>
                                </div>
                                <div class="item-details">
                                    <span class="detail-item">
                                        <span class="material-icons">directions_car</span>
                                        <%= vehicle.getPlateNumber() %>
                                    </span>
                                    <span class="detail-item">
                                        <span class="material-icons">info</span>
                                        ID: <%= vehicle.getId() %>
                                    </span>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <input type="hidden" name="driverId" id="selectedDriverId">
            <input type="hidden" name="vehicleId" id="selectedVehicleId">

            <div class="form-buttons">
                <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/assignment?action=list'">
                    <span class="material-icons">close</span>
                    Cancel
                </button>
                <button type="submit" class="form-button primary" id="submitButton" disabled>
                    <span class="material-icons">check</span>
                    Create Assignment
                </button>
            </div>
        </form>
    </main>

    <script>
        let selectedDriver = null;
        let selectedVehicle = null;
        let driverSearchTimeout = null;
        let vehicleSearchTimeout = null;

        function filterDrivers(query) {
            clearTimeout(driverSearchTimeout);
            driverSearchTimeout = setTimeout(() => {
                query = query.toLowerCase();
                const items = document.querySelectorAll('#driversContainer .list-item');
                items.forEach(item => {
                    const text = item.textContent.toLowerCase();
                    item.style.display = text.includes(query) ? '' : 'none';
                });
            }, 300);
        }

        function filterVehicles(query) {
            clearTimeout(vehicleSearchTimeout);
            vehicleSearchTimeout = setTimeout(() => {
                query = query.toLowerCase();
                const items = document.querySelectorAll('#vehiclesContainer .list-item');
                items.forEach(item => {
                    const text = item.textContent.toLowerCase();
                    item.style.display = text.includes(query) ? '' : 'none';
                });
            }, 300);
        }

        function selectDriver(element, id) {
            // Remove previous selection
            document.querySelectorAll('#driversContainer .list-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Add selection to clicked item
            element.classList.add('selected');
            selectedDriver = id;
            document.getElementById('selectedDriverId').value = id;
            updateSubmitButton();
        }

        function selectVehicle(element, id) {
            // Remove previous selection
            document.querySelectorAll('#vehiclesContainer .list-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Add selection to clicked item
            element.classList.add('selected');
            selectedVehicle = id;
            document.getElementById('selectedVehicleId').value = id;
            updateSubmitButton();
        }

        function updateSubmitButton() {
            document.getElementById('submitButton').disabled = !selectedDriver || !selectedVehicle;
        }

        // Handle sidebar toggle affecting main content
        document.addEventListener('DOMContentLoaded', function() {
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sidebar');
            
            document.getElementById('toggleBtn').addEventListener('click', function() {
                mainContent.classList.toggle('expanded');
            });

            function handleResize() {
                if (window.innerWidth <= 768) {
                    mainContent.classList.add('expanded');
                } else if (!sidebar.classList.contains('collapsed')) {
                    mainContent.classList.remove('expanded');
                }
            }

            handleResize();
            window.addEventListener('resize', handleResize);
        });
    </script>
</body>
</html>