<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Vehicles - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Available Vehicles</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by plate number, model, or capacity">
                <button onclick="searchVehicles()">
                    <span class="material-icons">search</span>
                </button>
            </div>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Plate Number</th>
                            <th>Model</th>
                            <th>Capacity</th>
                            <th>Rate Per KM</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody id="vehiclesTableBody">
                        <%
                            List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
                            if (vehicles != null && !vehicles.isEmpty()) {
                                for (Vehicle vehicle : vehicles) {
                                    if ("Available".equalsIgnoreCase(vehicle.getStatus())) { // ✅ Only display available vehicles
                        %>
                        <tr>
                            <td><%= vehicle.getPlateNumber() %></td>
                            <td><%= vehicle.getModel() %></td>
                            <td><%= vehicle.getCapacity() %> persons</td>
                            <td><%= vehicle.getRatePerKm() %> per km</td>
                            <td>Available</td>
                        </tr>
                        <%
                                    }
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5">No Available Vehicles found.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
