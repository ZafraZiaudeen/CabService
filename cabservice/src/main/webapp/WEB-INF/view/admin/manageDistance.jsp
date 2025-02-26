<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Distance" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Distance - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
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
        <section class="section-table">
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
