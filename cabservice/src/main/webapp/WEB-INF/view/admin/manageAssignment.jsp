<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Assignment" %>
<%@ page import="com.cabservice.service.AssignmentService" %>
<%
    AssignmentService service = new AssignmentService();
    List<Assignment> assignments = service.getAllAssignments();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver-Vehicle Assignments - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/assManagement.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />
 <c:if test="${not empty message}">
            <p class="success-message">${message}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Driver-Vehicle Assignments</h1>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/assignment?action=add'">
                <span class="material-icons">add</span>
                New Assignment
            </button>
        </div>
<div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by driver, plate number, or model" onkeyup="searchAssignments()">
                <button class="search-btn" onclick="searchAssignments()">
                    <span class="material-icons">search</span>
                </button>
            </div>
        </div>
        <section class="assignments-table">
            <div class="table-container">
                <% if (assignments != null && !assignments.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Driver</th>
                                <th>Plate Number</th>
                                <th>Model</th>
                                <th>Assigned Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                       <tbody id="assignmentsTableBody">
    <% for (Assignment assignment : assignments) { %>
        <tr>
            <td>
                <div class="driver-info">
                    <span class="material-icons info-icon">person</span>
                    <%= (assignment.getDriverName() != null) ? assignment.getDriverName() : "Unknown Driver" %>
                </div>
            </td>
            <td>
                <div class="vehicle-info">
                    <span class="material-icons info-icon">directions_car</span>
                    <%= (assignment.getVehiclePlate() != null) ? assignment.getVehiclePlate() : "Unknown Vehicle" %>
                </div>
            </td>
            <td>
    <div class="vehicle-info">
        <span class="material-icons info-icon">directions_car</span>
        <%= (assignment.getVehicleModel() != null) ? assignment.getVehicleModel()  : "Unknown Vehicle" %>
    </div>
</td>
            
            <td>
                <div class="date-info">
                    <%= assignment.getAssignedAt() %>
                </div>
            </td>
            <td>
                <span class="status-badge active">
                    <span class="material-icons">check_circle</span>
                    Active
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <form action="<%= request.getContextPath() %>/assignment" method="post" style="margin: 0;">
    <input type="hidden" name="action" value="unassign">
    <input type="hidden" name="driverId" value="<%= assignment.getDriverId() %>">
    <input type="hidden" name="vehicleId" value="<%= assignment.getVehicleId() %>">
    <button type="submit" class="action-button unassign">
        <span class="material-icons">link_off</span>
        Unassign
    </button>
</form>
                </div>
            </td>
        </tr>
    <% } %>
</tbody>

                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <span class="material-icons">assignment</span>
                        <h3>No Assignments Found</h3>
                        <p>There are currently no driver-vehicle assignments. Create a new assignment to get started.</p>
                        <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/assignment?action=add'">
                            <span class="material-icons">add</span>
                            Create Assignment
                        </button>
                    </div>
                <% } %>
            </div>
        </section>
    </main>

    <script>
        // Handle sidebar toggle affecting main content
        document.addEventListener('DOMContentLoaded', function() {
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sidebar');
            
            // Listen for sidebar toggle events
            document.getElementById('toggleBtn').addEventListener('click', function() {
                mainContent.classList.toggle('expanded');
            });

            // Handle responsive behavior
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
     // Search functionality for assignments
        function searchAssignments() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const tableBody = document.getElementById('assignmentsTableBody');
            let rows = tableBody ? tableBody.getElementsByTagName('tr') : [];
            let visibleRows = 0;

            const existingNoResults = document.getElementById('noResultsRow');
            if (existingNoResults && tableBody) {
                tableBody.removeChild(existingNoResults);
            }

            if (tableBody) {
                for (let i = 0; i < rows.length; i++) {
                    const row = rows[i];
                    const driverName = row.cells[0].textContent.toLowerCase();
                    const plateNumber = row.cells[1].textContent.toLowerCase();
                    const model = row.cells[2].textContent.toLowerCase();

                    if (driverName.includes(searchValue) || plateNumber.includes(searchValue) || 
                        model.includes(searchValue)) {
                        row.style.display = '';
                        visibleRows++;
                    } else {
                        row.style.display = 'none';
                    }
                }

                if (visibleRows === 0) {
                    const noResultsRow = document.createElement('tr');
                    noResultsRow.id = 'noResultsRow';
                    const noResultsCell = document.createElement('td');
                    noResultsCell.colSpan = 6;
                    noResultsCell.textContent = 'No assignments found for the search.';
                    noResultsCell.style.textAlign = 'center';
                    noResultsRow.appendChild(noResultsCell);
                    tableBody.appendChild(noResultsRow);
                }
            }
        }
    </script>
</body>
</html>