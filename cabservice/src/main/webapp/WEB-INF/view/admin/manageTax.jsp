<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.cabservice.model.SystemConfig" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Tax/Discount - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Manage Tax & Discount</h1>
        </div>
        <div class="search-container">
            
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/system-config?action=add'">
                <span class="material-icons">add</span>
                Add Tax/Discount
            </button>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Tax Rate (%)</th>
                            <th>Discount Rate (%)</th>
                            <th>Last Updated</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="customersTableBody">
    <% 
        SystemConfig systemConfig = (SystemConfig) request.getAttribute("config");
        if (systemConfig != null) {
    %>
    <tr>
        <td><%= systemConfig.getTaxRate() %></td>
        <td><%= systemConfig.getDiscountRate() %></td>
        <td><%= systemConfig.getUpdatedAt() %></td>  <!-- Display the updated_at field -->
        <td>
            <div class="action-buttons">
                <button class="action-btn edit" onclick="editConfig(<%= systemConfig.getId() %>)">
                    <span class="material-icons">edit</span>
                </button>
                <button class="action-btn delete" onclick="showDeleteModal(<%= systemConfig.getId() %>)">
                    <span class="material-icons">delete</span>
                </button>
            </div>
        </td>
    </tr>
    <% } else { %>
    <tr>
        <td colspan="4">No tax/discount configured.</td>
    </tr>
    <% } %>
</tbody>
                </table>
            </div>
        </section>
        <!-- Modal for Deletion Confirmation -->
        <div class="modal-backdrop" id="deleteModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 class="modal-title">Confirm Delete</h3>
                    <button class="modal-close" onclick="closeDeleteModal()">
                        <span class="material-icons">close</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the current tax/discount configuration? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="search-btn secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="search-btn primary" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>
    <script>
        let configToDelete = null;

        function showDeleteModal(configId) {
            configToDelete = configId;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            configToDelete = null;
        }

        function confirmDelete() {
            if (configToDelete !== null) {
                window.location.href = "<%= request.getContextPath() %>/system-config?action=delete&id=" + configToDelete;
            }
        }

        function editConfig(configId) {
            window.location.href = "<%= request.getContextPath() %>/system-config?action=edit&id=" + configId;
        }

       
    </script>
</body>
</html>
