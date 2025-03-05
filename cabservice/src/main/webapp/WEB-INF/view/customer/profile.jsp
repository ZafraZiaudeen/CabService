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
    <link rel="stylesheet" href="<c:url value='/css/customerProfile.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">

</head>
<body>
    <jsp:include page="/Header.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <!-- Alerts at the top of main-content -->

        <% if (request.getAttribute("success") != null) { %>
         <div id="successAlert" class="alert alert-success">
         	<div class="alert-msg-box">
	         	<span class="material-icons alert-icon">check_circle</span>
	             <span><%= request.getAttribute("success") %></span>
         	</div>
         </div>
        <% request.removeAttribute("success"); /* Clear the attribute! */ } %>


        <% if (request.getAttribute("error") != null) { %>
         <div id="errorAlert" class="alert alert-error">
         <div class="alert-msg-box">
         	<span class="material-icons alert-icon">error</span>
             <span><%= request.getAttribute("error") %></span>
         </div>
         </div>
        <% request.removeAttribute("error"); /* Clear the attribute! */ } %>



        <div class="container">
            <div class="page-header">
                <h1 class="page-title">
                    <span class="material-icons">settings</span>
                    Account Settings
                </h1>
                <p class="page-description">Manage your Mega City Cab account information</p>
            </div>

            <div class="settings-container">
                <!-- Settings Navigation -->
                <div class="settings-nav">
                    <button class="nav-item active" data-target="overview">
                        <span class="material-icons">person</span>
                        Profile Overview
                    </button>
                    <button class="nav-item" data-target="personal-info">
                        <span class="material-icons">edit</span>
                        Personal Information
                    </button>
                    <button class="nav-item" data-target="password">
                        <span class="material-icons">lock</span>
                        Password
                    </button>
                </div>

                <!-- Settings Content -->
                <div class="settings-content">
                    <!-- Overview Section -->
                    <div id="overview" class="settings-section active">
                        <h2 class="section-title">Profile Overview</h2>
                        <div class="profile-card">
                            <div class="profile-header">
                                <div class="profile-avatar">
                                    <span class="material-icons">account_circle</span>
                                </div>
                                <div class="profile-info">
                                    <h3 class="profile-name" id="overviewName"><%= request.getAttribute("name") != null ? request.getAttribute("name") : "Not set" %></h3>
                                    <p class="profile-username" id="overviewUsername">@<%= request.getAttribute("username") != null ? request.getAttribute("username") : "username" %></p>
                                </div>
                            </div>
                            <div class="profile-details">
                                <div class="detail-item">
                                    <span class="material-icons">email</span>
                                    <div class="detail-content">
                                        <p class="detail-label">Email</p>
                                        <p class="detail-value" id="overviewEmail"><%= request.getAttribute("email") != null ? request.getAttribute("email") : "Not set" %></p>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <span class="material-icons">phone</span>
                                    <div class="detail-content">
                                        <p class="detail-label">Phone</p>
                                        <p class="detail-value" id="overviewPhone"><%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "Not set" %></p>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <span class="material-icons">home</span>
                                    <div class="detail-content">
                                        <p class="detail-label">Address</p>
                                        <p class="detail-value" id="overviewAddress"><%= request.getAttribute("address") != null ? request.getAttribute("address") : "Not set" %></p>
                                    </div>
                                </div>
                                <div class="detail-item">
                                    <span class="material-icons">badge</span>
                                    <div class="detail-content">
                                        <p class="detail-label">NIC</p>
                                        <p class="detail-value" id="overviewNic"><%= request.getAttribute("nic") != null ? request.getAttribute("nic") : "Not set" %></p>
                                    </div>
                                </div>
                            </div>
                            <div class="profile-actions">
                                <button class="btn-secondary" onclick="showSection('personal-info')">
                                    <span class="material-icons">edit</span>
                                    Edit Profile
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Personal Information Section -->
                    <div id="personal-info" class="settings-section">
                        <h2 class="section-title">Edit Personal Information</h2>
                        <form id="personalInfoForm" action="<%= request.getContextPath() %>/customerProfile" method="post">
                            <input type="hidden" name="action" value="updatePersonalInfo">
                            <div class="form-group">
                                <label for="name" class="form-label">Full Name</label>
                                <div class="input-with-icon">
                                    <input type="text" id="name" name="name" class="form-control" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="username" class="form-label">Username</label>
                                <div class="input-with-icon">
                                    <input type="text" id="username" name="username" class="form-control" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class="form-label">Email Address</label>
                                <div class="input-with-icon">
                                    <input type="email" id="email" name="email" class="form-control" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="phone" class="form-label">Phone Number</label>
                                <div class="input-with-icon">
                                    <input type="tel" id="phone" name="phone" class="form-control" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="address" class="form-label">Address</label>
                                <div class="input-with-icon">
                                    <input type="text" id="address" name="address" class="form-control" value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="nic" class="form-label">NIC</label>
                                <div class="input-with-icon">
                                    <input type="text" id="nic" name="nic" class="form-control" value="<%= request.getAttribute("nic") != null ? request.getAttribute("nic") : "" %>">
                                </div>
                            </div>
                            <div class="form-footer">
                                <button type="button" class="btn-outline" onclick="showSection('overview')">Cancel</button>
                                <button type="submit" class="btn-primary">Save Changes</button>
                            </div>
                        </form>
                    </div>

                    <!-- Password Section -->
                    <div id="password" class="settings-section">
                        <h2 class="section-title">Change Password</h2>
                        <form id="passwordForm" action="<%= request.getContextPath() %>/customerProfile" method="post">
                            <input type="hidden" name="action" value="updatePassword">
                            <div class="form-group">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <div class="input-with-icon">
                                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="newPassword" class="form-label">New Password</label>
                                <div class="input-with-icon">
                                    <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                                </div>
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
                                <div class="input-with-icon">
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-footer">
                                <button type="button" class="btn-outline" onclick="showSection('overview')">Cancel</button>
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
       
       function showAlert(alertId) {
           const alert = document.getElementById(alertId);
           if (alert) {
               alert.classList.add('show');
               
               // Automatically hide after 5 seconds
               setTimeout(() => {
                   closeAlert(alertId);
               }, 5000);
           }
       }

       function closeAlert(alertId) {
           const alert = document.getElementById(alertId);
           if (alert) {
               alert.classList.remove('show');
               alert.classList.add('hide');
               
               // Remove the alert from DOM after animation completes
               setTimeout(() => {
                   alert.classList.remove('hide');
                   alert.style.display = 'none';
               }, 400);
           }
       }

       // Call showAlert for success and error alerts when page loads
       document.addEventListener("DOMContentLoaded", () => {
           const successAlert = document.getElementById('successAlert');
           const errorAlert = document.getElementById('errorAlert');

           if (successAlert) {
               showAlert('successAlert');
           }

           if (errorAlert) {
               showAlert('errorAlert');
           }
       });

        // Initialize the page
        document.addEventListener("DOMContentLoaded", () => {
            // Set up navigation
            const navItems = document.querySelectorAll(".nav-item");
            navItems.forEach((item) => {
                item.addEventListener("click", function () {
                    const target = this.getAttribute("data-target");
                    showSection(target);
                });
            });

            // Check for initial success or error messages from server and handle navigation
            const errorMessage = "<%= request.getAttribute("error") %>";

            if (errorMessage) {
                const action = "<%= request.getParameter("action") %>"; 
                if (action === "updatePersonalInfo") {
                    showSection("personal-info");
                } else if (action === "updatePassword") {
                    showSection("password");
                } else {
                    showSection("overview"); // Default to overview if no action
                }
            }


            // Set up password strength meter
            const newPasswordInput = document.getElementById("newPassword");
            if (newPasswordInput) {
                updatePasswordStrength(newPasswordInput.value); // Initial call
                newPasswordInput.addEventListener("input", function () {
                    updatePasswordStrength(this.value);
                });
            }

            // Initialize profile overview with form values
            updateProfileOverview();
        });

        // Show a specific section and handle success message for overview
        function showSection(sectionId) {
            const sections = document.querySelectorAll(".settings-section");
            sections.forEach((section) => {
                section.classList.remove("active");
            });

            const selectedSection = document.getElementById(sectionId);
            if (selectedSection) {
                selectedSection.classList.add("active");
            }

            const navItems = document.querySelectorAll(".nav-item");
            navItems.forEach((item) => {
                item.classList.remove("active");
                if (item.getAttribute("data-target") === sectionId) {
                    item.classList.add("active");
                }
            });
        }

         // Update password strength meter
        function updatePasswordStrength(password) {
            const strengthMeter = document.getElementById("passwordStrength");
            const strengthText = document.getElementById("strengthText");
            const strengthMeterFill = document.querySelector(".strength-meter-fill");

            if (!strengthMeter || !strengthText || !strengthMeterFill) return;

            // Reset classes and bar
            strengthMeter.classList.remove("strength-weak", "strength-medium", "strength-good", "strength-strong");
            strengthMeterFill.style.width = "0"; // Reset fill width

            if (!password || password.trim() === "") {
                strengthText.textContent = "Weak";
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
                strengthText.textContent = "Weak";
                strengthMeter.classList.add("strength-weak");
                strengthMeterFill.style.width = "25%";
            } else if (strength <= 4) {
                strengthText.textContent = "Medium";
                strengthMeter.classList.add("strength-medium");
                strengthMeterFill.style.width = "50%";
            } else if (strength <= 5) {
                strengthText.textContent = "Good";
                strengthMeter.classList.add("strength-good");
                strengthMeterFill.style.width = "75%";
            } else {
                strengthText.textContent = "Strong";
                strengthMeter.classList.add("strength-strong");
                strengthMeterFill.style.width = "100%";
            }
        }

        // Update profile overview with form values
        function updateProfileOverview() {
            const name = document.getElementById("name").value || "<%= request.getAttribute("name") != null ? request.getAttribute("name") : "Not set" %>";
            const username = document.getElementById("username").value || "<%= request.getAttribute("username") != null ? request.getAttribute("username") : "username" %>";
            const email = document.getElementById("email").value || "<%= request.getAttribute("email") != null ? request.getAttribute("email") : "Not set" %>";
            const phone = document.getElementById("phone").value || "<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "Not set" %>";
            const address = document.getElementById("address").value || "<%= request.getAttribute("address") != null ? request.getAttribute("address") : "Not set" %>";
            const nic = document.getElementById("nic").value || "<%= request.getAttribute("nic") != null ? request.getAttribute("nic") : "Not set" %>";

            document.getElementById("overviewName").textContent = name;
            document.getElementById("overviewUsername").textContent = "@" + username;
            document.getElementById("overviewEmail").textContent = email;
            document.getElementById("overviewPhone").textContent = phone;
            document.getElementById("overviewAddress").textContent = address;
            document.getElementById("overviewNic").textContent = nic;
        }

    </script>
</body>
</html>