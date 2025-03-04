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

            <div class="category-card" onclick="scrollToSection('userManagement')">
                <div class="category-icon">
                    <span class="material-icons">group</span>
                </div>
                <h3 class="category-title">User Management</h3>
                <p class="category-description">Manage customers, drivers, and admin accounts</p>
                <a href="#userManagement" class="category-link">
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

            <div class="category-card" onclick="scrollToSection('systemSettings')">
                <div class="category-icon">
                    <span class="material-icons">settings</span>
                </div>
                <h3 class="category-title">System Settings</h3>
                <p class="category-description">Configure system parameters, pricing, and policies</p>
                <a href="#systemSettings" class="category-link">
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
                    How do I process a new booking request?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To process a new booking request:
                        <ol>
                            <li>Go to "Bookings > New Requests"</li>
                            <li>Review the booking details</li>
                            <li>Check driver and vehicle availability</li>
                            <li>Assign a driver and vehicle</li>
                            <li>Confirm the booking</li>
                            <li>The system will automatically notify the customer</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I modify an existing booking?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To modify a booking:
                        <ol>
                            <li>Navigate to "Bookings > Manage Bookings"</li>
                            <li>Find the booking using the search or filters</li>
                            <li>Click "Edit" on the booking</li>
                            <li>Make necessary changes</li>
                            <li>Save changes and confirm</li>
                            <li>The system will notify affected parties</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="userManagement">
            <h2 class="section-title">
                <span class="material-icons">group</span>
                User Management
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I approve a new driver application?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To approve a driver application:
                        <ol>
                            <li>Go to "Drivers > Applications"</li>
                            <li>Review the driver's information and documents</li>
                            <li>Verify license and background check</li>
                            <li>Click "Approve" if everything is in order</li>
                            <li>Set up their account credentials</li>
                            <li>The system will send login details to the driver</li>
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
                            <li>View customer details, booking history, and ratings</li>
                            <li>Edit information or handle account issues</li>
                            <li>Process any special requests or complaints</li>
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
                    How do I add a new vehicle to the system?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To add a new vehicle:
                        <ol>
                            <li>Go to "Vehicles > Add Vehicle"</li>
                            <li>Enter vehicle details (make, model, year)</li>
                            <li>Upload registration documents</li>
                            <li>Set vehicle type and pricing category</li>
                            <li>Add maintenance schedule</li>
                            <li>Save and activate the vehicle</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I assign vehicles to drivers?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To assign vehicles:
                        <ol>
                            <li>Navigate to "Vehicles > Assign Vehicle"</li>
                            <li>Select an available vehicle</li>
                            <li>Choose an eligible driver</li>
                            <li>Set assignment duration</li>
                            <li>Confirm the assignment</li>
                            <li>Both driver and system will be updated</li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="systemSettings">
            <h2 class="section-title">
                <span class="material-icons">settings</span>
                System Settings
            </h2>
            <div class="faq-item">
                <div class="faq-question">
                    How do I update pricing and rates?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To update pricing:
                        <ol>
                            <li>Go to "Settings > Pricing"</li>
                            <li>Select the vehicle category</li>
                            <li>Update base rates, per-km charges</li>
                            <li>Set peak hour multipliers</li>
                            <li>Configure special rates</li>
                            <li>Save and apply changes</li>
                        </ol>
                    </div>
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    How do I configure system notifications?
                    <span class="material-icons">expand_more</span>
                </div>
                <div class="faq-answer">
                    <div class="faq-content">
                        To configure notifications:
                        <ol>
                            <li>Navigate to "Settings > Notifications"</li>
                            <li>Choose notification types</li>
                            <li>Set up email and SMS templates</li>
                            <li>Configure notification triggers</li>
                            <li>Test the notifications</li>
                            <li>Save and activate settings</li>
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
                    <a href="tel:+1234567890" class="contact-button">
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

    <!-- Back to Top Button -->
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