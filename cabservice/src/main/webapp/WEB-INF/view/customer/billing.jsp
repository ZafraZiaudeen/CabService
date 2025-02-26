<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Billing" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing & Payment - CabService</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/styles.css'/>">
    <style>
        /* Billing & Payment Page Styles */
        .billing-page {
            margin-top: 100px;
            padding: 20px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        .page-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 30px;
        }

        .back-button {
            background: none;
            border: none;
            cursor: pointer;
            color: #555;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .back-button:hover {
            background-color: rgba(255, 193, 7, 0.1);
            color: #FFC107;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            font-family: 'Poppins', sans-serif;
        }

        .billing-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .billing-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .card-header {
            background-color: #FFC107;
            padding: 20px;
            position: relative;
        }

        .card-header h2 {
            color: #000;
            font-size: 20px;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .card-header .material-icons {
            font-size: 24px;
        }

        .card-body {
            padding: 25px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            font-family: 'Poppins', sans-serif;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .label {
            color: #666;
            font-size: 15px;
        }

        .value {
            font-weight: 500;
            color: #333;
        }

        .final-amount {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #eee;
        }

        .final-amount .label {
            font-size: 16px;
            font-weight: 500;
            color: #333;
        }

        .final-amount .value {
            font-size: 24px;
            color: #FFC107;
            font-weight: 600;
        }

        .payment-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
        }

        .tab-button {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 8px;
            background: #f5f5f5;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            color: #666;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }

        .tab-button.active {
            background: #FFC107;
            color: #000;
        }

        .tab-button:hover:not(.active) {
            background: #f0f0f0;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
            font-size: 15px;
            font-family: 'Poppins', sans-serif;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }

        .form-control:focus {
            border-color: #FFC107;
            box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
            outline: none;
        }

        .input-group {
            display: flex;
            gap: 10px;
        }

        .submit-button {
            width: 100%;
            padding: 14px;
            background: #FFC107;
            color: #000;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .submit-button:hover {
            background: #FFD54F;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(255, 193, 7, 0.3);
        }

        .error-message {
            color: #e53935;
            background: #ffebee;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .card-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 40px;
            opacity: 0.2;
            color: #000;
        }

        .payment-info {
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            font-size: 14px;
            color: #666;
            line-height: 1.5;
            font-family: 'Poppins', sans-serif;
        }

        .payment-info .material-icons {
            font-size: 18px;
            vertical-align: middle;
            margin-right: 5px;
            color: #FFC107;
        }

        /* Card type icons */
        .card-types {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .card-type {
            width: 40px;
            height: 25px;
            background-color: #f0f0f0;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 600;
        }

        .visa {
            background-color: #0157a2;
            color: white;
        }

        .mastercard {
            background-color: #eb001b;
            color: white;
        }

        .amex {
            background-color: #2671b8;
            color: white;
        }

        /* Checkbox styling */
        .checkbox-container {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 15px;
        }

        .checkbox-container input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-top: 3px;
        }

        .checkbox-label {
            font-size: 15px;
            color: #333;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .billing-container {
                grid-template-columns: 1fr;
            }

            .input-group {
                flex-direction: column;
            }
            
            .billing-page {
                padding: 15px;
                margin-top: 80px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/Header.jsp" />

    <main class="billing-page">
        <div class="page-header">
            <button class="back-button" onclick="goBackToAddBooking()">
                <span class="material-icons">arrow_back</span>
            </button>
            <h1 class="page-title">Billing & Payment</h1>
        </div>

        <div class="billing-container">
            <!-- Billing Details Section -->
            <div class="billing-card">
                <div class="card-header">
                    <h2>
                        <span class="material-icons">receipt</span>
                        Billing Details
                    </h2>
                    <span class="material-icons card-icon">receipt_long</span>
                </div>

                <div class="card-body">
                    <%
                        Billing billing = (Billing) request.getAttribute("billing");
                        if (billing != null) {
                    %>
                        <div class="detail-item">
                            <span class="label">Booking ID</span>
                            <span class="value">#<%= billing.getBookingId() %></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Base Fare</span>
                            <span class="value">Rs.<%= String.format("%.2f", billing.getTotalAmount()) %></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Tax (18%)</span>
                            <span class="value">Rs.<%= String.format("%.2f", billing.getTax()) %></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Discount</span>
                            <span class="value">-Rs.<%= String.format("%.2f", billing.getDiscount()) %></span>
                        </div>
                        <div class="detail-item final-amount">
                            <span class="label">Total Amount</span>
                            <span class="value">Rs.<%= String.format("%.2f", billing.getFinalAmount()) %></span>
                        </div>
                        <div class="detail-item">
                            <span class="label">Generated At</span>
                            <span class="value"><%= billing.getGeneratedAt() %></span>
                        </div>
                    <%
                        } else {
                    %>
                        <div class="error-message">
                            <span class="material-icons">error</span>
                            Billing details not found. Please try again or contact support.
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Payment Section -->
            <div class="billing-card">
                <div class="card-header">
                    <h2>
                        <span class="material-icons">payment</span>
                        Payment Method
                    </h2>
                    <span class="material-icons card-icon">payments</span>
                </div>

                <div class="card-body">
                    <div class="payment-tabs">
                        <button type="button" class="tab-button active" onclick="switchTab('credit-card')" id="credit-card-tab">
                            <span class="material-icons">credit_card</span>
                            Pay Online
                        </button>
                        <button type="button" class="tab-button" onclick="switchTab('cash')" id="cash-tab">
                            <span class="material-icons">local_atm</span>
                            Pay with Cash
                        </button>
                    </div>

                    <!-- Credit Card Form -->
                    <form id="credit-card-form" action="<%= request.getContextPath() %>/customerBilling?action=save" method="post" onsubmit="return combineExpiryDate()">
                        <input type="hidden" name="payment_type" value="Card">
                        <input type="hidden" name="booking_id" value="<%= billing != null ? billing.getBookingId() : "" %>">
                        <input type="hidden" name="total_amount" value="<%= billing != null ? billing.getTotalAmount() : 0 %>">
                        <input type="hidden" name="tax" value="<%= billing != null ? billing.getTax() : 0 %>">
                        <input type="hidden" name="discount" value="<%= billing != null ? billing.getDiscount() : 0 %>">
                        <input type="hidden" name="final_amount" value="<%= billing != null ? billing.getFinalAmount() : 0 %>">
                        <input type="hidden" name="expiry_date" id="expiry_date">

                        <div class="form-group">
                            <label for="card_owner">Card Owner</label>
                            <input type="text" id="card_owner" name="card_owner" class="form-control" placeholder="Enter name as on card" required>
                        </div>

                        <div class="form-group">
                            <label for="card_number">Card Number</label>
                            <input type="text" id="card_number" name="card_number" class="form-control" maxlength="19" placeholder="1234 5678 9012 3456" required>
                            <div class="card-types">
                                <div class="card-type visa">VISA</div>
                                <div class="card-type mastercard">MC</div>
                            </div>
                        </div>

                        <div class="input-group">
                            <div class="form-group" style="flex: 2;">
                                <label>Expiration Date</label>
                                <div class="input-group">
                                    <input type="text" name="exp_month" id="exp_month" class="form-control" placeholder="MM" maxlength="2" required>
                                    <input type="text" name="exp_year" id="exp_year" class="form-control" placeholder="YY" maxlength="2" required>
                                </div>
                            </div>
                            <div class="form-group" style="flex: 1;">
                                <label for="cvv">CVV</label>
                                <input type="text" id="cvv" name="cvv" class="form-control" placeholder="123" maxlength="4" required>
                            </div>
                        </div>

                        <div class="payment-info">
                            <span class="material-icons">lock</span> Your payment information is secure. We use encryption to protect your data.
                        </div>

                        <button type="submit" class="submit-button">
                            <span class="material-icons">credit_card</span>
                            Pay ₹<%= billing != null ? String.format("%.2f", billing.getFinalAmount()) : "0.00" %>
                        </button>
                    </form>

                    <!-- Cash Payment Form -->
                    <form id="cash-form" action="<%= request.getContextPath() %>/customerBilling?action=save" method="post" style="display: none;">
                        <input type="hidden" name="payment_type" value="Cash">
                        <input type="hidden" name="booking_id" value="<%= billing != null ? billing.getBookingId() : "" %>">
                        <input type="hidden" name="total_amount" value="<%= billing != null ? billing.getTotalAmount() : 0 %>">
                        <input type="hidden" name="tax" value="<%= billing != null ? billing.getTax() : 0 %>">
                        <input type="hidden" name="discount" value="<%= billing != null ? billing.getDiscount() : 0 %>">
                        <input type="hidden" name="final_amount" value="<%= billing != null ? billing.getFinalAmount() : 0 %>">

                        <div class="checkbox-container">
                            <input type="checkbox" id="cash_agreement" required>
                            <label for="cash_agreement" class="checkbox-label">
                                I agree to pay Rs.<%= billing != null ? String.format("%.2f", billing.getFinalAmount()) : "0.00" %> in cash to the driver upon completion of the ride.
                            </label>
                        </div>

                        <div class="payment-info">
                            <span class="material-icons">info</span> Please ensure you have the exact amount ready for the driver. Our drivers may not always have change available.
                        </div>

                        <button type="submit" class="submit-button">
                            <span class="material-icons">local_atm</span>
                            Confirm Cash Payment
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="/Footer.jsp" />

    <script>
        function combineExpiryDate() {
            const expMonth = document.getElementById('exp_month').value;
            const expYear = document.getElementById('exp_year').value;
            
            // Validate month and year
            if (expMonth < 1 || expMonth > 12) {
                alert("Please enter a valid month (1-12)");
                return false;
            }
            
            const currentYear = new Date().getFullYear() % 100;
            if (expYear < currentYear) {
                alert("Card expiration year cannot be in the past");
                return false;
            }
            
            // Format month to always be 2 digits
            const formattedMonth = expMonth.padStart(2, '0');
            const expiryDate = `${formattedMonth}/${expYear}`;
            document.getElementById('expiry_date').value = expiryDate;
            return true;
        }

        function switchTab(tabId) {
            // Update tab buttons
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('active');
            });
            document.getElementById(`${tabId}-tab`).classList.add('active');

            // Show/hide forms
            document.getElementById('credit-card-form').style.display = tabId === 'credit-card' ? 'block' : 'none';
            document.getElementById('cash-form').style.display = tabId === 'cash' ? 'block' : 'none';
        }

        function goBackToAddBooking() {
            const urlParams = new URLSearchParams(window.location.search);
            const billingId = urlParams.get("id"); 
            const contextPath = "<%= request.getContextPath() %>";
            
            if (billingId) {
                // Navigate to the BillingController with action=back
                window.location.href = `${contextPath}/customerBilling?action=back&id=${billingId}`;
            } else {
                // If no ID, just go back to the previous page
                window.history.back();
            }
        }

        // Card number formatting
        document.getElementById('card_number').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            value = value.replace(/(.{4})/g, '$1 ').trim();
            e.target.value = value;
        });

        // Expiration date validation
        document.getElementById('exp_month').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (parseInt(value) > 12) value = '12';
            e.target.value = value;
        });

        document.getElementById('exp_year').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            e.target.value = value;
        });

        // CVV validation - numbers only
        document.getElementById('cvv').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/\D/g, '');
        });
    </script>
</body>
</html>