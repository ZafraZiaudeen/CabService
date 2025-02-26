<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CabService</title>
</head>
<body>
    <header>
        <nav>
            <div class="logo">CabService</div>
            <ul id="menu">
                <li><a href="<%= request.getContextPath() %>/index.jsp#hero">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/index.jsp#services">Services</a></li>
                <li><a href="<%= request.getContextPath() %>/index.jsp#about">About</a></li>

                <%
                    if (session != null && session.getAttribute("customerUser") != null) {
                %>
                    <li>
                        <a href="<%= request.getContextPath() %>/customerBilling?action=viewHistory&customer_id=<%= session.getAttribute("customerId") %>">Booking History</a>
                    </li>
                <%
                    }
                %>

                <div class="auth-buttons">
                    <%
                        if (session != null && session.getAttribute("customerUser") != null) {
                    %>
                        <a href="<%= request.getContextPath() %>/user?action=logout" class="btn btn-outline">Logout</a>
                    <%
                        } else {
                    %>
                        <a href="<%= request.getContextPath() %>/user?action=login" class="btn btn-outline">Login</a>
                        <a href="<%= request.getContextPath() %>/user?action=register" class="btn btn-primary">Register</a>
                    <%
                        }
                    %>
                </div>
            </ul>

            <!-- Menu Toggle Button -->
            <button class="menu-toggle">
                <span class="material-icons">menu</span>
            </button>
        </nav>
    </header>

    <!-- Include JavaScript for menu toggle -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const menuToggle = document.querySelector('.menu-toggle');
            const menu = document.getElementById('menu');

            // Toggle the 'active' class on the menu when the menu toggle button is clicked
            menuToggle.addEventListener('click', function() {
                menu.classList.toggle('active');
            });
        });
    </script>
</body>
</html>