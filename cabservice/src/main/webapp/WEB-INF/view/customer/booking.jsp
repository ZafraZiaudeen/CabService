<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Ride - CabService</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <nav>
            <div class="logo">CabService</div>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="index.html#services">Services</a></li>
                <li><a href="index.html#about">About</a></li>
                <li><a href="index.html#contact">Contact</a></li>
                <li><a href="#" id="userProfileLink">My Profile</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section class="booking-section">
            <h1>Book a Ride</h1>
            <form id="booking-form">
                <div class="form-group">
                    <label for="pickup">Pickup Location</label>
                    <input type="text" id="pickup" name="pickup" required>
                </div>
                <div class="form-group">
                    <label for="dropoff">Drop-off Location</label>
                    <input type="text" id="dropoff" name="dropoff" required>
                </div>
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date" required>
                </div>
                <div class="form-group">
                    <label for="time">Time</label>
                    <input type="time" id="time" name="time" required>
                </div>
                <div class="form-group">
                    <label for="vehicle-type">Vehicle Type</label>
                    <select id="vehicle-type" name="vehicle-type" required>
                        <option value="">Select a vehicle type</option>
                        <option value="sedan">Sedan</option>
                        <option value="suv">SUV</option>
                        <option value="luxury">Luxury</option>
                    </select>
                </div>
                <button type="submit" class="btn-primary">Book Now</button>
            </form>
        </section>

        <section class="booking-history">
            <h2>Your Booking History</h2>
            <table id="booking-history-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Date</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Booking history will be populated here -->
                </tbody>
            </table>
        </section>
    </main>
 <jsp:include page="/Footer.jsp" />

    <script src="script.js"></script>
</body>
</html>
