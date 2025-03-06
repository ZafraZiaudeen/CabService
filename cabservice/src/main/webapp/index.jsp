<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CabService - Your Ride, Your Way</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="Header.jsp" />

    <main>
        <section id="hero" class="hero">
            <div class="hero-content">
                <h1>Your Ride, Your Way</h1>
                <p>Experience comfort and reliability with CabService. Book your ride now and travel with ease.</p>
               <a href="javascript:void(0);" class="btn-primary" onclick="checkLogin()">Book a Ride</a>

            </div>
        </section>

        <section id="services" class="services">
            <h2>Our Services</h2>
            <div class="service-grid">
                <div class="service-card">
                    <span class="material-icons">directions_car</span>
                    <h3>City Rides</h3>
                    <p>Quick and comfortable rides within the city.</p>
                </div>
                <div class="service-card">
                    <span class="material-icons">airport_shuttle</span>
                    <h3>Airport Transfer</h3>
                    <p>Reliable airport pickup and drop-off services.</p>
                </div>
                <div class="service-card">
                    <span class="material-icons">star</span>
                    <h3>Premium Cars</h3>
                    <p>Luxury vehicles for special occasions.</p>
                </div>
            </div>
        </section>

        <section id="about" class="about">
            <h2>About CabService</h2>
            <p>CabService is committed to providing safe, reliable, and comfortable transportation solutions. With our fleet of well-maintained vehicles and professional drivers, we ensure that your journey is always pleasant and stress-free.</p>
        </section>

       <section id="why-choose-us" class="why-choose-us">
    <div class="container">
        <h2>Why Choose Our Cab Service</h2>
        <div class="benefits-grid">
            <div class="benefit-card">
                <div class="benefit-icon">
                    <span class="material-icons">verified</span>
                </div>
                <h3>Trusted & Reliable</h3>
                <p>With over 10 years of experience and 5-star ratings, we've built a reputation for reliability and excellence in service.</p>
            </div>
            
            <div class="benefit-card">
                <div class="benefit-icon">
                    <span class="material-icons">schedule</span>
                </div>
                <h3>Punctual Service</h3>
                <p>We value your time. Our drivers are trained to arrive at least 5 minutes before the scheduled pickup time.</p>
            </div>
            
            <div class="benefit-card">
                <div class="benefit-icon">
                    <span class="material-icons">local_offer</span>
                </div>
                <h3>Competitive Pricing</h3>
                <p>Enjoy premium transportation at affordable rates with no hidden charges or surprise fees.</p>
            </div>
            
            <div class="benefit-card">
                <div class="benefit-icon">
                    <span class="material-icons">security</span>
                </div>
                <h3>Safety First</h3>
                <p>All our vehicles undergo regular maintenance checks, and our drivers are thoroughly vetted for your safety.</p>
            </div>
            
           <div class="benefit-card">
    <div class="benefit-icon">
        <span class="material-icons">group</span>
    </div>
    <h3>Seamless Group Travel</h3>
    <p>Book larger vehicles for family or friends with ease, making group trips comfortable and hassle-free.</p>
</div>
            
            <div class="benefit-card">
                <div class="benefit-icon">
                    <span class="material-icons">eco</span>
                </div>
                <h3>Eco-Friendly Options</h3>
                <p>Choose from our fleet of hybrid and electric vehicles to reduce your carbon footprint while traveling in comfort.</p>
            </div>
        </div>
    </div>
</section>
    </main>
 <jsp:include page="Footer.jsp" />
    <script>
    function checkLogin() {
        fetch('<%= request.getContextPath() %>/user?action=checkLogin')
            .then(response => response.json())
            .then(data => {
                if (data.isLoggedIn) {
                    window.location.href = "<%= request.getContextPath() %>/customerBooking";
                } else {
                    alert("Please log in to book a ride.");
                    window.location.href = "<%= request.getContextPath() %>/user?action=login";
                }
            })
            .catch(error => {
                console.error('Error checking login status:', error);
            });
    }

    </script>
</body>
</html>
