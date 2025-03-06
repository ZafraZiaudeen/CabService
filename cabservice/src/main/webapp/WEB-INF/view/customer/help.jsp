<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <link rel="stylesheet" href="<c:url value='/css/customerHelp.css'/>">
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
                            Click on "Book a Ride" from the homepage to start booking. Choose your pickup and dropoff locations either by selecting them on the map or typing them in—the distance of your ride will be displayed. Then, select your preferred ride vehicle and click "Book Now." You’ll be directed to the billing section to complete the process.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I complete the billing for my ride?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            After clicking "Book Now," you’ll be taken to the billing section. Here, you can enter your card details for payment or agree to pay with cash to the driver. Once you submit your payment details or confirm cash payment, your booking will be successful and set as "Ongoing" in your booking history.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        What if I need to change my booking details before paying?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            If you forgot something while booking, click the "Back" button in the billing section. This will take you back to the booking form, where you can edit your pickup/dropoff locations, vehicle type, or other details. After making changes, click "Book Now" again to return to billing and complete your booking.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How can I cancel my booking?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            You can cancel your booking through the "Booking History" section in your account, but only within 5-10 minutes of booking. Go to "Booking History," find your recent booking, and click the cancel option if available. After this time window, cancellation is no longer possible through this section.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I view my ride details or complete a pending payment?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            In the "Booking History" section, you can see all your ride details, including past and current bookings. If you have a pending booking, look for the card icon next to it—click it to complete your payment by entering your card details or confirming cash payment.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I print a receipt for my ride?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Go to the "Booking History" section in your account. Find the booking you want a receipt for, and in the action column, click the "Print" option. This will generate a PDF of your receipt, which you can download or print.
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
                            To create an account, click on the "Register" button in the top right corner of the homepage. Provide all your details, including a valid email address, and submit the form. You'll receive an email with a verification link—click it to verify your details. Once verified, you can log in using your credentials.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I log in after registration?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            After verifying your email by clicking the link sent to you, go to the homepage and click "Login." Enter your email and password, then click "Submit." You’ll now be able to access your account and start booking rides.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I view my account details?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Log in to your account and go to the "Account" or "My Profile" section. Here, you’ll see an overview of your details, including your name, email, phone number, and other personal information.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I edit my account details?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Click on the person icon on top near logout button after logging in. Click the "Edit" button next to your details, update your information (such as name, phone number, or email), and click "Save" to apply the changes.
                        </div>
                    </div>
                </div>
                
                <div class="faq-item">
                    <div class="faq-question">
                        How do I change my password?
                        <span class="material-icons">expand_more</span>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            In the "Account" or "My Profile" section, find the password settings or "Change Password" option. Enter your current password, then provide and confirm your new password. Click "Save" or "Update" to change it.
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
                            We accept all major credit and debit cards (Visa, Mastercard) and cash payments directly to the driver.
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
                           A receipt is automatically emailed to you after completing your ride. You can also find all your receipts in the "Booking History" section of your account. Click on any past booking and select "Print" in the action column to get a PDF copy.
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
                            Refunds are processed if you cancel within the allowed 5-10 minute window after booking. If eligible, the refund will be credited back to your original payment method within 5-7 business days. For any refund inquiries, please contact us.
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
                    <div class="contact-info">+94 (777) 123-4567</div>
                    <div class="contact-action">
                        <a href="tel:+947771234567" class="btn-contact">
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
                    <div class="contact-info">megacitycab11@gmail.com</div>
                    <div class="contact-action">
                        <a href="mailto:megacitycab11@gmail.com" class="btn-contact">
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
    </main>

    <jsp:include page="/Footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const faqQuestions = document.querySelectorAll('.faq-question');
            
            faqQuestions.forEach(question => {
                question.addEventListener('click', function() {
                    this.classList.toggle('active');
                    const answer = this.nextElementSibling;
                    answer.classList.toggle('active');
                });
            });
            
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
            
            function scrollToSection(sectionId) {
                const section = document.getElementById(sectionId);
                if (section) {
                    window.scrollTo({
                        top: section.offsetTop - 100,
                        behavior: 'smooth'
                    });
                }
            }
            
            window.scrollToSection = scrollToSection;
            
            const startChatBtn = document.getElementById('startChatBtn');
            if (startChatBtn) {
                startChatBtn.addEventListener('click', function() {
                    alert('Live chat feature coming soon!');
                });
            }
        });
    </script>
</body>
</html>