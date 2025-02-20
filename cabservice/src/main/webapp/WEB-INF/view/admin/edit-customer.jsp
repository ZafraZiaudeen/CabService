<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Customer" %>

<%
    // ✅ Get customer from request attribute
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
    <style>
        .main-content {
            margin-left: 300px;
            margin-top:30px;
            padding: 20px;
            transition: margin-left 0.3s ease;
        }
        .main-content.expanded {
            margin-left: 70px;
        }
        .page-header {
            display: flex;
            align-items: center;
            margin-bottom: 24px;
            gap: 16px;
        }
        .back-button {
            background: none;
            border: none;
            cursor: pointer;
            color: #4a5568;
            padding: 8px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            transition: background-color 0.2s;
        }
        .back-button:hover {
            background-color: #e2e8f0;
        }
        .page-title {
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }
        .customer-form {
            background-color: white;
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 800px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
        }
        .form-field {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .form-field label {
            font-size: 14px;
            font-weight: 500;
            color: #4a5568;
        }
        .form-field input,
        .form-field textarea {
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            width: 100%;
        }
        .form-field textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-field input:focus,
        .form-field textarea:focus {
            outline: none;
            border-color: #0984e3;
            box-shadow: 0 0 0 3px rgba(9, 132, 227, 0.1);
        }
        .form-buttons {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }
        .form-button {
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .form-button.primary {
            background-color: #0984e3;
            color: white;
            border: none;
        }
        .form-button.secondary {
            background-color: #e2e8f0;
            color: #4a5568;
            border: none;
        }
        .form-button:hover {
            opacity: 0.9;
        }
        @media (max-width: 768px) {
            .main-content {
                margin-left: 70px;
            }
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            
            <h1 class="page-title">Edit Customer</h1>
        </div>

        <form class="customer-form" id="customerForm" action="<%= request.getContextPath() %>/customer" method="post">
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
