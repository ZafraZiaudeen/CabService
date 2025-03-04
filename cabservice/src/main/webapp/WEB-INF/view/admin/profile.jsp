<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Dashboard</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, sans-serif;
        }

        :root {
            --black: #1a1a1a;
            --white: #ffffff;
            --amber: #FFC107;
            --gray-dark: #333333;
            --gray-light: #666666;
            --bg-dark: #242424;
            --bg-light: #ffffff;
           --border-color: #D3D3D3; /* Light gray */
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            --sidebar-width-expanded: 260px;
            --sidebar-width-collapsed: 70px;
            --profile-card-width: 320px; /* Fixed width for left card */
        }

        body {
            background-color: var(--bg-dark);
            color: var(--black);
            line-height: 1.6;
            min-height: 100vh;
            padding-left: var(--sidebar-width-expanded);
            transition: padding-left 0.3s ease;
        }

        body.sidebar-collapsed {
            padding-left: var(--sidebar-width-collapsed);
        }

        .container {
            max-width: 1280px;
            padding: 2rem;
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 2.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--amber);
        }
.profile-grid {
    display: grid;
    grid-template-columns: minmax(var(--profile-card-width), var(--profile-card-width)) 1fr;
    gap: 2rem;
    align-items: start;
}

.profile-card {
    background-color: var(--white);
    border-radius: 12px;
    box-shadow: var(--shadow);
    padding: 2rem;
    text-align: center;
    width: var(--profile-card-width);
    min-width: var(--profile-card-width);
    max-width: var(--profile-card-width);
    flex-shrink: 0;
}

        .profile-name {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--black);
            margin-bottom: 0.5rem;
        }

        .profile-role {
            color: var(--amber);
            font-size: 1rem;
            font-weight: 500;
        }

        .main-card {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
        }

        .tab-navigation {
            display: flex;
            border-bottom: 1px solid var(--border-color);
        }

        .tab-button {
            padding: 1.25rem 2rem;
            border: none;
            background: none;
            font-size: 1rem;
            font-weight: 500;
            color: var(--gray-dark);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .tab-button:hover {
            color: var(--amber);
        }

        .tab-button.active {
            color: var(--amber);
            border-bottom: 2px solid var(--amber);
        }

        .tab-content {
            padding: 2rem;
        }

        .tab-panel {
            display: none;
        }

        .tab-panel.active {
            display: block;
        }

        .form-group {
            margin-bottom: 1.75rem;
        }

        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--black);
        }

        .form-control {
            width: 100%;
            padding: 0.875rem;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            background-color: var(--bg-light);
            color: var(--black);
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--amber);
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background-color: var(--amber);
            color: var(--black);
        }

        .btn-primary:hover {
            background-color: #ffca28;
            transform: translateY(-1px);
        }

        .password-field {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--gray-dark);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .password-toggle:hover {
            color: var(--amber);
        }

        .detail-row {
            display: grid;
            grid-template-columns: 180px 1fr;
            padding: 1rem 0;
           
        }

        .detail-label {
            color: var(--gray-dark);
            font-weight: 500;
        }

        .detail-value {
            color: var(--black);
        }

        @media (max-width: 768px) {
            body {
                padding-left: var(--sidebar-width-collapsed);
            }

            .profile-grid {
                grid-template-columns: 1fr; /* Stack cards on mobile */
            }

            .profile-card {
                width: 100%; /* Full width on mobile */
                max-width: none; /* Remove max-width restriction */
            }

            .tab-navigation {
                overflow-x: auto;
                white-space: nowrap;
            }

            .detail-row {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }

            .container {
                padding: 1rem;
            }
        }
    </style>
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