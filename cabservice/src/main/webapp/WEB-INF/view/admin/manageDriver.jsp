<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Driver" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Manage Drivers</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by name, NIC, phone, or email">
                <button onclick="searchDrivers()">
                    <span class="material-icons">search</span>
                </button>
            </div>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/driver?action=add'">
             <span class="material-icons">add</span>
            Add Driver
        </button>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                             <th>Name</th>
			                <th>NIC</th>
			                <th>License Number</th>
			                <th>Phone Number</th>
			                <th>Experience</th>
			                <th>Availability</th>
			                <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="driversTableBody">
                         <%
                    List<Driver> drivers = (List<Driver>) request.getAttribute("drivers");
                    if (drivers != null && !drivers.isEmpty()) {
                        for (Driver driver : drivers) {
                %>
                <tr>
                    <td><%= driver.getName() %></td>
                    <td><%= driver.getNic() %></td>
                    <td><%= driver.getLicenseNumber() %></td>
                    <td><%= driver.getPhoneNumber() %></td>
                    <td><%= driver.getExperience() %> years</td>
                    <td><%= driver.isAvailability() ? "Available" : "Unavailable" %></td>
                            <td>
                                <div class="action-buttons">
                                   <button class="action-btn edit"onclick="editDriver(<%= driver.getDriverId() %>)">
			    <span class="material-icons">edit</span>
			</button>

                                    <button class="action-btn delete" onclick="showDeleteModal(<%= driver.getDriverId() %>)">
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
                            <td colspan="6">No Drivers found.</td>
                        </tr>
                        <%
                            }
                        %>
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
                    <p>Are you sure you want to delete this driver? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="search-btn secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="search-btn primary" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>
    <script>
        let driverToDelete = null;
        function showDeleteModal(driverId) {
            driverToDelete = driverId;
            document.getElementById('deleteModal').style.display = 'block';
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            driverToDelete = null;
        }
        function confirmDelete() {
            if (driverToDelete !== null) {
                window.location.href = `driver?action=delete&driverId=${driverToDelete}`;
            }
        }
        
        function editDriver(driverId) {
            window.location.href = "<%= request.getContextPath() %>/driver?action=edit&driverId=" + driverId;
        }
        function searchDrivers() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const tableBody = document.getElementById('driversTableBody');
            const rows = tableBody.getElementsByTagName('tr');
            let visibleRows = 0;

           
            const existingNoResults = document.getElementById('noResultsRow');
            if (existingNoResults) {
                tableBody.removeChild(existingNoResults);
            }

            // Filter rows
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const name = row.cells[0].textContent.toLowerCase();
                const nic = row.cells[1].textContent.toLowerCase();
                const licenseNumber = row.cells[2].textContent.toLowerCase();
                const phone = row.cells[3].textContent.toLowerCase();

                if (name.includes(searchValue) || nic.includes(searchValue) || 
                    licenseNumber.includes(searchValue) || phone.includes(searchValue)) {
                    row.style.display = '';
                    visibleRows++;
                } else {
                    row.style.display = 'none';
                }
            }

            // If no rows are visible, add a "No drivers found" message
            if (visibleRows === 0) {
                const noResultsRow = document.createElement('tr');
                noResultsRow.id = 'noResultsRow';
                const noResultsCell = document.createElement('td');
                noResultsCell.colSpan = 7;
                noResultsCell.textContent = 'No drivers found for the search.';
                noResultsCell.style.textAlign = 'center';
                noResultsRow.appendChild(noResultsCell);
                tableBody.appendChild(noResultsRow);
            }
        }
    </script>
</body>

</html>