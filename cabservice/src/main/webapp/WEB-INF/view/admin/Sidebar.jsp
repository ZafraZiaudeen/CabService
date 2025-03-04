<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sidebar</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/sidebar.css'/>">
</head>
<body>
    <jsp:include page="help-icon.jsp" />
    <div class="sidebar" id="sidebar">
        <div class="logo-container">
            <h2 class="site-title">Mega City Cab</h2>
            <button class="toggle-btn" id="toggleBtn">
                <span class="material-icons">menu</span>
            </button>
        </div>
        <nav class="nav-menu">
            <ul>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/dashboard">
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
                        <li><a href="<%= request.getContextPath() %>/booking?action=add">
                            <span class="nav-text">New Booking</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/booking?action=pending">
                            <span class="nav-text">Pending Bookings</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/booking?action=ongoing">
                            <span class="nav-text">Ongoing Bookings</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/booking?action=manage">
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
                        <li><a href="<%= request.getContextPath() %>/vehicle?action=list">
                            <span class="nav-text">Manage Vehicle</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/vehicle?action=add">
                            <span class="nav-text">Add Vehicle</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/vehicle?action=available">
                            <span class="nav-text">Available Vehicles</span>
                        </a></li>
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="#" class="has-submenu">
                        <span class="material-icons">settings</span>
                        <span class="nav-text">Tax/Discount</span>
                        <span class="material-icons dropdown-icon">expand_more</span>
                    </a>
                    <ul class="submenu">
                        <li><a href="<%= request.getContextPath() %>/system-config?action=list">
                            <span class="nav-text">Manage Tax/Discount</span>
                        </a></li>
                        <li><a href="<%= request.getContextPath() %>/system-config?action=add">
                            <span class="nav-text">Add Tax</span>
                        </a></li>
                    </ul>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/assignment?action=list">
                        <span class="material-icons">assignment_ind</span>
                        <span class="nav-text">Assign Vehicle-Driver</span>
                    </a>
                </li>
            </ul>
        </nav>
        <div class="sidebar-footer">
            
            <!-- User Settings Button -->
            <a href="<%= request.getContextPath() %>/adminProfile" class="settings-btn">
                <span class="material-icons">manage_accounts</span>
                <span class="nav-text">User Settings</span>
            </a>
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
                
                if (sidebar.classList.contains('collapsed')) {
                    navText.forEach(text => {
                        text.style.opacity = '0';
                        text.style.width = '0';
                    });
                    siteTitle.style.opacity = '0';
                    siteTitle.style.width = '0';
                    
                    // Close all submenus when collapsing
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
                    
                    if (sidebar.classList.contains('collapsed')) {
                        return;
                    }

                    const menuItem = this.closest('.menu-item');
                    const submenu = this.nextElementSibling;
                    const isExpanded = menuItem.classList.contains('active');

                    document.querySelectorAll('.menu-item').forEach(item => {
                        if (item !== menuItem) {
                            item.classList.remove('active');
                            if (item.querySelector('.submenu')) {
                                item.querySelector('.submenu').classList.remove('expanded');
                            }
                        }
                    });

                    menuItem.classList.toggle('active');
                    submenu.classList.toggle('expanded');
                    const dropdownIcon = this.querySelector('.dropdown-icon');
                    dropdownIcon.textContent = isExpanded ? 'expand_more' : 'expand_less';
                });
            });

            // Handle submenu item clicks
            document.querySelectorAll('.submenu a').forEach(item => {
                item.addEventListener('click', function(e) {
                    e.stopPropagation();
                    document.querySelectorAll('.submenu a').forEach(link => link.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Responsive behavior
            function handleResize() {
                if (window.innerWidth <= 768 && !sidebar.classList.contains('collapsed')) {
                    sidebar.classList.add('collapsed');
                    navText.forEach(text => {
                        text.style.opacity = '0';
                        text.style.width = '0';
                    });
                    siteTitle.style.opacity = '0';
                    siteTitle.style.width = '0';
                    document.querySelectorAll('.submenu').forEach(submenu => {
                        submenu.classList.remove('expanded');
                    });
                    document.querySelectorAll('.menu-item').forEach(item => {
                        item.classList.remove('active');
                    });
                }
            }

            handleResize();
            window.addEventListener('resize', handleResize);
        });
    </script>
</body>
</html>