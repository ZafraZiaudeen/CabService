<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminProfile.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />
    <div class="container">
        <div class="page-header">
            <h1 class="page-title">Profile Settings</h1>
        </div>

        <c:if test="${not empty message}">
            <p class="success-message">${message}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>

        <div class="profile-grid">
            <div class="profile-card">
                <h2 class="profile-name">${admin.name}</h2>
                <p class="profile-role">System Administrator</p>
            </div>

            <div class="main-card">
                <div class="tab-navigation">
                    <button class="tab-button active" data-tab="overview">Overview</button>
                    <button class="tab-button" data-tab="edit">Edit Profile</button>
                    <button class="tab-button" data-tab="password">Change Password</button>
                </div>

                <div class="tab-content">
                    <div class="tab-panel active" id="overview">
                        <div class="detail-row">
                            <div class="detail-label">Full Name</div>
                            <div class="detail-value">${admin.name}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Username</div> 
                            <div class="detail-value">${admin.username}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Phone</div>
                            <div class="detail-value">${admin.phoneNumber}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Email</div>
                            <div class="detail-value">${admin.email}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Address</div>
                            <div class="detail-value">${admin.address}</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Role</div>
                            <div class="detail-value">System Administrator</div>
                        </div>
                    </div>

                    <div class="tab-panel" id="edit">
                        <form id="profileForm" method="post" action="adminProfile">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="form-group">
                                <label class="form-label" for="fullName">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${admin.name}">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="username">Username</label> <!-- Changed from email to username -->
                                <input type="text" class="form-control" id="username" name="username" value="${admin.username}">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="phone">Phone</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${admin.phoneNumber}">
                            </div>
                              <div class="form-group">
                                <label class="form-label" for="phone">Phone</label>
                                <input type="email" class="form-control" id="email" name="email" value="${admin.email}">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="address">Address</label>
                                <input type="text" class="form-control" id="address" name="address" value="${admin.address}">
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <span class="material-icons">save</span>
                                Save Changes
                            </button>
                        </form>
                    </div>

                    <div class="tab-panel" id="password">
                        <form id="passwordForm" method="post" action="adminProfile">
                            <input type="hidden" name="action" value="updatePassword">
                            <div class="form-group">
                                <label class="form-label" for="currentPassword">Current Password</label>
                                <div class="password-field">
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                                    <button type="button" class="password-toggle">
                                        <span class="material-icons">visibility</span>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="newPassword">New Password</label>
                                <div class="password-field">
                                    <input type="password" class="form-control" id="newPassword" name="newPassword">
                                    <button type="button" class="password-toggle">
                                        <span class="material-icons">visibility</span>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="confirmPassword">Confirm New Password</label>
                                <div class="password-field">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                    <button type="button" class="password-toggle">
                                        <span class="material-icons">visibility</span>
                                    </button>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <span class="material-icons">lock</span>
                                Update Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tabButtons = document.querySelectorAll('.tab-button');
            const tabPanels = document.querySelectorAll('.tab-panel');

            tabButtons.forEach(button => {
                button.addEventListener('click', () => {
                    const tabId = button.dataset.tab;
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    tabPanels.forEach(panel => panel.classList.remove('active'));
                    button.classList.add('active');
                    document.getElementById(tabId).classList.add('active');
                });
            });

            const passwordToggles = document.querySelectorAll('.password-toggle');
            passwordToggles.forEach(toggle => {
                toggle.addEventListener('click', () => {
                    const input = toggle.previousElementSibling;
                    const icon = toggle.querySelector('.material-icons');
                    if (input.type === 'password') {
                        input.type = 'text';
                        icon.textContent = 'visibility_off';
                    } else {
                        input.type = 'password';
                        icon.textContent = 'visibility';
                    }
                });
            });
        });
    </script>
</body>
</html>