<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    .floating-help-button {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 99;
    }
    
    .floating-help-button a {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 56px;
        height: 56px;
        border-radius: 50%;
        background-color: #FFC107;
        color: #000;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transition: all 0.3s ease;
    }
    
    .floating-help-button a:hover {
        background-color: #FFD54F;
        transform: translateY(-3px);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
    }
    
    .floating-help-button .material-icons {
        font-size: 24px;
    }
    
    @media (max-width: 768px) {
        .floating-help-button {
            bottom: 20px;
            right: 20px;
        }
    }
</style>
</head>
<body>
<div class="floating-help-button">
    <a href="<%= request.getContextPath() %>/customerHelp" title="Get Help">
        <span class="material-icons">help_outline</span>
    </a>
</div>
    <footer>
        <div class="footer-content">
            <div class="footer-section">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="index.jsp#hero">Home</a></li>
                    <li><a href="index.jsp#services">Services</a></li>
                    <li><a href="index.jsp#about">About</a></li>
                    <li><a href="index.jsp#why-choose-us">Why choose us</a></li>
                </ul>
            </div>
            
            <div class="footer-section">
                <h3>Contact Info</h3>
                <p>Email: megacitycab11@gmail.com</p>
                <p>Phone: +94 (777) 123-4567</p>
                <p>Address: 123 Main street,Colombo11,Sri Lanka</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2023 Mega City Cab. All rights reserved.</p>
        </div>
    </footer>


</body>
</html>