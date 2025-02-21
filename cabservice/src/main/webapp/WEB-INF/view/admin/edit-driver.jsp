<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Driver" %>

<%
    // ✅ Get driver from request attribute
    Driver driver = (Driver) request.getAttribute("driver");

    if (driver == null) {
        response.sendRedirect(request.getContextPath() + "/driver?action=list"); 
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Driver - Cab Service</title>
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
        .driver-form {
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
            
            <h1 class="page-title">Edit Driver</h1>
        </div>

        <!-- ✅ Updated Form to Include Existing Driver Details -->
        <form class="driver-form" id="driverForm" action="<%= request.getContextPath() %>/driver?action=update" method="post">
            <input type="hidden" name="driverId" value="<%= driver.getDriverId() %>">

            <div class="form-grid">
                <div class="form-field">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" value="<%= driver.getName() %>" required>
                </div>

                <div class="form-field">
                    <label for="nic">NIC Number *</label>
                    <input type="text" id="nic" name="nic" value="<%= driver.getNic() %>" required>
                </div>

                <div class="form-field">
                    <label for="licenseNumber">License Number *</label>
                    <input type="text" id="licenseNumber" name="licenseNumber" value="<%= driver.getLicenseNumber() %>" required>
                </div>

                <div class="form-field">
                    <label for="phoneNumber">Phone Number *</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" value="<%= driver.getPhoneNumber() %>" required>
                </div>

                <div class="form-field">
                    <label for="experience">Experience (Years) *</label>
                    <input type="number" id="experience" name="experience" value="<%= driver.getExperience() %>" min="0" required>
                </div>

                <div class="form-field">
                    <label for="availability">Availability *</label>
                    <select id="availability" name="availability" required>
                        <option value="true" <%= driver.isAvailability() ? "selected" : "" %>>Available</option>
                        <option value="false" <%= !driver.isAvailability() ? "selected" : "" %>>Unavailable</option>
                    </select>
                </div>

                <div class="form-buttons">
                   <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/driver?action=list'">
                        Cancel
                    </button>
                    <button type="submit" class="form-button primary">
                        Update Driver
                    </button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
