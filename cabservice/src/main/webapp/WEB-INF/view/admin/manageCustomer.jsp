<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Customer" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Customers - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Manage Customers</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by name, NIC, phone, or email">
                <button onclick="searchCustomers()">
                    <span class="material-icons">search</span>
                </button>
            </div>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/customer?action=add'">
                <span class="material-icons">add</span>
                Add Customer
            </button>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Address</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Username</th>
                            <th>NIC</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="customersTableBody">
                        <%
                            List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                            if (customers != null && !customers.isEmpty()) {
                                for (Customer customer : customers) {
                        %>
                        <tr>
                            <td><%= customer.getName() %></td>
                            <td><%= customer.getAddress() %></td>
                            <td><%= customer.getPhoneNumber() %></td>
                            <td><%= customer.getEmail() %></td>
                            <td><%= customer.getUsername() %></td>
                            <td><%= customer.getNic() %></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="editCustomer(<%= customer.getCustomerId() %>)">
                                        <span class="material-icons">edit</span>
                                    </button>
                                    <button class="action-btn delete" onclick="showDeleteModal(<%= customer.getCustomerId() %>)">
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
                            <td colspan="7">No customers found.</td>
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
                    <p>Are you sure you want to delete this customer? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="search-btn secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="search-btn primary" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>
    <script>
        let customerToDelete = null;

        function showDeleteModal(customerId) {
            customerToDelete = customerId;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            customerToDelete = null;
        }

        function confirmDelete() {
            if (customerToDelete !== null) {
                window.location.href = `customer?action=delete&customerId=${customerToDelete}`;
            }
        }

        function editCustomer(customerId) {
            window.location.href = "<%= request.getContextPath() %>/customer?action=edit&customerId=" + customerId;
        }

        function searchCustomers() {
            const searchValue = document.getElementById('search').value.toLowerCase();
            const rows = document.querySelectorAll('#customersTableBody tr');
            rows.forEach(row => {
                const cells = row.getElementsByTagName('td');
                let found = false;
                for (let i = 0; i < cells.length - 1; i++) { // Exclude Actions column
                    if (cells[i].textContent.toLowerCase().includes(searchValue)) {
                        found = true;
                        break;
                    }
                }
                row.style.display = found ? '' : 'none';
            });
        }
    </script>
</body>
</html>