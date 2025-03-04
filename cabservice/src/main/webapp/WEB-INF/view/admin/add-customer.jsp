<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Customer - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
    <style>
     
    </style>
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Add New Customer</h1>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error-message">
                <span class="material-icons">error_outline</span>
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message success-message">
                <span class="material-icons">check_circle</span>
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>

        <form class="section-form" id="customerForm" action="<%= request.getContextPath() %>/customer" method="post">
            <input type="hidden" name="action" value="save">
            <div class="form-grid">
                <div class="form-field">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" required>
                </div>

                <div class="form-field">
                    <label for="nic">NIC Number *</label>
                    <input type="text" id="nic" name="nic" required>
                </div>

                <div class="form-field">
                    <label for="phone">Phone Number *</label>
                    <input type="tel" id="phone" name="phone" required>
                </div>

                <div class="form-field">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-field">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username"required>
                </div>

                <div class="form-field">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <div class="form-field full-width">
                    <label for="address">Address *</label>
                    <textarea id="address" name="address" required></textarea>
                </div>

                <div class="form-buttons">
                    <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/customer'">
                        Cancel
                    </button>
                    <button type="submit" class="form-button primary">
                        Save Customer
                    </button>
                </div>
            </div>
        </form>
    </main>

    <script>
        document.getElementById("customerForm").addEventListener("submit", function(event) {
            const email = document.getElementById("email").value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert("Please enter a valid email address.");
                event.preventDefault();
            }
        });
    </script>
</body>
</html>