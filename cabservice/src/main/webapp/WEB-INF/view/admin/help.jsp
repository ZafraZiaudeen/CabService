<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Help Center - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminHelp.css'/>">
</head>
<body>
    <jsp:include page="Sidebar.jsp" />

    <div class="main-content">
        <div class="help-header">
            <h1 class="help-title">Admin Help Center</h1>
            <p class="help-subtitle">Your guide to managing the cab service platform efficiently</p>
        </div>

        <div class="search-box">
            <span class="material-icons">search</span>
            <input type="text" id="searchInput" placeholder="Search help topics...">
        </div>

        <div class="help-categories">
            <div class="category-card" onclick="scrollToSection('bookingManagement')">
                <div class="category-icon">
                    <span class="material-icons">book_online</span>
                </div>
                <h3 class="category-title">Booking Management</h3>
                <p class="category-description">Learn how to manage bookings, handle requests, and track rides</p>
                <a href="#bookingManagement" class="category-link">
                    View Guide <span class="material-icons">arrow_forward</span>
                </a>
            </div>

            <div class="category-card" onclick="scrollToSection('customerManagement')">
                <div class="category-icon">
                    <span class="material-icons">group</span>
                </div>
                <h3 class="category-title">Customer Management</h3>
                <p class="category-description">Manage customers</p>
                <a href="#customerManagement" class="category-link">
                    View Guide <span class="material-icons">arrow_forward</span>
                </a>
            </div>

            <div class="category-card" onclick="scrollToSection('driverManagement')">
                <div class="category-icon">
                    <span class="material-icons">person</span>
                </div>
                <h3 class="category-title">Driver Management</h3>
                <p class="category-description">Manage driver applications, details, and availability</p>
                <a href="#driverManagement" class="category-link">
                    View Guide <span class="material-icons">arrow_forward</span>
                </a>
            </div>

            <div class="category-card" onclick="scrollToSection('vehicleManagement')">
                <div class="category-icon">
                    <span class="material-icons">directions_car</span>
                </div>
                <h3 class="category-title">Vehicle Management</h3>
                <p class="category-description">Handle vehicle registration, assignments, and maintenance</p>
                <a href="#vehicleManagement" class="category-link">
                    View Guide <span class="material-icons">arrow_forward</span>
                </a>
            </div>

            <div class="category-card" onclick="scrollToSection('taxDiscountManagement')">
                <div class="category-icon">
                    <span class="material-icons">attach_money</span>
                </div>
                <h3 class="category-title">Tax/Discount Allocation</h3>
                <p class="category-description">Manage tax and discount settings for bookings</p>
                <a href="#taxDiscountManagement" class="category-link">
                    View Guide <span class="material-icons">arrow_forward</span>
                </a>
            </div>

            <div class="category-card" onclick="scrollToSection('assignVehicleDriver')">
                <div class="category-icon">
                    <span class="material-icons">link</span>
                </div>
                <h3 class="category-title">Assign Vehicle-Driver</h3>
                <p class="category-description">Manage vehicle and driver assignments</p>
                <a href="#assignVehicleDriver" class="category-link">
                    View Guide <span class="material-icons">arrow_forward</span>
                </a>
            </div>
        </div>

        <div class="faq-section" id="bookingManagement">
            <h2 class="section-title">
                <span class="material-icons">book_online</span>
                Booking Management
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I make a booking for a customer?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To make a booking for a customer:
                        <ol>
                            <li>Select "New Booking" from the "Bookings" section.</li>
                            <li>In the "Select a Customer" option, choose a customer—you can search for them in the box provided.</li>
                            <li>Next, select pickup and drop-off locations using the map or by typing them in.</li>
                            <li>Wait until the distance is calculated properly.</li>
                            <li>Select the relevant vehicle—you can search for it in the selection bar.</li>
                            <li>Click "Create Booking." Note: Payments cannot be updated from the admin side for customer privacy, so it will be set as a pending booking.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I check pending bookings?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To check pending bookings:
                        <ol>
                            <li>Go to the "Pending Bookings" section under "Bookings."</li>
                            <li>View the list of pending bookings to access customer contact details.</li>
                            <li>Contact the customer to remind them to complete the payment for their booking through the website.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I manage ongoing bookings?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To manage ongoing bookings:
                        <ol>
                            <li>Navigate to "Bookings > Ongoing Bookings" to see paid bookings where the ride is still in progress.</li>
                            <li>If the ride is completed but the customer forgot to update it, manually update the status to "Completed."</li>
                            <li>This will mark the driver as available, allowing the vehicle to be booked by another customer.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I view all bookings?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To view all bookings:
                        <ol>
                            <li>Select "Booking History" from the "Bookings" section.</li>
                            <li>View a complete list of all bookings made on the platform.</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="customerManagement">
            <h2 class="section-title">
                <span class="material-icons">group</span>
                Customer Management
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I enroll a customer?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To enroll a customer:
                        <ol>
                            <li>Navigate to the "Customers" section from the sidebar.</li>
                            <li>Select "Add Customer" and provide all relevant details (e.g., name, contact info).</li>
                            <li>Save the information to create the customer profile.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I manage customer accounts?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To manage customer accounts:
                        <ol>
                            <li>Navigate to "Customers > Manage Customers"</li>
                            <li>Use search or filters to find specific customers</li>
                            <li>View customer details</li>
                            <li>Edit information</li>
                            <li>Use the pencil icon to edit customer details and update as needed.</li>
                            <li>Use the bin icon to delete; a confirmation popup will appear—confirm to delete the customer.</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="driverManagement">
            <h2 class="section-title">
                <span class="material-icons">person</span>
                Driver Management
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I add a driver?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To add a driver:
                        <ol>
                            <li>Go to "Drivers > Applications" from the sidebar.</li>
                            <li>Add the driver details (e.g., name, contact info, license number).</li>
                            <li>Save the information to register the driver in the system.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I manage driver details?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To manage driver details:
                        <ol>
                            <li>Navigate to "Drivers > Manage Drivers."</li>
                            <li>View all drivers in the system.</li>
                            <li>Click the pencil icon to edit a driver’s details and update as needed.</li>
                            <li>Click the bin icon to delete a driver; confirm the deletion when prompted.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I check available drivers?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To check available drivers:
                        <ol>
                            <li>Go to "Drivers > Active Drivers" from the sidebar.</li>
                            <li>View the list of drivers who currently have no bookings assigned to them.</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="vehicleManagement">
            <h2 class="section-title">
                <span class="material-icons">directions_car</span>
                Vehicle Management
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I add a vehicle?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To add a vehicle:
                        <ol>
                            <li>Click "Add Vehicle" under the "Vehicles" section.</li>
                            <li>Provide all relevant details (e.g., make, model, year, rate per km).</li>
                            <li>Save the information—the rate per km will be used to calculate fares based on distance for bookings.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I manage vehicle details?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To manage vehicle details:
                        <ol>
                            <li>Navigate to "Vehicles > Manage Vehicles."</li>
                            <li>View all vehicles in the system.</li>
                            <li>Click the pencil icon to edit vehicle details and update as needed.</li>
                            <li>Click the delete icon to remove a vehicle if desired.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I check available vehicles?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To check available vehicles:
                        <ol>
                            <li>Go to "Vehicles > Available Vehicles."</li>
                            <li>View the list of vehicles that currently have no driver assigned to them.</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

     
        <div class="faq-section" id="taxDiscountManagement">
            <h2 class="section-title">
                <span class="material-icons">attach_money</span>
                Tax/Discount Allocation
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I manage existing taxes or discounts?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To manage existing taxes or discounts:
                        <ol>
                            <li>Navigate to "Tax/Discount > Manage Tax/Discount."</li>
                            <li>View the currently allocated taxes and discounts.</li>
                            <li>Click the edit icon to modify a specific tax or discount.</li>
                            <li>Click the delete icon to remove a specific tax or discount.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I add a new tax or discount?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To add a new tax or discount:
                        <ol>
                            <li>Navigate to "Tax/Discount > Add Tax/Discount."</li>
                            <li>Enter the new tax or discount details ( percentage).</li>
                            <li>Apply it commonly to all vehicles—note that this will replace any existing tax or discount with the new amount.</li>
                            <li>Save the changes to update the system.</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="assignVehicleDriver">
            <h2 class="section-title">
                <span class="material-icons">link</span>
                Assign Vehicle-Driver
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I unassign a vehicle from a driver?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To unassign a vehicle from a driver:
                        <ol>
                            <li>Click "Assign Vehicle-Driver" from the sidebar.</li>
                            <li>Navigate to the management page for vehicle-driver assignments.</li>
                            <li>In the "Action" column, click "Unassign" next to the specific driver-vehicle pair.</li>
                            <li>The vehicle will be unassigned from that driver.</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I assign a vehicle to a driver?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To assign a vehicle to a driver:
                        <ol>
                            <li>Click "Assign Vehicle-Driver" from the sidebar.</li>
                            <li>Select "New Assignment."</li>
                            <li>Choose a driver who doesn’t currently have a vehicle assigned to them.</li>
                            <li>Select a vehicle that doesn’t have a driver assigned to it.</li>
                            <li>Click "Create Assignment" to finalize the assignment.</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="contact-support">
            <h2 class="contact-title">
                <span class="material-icons">support_agent</span>
                Technical Support
            </h2>
            <div class="contact-methods">
                <div class="contact-method">
                    <span class="material-icons">phone</span>
                    <h3 class="contact-method-title">Phone Support</h3>
                    <p class="contact-method-info">24/7 priority support line for admins</p>
                    <a href="tel:++941234567890" class="contact-button">
                        <span class="material-icons">call</span>
                        Call Support
                    </a>
                </div>

                <div class="contact-method">
                    <span class="material-icons">email</span>
                    <h3 class="contact-method-title">Email Support</h3>
                    <p class="contact-method-info">Get help via email</p>
                    <a href="mailto:admin-support@cabservice.com" class="contact-button">
                        <span class="material-icons">mail</span>
                        Send Email
                    </a>
                </div>

                <div class="contact-method">
                    <span class="material-icons">chat</span>
                    <h3 class="contact-method-title">Live Chat</h3>
                    <p class="contact-method-info">Chat with technical support</p>
                    <button class="contact-button" onclick="startLiveChat()">
                        <span class="material-icons">forum</span>
                        Start Chat
                    </button>
                </div>
            </div>
        </div>
    </div>

    <button class="back-to-top" id="backToTop">
        <span class="material-icons">arrow_upward</span>
    </button>

    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const faqItems = document.querySelectorAll('.faq-item');
            
            faqItems.forEach(item => {
                const question = item.querySelector('.faq-question').textContent.toLowerCase();
                const answer = item.querySelector('.faq-content').textContent.toLowerCase();
                
                if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        });

        // FAQ accordion functionality
        document.querySelectorAll('.faq-question').forEach(question => {
            question.addEventListener('click', function() {
                this.classList.toggle('active');
                const answer = this.nextElementSibling;
                answer.classList.toggle('active');
            });
        });

        // Smooth scroll to sections
        function scrollToSection(sectionId) {
            const section = document.getElementById(sectionId);
            if (section) {
                section.scrollIntoView({ behavior: 'smooth' });
            }
        }

        // Back to top button visibility
        window.addEventListener('scroll', function() {
            const backToTop = document.getElementById('backToTop');
            if (window.scrollY > 300) {
                backToTop.classList.add('visible');
            } else {
                backToTop.classList.remove('visible');
            }
        });

        // Back to top functionality
        document.getElementById('backToTop').addEventListener('click', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });

        // Placeholder for live chat (implement as needed)
        function startLiveChat() {
            alert('Live chat feature coming soon!');
            // Add actual live chat integration here
        }
    </script>
</body>
</html>