<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Mega City Cab</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/register.css' />">
</head>
<body>
    <div class="page-container">
        <div class="register-container">
            <div class="register-card">
                <div class="register-header">
                    <div class="logo">
                        <span class="logo-text">Mega City Cab</span>
                    </div>
                    <h1>Create an Account</h1>
                    <p class="subtitle">Join our community and enjoy premium cab services</p>
                </div>
 <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <span class="material-icons">error</span>
                        <span><%= request.getAttribute("errorMessage") %></span>
                    </div>
                <% } %>
                <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success">
                        <span class="material-icons">check_circle</span>
                        <span><%= request.getAttribute("successMessage") %></span>
                    </div>
                    <div class="success-actions">
                        <a href="user?action=login" class="btn btn-primary">
                            <span class="material-icons">login</span>
                            Log In Now
                        </a>
                    </div>
                <% } else if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success">
                        <span class="material-icons">check_circle</span>
                        <span><%= request.getAttribute("message") %></span>
                    </div>
                    <div class="success-actions">
                        <a href="user?action=login" class="btn btn-primary">
                            <span class="material-icons">arrow_forward</span>
                            Continue
                        </a>
                    </div>
                <% } else { %>
                    <form action="user?action=register" id="registrationForm" method="post" novalidate>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="name">Full Name</label>
                                <div class="input-with-icon">
                                    <span class="material-icons">person</span>
                                    <input type="text" id="name" name="name" placeholder="Enter your full name" required>
                                </div>
                                <div class="error-message" id="nameError"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="username">Username</label>
                                <div class="input-with-icon">
                                    <span class="material-icons">alternate_email</span>
                                    <input type="text" id="username" name="username" placeholder="Choose a username" required>
                                </div>
                                <div class="error-message" id="usernameError"></div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <div class="input-with-icon">
                                    <span class="material-icons">email</span>
                                    <input type="email" id="email" name="email" placeholder="Enter your email address" required>
                                </div>
                                <div class="error-message" id="emailError"></div>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <div class="input-with-icon">
                                    <span class="material-icons">phone</span>
                                    <input type="text" id="phone" name="phoneNumber" placeholder="Enter your phone number" required>
                                </div>
                                <div class="error-message" id="phoneError"></div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address">Address</label>
                            <div class="input-with-icon">
                                <span class="material-icons">home</span>
                                <input type="text" id="address" name="address" placeholder="Enter your address" required>
                            </div>
                            <div class="error-message" id="addressError"></div>
                        </div>

                        <div class="form-group">
                            <label for="nic">NIC</label>
                            <div class="input-with-icon">
                                <span class="material-icons">badge</span>
                                <input type="text" id="nic" name="nic" placeholder="Enter your NIC number" required>
                            </div>
                            <div class="error-message" id="nicError"></div>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <div class="input-with-icon">
                                <span class="material-icons">lock</span>
                                <input type="password" id="password" name="password" placeholder="Create a strong password" required>
                                <button type="button" class="toggle-password" onclick="togglePasswordVisibility()">
                                    <span class="material-icons">visibility_off</span>
                                </button>
                            </div>
                            <div class="password-strength" id="passwordStrength">
                                <div class="strength-meter">
                                    <div class="strength-meter-fill"></div>
                                </div>
                                <div class="strength-text">Password strength: <span id="strengthText">Weak</span></div>
                            </div>
                            <div class="error-message" id="passwordError"></div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <span class="material-icons">how_to_reg</span>
                                Register
                            </button>
                        </div>

                        <div class="form-footer">
                            <p>Already have an account? <a href="user?action=login">Log In</a></p>
                        </div>
                    </form>
                <% } %>

               
            </div>
        </div>
    </div>

    <script src="<c:url value='/js/register.js' />"></script>
</body>
</html>