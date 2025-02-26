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
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/addAssignment.css'/>">
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