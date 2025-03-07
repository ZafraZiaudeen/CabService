<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/bookingManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Manage Bookings</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by Booking Number, Customer, or Status">
                <button onclick="searchBookings()">
                    <i class="material-icons">search</i>
                </button>
            </div>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/booking?action=add'">
                <i class="material-icons">add</i>
                Add Booking
            </button>
        </div>

        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null) { %>
            <div class="message success">
                <i class="material-icons">check_circle</i>
                <%= success %>
            </div>
        <% } %>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="message error">
                <i class="material-icons">error</i>
                <%= error %>
            </div>
        <% } %>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Booking Number</th>
                            <th>Customer Name</th>
                            <th>Phone Number</th>
                            <th>Pickup Location</th>
                            <th>Dropoff Location</th>
                            <th>Distance (km)</th>
                            <th>Status</th>
                            <th>Booked At</th>
                            <th>Final Amount</th>
                            <th>Payment Type</th>
                            <th>Vehicle</th>
                            <th>Rate/Km</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="bookingsTableBody">
                        <% 
                            List<Map<String, Object>> bookings = (List<Map<String, Object>>) request.getAttribute("bookings");
                            int totalEntries = bookings != null ? bookings.size() : 0;
                            if (bookings != null && !bookings.isEmpty()) {
                                for (int i = 0; i < totalEntries; i++) { 
                                    Map<String, Object> booking = bookings.get(i);
                                    int displayNumber = totalEntries - i;
                        %>
                        <tr data-index="<%= i %>">
                            <td><%= displayNumber %></td>
                            <td><%= booking.get("bookingNumber") %></td>
                            <td><%= booking.get("customerName") %></td>
                            <td><%= booking.get("customerPhone") %></td>
                            <td><%= booking.get("pickupLocation") %></td>
                            <td><%= booking.get("dropoffLocation") %></td>
                            <td><%= booking.get("distanceKm") %></td>
                            <td><%= booking.get("status") %></td>
                            <td><%= booking.get("bookedAt") %></td>
                            <td><%= booking.get("finalAmount") != null ? String.format("%.2f", booking.get("finalAmount")) : "N/A" %></td>
                            <td><%= booking.get("paymentType") != null ? booking.get("paymentType") : "N/A" %></td>
                            <td><%= booking.get("vehiclePlate") + " (" + booking.get("vehicleModel") + ")" %></td>
                            <td><%= String.format("%.2f", booking.get("vehicleRatePerKm")) %></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="window.location.href='<%= request.getContextPath() %>/booking?action=edit&bookingId=<%= booking.get("bookingId") %>'">
                                        <i class="material-icons">edit</i>
                                    </button>
                                    <button class="action-btn delete" onclick="showDeleteModal(<%= booking.get("bookingId") %>)">
                                        <i class="material-icons">delete</i>
                                    </button>
                                    <button class="action-btn download" onclick="window.location.href='<%= request.getContextPath() %>/booking?action=generateReceipt&bookingId=<%= booking.get("bookingId") %>'" title="Download Receipt">
                                        <i class="material-icons">download</i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="14">No bookings found.</td>
                        </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <div class="pagination">
                <div class="pagination-info" id="paginationInfo">
                    Showing 1 to <%= Math.min(6, totalEntries) %> of <%= totalEntries %> entries
                </div>
                <div class="pagination-buttons" id="paginationButtons">
                    <button class="pagination-btn" id="prevBtn" onclick="changePage(-1)">Previous</button>
                    <!-- Page numbers will be dynamically added here -->
                    <button class="pagination-btn" id="nextBtn" onclick="changePage(1)">Next</button>
                </div>
            </div>
        </section>


        <!-- Delete Modal -->
        <div class="modal-backdrop" id="deleteModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 class="modal-title">Confirm Delete</h3>
                    <button class="modal-close" onclick="closeDeleteModal()">
                        <i class="material-icons">close</i>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this booking? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="btn btn-danger" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>

    <script>
        let bookingToDelete = null;
        const itemsPerPage = 6;
        let currentPage = 1;
        const totalEntries = <%= totalEntries %>;

        function showDeleteModal(bookingId) {
            bookingToDelete = bookingId;
            document.getElementById('deleteModal').style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            document.body.style.overflow = '';
            bookingToDelete = null;
        }

        function confirmDelete() {
            if (bookingToDelete !== null) {
                window.location.href = "<%= request.getContextPath() %>/booking?action=delete&bookingId=" + bookingToDelete;
            }
        }

        function searchBookings() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const rows = document.getElementById('bookingsTableBody').getElementsByTagName('tr');
            for (let row of rows) {
                const bookingNumber = row.cells[1].textContent.toLowerCase();
                const customerName = row.cells[2].textContent.toLowerCase();
                const status = row.cells[7].textContent.toLowerCase();
                const finalAmount = row.cells[9].textContent.toLowerCase();
                const paymentType = row.cells[10].textContent.toLowerCase();
                const vehicle = row.cells[11].textContent.toLowerCase();
                if (bookingNumber.includes(searchValue) || customerName.includes(searchValue) || 
                    status.includes(searchValue) || finalAmount.includes(searchValue) || 
                    paymentType.includes(searchValue) || vehicle.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            }
            updatePagination(); // Update pagination after search
        }

        function updateTable() {
            const rows = document.getElementById('bookingsTableBody').getElementsByTagName('tr');
            const start = (currentPage - 1) * itemsPerPage;
            const end = start + itemsPerPage;

            for (let i = 0; i < rows.length; i++) {
                if (rows[i].getAttribute('data-index')) {
                    rows[i].style.display = (i >= start && i < end) ? '' : 'none';
                }
            }

            const showingEnd = Math.min(end, totalEntries);
            document.getElementById('paginationInfo').textContent = 
                `Showing ${start + 1} to ${showingEnd} of ${totalEntries} entries`;

            updatePaginationButtons();
        }

        function updatePaginationButtons() {
            const paginationButtons = document.getElementById('paginationButtons');
            const totalPages = Math.ceil(totalEntries / itemsPerPage);
            
            // Clear existing page numbers
            while (paginationButtons.children.length > 2) {
                paginationButtons.removeChild(paginationButtons.children[1]);
            }

            // Add page number buttons
            for (let i = 1; i <= totalPages; i++) {
                const btn = document.createElement('button');
                btn.className = 'pagination-btn' + (i === currentPage ? ' active' : '');
                btn.textContent = i;
                btn.onclick = () => {
                    currentPage = i;
                    updateTable();
                };
                paginationButtons.insertBefore(btn, document.getElementById('nextBtn'));
            }

            // Update Previous/Next buttons
            document.getElementById('prevBtn').disabled = currentPage === 1;
            document.getElementById('nextBtn').disabled = currentPage === totalPages;
        }

        function changePage(delta) {
            const totalPages = Math.ceil(totalEntries / itemsPerPage);
            currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
            updateTable();
        }

        // Initial setup
        document.addEventListener('DOMContentLoaded', () => {
            updateTable();
        });

        document.getElementById('search').addEventListener('keyup', function(event) {
            if (event.key === 'Enter') {
                searchBookings();
            }
        });

        window.onclick = function(event) {
            const deleteModal = document.getElementById('deleteModal');
            if (event.target === deleteModal) {
                closeDeleteModal();
            }
        }
    </script>
</body>
</html>