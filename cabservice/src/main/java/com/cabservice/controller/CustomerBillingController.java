package com.cabservice.controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.dao.DriverDAO;
import com.cabservice.dao.VehicleDAO;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.model.Customer;
import com.cabservice.model.Driver;
import com.cabservice.model.Vehicle;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;
import com.cabservice.service.CustomerService;
import com.cabservice.service.SystemConfigService;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/customerBilling")
public class CustomerBillingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CustomerBillingController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        // Check if customer is authenticated
        if (session == null || session.getAttribute("customerUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);
            BookingService bookingService = new BookingService(conn);
            CustomerService customerService = new CustomerService();
            VehicleDAO vehicleDAO = new VehicleDAO();  
            DriverDAO driverDAO = new DriverDAO();   
            SystemConfigService systemConfigService = new SystemConfigService(conn); // Added SystemConfigService

            if ("view".equals(action)) {
                String billingIdStr = request.getParameter("id");
                String bookingIdStr = request.getParameter("booking_id");

                Billing billing = null;
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    billing = billingService.getBillingByBookingId(bookingId);
                } else if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    int billingId = Integer.parseInt(billingIdStr);
                    billing = billingService.getBillingById(billingId);
                }

                if (billing != null) {
                    request.setAttribute("billing", billing);
                    // Fetch and set the SystemConfig to get tax and discount percentages
                    request.setAttribute("systemConfig", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Billing details not found.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }
            } else if ("completeBilling".equals(action)) {
                String customerIdStr = request.getParameter("customer_id");
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    int customerId = Integer.parseInt(customerIdStr);
                    List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
                    request.setAttribute("bookingHistory", bookingHistory);
                    response.sendRedirect(request.getContextPath() + "/booking/history");
                } else {
                    request.setAttribute("error", "Invalid customer ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }
            } else if ("back".equals(action)) {
                String billingIdStr = request.getParameter("id");
                if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    int billingId = Integer.parseInt(billingIdStr);
                    Billing billing = billingService.getBillingById(billingId);
                    if (billing != null) {
                        int bookingId = billing.getBookingId();
                        Booking booking = bookingService.getBookingById(bookingId);
                        if (booking != null) {
                            request.setAttribute("tempBookingData", booking);
                            bookingService.deleteBooking(bookingId);
                            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                        } else {
                            request.setAttribute("error", "Booking details not found.");
                            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("error", "Billing details not found.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid billing ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }
            } else if ("viewHistory".equals(action)) {
                String customerIdStr = request.getParameter("customer_id");
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    int customerId = Integer.parseInt(customerIdStr);
                    List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
                    request.setAttribute("bookingHistory", bookingHistory);
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Invalid customer ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                }
            } else if ("generateReceipt".equals(action)) {
                String bookingIdStr = request.getParameter("booking_id");
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    Booking booking = bookingService.getBookingById(bookingId);
                    Billing billing = billingService.getBillingByBookingId(bookingId);

                    if (booking != null && billing != null) {
                        // Fetch customer name
                        Customer customer = customerService.getCustomerById(booking.getCustomerId());
                        String customerName = customer != null ? customer.getName() : "Unknown Customer";

                        // Fetch vehicle details
                        Vehicle vehicle = vehicleDAO.getVehicleById(booking.getVehicleId());
                        String vehicleModel = vehicle != null ? vehicle.getModel() : "N/A";
                        String plateNumber = vehicle != null ? vehicle.getPlateNumber() : "N/A";

                        // Fetch driver name
                        Driver driver = driverDAO.getDriverById(booking.getDriverId());
                        String driverName = driver != null ? driver.getName() : "N/A";

                        response.setContentType("application/pdf");
                        String filename = "Receipt_Booking_" + 
                                (booking.getBookingNumber() != null ? booking.getBookingNumber() : "ID_" + bookingId) + 
                                ".pdf";
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                        Document document = new Document();
                        try {
                            PdfWriter.getInstance(document, response.getOutputStream());
                            document.open();

                            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
                            Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);

                            document.add(new Paragraph("Mega City Cab Receipt", titleFont));
                            document.add(new Paragraph("Booking Number: " + (booking.getBookingNumber() != null ? booking.getBookingNumber() : "N/A"), normalFont));
                            document.add(new Paragraph("--------------------------------------------------", normalFont));
                            document.add(new Paragraph("Booking Details", titleFont));
                            document.add(new Paragraph("Customer Name: " + customerName, normalFont));
                            document.add(new Paragraph("Driver Name: " + driverName, normalFont));
                            document.add(new Paragraph("Vehicle Model: " + vehicleModel, normalFont));
                            document.add(new Paragraph("Plate Number: " + plateNumber, normalFont));
                            document.add(new Paragraph("Pickup Location: " + (booking.getPickupLocation() != null ? booking.getPickupLocation() : "N/A"), normalFont));
                            document.add(new Paragraph("Dropoff Location: " + (booking.getDropoffLocation() != null ? booking.getDropoffLocation() : "N/A"), normalFont));
                            document.add(new Paragraph("Distance: " + booking.getDistanceKm() + " km", normalFont));
                            document.add(new Paragraph("Booked At: " + (booking.getBookedAt() != null ? booking.getBookedAt() : "N/A"), normalFont));
                            document.add(new Paragraph("Status: " + (booking.getStatus() != null ? booking.getStatus() : "N/A"), normalFont));
                            document.add(new Paragraph("--------------------------------------------------", normalFont));
                            document.add(new Paragraph("Billing Details", titleFont));
                            document.add(new Paragraph("Total Amount: Rs. " + String.format("%.2f", billing.getTotalAmount()), normalFont));
                            document.add(new Paragraph("Tax: Rs. " + String.format("%.2f", billing.getTax()), normalFont));
                            document.add(new Paragraph("Discount: Rs. " + String.format("%.2f", billing.getDiscount()), normalFont));
                            document.add(new Paragraph("Final Amount: Rs. " + String.format("%.2f", billing.getFinalAmount()), normalFont));
                            document.add(new Paragraph("Payment Status: " + (billing.getStatus() != null ? billing.getStatus() : "Pending"), normalFont));
                            document.add(new Paragraph("Payment Type: " + (billing.getPaymentType() != null ? billing.getPaymentType() : "Pending"), normalFont));
                            document.add(new Paragraph("--------------------------------------------------", normalFont));
                            document.add(new Paragraph("Thank you for choosing Mega City Cab!", normalFont));

                            document.close();
                        } catch (DocumentException e) {
                            e.printStackTrace();
                            throw new IOException("Error generating PDF: " + e.getMessage());
                        }
                    } else {
                        request.setAttribute("error", "Booking or billing details not found for booking ID: " + bookingId);
                        request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);
            BookingService bookingService = new BookingService(conn);

            if ("save".equals(action)) {
                String bookingIdStr = request.getParameter("booking_id");
                String paymentType = request.getParameter("payment_type");
                int bookingId = Integer.parseInt(bookingIdStr);

                if (paymentType == null || paymentType.isEmpty()) {
                    request.setAttribute("error", "Payment type cannot be null.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    return;
                }

                Billing existingBilling = billingService.getBillingByBookingId(bookingId);
                if (existingBilling != null) {
                    existingBilling.setPaymentType(paymentType);
                    if ("Card".equals(paymentType)) {
                        existingBilling.setCardNumber(request.getParameter("card_number"));
                        existingBilling.setCvv(request.getParameter("cvv"));
                        existingBilling.setExpiryDate(request.getParameter("expiry_date"));
                    } else {
                        existingBilling.setCardNumber(null);
                        existingBilling.setCvv(null);
                        existingBilling.setExpiryDate(null);
                    }
                    billingService.updateBilling(existingBilling);
                    billingService.updateBillingStatusByBookingId(bookingId, "Paid", paymentType, 
                        request.getParameter("card_number"), request.getParameter("cvv"), request.getParameter("expiry_date"));
                    
                    bookingService.updateBookingStatus(bookingId, "Ongoing");
                } else {
                    Billing billing = new Billing();
                    billing.setBookingId(bookingId);
                    billing.setTotalAmount(Double.parseDouble(request.getParameter("total_amount")));
                    billing.setTax(Double.parseDouble(request.getParameter("tax")));
                    billing.setDiscount(Double.parseDouble(request.getParameter("discount")));
                    billing.setFinalAmount(Double.parseDouble(request.getParameter("final_amount")));
                    billing.setPaymentType(paymentType);
                    if ("Card".equals(paymentType)) {
                        billing.setCardNumber(request.getParameter("card_number"));
                        billing.setCvv(request.getParameter("cvv"));
                        billing.setExpiryDate(request.getParameter("expiry_date"));
                    }
                    int billingId = billingService.createBilling(billing);
                    if (billingId != -1) {
                        billingService.updateBillingStatus(billingId, "Paid", paymentType, 
                            request.getParameter("card_number"), request.getParameter("cvv"), request.getParameter("expiry_date"));
                        bookingService.updateBookingStatus(bookingId, "Ongoing");
                    } else {
                        request.setAttribute("error", "Failed to create billing.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                        return;
                    }
                }

                request.setAttribute("success", "Payment completed successfully!");
                Integer customerId = (Integer) request.getSession().getAttribute("customerId");
                if (customerId != null) {
                    response.sendRedirect(request.getContextPath() + "/customerBilling?action=completeBilling&customer_id=" + customerId);
                } else {
                    request.setAttribute("error", "Customer ID is missing.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
        }
    }
}