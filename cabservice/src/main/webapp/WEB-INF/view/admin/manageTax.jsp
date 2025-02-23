<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.cabservice.model.SystemConfig" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Tax/Discount - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        /* Add the existing styles or modify them for tax/discount management */
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
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-title {
            font-size: 24px;
            font-weight: 600;
        }
        
        .add-button {
            background-color: #0984e3;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        .add-button:hover {
            background-color: #0773c5;
        }
        .customers-table {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        th {
            background-color: #f8fafc;
            font-weight: 600;
            color: #4a5568;
            font-size: 14px;
        }

        td {
            font-size: 14px;
            color: #2d3748;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            padding: 6px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s;
        }

        .action-btn.edit {
            background-color: #edf2f7;
            color: #4a5568;
        }

        .action-btn.delete {
            background-color: #fed7d7;
            color: #e53e3e;
        }

        .action-btn:hover {
            opacity: 0.9;
        }

        /* Modal styles */
        .modal-backdrop {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 24px;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            z-index: 1001;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 600;
        }

        .modal-close {
            background: none;
            border: none;
            cursor: pointer;
            color: #4a5568;
        }

        .modal-body {
            margin-bottom: 24px;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 70px;
            }
        }
    </style>
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
        <section class="customers-table">
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
