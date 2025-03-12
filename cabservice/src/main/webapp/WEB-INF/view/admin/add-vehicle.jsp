<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Vehicle - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
    <style>
        .form-field label {
            font-size: 14px;
            font-weight: 500;
            color: #4a5568;
        }

        .form-field input,
        .form-field select {
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            width: 100%;
        }

        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 10px;
            text-align: center;
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Add New Vehicle</h1>
        </div>
  <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form class="section-form" id="vehicleForm" action="<%= request.getContextPath() %>/vehicle?action=save" method="post">
            <div class="form-grid">
                <div class="form-field">
                    <label for="plateNumber">Plate Number *</label>
                    <input type="text" id="plateNumber" name="plateNumber" required>
                </div>

                <div class="form-field">
                    <label for="model">Vehicle Model *</label>
                    <input type="text" id="model" name="model" required>
                </div>

                <div class="form-field">
                    <label for="capacity">Capacity *</label>
                    <input type="number" id="capacity" name="capacity" min="1" required>
                </div>

                <div class="form-field">
                    <label for="ratePerKm">Rate Per Km *</label>
                    <input type="number" id="ratePerKm" name="ratePerKm" step="0.01" required>
                </div>

                <div class="form-field">
                    <label for="status">Status *</label>
                    <select id="status" name="status" required>
                        <option value="Available">Available</option>
                        <option value="Unavailable">Unavailable</option>
                    </select>
                </div>

                <div class="form-buttons">
                    <button type="submit" class="form-button primary">Save Vehicle</button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
