<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Distance" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Distance - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
 <style>
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
        .search-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }
        .search-bar {
            flex-grow: 1;
            max-width: 400px;
            display: flex;
            align-items: center;
            background-color: white;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .search-bar input {
            flex-grow: 1;
            padding: 8px 12px;
            border: none;
            font-size: 14px;
            outline: none;
        }
        .search-bar button {
            background: none;
            border: none;
            cursor: pointer;
            color: #4a5568;
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

        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            background-color: #f8fafc;
            border-top: 1px solid #e2e8f0;
        }

        .pagination-info {
            font-size: 14px;
            color: #4a5568;
        }

        .pagination-buttons {
            display: flex;
            gap: 8px;
        }

        .pagination-btn {
            padding: 6px 12px;
            border: 1px solid #e2e8f0;
            background-color: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            color: #4a5568;
            transition: all 0.2s;
        }

        .pagination-btn:hover:not(:disabled) {
            background-color: #f8fafc;
        }

        .pagination-btn.active {
            background-color: #0984e3;
            color: white;
            border-color: #0984e3;
        }

        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
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
            <h1 class="page-title">Manage Distance</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by From, To, or Distance">
                <button onclick="searchDistances()">
                    <span class="material-icons">search</span>
                </button>
            </div>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/distance?action=add'">
                <span class="material-icons">add</span>
                Add Distance
            </button>
        </div>
        <section class="customers-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>From</th>
                            <th>To</th>
                            <th>Distance (km)</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="customersTableBody">
                        <% 
                            List<Distance> distances = (List<Distance>) request.getAttribute("distances");
                            if (distances != null && !distances.isEmpty()) {
                                for (Distance distance : distances) { 
                        %>
                        <tr>
                            <td><%= distance.getFromLocation() %></td>
                            <td><%= distance.getToLocation() %></td>
                            <td><%= distance.getDistanceKm() %></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="action-btn edit" onclick="editDistance(<%= distance.getId() %>)">
						    <span class="material-icons">edit</span>
						</button>


                                    <button class="action-btn delete" onclick="showDeleteModal(<%= distance.getId() %>)">
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
                            <td colspan="6">No Distances allocated.</td>
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
                    <p>Are you sure you want to delete this distance? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button class="search-btn secondary" onclick="closeDeleteModal()">Cancel</button>
                    <button class="search-btn primary" onclick="confirmDelete()">Delete</button>
                </div>
            </div>
        </div>
    </main>
    <script>
        let distanceToDelete = null;
        
        function showDeleteModal(distanceId) {
            distanceToDelete = distanceId;
            document.getElementById('deleteModal').style.display = 'block';
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').style.display = 'none';
            distanceToDelete = null;
        }

        function confirmDelete() {
            if (distanceToDelete !== null) {
                window.location.href = "<%= request.getContextPath() %>/distance?action=delete&distanceId=" + distanceToDelete;
            }
        }

        function editDistance(distanceId) {
            window.location.href = "<%= request.getContextPath() %>/distance?action=edit&distanceId=" + distanceId;
        }

        function searchDistances() {
            // Implement the search functionality if needed
        }
    </script>
</body>
</html>
