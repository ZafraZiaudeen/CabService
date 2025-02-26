<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.SystemConfig" %>

<%
    // Get systemConfig from request attribute
    SystemConfig systemConfig = (SystemConfig) request.getAttribute("config");

    if (systemConfig == null) {
        response.sendRedirect(request.getContextPath() + "/system-config?action=view"); 
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Tax/Discount - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/tax.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Edit Tax/Discount</h1>
        </div>

        <!-- Updated Form to Include Existing Tax/Discount Details -->
        <form class="form-container" id="taxDiscountForm" action="<%= request.getContextPath() %>/system-config?action=update" method="post">
            <input type="hidden" name="configId" value="<%= systemConfig.getId() %>">

            <div class="form-grid">
                <div class="form-field">
                    <label for="tax_rate">Tax Rate (%) *</label>
                    <input type="number" id="tax_rate" name="tax_rate" value="<%= systemConfig.getTaxRate() %>" step="0.01" min="0" required>
                </div>

                <div class="form-field">
                    <label for="discount_rate">Discount Rate (%) *</label>
                    <input type="number" id="discount_rate" name="discount_rate" value="<%= systemConfig.getDiscountRate() %>" step="0.01" min="0" required>
                </div>

                <div class="form-buttons">
                    <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/system-config?action=view'">
                        Cancel
                    </button>
                    <button type="submit" class="form-button primary">
                        Update Tax/Discount
                    </button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
