<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Routes - SwiftRide</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
   <link rel="stylesheet" href="<c:url value='/css/routes.css'/>">
</head>
<body>
    <jsp:include page="/Header.jsp" />

    <main class="routes-page">
        <div class="page-header">
            <h1 class="page-title">
                <span class="material-icons">map</span>
                Available Routes
            </h1>
            <p class="page-subtitle">Explore our service routes and plan your journey</p>
        </div>

        <%-- Display error message if present --%>
        <% 
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div style="background-color: #ffebee; color: #c62828; padding: 16px 20px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                <span class="material-icons">error</span>
                <%= error %>
            </div>
        <% } %>

        <div class="search-container">
            <div class="search-box">
                <span class="material-icons">search</span>
                <input type="text" id="routeSearch" placeholder="Search for routes, locations...">
            </div>
        </div>

        <div class="view-toggle">
            <button class="toggle-btn active" data-view="grid">
                <span class="material-icons">grid_view</span> Grid View
            </button>
            <button class="toggle-btn" data-view="table">
                <span class="material-icons">view_list</span> Table View
            </button>
        </div>

        <%-- Routes Container with Scrollbar --%>
        <div class="routes-container">
            <%
                List<Map<String, Object>> routes = (List<Map<String, Object>>) request.getAttribute("routes");

                if (routes != null && !routes.isEmpty()) {
                    int count = 1; // Initialize counter for routes
            %>
                <!-- Grid View -->
                <div class="routes-grid" id="gridView">
                    <%
                        for (Map<String, Object> route : routes) {
                            double distance = (Double) route.get("distance_km");
                    %>
                        <div class="route-card">
                            <div class="route-header">
                                <h3 class="route-title">Route #<%= count %></h3>
                                <div class="route-distance">
                                    <span class="material-icons">straighten</span>
                                    <%= String.format("%.1f", distance) %> km
                                </div>
                            </div>
                            <div class="route-content">
                                <div class="route-locations">
                                    <div class="location-item">
                                        <div class="location-label">From</div>
                                        <div class="location-name"><%= route.get("from_location") %></div>
                                    </div>
                                    <div class="location-item">
                                        <div class="location-label">To</div>
                                        <div class="location-name"><%= route.get("to_location") %></div>
                                    </div>
                                </div>
                            </div>
                            <div class="route-footer">
                                <a href="<%= request.getContextPath() %>/customerBooking?from=<%= route.get("from_location") %>&to=<%= route.get("to_location") %>" class="btn-book">
                                    <span class="material-icons">directions_car</span> Book Now
                                </a>
                            </div>
                        </div>
                    <%
                            count++; // Increment counter
                        }
                    %>
                </div>

                <!-- Table View with Scrollbar -->
                <div class="table-wrapper" id="tableView" style="display: none;">
                    <table class="routes-table">
                        <thead>
                            <tr>
                                <th>Route #</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Distance</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                count = 1; // Reset counter for table view
                                for (Map<String, Object> route : routes) {
                                    double distance = (Double) route.get("distance_km");
                            %>
                                <tr>
                                    <td data-label="Route #"><%= count %></td>
                                    <td data-label="From"><%= route.get("from_location") %></td>
                                    <td data-label="To"><%= route.get("to_location") %></td>
                                    <td data-label="Distance"><%= String.format("%.1f", distance) %> km</td>
                                    <td data-label="Action">
                                        <a href="<%= request.getContextPath() %>/customerBooking?from=<%= route.get("from_location") %>&to=<%= route.get("to_location") %>" class="btn-book">
                                            <span class="material-icons">directions_car</span> Book
                                        </a>
                                    </td>
                                </tr>
                            <%
                                    count++; // Increment counter
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            <%
                } else {
            %>
                <div class="empty-state">
                    <span class="material-icons">route</span>
                    <h3>No Routes Available</h3>
                    <p>We're currently expanding our service areas. Please check back later for available routes.</p>
                </div>
            <%
                }
            %>
        </div>
    </main>

    <jsp:include page="/Footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggleButtons = document.querySelectorAll('.toggle-btn');
            const gridView = document.getElementById('gridView');
            const tableView = document.getElementById('tableView');
            
            toggleButtons.forEach(button => {
                button.addEventListener('click', function() {
                    toggleButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    const viewType = this.getAttribute('data-view');
                    if (viewType === 'grid') {
                        gridView.style.display = 'grid';
                        tableView.style.display = 'none';
                    } else {
                        gridView.style.display = 'none';
                        tableView.style.display = 'block';
                    }
                });
            });
            
            const searchInput = document.getElementById('routeSearch');
            
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                
                const routeCards = document.querySelectorAll('.route-card');
                routeCards.forEach(card => {
                    const fromLocation = card.querySelector('.location-item:first-child .location-name').textContent.toLowerCase();
                    const toLocation = card.querySelector('.location-item:last-child .location-name').textContent.toLowerCase();
                    
                    if (fromLocation.includes(searchTerm) || toLocation.includes(searchTerm)) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
                
                const tableRows = document.querySelectorAll('.routes-table tbody tr');
                tableRows.forEach(row => {
                    const fromLocation = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                    const toLocation = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                    
                    if (fromLocation.includes(searchTerm) || toLocation.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        });
    </script>
</body>
</html>