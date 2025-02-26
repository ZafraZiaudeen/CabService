<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Driver" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Active Drivers - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminManagement.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Active Drivers</h1>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" id="search" placeholder="Search by name, NIC, phone, or email">
                <button onclick="searchDrivers()">
                    <span class="material-icons">search</span>
                </button>
            </div>
        </div>
        <section class="section-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>NIC</th>
                            <th>License Number</th>
                            <th>Phone Number</th>
                            <th>Experience</th>
                            <th>Availability</th>
                        </tr>
                    </thead>
                    <tbody id="driversTableBody">
                        <%
                            List<Driver> drivers = (List<Driver>) request.getAttribute("drivers");
                            if (drivers != null && !drivers.isEmpty()) {
                                for (Driver driver : drivers) {
                                    if (driver.isAvailability()) { // ✅ Only display active drivers
                        %>
                        <tr>
                            <td><%= driver.getName() %></td>
                            <td><%= driver.getNic() %></td>
                            <td><%= driver.getLicenseNumber() %></td>
                            <td><%= driver.getPhoneNumber() %></td>
                            <td><%= driver.getExperience() %> years</td>
                            <td>Available</td>
                        </tr>
                        <%
                                    }
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6">No Active Drivers found.</td>
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
