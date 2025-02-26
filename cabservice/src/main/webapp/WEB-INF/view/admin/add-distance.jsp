<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Distance - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Add Distance</h1>
        </div>

        <form class="section-form" id="distanceForm" action="<%= request.getContextPath() %>/distance?action=save" method="post">
            <div class="form-grid">
                <div class="form-field">
                    <label for="from_location">From Location *</label>
                    <input type="text" id="from_location" name="from_location" required>
                </div>

                <div class="form-field">
                    <label for="to_location">To Location *</label>
                    <input type="text" id="to_location" name="to_location" required>
                </div>

                <div class="form-field">
                    <label for="distance_km">Distance (in km) *</label>
                    <input type="number" id="distance_km" name="distance_km" step="0.01" min="0" required>
                </div>

                <div class="form-buttons">
                    <button type="submit" class="form-button primary">
                        Save Distance
                    </button>
                </div>
            </div>
        </form>
    </main>

    <script>
        // Handle form submission
        function handleSubmit(event) {
            event.preventDefault();
            
            // Get form data
            const formData = {
                fromLocation: document.getElementById('from_location').value,
                toLocation: document.getElementById('to_location').value,
                distanceKm: document.getElementById('distance_km').value
            };

            // Here you would typically make an API call to save the distance
            console.log('Saving distance:', formData);

            // Redirect back to distance list
            window.location.href = 'manage-distances.jsp';
        }

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
    </script>
</body>
</html>
