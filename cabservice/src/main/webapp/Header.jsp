<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
            <ul>
                <li><a href="#home">Home</a></li>
                <li><a href="#services">Services</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#contact">Contact</a></li>

                <%
                    if (session != null && session.getAttribute("customerUser") != null) {
                %>
                    <li><a href="booking.jsp">Booking</a></li> <!-- Show Booking option when logged in -->
                <%
                    }
                %>

                <div class="auth-buttons">
                    <%
                        if (session != null && session.getAttribute("customerUser") != null) {
                    %>
                        <a href="user?action=logout" class="btn btn-outline">Logout</a>
                    <%
                        } else {
                    %>
                        <a href="javascript:location.href='user?action=login'" class="btn btn-outline">Login</a>
                        <a href="javascript:location.href='user?action=register'" class="btn btn-primary">Register</a>
                    <%
                        }
                    %>
                </div>
                <button class="menu-toggle">
                    <span class="material-icons">menu</span>
                </button>
            </ul>
        </nav>
    </header>
</body>
</html>
