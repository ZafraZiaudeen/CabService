<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cabservice.model.Billing" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing & Payment - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            background: #f0f2f5;
        }

        .main-content {
            margin-left: 260px;
            padding: 20px;
        }

        .page-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .back-button {
            background: none;
            border: none;
            cursor: pointer;
            color: #64748b;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #1e293b;
        }

        .billing-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .billing-details, .payment-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 24px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .label {
            color: #64748b;
            font-size: 14px;
        }

        .value {
            font-weight: 500;
            color: #1e293b;
        }

        .final-amount {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #e2e8f0;
        }

        .final-amount .value {
            font-size: 24px;
            color: #0984e3;
        }

        .payment-tabs {
            display: flex;
            gap: 10px;
            background: #f8fafc;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .tab-button {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: none;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            color: #64748b;
            transition: all 0.2s;
        }

        .tab-button.active {
            background: #0984e3;
            color: white;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #334155;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 14px;
        }

        .input-group {
            display: flex;
            gap: 10px;
        }

        .submit-button {
            width: 100%;
            padding: 12px;
            background: #0984e3;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .submit-button:hover {
            background: #0773c5;
        }

        .error-message {
            color: #dc2626;
            background: #fee2e2;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
            }

            .billing-container {
                grid-template-columns: 1fr;
            }

            .input-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content">
        <div class="page-header">
            <button class="back-button" onclick="window.location.href='active-bookings.jsp'">
                <span class="material-icons">arrow_back</span>
            </button>
            <h1 class="page-title">Billing & Payment</h1>
        </div>

        <div class="billing-container">
            <!-- Billing Details Section -->
            <div class="billing-details">
                <h2 class="section-title">
                    <span class="material-icons">receipt</span>
                    Billing Details
                </h2>

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
                        Billing details not found.
                    </div>
                <%
                    }
                %>
            </div>

            <!-- Payment Section -->
            <div class="payment-section">
                <h2 class="section-title">
                    <span class="material-icons">payment</span>
                    Payment Method
                </h2>

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
<form id="credit-card-form" action="<%= request.getContextPath() %>/billing?action=save" method="post" onsubmit="return combineExpiryDate()">
    <input type="hidden" name="payment_type" value="Card"> <!-- Ensure payment_type is set -->
    <input type="hidden" name="booking_id" value="<%= billing != null ? billing.getBookingId() : "" %>">
    <input type="hidden" name="total_amount" value="<%= billing != null ? billing.getTotalAmount() : 0 %>">
    <input type="hidden" name="tax" value="<%= billing != null ? billing.getTax() : 0 %>">
    <input type="hidden" name="discount" value="<%= billing != null ? billing.getDiscount() : 0 %>">
    <input type="hidden" name="final_amount" value="<%= billing != null ? billing.getFinalAmount() : 0 %>">
    <input type="hidden" name="expiry_date" id="expiry_date"> <!-- Hidden field for combined expiry date -->

    <div class="form-group">
        <label for="card_owner">Card Owner</label>
        <input type="text" id="card_owner" name="card_owner" class="form-control" required>
    </div>

    <div class="form-group">
        <label for="card_number">Card Number</label>
        <input type="text" id="card_number" name="card_number" class="form-control" 
               maxlength="19" placeholder="1234 5678 9012 3456" required>
    </div>

    <div class="input-group">
        <div class="form-group" style="flex: 2;">
            <label>Expiration Date</label>
            <div class="input-group">
                <input type="text" name="exp_month" id="exp_month" class="form-control" 
                       placeholder="MM" maxlength="2" required>
                <input type="text" name="exp_year" id="exp_year" class="form-control" 
                       placeholder="YY" maxlength="2" required>
            </div>
        </div>
        <div class="form-group" style="flex: 1;">
            <label for="cvv">CVV</label>
            <input type="text" id="cvv" name="cvv" class="form-control" 
                   placeholder="123" maxlength="4" required>
        </div>
    </div>

    <button type="submit" class="submit-button">Pay ₹<%= billing != null ? String.format("%.2f", billing.getFinalAmount()) : "0.00" %></button>
</form>
<!-- Cash Payment Form -->
<form id="cash-form" action="<%= request.getContextPath() %>/billing?action=save" method="post" style="display: none;">
    <input type="hidden" name="payment_type" value="Cash"> <!-- Ensure payment_type is set -->
    <input type="hidden" name="booking_id" value="<%= billing != null ? billing.getBookingId() : "" %>">
    <input type="hidden" name="total_amount" value="<%= billing != null ? billing.getTotalAmount() : 0 %>">
    <input type="hidden" name="tax" value="<%= billing != null ? billing.getTax() : 0 %>">
    <input type="hidden" name="discount" value="<%= billing != null ? billing.getDiscount() : 0 %>">
    <input type="hidden" name="final_amount" value="<%= billing != null ? billing.getFinalAmount() : 0 %>">

    <div class="form-group">
        <label>
            <input type="checkbox" required>
            I agree to pay Rs.<%= billing != null ? String.format("%.2f", billing.getFinalAmount()) : "0.00" %> in cash to the driver.
        </label>
        <p style="margin-top: 8px; color: #64748b; font-size: 14px;">
            Please ensure you have the exact amount ready for the driver.
        </p>
    </div>

    <button type="submit" class="submit-button">Confirm Cash Payment</button>
</form>
            </div>
        </div>
    </main>

    <script>
    
    function combineExpiryDate() {
        const expMonth = document.getElementById('exp_month').value;
        const expYear = document.getElementById('exp_year').value;
        const expiryDate = `${expMonth}/${expYear}`;
        document.getElementById('expiry_date').value = expiryDate;
        return true; // Allow form submission
    }
        function switchTab(tabId) {
            // Update tab buttons
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('active');
            });
            document.getElementById(`${tabId}-tab`).classList.add('active');

            // Show/hide forms
            document.getElementById('credit-card-form').style.display = 
                tabId === 'credit-card' ? 'block' : 'none';
            document.getElementById('cash-form').style.display = 
                tabId === 'cash' ? 'block' : 'none';
        }

        // Card number formatting
        document.getElementById('card_number').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            value = value.replace(/(.{4})/g, '$1 ').trim();
            e.target.value = value;
        });

        // Expiration date validation
        document.querySelector('input[name="exp_month"]').addEventListener('input', function(e) {
            let value = parseInt(e.target.value);
            if (value > 12) e.target.value = '12';
            if (value < 1) e.target.value = '01';
        });
    </script>
</body>
</html>

