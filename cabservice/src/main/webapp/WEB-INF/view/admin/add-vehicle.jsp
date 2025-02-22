<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Vehicle - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        .main-content {
            margin-left: 300px;
            margin-top: 30px;
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

        .page-title {
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }

        .vehicle-form {
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
            <h1 class="page-title">Add New Vehicle</h1>
        </div>

        <form class="vehicle-form" id="vehicleForm" action="<%= request.getContextPath() %>/vehicle?action=save" method="post">
            <div class="form-grid">
                <div class="form-field">
                    <label for="plateNumber">Plate Number *</label>
                    <input type="text" id="plateNumber" name="plateNumber" required>
                </div>

                <div class="form-field">
                    <label for="model">Vehicle Model *</label>
                    <input type="text" id="model" name="model" required>
                </div>

                <div class="form-field">
                    <label for="capacity">Capacity *</label>
                    <input type="number" id="capacity" name="capacity" min="1" required>
                </div>

                <div class="form-field">
                    <label for="ratePerKm">Rate Per Km *</label>
                    <input type="number" id="ratePerKm" name="ratePerKm" step="0.01" required>
                </div>

                <div class="form-field">
                    <label for="status">Status *</label>
                    <select id="status" name="status" required>
                        <option value="Available">Available</option>
                        <option value="Unavailable">Unavailable</option>
                    </select>
                </div>

                <div class="form-buttons">
                    <button type="submit" class="form-button primary">Save Vehicle</button>
                </div>
            </div>
        </form>
    </main>
</body>
</html>
