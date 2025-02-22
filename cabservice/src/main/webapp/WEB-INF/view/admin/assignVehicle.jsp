<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.cabservice.model.Assignment" %>
<%@ page import="com.cabservice.service.AssignmentService" %>
<%
    AssignmentService service = new AssignmentService();
    List<Assignment> assignments = service.getAllAssignments();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver-Vehicle Assignments - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        :root {
            --primary-color: #0984e3;
            --secondary-color: #2d3436;
            --background-color: #f5f6fa;
            --surface-color: #ffffff;
            --error-color: #d63031;
            --success-color: #00b894;
            --border-color: #dfe6e9;
            --text-primary: #2d3436;
            --text-secondary: #636e72;
        }

        body {
            background-color: var(--background-color);
            color: var(--text-primary);
        }

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
            padding: 0 4px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .add-button {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: background-color 0.2s;
        }

        .add-button:hover {
            background-color: #0773c5;
        }

        .add-button .material-icons {
            font-size: 20px;
        }

        .assignments-table {
            background-color: var(--surface-color);
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
            min-height: 400px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }

        thead {
            background-color: #f8fafc;
            border-bottom: 2px solid var(--border-color);
        }

        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid var(--border-color);
            font-size: 14px;
            color: var(--text-primary);
        }

        tr:hover {
            background-color: #f8fafc;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .status-badge.active {
            background-color: #e1f8e9;
            color: #00b894;
        }

        .driver-info, .vehicle-info {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-icon {
            color: var(--text-secondary);
            font-size: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-button {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 4px;
            border: none;
            transition: all 0.2s;
        }

        .action-button.unassign {
            background-color: #fff3f3;
            color: var(--error-color);
        }

        .action-button.unassign:hover {
            background-color: #ffe9e9;
        }

        .action-button .material-icons {
            font-size: 16px;
        }

        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 48px 20px;
            text-align: center;
            color: var(--text-secondary);
        }

        .empty-state .material-icons {
            font-size: 48px;
            margin-bottom: 16px;
            color: var(--border-color);
        }

        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 8px;
        }

        .empty-state p {
            font-size: 14px;
            max-width: 300px;
            margin-bottom: 24px;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 70px;
                padding: 16px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .add-button {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Driver-Vehicle Assignments</h1>
            <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/assignment?action=add'">
                <span class="material-icons">add</span>
                New Assignment
            </button>
        </div>

        <section class="assignments-table">
            <div class="table-container">
                <% if (assignments != null && !assignments.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Driver</th>
                                <th>Plate Number</th>
                                <th>Model</th>
                                <th>Assigned Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                       <tbody>
    <% for (Assignment assignment : assignments) { %>
        <tr>
            <td>
                <div class="driver-info">
                    <span class="material-icons info-icon">person</span>
                    <%= (assignment.getDriverName() != null) ? assignment.getDriverName() : "Unknown Driver" %>
                </div>
            </td>
            <td>
                <div class="vehicle-info">
                    <span class="material-icons info-icon">directions_car</span>
                    <%= (assignment.getVehiclePlate() != null) ? assignment.getVehiclePlate() : "Unknown Vehicle" %>
                </div>
            </td>
            <td>
    <div class="vehicle-info">
        <span class="material-icons info-icon">directions_car</span>
        <%= (assignment.getVehicleModel() != null) ? assignment.getVehicleModel()  : "Unknown Vehicle" %>
    </div>
</td>
            
            <td>
                <div class="date-info">
                    <%= assignment.getAssignedAt() %>
                </div>
            </td>
            <td>
                <span class="status-badge active">
                    <span class="material-icons">check_circle</span>
                    Active
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <form action="<%= request.getContextPath() %>/assignment" method="post" style="margin: 0;">
    <input type="hidden" name="action" value="unassign">
    <input type="hidden" name="driverId" value="<%= assignment.getDriverId() %>">
    <input type="hidden" name="vehicleId" value="<%= assignment.getVehicleId() %>">
    <button type="submit" class="action-button unassign">
        <span class="material-icons">link_off</span>
        Unassign
    </button>
</form>
                </div>
            </td>
        </tr>
    <% } %>
</tbody>

                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <span class="material-icons">assignment</span>
                        <h3>No Assignments Found</h3>
                        <p>There are currently no driver-vehicle assignments. Create a new assignment to get started.</p>
                        <button class="add-button" onclick="window.location.href='<%= request.getContextPath() %>/assignment?action=add'">
                            <span class="material-icons">add</span>
                            Create Assignment
                        </button>
                    </div>
                <% } %>
            </div>
        </section>
    </main>

    <script>
        // Handle sidebar toggle affecting main content
        document.addEventListener('DOMContentLoaded', function() {
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sidebar');
            
            // Listen for sidebar toggle events
            document.getElementById('toggleBtn').addEventListener('click', function() {
                mainContent.classList.toggle('expanded');
            });

            // Handle responsive behavior
            function handleResize() {
                if (window.innerWidth <= 768) {
                    mainContent.classList.add('expanded');
                } else if (!sidebar.classList.contains('collapsed')) {
                    mainContent.classList.remove('expanded');
                }
            }

            handleResize();
            window.addEventListener('resize', handleResize);
        });
    </script>
</body>
</html>