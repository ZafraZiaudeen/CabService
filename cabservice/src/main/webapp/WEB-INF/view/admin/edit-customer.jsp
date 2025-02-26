<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Customer" %>

<%
  
    Customer customer = (Customer) request.getAttribute("customer");

    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/customer"); // Redirect to customer management page
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            
            <h1 class="page-title">Edit Customer</h1>
        </div>

        <form class="section-form" id="customerForm" action="<%= request.getContextPath() %>/customer" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="customerId" value="<%= customer.getUserId() %>">

            <div class="form-grid">
                <div class="form-field">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" value="<%= customer.getName() %>" required>
                </div>

                <div class="form-field">
                    <label for="nic">NIC Number *</label>
                    <input type="text" id="nic" name="nic" value="<%= customer.getNic() %>" required>
                </div>

                <div class="form-field">
                    <label for="phone">Phone Number *</label>
                    <input type="tel" id="phone" name="phone" value="<%= customer.getPhoneNumber() %>" required>
                </div>

                <div class="form-field">
                    <label for="username">Username *</label>
                    <input type="text" id="username" name="username" value="<%= customer.getUsername() %>" required>
                </div>

                <div class="form-field full-width">
                    <label for="address">Address *</label>
                    <textarea id="address" name="address" required><%= customer.getAddress() %></textarea>
                </div>

                <div class="form-buttons">
                    <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/customer'">
                        Cancel
                    </button>
                    <button type="submit" class="form-button primary">
                        Update Customer
                    </button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
