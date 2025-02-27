<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support - SwiftRide</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
    <style>
        /* Help Page Styles */
        .help-page {
            max-width: 1200px;
            margin: 120px auto 60px;
            padding: 0 20px;
        }

        .page-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .page-title {
            font-size: 32px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .page-subtitle {
            color: #666;
            font-size: 16px;
            font-family: 'Poppins', sans-serif;
            max-width: 600px;
            margin: 0 auto;
        }

        .help-search {
            max-width: 700px;
            margin: 0 auto 50px;
            position: relative;
        }

        .help-search input {
            width: 100%;
            padding: 16px 20px 16px 55px;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .help-search input:focus {
            border-color: #FFC107;
            outline: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .help-search .material-icons {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #757575;
            font-size: 24px;
        }

        .help-categories {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }

        .category-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid #f0f0f0;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #FFC107;
        }

        .category-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color: #FFF8E1;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }

        .category-icon .material-icons {
            font-size: 32px;
            color: #FFC107;
        }

        .category-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .category-description {
            color: #666;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
            margin-bottom: 15px;
        }

        .category-link {
            color: #FFC107;
            font-weight: 500;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }

        .category-link:hover {
            color: #FF9800;
        }

        .faq-section {
            margin-bottom: 50px;
        }

        .section-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 25px;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .faq-list {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .faq-item {
            border-bottom: 1px solid #f0f0f0;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            padding: 20px 25px;
            font-size: 16px;
            font-weight: 500;
            color: #333;
            font-family: 'Poppins', sans-serif;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.3s ease;
        }

        .faq-question:hover {
            background-color: #f9f9f9;
        }

        .faq-question .material-icons {
            font-size: 20px;
            transition: all 0.3s ease;
        }

        .faq-question.active .material-icons {
            transform: rotate(180deg);
        }

        .faq-answer {
            padding: 0 25px;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .faq-answer.active {
            padding: 0 25px 20px;
            max-height: 500px;
        }

        .faq-answer-content {
            color: #666;
            font-size: 15px;
            line-height: 1.6;
            font-family: 'Poppins', sans-serif;
        }

        .contact-section {
            margin-bottom: 50px;
        }

        .contact-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .contact-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid #f0f0f0;
        }

        .contact-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-color: #FFC107;
        }

        .contact-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: #FFF8E1;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }

        .contact-icon .material-icons {
            font-size: 28px;
            color: #FFC107;
        }

        .contact-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .contact-info {
            color: #666;
            font-size: 15px;
            font-family: 'Poppins', sans-serif;
            margin-bottom: 15px;
        }

        .contact-action {
            margin-top: 15px;
        }

        .btn-contact {
            background-color: #FFC107;
            color: #000;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 14px;
            padding: 8px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
        }

        .btn-contact:hover {
            background-color: #FFD54F;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(255, 193, 7, 0.3);
        }

        .support-form-section {
            margin-bottom: 50px;
        }

        .support-form {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            font-family: 'Poppins', sans-serif;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #FFC107;
            outline: none;
            box-shadow: 0 0 0 2px rgba(255, 193, 7, 0.2);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }

        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%23757575' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
        }

        .form-actions {
            text-align: right;
        }

        .btn-submit {
            background-color: #FFC107;
            color: #000;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            font-size: 15px;
            padding: 12px 25px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-submit:hover {
            background-color: #FFD54F;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(255, 193, 7, 0.3);
        }

        @media (max-width: 768px) {
            .help-page {
                margin-top: 100px;
                padding: 0 15px;
            }
            
            .page-title {
                font-size: 28px;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-group.full-width {
                grid-column: span 1;
            }
            
            .contact-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/Header.jsp" />

    <main class="help-page">
        <div class="page-header">
            <h1 class="page-title">How Can We Help You?</h1>
            <p class="page-subtitle">Find answers to common questions or get in touch with our support team</p>
        </div>

        <div class="help-search">
            <span class="material-icons">search</span>
            <input type="text" id="helpSearch" placeholder="Search for help topics...">
        </div>

        <div class="help-categories">
            <div class="category-card" onclick="scrollToSection('bookingHelp')">
                <div class="category-icon">
                    <span class="material-icons">event_available</span>
                </div>
                <h3 class="category-title">Booking Help</h3>
                <p class="category-description">Learn how to book, modify or cancel your rides</p>
                <a href="#bookingHelp" class="category-link">
                    View FAQs <span class="material-icons">arrow_forward</span>
                </a>
            </div>
            
            <div class="category-card" onclick="scrollToSection('accountHelp')">
                <div class="category-icon">
                    <span class="material-icons">person</span>
                </div>
                <h3 class="category-title">Account & Profile</h3>
                <p class="category-description">Manage your account, profile and payment methods</p>
                <a href="#accountHelp" class="category-link">
                    View FAQs <span class="material-icons">arrow_forward</span>
                </a>
            </div>
            
            <div class="category-card" onclick="scrollToSection('paymentHelp')">
                <div class="category-icon">
                    <span class="material-icons">payments</span>
                </div>
                <h3 class="category-title">Payments & Billing</h3>
                <p class="category-description">Information about payments, receipts and refunds</p>
                <a href="#paymentHelp" class="category-link">
                    View FAQs <span class="material-icons">arrow_forward</span>
                </a>
            </div>
            
            <div class="category-card" onclick="scrollToSection('serviceHelp')">
                <div class="category-icon">
                    <span class="material-icons">support_agent</span>
                </div>
                <h3 class="category-title">Service Issues</h3>
                <p class="category-description">Report problems with drivers, vehicles or service</p>
                <a href="#serviceHelp" class="category-link">
                    View FAQs <span class="material-icons">arrow_forward</span>
                </a>
            </div>
        </div>

        <div class="faq-section" id="bookingHelp">
            <h2 class="section-title">
                <span class="material-icons">event_available</span>
                Booking Help
            </h2>
            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        How do I book a ride?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            To book a ride, log in to your account and click on the "Book Now" button on the homepage. Enter your pickup and drop-off locations, select the date and time, choose your preferred vehicle type, and confirm your booking. You'll receive a confirmation email with your booking details.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How can I modify my booking?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            You can modify your booking by going to "My Bookings" in your account dashboard. Find the booking you want to change and click on the "Edit" button. You can modify the date, time, pickup/drop-off locations, and vehicle type, subject to availability. Changes made less than 2 hours before the scheduled pickup may incur a modification fee.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        What is the cancellation policy?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            You can cancel your booking through the "My Bookings" section in your account. Cancellations made more than 24 hours before the scheduled pickup are free of charge. Cancellations made between 2-24 hours before pickup incur a 25% fee. Cancellations made less than 2 hours before pickup or no-shows incur a 100% fee.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        Can I schedule a ride in advance?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Yes, you can schedule a ride up to 30 days in advance. Simply select your desired date and time during the booking process. We recommend booking in advance for airport transfers and important appointments to ensure availability.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="accountHelp">
            <h2 class="section-title">
                <span class="material-icons">person</span>
                Account & Profile
            </h2>
            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        How do I create an account?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            To create an account, click on the "Register" button in the top right corner of the homepage. Fill in your personal details, create a password, and agree to the terms and conditions. Verify your email address by clicking on the link sent to your email, and your account will be ready to use.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I update my profile information?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Log in to your account and go to "My Profile" or "Account Settings." Here, you can update your personal information, contact details, and preferences. Click "Save Changes" after making your updates.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        I forgot my password. How do I reset it?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            On the login page, click on "Forgot Password." Enter the email address associated with your account, and we'll send you a password reset link. Click on the link in the email and follow the instructions to create a new password.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="paymentHelp">
            <h2 class="section-title">
                <span class="material-icons">payments</span>
                Payments & Billing
            </h2>
            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        What payment methods do you accept?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            We accept all major credit and debit cards (Visa, Mastercard, American Express), digital wallets (Google Pay, Apple Pay), and cash payments directly to the driver. Corporate customers can also set up invoicing for monthly billing.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I get a receipt for my ride?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            A receipt is automatically emailed to you after completing your ride. You can also find all your receipts in the "My Bookings" section of your account. Click on any past booking and select "Download Receipt" to get a PDF copy.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do refunds work?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Refunds are processed according to our cancellation policy. If you're eligible for a refund, it will be credited back to your original payment method within 5-7 business days. For any refund inquiries, please contact our customer support team.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="faq-section" id="serviceHelp">
            <h2 class="section-title">
                <span class="material-icons">support_agent</span>
                Service Issues
            </h2>
            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        What if my driver is late?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            If your driver is running late, you'll receive a notification through the app or via SMS. You can also check the status of your booking in real-time through the "My Bookings" section. If there's a significant delay, please contact our customer support for assistance.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        I left an item in the cab. How do I retrieve it?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            If you've left an item in one of our vehicles, please contact our customer support immediately. Provide your booking details and a description of the item. We'll coordinate with the driver to locate your item and arrange for its return.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I report an issue with my ride or driver?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            You can report an issue by going to "My Bookings," selecting the relevant booking, and clicking on "Report an Issue." Alternatively, you can contact our customer support team directly. Please provide as much detail as possible to help us address your concerns promptly.
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="contact-section">
            <h2 class="section-title">
                <span class="material-icons">contact_support</span>
                Contact Us
            </h2>
            <div class="contact-cards">
                <div class="contact-card">
                    <div class="contact-icon">
                        <span class="material-icons">phone</span>
                    </div>
                    <h3 class="contact-title">Call Us</h3>
                    <p class="contact-info">Our support team is available 24/7 to assist you with any questions or concerns.</p>
                    <div class="contact-info">+1 (555) 123-4567</div>
                    <div class="contact-action">
                        <a href="tel:+15551234567" class="btn-contact">
                            <span class="material-icons">call</span> Call Now
                        </a>
                    </div>
                </div>
                
                <div class="contact-card">
                    <div class="contact-icon">
                        <span class="material-icons">email</span>
                    </div>
                    <h3 class="contact-title">Email Us</h3>
                    <p class="contact-info">Send us an email and we'll get back to you within 24 hours.</p>
                    <div class="contact-info">support@swiftride.com</div>
                    <div class="contact-action">
                        <a href="mailto:support@swiftride.com" class="btn-contact">
                            <span class="material-icons">mail</span> Send Email
                        </a>
                    </div>
                </div>
                
                <div class="contact-card">
                    <div class="contact-icon">
                        <span class="material-icons">chat</span>
                    </div>
                    <h3 class="contact-title">Live Chat</h3>
                    <p class="contact-info">Chat with our support team in real-time for immediate assistance.</p>
                    <div class="contact-info">Available 8AM - 10PM</div>
                    <div class="contact-action">
                        <button class="btn-contact" id="startChatBtn">
                            <span class="material-icons">chat</span> Start Chat
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="support-form-section">
            <h2 class="section-title">
                <span class="material-icons">help_outline</span>
                Submit a Support Request
            </h2>
            <div class="support-form">
                <form id="helpForm" action="<%= request.getContextPath() %>/submitSupportRequest" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name" class="form-label">Your Name</label>
                            <input type="text" id="name" name="name" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" id="phone" name="phone" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="requestType" class="form-label">Request Type</label>
                            <select id="requestType" name="requestType" class="form-select" required>
                                <option value="">Select a request type</option>
                                <option value="booking">Booking Issue</option>
                                <option value="account">Account Problem</option>
                                <option value="payment">Payment or Billing</option>
                                <option value="feedback">Feedback</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="form-group full-width">
                            <label for="subject" class="form-label">Subject</label>
                            <input type="text" id="subject" name="subject" class="form-control" required>
                        </div>
                        <div class="form-group full-width">
                            <label for="message" class="form-label">Message</label>
                            <textarea id="message" name="message" class="form-control" required></textarea>
                        </div>
                        <div class="form-group full-width">
                            <div class="form-actions">
                                <button type="submit" class="btn-submit">
                                    <span class="material-icons">send</span> Submit Request
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <jsp:include page="/Footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // FAQ accordion functionality
            const faqQuestions = document.querySelectorAll('.faq-question');
            
            faqQuestions.forEach(question => {
                question.addEventListener('click', function() {
                    // Toggle active class on question
                    this.classList.toggle('active');
                    
                    // Toggle active class on answer
                    const answer = this.nextElementSibling;
                    answer.classList.toggle('active');
                });
            });
            
            // Help search functionality
            const helpSearch = document.getElementById('helpSearch');
            
            helpSearch.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const faqItems = document.querySelectorAll('.faq-item');
                
                faqItems.forEach(item => {
                    const question = item.querySelector('.faq-question').textContent.toLowerCase();
                    const answer = item.querySelector('.faq-answer-content').textContent.toLowerCase();
                    
                    if (question.includes(searchTerm) || answer.includes(searchTerm)) {
                        item.style.display = '';
                    } else {
                        item.style.display = 'none';
                    }
                });
            });
            
            // Smooth scroll to sections
            function scrollToSection(sectionId) {
                const section = document.getElementById(sectionId);
                if (section) {
                    window.scrollTo({
                        top: section.offsetTop - 100,
                        behavior: 'smooth'
                    });
                }
            }
            
            // Make scrollToSection available globally
            window.scrollToSection = scrollToSection;
            
            // Live chat button functionality (placeholder)
            const startChatBtn = document.getElementById('startChatBtn');
            
            if (startChatBtn) {
                startChatBtn.addEventListener('click', function() {
                    alert('Live chat feature coming soon!');
                    // Here you would typically initialize your chat widget
                });
            }
        });
    </script>
</body>
</html>