<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Vehicle" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Vehicles - Cab Service</title>
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
        .vehicles-table {
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
    </style>
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
        <section class="vehicles-table">
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
