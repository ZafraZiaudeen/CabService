<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Vehicle" %>

<%
    // ✅ Get vehicle from request attribute
    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");

    if (vehicle == null) {
        response.sendRedirect(request.getContextPath() + "/vehicle?action=list"); 
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Vehicle - Cab Service</title>
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
        .form-field input:focus,
        .form-field select:focus {
            outline: none;
            border-color: #0984e3;
            box-shadow: 0 0 0 3px rgba(9, 132, 227, 0.1);
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
    <!-- Include Sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Edit Vehicle</h1>
        </div>
  <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <!-- ✅ Updated Form with Existing Vehicle Details -->
        <form class="section-form" id="vehicleForm" action="<%= request.getContextPath() %>/vehicle?action=update" method="post">
            <input type="hidden" name="vehicleId" value="<%= vehicle.getId() %>">

            <div class="form-grid">
                <div class="form-field">
                    <label for="plateNumber">Plate Number *</label>
                    <input type="text" id="plateNumber" name="plateNumber" value="<%= vehicle.getPlateNumber() %>" required>
                </div>

                <div class="form-field">
                    <label for="model">Model *</label>
                    <input type="text" id="model" name="model" value="<%= vehicle.getModel() %>" required>
                </div>

                <div class="form-field">
                    <label for="capacity">Capacity *</label>
                    <input type="number" id="capacity" name="capacity" value="<%= vehicle.getCapacity() %>" min="1" required>
                </div>

                <div class="form-field">
                    <label for="ratePerKm">Rate per Km *</label>
                    <input type="text" id="ratePerKm" name="ratePerKm" value="<%= vehicle.getRatePerKm() %>" required>
                </div>

                <div class="form-field">
                    <label for="status">Status *</label>
                    <select id="status" name="status" required>
                        <option value="Available" <%= vehicle.getStatus().equals("Available") ? "selected" : "" %>>Available</option>
                        <option value="In Use" <%= vehicle.getStatus().equals("In Use") ? "selected" : "" %>>In Use</option>
                        <option value="Maintenance" <%= vehicle.getStatus().equals("Maintenance") ? "selected" : "" %>>Maintenance</option>
                    </select>
                </div>

                <div class="form-buttons">
                    <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/vehicle?action=list'">
                        Cancel
                    </button>
                    <button type="submit" class="form-button primary">
                        Update Vehicle
                    </button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
