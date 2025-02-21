<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sidebar</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f6fa;
            color: #2d3436;
        }

        .sidebar {
            width: 260px;
            height: 100vh;
            background-color: #2d3436;
            color: #fff;
            position: fixed;
            left: 0;
            top: 0;
            transition: width 0.3s ease;
            overflow-x: hidden;
        }

        .sidebar.collapsed {
            width: 70px;
        }

        .logo-container {
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1px solid #40464a;
            position: relative;
            min-height: 80px;
        }

        .logo {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            flex-shrink: 0;
        }

        .site-title {
            font-size: 1.2rem;
            font-weight: 600;
            white-space: nowrap;
            transition: opacity 0.3s ease, width 0.3s ease;
        }

        .toggle-btn {
            background: none;
            border: none;
            color: #fff;
            cursor: pointer;
            padding: 5px;
            border-radius: 4px;
            position: absolute;
            right: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: right 0.3s ease;
        }

        .toggle-btn:hover {
            background-color: #40464a;
        }

        .sidebar.collapsed .site-title {
            opacity: 0;
            width: 0;
            overflow: hidden;
        }

        .sidebar.collapsed .toggle-btn {
            right: 10px;
        }

        .nav-menu {
            padding: 20px 0;
            overflow-y: auto;
            height: calc(100vh - 80px - 100px); /* Adjust based on header and footer height */
        }

        .nav-menu ul {
            list-style: none;
        }

        .nav-menu .menu-item {
            margin-bottom: 5px;
            position: relative;
        }

        .nav-menu a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: #fff;
            text-decoration: none;
            gap: 12px;
            transition: background-color 0.2s;
            white-space: nowrap;
            width: 100%;
        }

        .nav-menu a:hover {
            background-color: #40464a;
        }

        .nav-menu .menu-item.active > a {
            background-color: #0984e3;
        }

        .nav-menu .material-icons {
            flex-shrink: 0;
        }

        .nav-menu .submenu {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            background-color: #363b3d;
        }

        .nav-menu .submenu.expanded {
            max-height: 500px;
        }

        .nav-menu .submenu a {
            padding-left: 56px;
            font-size: 0.9em;
        }

        .nav-menu .dropdown-icon {
            margin-left: auto;
            transition: transform 0.3s ease;
        }

        .nav-menu .menu-item.active .dropdown-icon {
            transform: rotate(180deg);
        }

        .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 20px;
            border-top: 1px solid #40464a;
            background-color: #2d3436;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .logout-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
            text-decoration: none;
            padding: 8px;
            border-radius: 4px;
            white-space: nowrap;
        }

        .logout-btn:hover {
            background-color: #40464a;
        }

        .nav-text {
            transition: opacity 0.3s ease;
        }

        .sidebar.collapsed .nav-text {
            opacity: 0;
            width: 0;
            overflow: hidden;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
            }

            .site-title {
                opacity: 0;
                width: 0;
                overflow: hidden;
            }

            .toggle-btn {
                right: 10px;
            }

            .nav-text {
                opacity: 0;
                width: 0;
                overflow: hidden;
            }

            .nav-menu .submenu {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="sidebar" id="sidebar">
        <div class="logo-container">
           
            <h2 class="site-title">CabService</h2>
            <button class="toggle-btn" id="toggleBtn">
                <span class="material-icons">menu</span>
            </button>
        </div>
        <nav class="nav-menu">
            <ul>
                <li class="menu-item">
                    <li><a href="<%= request.getContextPath() %>/dashboard">


                        <span class="material-icons">dashboard</span>
                        <span class="nav-text">Dashboard</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#" class="has-submenu">
                        <span class="material-icons">group</span>
                        <span class="nav-text">Customer</span>
                        <span class="material-icons dropdown-icon">expand_more</span>
                    </a>
                    <ul class="submenu">
                        <li><a href="<%= request.getContextPath() %>/customer">
                            <span class="nav-text">Manage Customer</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/customer?action=add">
                            <span class="nav-text">Add Customer</span>
                        </a></li>
                        
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="#" class="has-submenu">
                        <span class="material-icons">book_online</span>
                        <span class="nav-text">Bookings</span>
                        <span class="material-icons dropdown-icon">expand_more</span>
                    </a>
                    <ul class="submenu">
                        <li><a href="#new-booking">
                            <span class="nav-text">New Booking</span>
                        </a></li>
                        <li><a href="#active-bookings">
                            <span class="nav-text">Active Bookings</span>
                        </a></li>
                        <li><a href="#booking-history">
                            <span class="nav-text">Booking History</span>
                        </a></li>
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="#" class="has-submenu">
                        <span class="material-icons">person</span>
                        <span class="nav-text">Drivers</span>
                        <span class="material-icons dropdown-icon">expand_more</span>
                    </a>
                    <ul class="submenu">
                        <li><a href="<%= request.getContextPath() %>/driver?action=list">
                            <span class="nav-text">All Drivers</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/driver?action=available">
                            <span class="nav-text">Active Drivers</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/driver?action=add">
                            <span class="nav-text">Applications</span>
                        </a></li>
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="#" class="has-submenu">
                        <span class="material-icons">directions_car</span>
                        <span class="nav-text">Vehicles</span>
                        <span class="material-icons dropdown-icon">expand_more</span>
                    </a>
                    <ul class="submenu">
                        <li><a href="#fleet-overview">
                            <span class="nav-text">Fleet Overview</span>
                        </a></li>
                        <li><a href="#maintenance">
                            <span class="nav-text">Maintenance</span>
                        </a></li>
                        <li><a href="#vehicle-documents">
                            <span class="nav-text">Documents</span>
                        </a></li>
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="#" class="has-submenu">
                        <span class="material-icons">analytics</span>
                        <span class="nav-text">Reports</span>
                        <span class="material-icons dropdown-icon">expand_more</span>
                    </a>
                    <ul class="submenu">
                        <li><a href="#earnings">
                            <span class="nav-text">Earnings</span>
                        </a></li>
                        <li><a href="#driver-performance">
                            <span class="nav-text">Driver Performance</span>
                        </a></li>
                        <li><a href="#customer-feedback">
                            <span class="nav-text">Customer Feedback</span>
                        </a></li>
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="#settings">
                        <span class="material-icons">settings</span>
                        <span class="nav-text">Settings</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <img src="/placeholder.svg?height=32&width=32" alt="User Avatar" class="user-avatar">
                <span class="nav-text">Admin User</span>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                <span class="material-icons">logout</span>
                <span class="nav-text">Logout</span>
            </a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.getElementById('sidebar');
            const toggleBtn = document.getElementById('toggleBtn');
            const navText = document.querySelectorAll('.nav-text');
            const siteTitle = document.querySelector('.site-title');
            const submenuTriggers = document.querySelectorAll('.has-submenu');

            // Toggle sidebar
            toggleBtn.addEventListener('click', function() {
                sidebar.classList.toggle('collapsed');
                
                // Handle title and text visibility with transition
                if (sidebar.classList.contains('collapsed')) {
                    navText.forEach(text => {
                        text.style.opacity = '0';
                        text.style.width = '0';
                    });
                    siteTitle.style.opacity = '0';
                    siteTitle.style.width = '0';
                    
                    // Close all submenus when collapsing sidebar
                    document.querySelectorAll('.submenu').forEach(submenu => {
                        submenu.classList.remove('expanded');
                    });
                    document.querySelectorAll('.menu-item').forEach(item => {
                        item.classList.remove('active');
                    });
                } else {
                    navText.forEach(text => {
                        text.style.opacity = '1';
                        text.style.width = 'auto';
                    });
                    siteTitle.style.opacity = '1';
                    siteTitle.style.width = 'auto';
                }
            });

            // Handle submenu toggles
            submenuTriggers.forEach(trigger => {
                trigger.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Don't toggle submenu if sidebar is collapsed
                    if (sidebar.classList.contains('collapsed')) {
                        return;
                    }

                    const menuItem = this.closest('.menu-item');
                    const submenu = this.nextElementSibling;
                    const isExpanded = menuItem.classList.contains('active');

                    // Close all other submenus
                    document.querySelectorAll('.menu-item').forEach(item => {
                        if (item !== menuItem) {
                            item.classList.remove('active');
                            if (item.querySelector('.submenu')) {
                                item.querySelector('.submenu').classList.remove('expanded');
                            }
                        }
                    });

                    // Toggle current submenu
                    menuItem.classList.toggle('active');
                    submenu.classList.toggle('expanded');

                    // Update dropdown icon
                    const dropdownIcon = this.querySelector('.dropdown-icon');
                    dropdownIcon.textContent = isExpanded ? 'expand_more' : 'expand_less';
                });
            });

            // Handle submenu item clicks
            document.querySelectorAll('.submenu a').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.stopPropagation(); // Prevent triggering parent click events
                    
                    // Remove active class from all menu items
                    document.querySelectorAll('.submenu a').forEach(link => {
                        link.classList.remove('active');
                    });
                    
                    // Add active class to clicked item
                    this.classList.add('active');
                });
            });

            // Handle responsive behavior
            function handleResize() {
                if (window.innerWidth <= 768) {
                    sidebar.classList.add('collapsed');
                    navText.forEach(text => {
                        text.style.opacity = '0';
                        text.style.width = '0';
                    });
                    siteTitle.style.opacity = '0';
                    siteTitle.style.width = '0';
                    
                    // Close all submenus
                    document.querySelectorAll('.submenu').forEach(submenu => {
                        submenu.classList.remove('expanded');
                    });
                    document.querySelectorAll('.menu-item').forEach(item => {
                        item.classList.remove('active');
                    });
                } else if (!sidebar.classList.contains('collapsed')) {
                    navText.forEach(text => {
                        text.style.opacity = '1';
                        text.style.width = 'auto';
                    });
                    siteTitle.style.opacity = '1';
                    siteTitle.style.width = 'auto';
                }
            }

            // Initial check and event listener for window resize
            handleResize();
            window.addEventListener('resize', handleResize);
        });
    </script>
</body>
</html>