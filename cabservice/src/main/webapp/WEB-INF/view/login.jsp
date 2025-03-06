<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Mega City Cab</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/login.css' />">
</head>
<body>
    <div class="page-container">
        <div class="login-container">
            <div class="login-card">
                <div class="login-header">
                    <div class="logo">
                        <span class="logo-text">Mega City Cab</span>
                    </div>
                    <h1>Welcome Back</h1>
                    <p class="subtitle">Log in to access your account</p>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <span class="material-icons">error</span>
                        <span><%= request.getAttribute("errorMessage") %></span>
                    </div>
                <% } %>

                <form action="user?action=login" id="loginForm" method="post" novalidate>
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-with-icon">
                            <span class="material-icons">person</span>
                            <input type="text" id="username" name="username" placeholder="Enter your username" required>
                        </div>
                        <div class="error-message" id="usernameError"></div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-with-icon">
                            <span class="material-icons">lock</span>
                            <input type="password" id="password" name="password" placeholder="Enter your password" required>
                            <button type="button" class="toggle-password" onclick="togglePasswordVisibility()">
                                <span class="material-icons">visibility_off</span>
                            </button>
                        </div>
                        <div class="error-message" id="passwordError"></div>
                    </div>


                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <span class="material-icons">login</span>
                            Log In
                        </button>
                    </div>

                    <div class="form-footer">
                        <p>Don't have an account? <a href="user?action=register">Sign Up</a></p>
                        <p><a href="user?action=home" class="back-home">
                            <span class="material-icons">home</span>
                            Back to Home
                        </a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>

     <script src="<c:url value='/js/login.js' />"></script>
</body>
</html>

