<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Customer - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Add New Customer</h1>
        </div>

        <form class="section-form" id="customerForm" action="<%= request.getContextPath() %>/customer?action=save" method="post">
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
                    <label for="username">username *</label>
                    <input type="text" id="username" name="username" required>
                </div>
				<div class="form-field">
                    <label for="password">password *</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-field full-width">
                    <label for="address">Address *</label>
                    <textarea id="address" name="address" required></textarea>
                </div>

                <div class="form-buttons">
                    
                    <button type="submit" class="form-button primary">
                        Save Customer
                    </button>
                </div>
            </div>
        </form>
    </main>

</body>
</html>