<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Vehicles - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Available Vehicles</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by plate number, model, or capacity">
                <button onclick="searchVehicles()">
                    <span class="material-icons">search</span>
                </button>
            </div>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Plate Number</th>
                            <th>Model</th>
                            <th>Capacity</th>
                            <th>Rate Per KM</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="vehiclesTableBody">
                        <%
                            List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
                            if (vehicles != null && !vehicles.isEmpty()) {
                                for (Vehicle vehicle : vehicles) {
                                    if ("Available".equalsIgnoreCase(vehicle.getStatus())) { // ✅ Only display available vehicles
                        %>
                        <tr>
                            <td><%= vehicle.getPlateNumber() %></td>
                            <td><%= vehicle.getModel() %></td>
                            <td><%= vehicle.getCapacity() %> persons</td>
                            <td><%= vehicle.getRatePerKm() %> per km</td>
                            <td>Available</td>
                        </tr>
                        <%
                                    }
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5">No Available Vehicles found.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
    <script>
        function searchVehicles() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const tableBody = document.getElementById('vehiclesTableBody');
            const rows = tableBody.getElementsByTagName('tr');
            let visibleRows = 0;

            // Remove any existing "No available vehicles found" message
            const existingNoResults = document.getElementById('noResultsRow');
            if (existingNoResults) {
                tableBody.removeChild(existingNoResults);
            }

            // Filter rows
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                // Only process rows with actual vehicle data (skip initial "No Available Vehicles found" if present)
                if (row.cells.length === 5) {
                    const plateNumber = row.cells[0].textContent.toLowerCase();
                    const model = row.cells[1].textContent.toLowerCase();
                    const capacity = row.cells[2].textContent.toLowerCase();

                    if (plateNumber.includes(searchValue) || model.includes(searchValue) || 
                        capacity.includes(searchValue)) {
                        row.style.display = '';
                        visibleRows++;
                    } else {
                        row.style.display = 'none';
                    }
                }
            }

            // If no rows are visible, add a "No available vehicles found" message
            if (visibleRows === 0) {
                const noResultsRow = document.createElement('tr');
                noResultsRow.id = 'noResultsRow';
                const noResultsCell = document.createElement('td');
                noResultsCell.colSpan = 5;
                noResultsCell.textContent = 'No available vehicles found for the search.';
                noResultsCell.style.textAlign = 'center';
                noResultsRow.appendChild(noResultsCell);
                tableBody.appendChild(noResultsRow);
            }
        }
    </script>
</body>
</html>
