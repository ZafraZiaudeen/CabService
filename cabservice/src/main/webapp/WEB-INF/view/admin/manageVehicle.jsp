<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Vehicles - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Manage Vehicles</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by plate number, model, or status">
                <button onclick="searchVehicles()">
                    <span class="material-icons">search</span>
                </button>
            </div>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/vehicle?action=add'">
                <span class="material-icons">add</span>
                Add Vehicle
            </button>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Plate Number</th>
                            <th>Model</th>
                            <th>Capacity</th>
                            <th>Rate per km</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="vehiclesTableBody">
                        <%
                            List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
                            if (vehicles != null && !vehicles.isEmpty()) {
                                for (Vehicle vehicle : vehicles) {
                        %>
                        <tr>
                            <td><%= vehicle.getPlateNumber() %></td>
                            <td><%= vehicle.getModel() %></td>
                            <td><%= vehicle.getCapacity() %></td>
                            <td><%= vehicle.getRatePerKm() %></td>
                            <td><%= vehicle.getStatus() %></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="editVehicle(<%= vehicle.getId() %>)">
                                        <span class="material-icons">edit</span>
                                    </button>
                                    <button class="action-btn delete" onclick="showDeleteModal(<%= vehicle.getId() %>)">
                                        <span class="material-icons">delete</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6">No Vehicles found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
        <div class="modal-backdrop" id="deleteModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 class="modal-title">Confirm Delete</h3>
                    <button class="modal-close" onclick="closeDeleteModal()">
                        <span class="material-icons">close</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this vehicle? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="search-btn secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="search-btn primary" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>
    <script>
        let vehicleToDelete = null;
        function showDeleteModal(vehicleId) {
            vehicleToDelete = vehicleId;
            document.getElementById('deleteModal').style.display = 'block';
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            vehicleToDelete = null;
        }
        function confirmDelete() {
            if (vehicleToDelete !== null) {
                window.location.href = `<%= request.getContextPath() %>/vehicle?action=delete&vehicleId=${vehicleToDelete}`;
            }
        }
        function editVehicle(vehicleId) {
            window.location.href = "<%= request.getContextPath() %>/vehicle?action=edit&vehicleId=" + vehicleId;
        }
        function searchVehicles() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const tableBody = document.getElementById('vehiclesTableBody');
            const rows = tableBody.getElementsByTagName('tr');
            let visibleRows = 0;

            // Remove any existing "No vehicles found" message
            const existingNoResults = document.getElementById('noResultsRow');
            if (existingNoResults) {
                tableBody.removeChild(existingNoResults);
            }

            // Filter rows
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                // Only process rows with actual vehicle data (skip initial "No Vehicles found" if present)
                if (row.cells.length === 6) {
                    const plateNumber = row.cells[0].textContent.toLowerCase();
                    const model = row.cells[1].textContent.toLowerCase();
                    const status = row.cells[4].textContent.toLowerCase();

                    if (plateNumber.includes(searchValue) || model.includes(searchValue) || 
                        status.includes(searchValue)) {
                        row.style.display = '';
                        visibleRows++;
                    } else {
                        row.style.display = 'none';
                    }
                }
            }

            // If no rows are visible, add a "No vehicles found" message
            if (visibleRows === 0) {
                const noResultsRow = document.createElement('tr');
                noResultsRow.id = 'noResultsRow';
                const noResultsCell = document.createElement('td');
                noResultsCell.colSpan = 6;
                noResultsCell.textContent = 'No vehicles found for the search.';
                noResultsCell.style.textAlign = 'center';
                noResultsRow.appendChild(noResultsCell);
                tableBody.appendChild(noResultsRow);
            }
        }
    </script>
</body>
</html>
