<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="com.cabservice.model.*" %>
<%@ page import="com.cabservice.service.*" %>
<%@ page import="com.cabservice.dao.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Settings - Mega City Cab</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #f5f5f5;
            color: #000000;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .main-content {
            padding: 40px 0;
        }

        .page-header {
            margin-top: 50px;
            margin-bottom: 24px;
            text-align: center;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #000000;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .page-title .material-icons {
            color: #FFC107;
            font-size: 32px;
        }

        .page-description {
            color: #666666;
            font-size: 16px;
        }

        .settings-container {
            display: grid;
            grid-template-columns: 1fr;
            gap: 24px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        @media (min-width: 768px) {
            .settings-container {
                grid-template-columns: 1fr;
                max-width: 600px;
                margin: 0 auto;
            }
        }

        .settings-content {
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
        }

        .settings-section {
            padding: 24px;
            border-bottom: 1px solid #e0e0e0;
        }

        .settings-section:last-child {
            border-bottom: none;
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #000000;
            border-left: 4px solid #FFC107;
            padding-left: 12px;
        }

        .overview-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .overview-table td {
            padding: 12px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 14px;
        }

        .overview-table td:first-child {
            font-weight: 500;
            color: #000000;
            width: 30%;
        }

        .overview-table td:last-child {
            color: #666666;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #000000;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #cccccc;
            border-radius: 6px;
            font-size: 14px;
            color: #000000;
            background-color: #fafafa;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #FFC107;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }

        .form-hint {
            margin-top: 6px;
            font-size: 12px;
            color: #666666;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 16px;
        }

        @media (min-width: 640px) {
            .form-row {
                grid-template-columns: 1fr 1fr;
            }
        }

        .form-footer {
            display: flex;
            justify-content: flex-end;
            margin-top: 24px;
            gap: 12px;
        }

        .btn-primary {
            padding: 12px 24px;
            background-color: #FFC107;
            color: #000000;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-primary:hover {
            background-color: #e0a800;
        }

        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
        }

        .alert-icon {
            margin-right: 12px;
            font-size: 20px;
        }

        .alert-success {
            background-color: #e6ffe6;
            color: #006400;
            border: 1px solid #b3ffb3;
        }

        .alert-error {
            background-color: #ffe6e6;
            color: #8b0000;
            border: 1px solid #ffcccc;
        }

        .password-strength {
            margin-top: 8px;
        }

        .strength-meter {
            height: 4px;
            background-color: #e0e0e0;
            border-radius: 2px;
            margin-top: 6px;
            overflow: hidden;
        }

        .strength-meter-fill {
            height: 100%;
            border-radius: 2px;
            transition: width 0.3s ease;
        }

        .strength-text {
            font-size: 12px;
            margin-top: 4px;
            color: #666666;
        }

        .strength-weak .strength-meter-fill {
            width: 25%;
            background-color: #ff4d4d;
        }

        .strength-medium .strength-meter-fill {
            width: 50%;
            background-color: #ff9900;
        }

        .strength-good .strength-meter-fill {
            width: 75%;
            background-color: #FFC107;
        }

        .strength-strong .strength-meter-fill {
            width: 100%;
            background-color: #006400;
        }
    </style>
</head>
<body>
    <jsp:include page="/Header.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">
                    <span class="material-icons">settings</span>
                    Account Settings
                </h1>
                <p class="page-description">Manage your Mega City Cab account information</p>
            </div>

            <div class="settings-container">
                <!-- Settings Content -->
                <div class="settings-content">
                    <!-- Success Message -->
                    <c:if test="${not empty success}">
                        <div id="successAlert" class="alert alert-success">
                            <span class="material-icons alert-icon">check_circle</span>
                            <span id="successMessage">${success}</span>
                        </div>
                    </c:if>

                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div id="errorAlert" class="alert alert-error">
                            <span class="material-icons alert-icon">error</span>
                            <span id="errorMessage">${error}</span>
                        </div>
                    </c:if>

                    <!-- Overview Section -->
                    <div class="settings-section">
                        <h2 class="section-title">Profile Overview</h2>
                        <table class="overview-table">
                            <tr>
                                <td>Full Name</td>
                                <td><%= request.getAttribute("name") != null ? request.getAttribute("name") : "Not set" %></td>
                            </tr>
                            <tr>
                                <td>Username</td>
                                <td><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Not set" %></td>
                            </tr>
                            <tr>
                                <td>Email</td>
                                <td><%= request.getAttribute("email") != null ? request.getAttribute("email") : "Not set" %></td>
                            </tr>
                            <tr>
                                <td>Phone Number</td>
                                <td><%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "Not set" %></td>
                            </tr>
                            <tr>
                                <td>Address</td>
                                <td><%= request.getAttribute("address") != null ? request.getAttribute("address") : "Not set" %></td>
                            </tr>
                            <tr>
                                <td>NIC</td>
                                <td><%= request.getAttribute("nic") != null ? request.getAttribute("nic") : "Not set" %></td>
                            </tr>
                        </table>
                    </div>

                    <!-- Personal Information Section -->
                    <div class="settings-section">
                        <h2 class="section-title">Edit Personal Information</h2>
                        <form id="personalInfoForm" action="<%= request.getContextPath() %>/customerProfile" method="post">
                            <input type="hidden" name="action" value="updatePersonalInfo">
                            <div class="form-group">
                                <label for="name" class="form-label">Full Name</label>
                                <input type="text" id="name" name="name" class="form-control" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" id="username" name="username" class="form-control" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" id="email" name="email" class="form-control" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="tel" id="phone" name="phone" class="form-control" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>
                                <p class="form-hint">We'll use this number to send you ride updates.</p>
                            </div>
                            <div class="form-group">
                                <label for="address" class="form-label">Address</label>
                                <input type="text" id="address" name="address" class="form-control" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="nic" class="form-label">NIC</label>
                                <input type="text" id="nic" name="nic" class="form-control" value="<%= request.getAttribute("nic") != null ? request.getAttribute("nic") : "" %>">
                            </div>
                            <div class="form-footer">
                                <button type="submit" class="btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>

                    <!-- Password Section -->
                    <div class="settings-section">
                        <h2 class="section-title">Change Password</h2>
                        <form id="passwordForm" action="<%= request.getContextPath() %>/customerProfile" method="post">
                            <input type="hidden" name="action" value="updatePassword">
                            <div class="form-group">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="newPassword" class="form-label">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                                <div class="password-strength" id="passwordStrength">
                                    <div class="strength-meter">
                                        <div class="strength-meter-fill"></div>
                                    </div>
                                    <div class="strength-text">Password strength: <span id="strengthText">Weak</span></div>
                                </div>
                                <p class="form-hint">Use at least 8 characters with a mix of letters, numbers, and symbols.</p>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                            </div>
                            <div class="form-footer">
                                <button type="submit" class="btn-primary">Update Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/Footer.jsp" />

    <script>
        // Show success message
        function showSuccess(message) {
            const successAlert = document.getElementById('successAlert');
            const successMessage = document.getElementById('successMessage');
            successMessage.textContent = message || 'Your changes have been saved successfully.';
            successAlert.style.display = 'flex';
            setTimeout(() => successAlert.style.display = 'none', 5000);
        }

        // Show error message
        function showError(message) {
            const errorAlert = document.getElementById('errorAlert');
            const errorMessage = document.getElementById('errorMessage');
            errorMessage.textContent = message || 'An error occurred. Please try again.';
            errorAlert.style.display = 'flex';
            setTimeout(() => errorAlert.style.display = 'none', 5000);
        }

        // Password Strength Meter
        document.getElementById('newPassword').addEventListener('input', function(e) {
            updatePasswordStrength(e.target.value);
        });

        function updatePasswordStrength(password) {
            const strengthMeter = document.getElementById('passwordStrength');
            const strengthText = document.getElementById('strengthText');
            strengthMeter.classList.remove('strength-weak', 'strength-medium', 'strength-good', 'strength-strong');

            if (!password) {
                strengthText.textContent = 'Weak';
                strengthMeter.classList.add('strength-weak');
                return;
            }

            let strength = 0;
            if (password.length >= 8) strength += 1;
            if (password.length >= 12) strength += 1;
            if (/[0-9]/.test(password)) strength += 1;
            if (/[a-z]/.test(password)) strength += 1;
            if (/[A-Z]/.test(password)) strength += 1;
            if (/[^a-zA-Z0-9]/.test(password)) strength += 1;

            if (strength <= 2) {
                strengthText.textContent = 'Weak';
                strengthMeter.classList.add('strength-weak');
            } else if (strength <= 4) {
                strengthText.textContent = 'Medium';
                strengthMeter.classList.add('strength-medium');
            } else if (strength <= 5) {
                strengthText.textContent = 'Good';
                strengthMeter.classList.add('strength-good');
            } else {
                strengthText.textContent = 'Strong';
                strengthMeter.classList.add('strength-strong');
            }
        }

        // Client-side validation for password form
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                showError('New passwords do not match.');
            }
        });
    </script>
</body>
</html>