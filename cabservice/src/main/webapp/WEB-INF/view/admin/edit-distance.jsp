<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Distance" %>

<%

    Distance distance = (Distance) request.getAttribute("distance");

    if (distance == null) {
        response.sendRedirect(request.getContextPath() + "/distance?action=list"); 
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Distance - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Edit Distance</h1>
        </div>

        <!-- Updated Form to Include Existing Distance Details -->
        <form class="section-form" id="distanceForm" action="<%= request.getContextPath() %>/distance?action=update" method="post">
            <input type="hidden" name="distanceId" value="<%= distance.getId() %>">

            <div class="form-grid">
                <div class="form-field">
                    <label for="startLocation">Start Location *</label>
                    <input type="text" id="from_location" name="from_location" value="<%= distance.getFromLocation() %>" required>
                </div>

                <div class="form-field">
                    <label for="endLocation">End Location *</label>
                    <input type="text" id="to_location" name="to_location" value="<%= distance.getToLocation() %>" required>
                </div>

                <div class="form-field">
                    <label for="distanceKm">Distance (in km) *</label>
                    <input type="number" id="distance_km" name="distance_km" value="<%= distance.getDistanceKm() %>" min="0" required>
                </div>

                <div class="form-buttons">
                    <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/distance?action=list'">
                        Cancel
                    </button>
                    <button type="submit" class="form-button primary">
                        Update Distance
                    </button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
