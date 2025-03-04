<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Dashboard</title>
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

        <div class="profile-grid">
            <div class="profile-card">
                <h2 class="profile-name">John Doe</h2>
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
                            <div class="detail-value">John Doe</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Email</div>
                            <div class="detail-value">john.doe@example.com</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Phone</div>
                            <div class="detail-value">+1 (234) 567-8900</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Address</div>
                            <div class="detail-value">123 Admin Street, Dashboard City, 12345</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">Role</div>
                            <div class="detail-value">System Administrator</div>
                        </div>
                        <div class="detail-row">
                            <div class="detail-label">About</div>
                            <div class="detail-value">Experienced system administrator with a focus on maintaining and optimizing enterprise-level applications.</div>
                        </div>
                    </div>

                    <div class="tab-panel" id="edit">
                        <form id="profileForm">
                            <div class="form-group">
                                <label class="form-label" for="fullName">Full Name</label>
                                <input type="text" class="form-control" id="fullName" value="John Doe">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="email">Email</label>
                                <input type="email" class="form-control" id="email" value="john.doe@example.com">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="phone">Phone</label>
                                <input type="tel" class="form-control" id="phone" value="+1 (234) 567-8900">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="address">Address</label>
                                <input type="text" class="form-control" id="address" value="123 Admin Street, Dashboard City, 12345">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="about">About</label>
                                <textarea class="form-control" id="about">Experienced system administrator with a focus on maintaining and optimizing enterprise-level applications.</textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <span class="material-icons">save</span>
                                Save Changes
                            </button>
                        </form>
                    </div>

                    <div class="tab-panel" id="password">
                        <form id="passwordForm">
                            <div class="form-group">
                                <label class="form-label" for="currentPassword">Current Password</label>
                                <div class="password-field">
                                    <input type="password" class="form-control" id="currentPassword">
                                    <button type="button" class="password-toggle">
                                        <span class="material-icons">visibility</span>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="newPassword">New Password</label>
                                <div class="password-field">
                                    <input type="password" class="form-control" id="newPassword">
                                    <button type="button" class="password-toggle">
                                        <span class="material-icons">visibility</span>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="confirmPassword">Confirm New Password</label>
                                <div class="password-field">
                                    <input type="password" class="form-control" id="confirmPassword">
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
            // Tab Navigation
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

            // Password Visibility Toggle
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

            // Form Submissions
            document.getElementById('profileForm').addEventListener('submit', (e) => {
                e.preventDefault();
                alert('Profile updated successfully!');
            });

            document.getElementById('passwordForm').addEventListener('submit', (e) => {
                e.preventDefault();
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                if (newPassword !== confirmPassword) {
                    alert('New passwords do not match!');
                    return;
                }
                alert('Password updated successfully!');
            });

            // Sync with sidebar collapse
            const sidebar = document.getElementById('sidebar');
            const toggleBtn = document.getElementById('toggleBtn');
            const body = document.body;

            toggleBtn.addEventListener('click', () => {
                body.classList.toggle('sidebar-collapsed');
            });

            // Initial check
            if (sidebar.classList.contains('collapsed')) {
                body.classList.add('sidebar-collapsed');
            }

            // Handle resize
            function handleResize() {
                if (window.innerWidth <= 768) {
                    body.classList.add('sidebar-collapsed');
                }
            }

            window.addEventListener('resize', handleResize);
            handleResize();
        });
    </script>
</body>
</html>