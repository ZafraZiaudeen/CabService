package com.cabservice.controller;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.model.Customer;
import com.cabservice.model.Driver;
import com.cabservice.model.Vehicle;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;
import com.cabservice.dao.DriverDAO;
import com.cabservice.dao.VehicleDAO;
import com.cabservice.service.CustomerService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BookingController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            BillingService billingService = new BillingService(conn);
            CustomerService customerService = new CustomerService();
            VehicleDAO vehicleDAO = new VehicleDAO();
            DriverDAO driverDAO = new DriverDAO();

            if ("add".equals(action)) {
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            } else if ("manage".equals(action)) {
                List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
            } else if ("pending".equals(action)) {
                List<Map<String, Object>> bookings = bookingService.getPendingBookings();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/pendingBooking.jsp").forward(request, response);
            } else if ("ongoing".equals(action)) {
                List<Map<String, Object>> bookings = bookingService.getOngoingBookings();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/ongoingBooking.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    Booking booking = bookingService.getBookingById(bookingId);
                    if (booking != null) {
                        request.setAttribute("booking", booking);
                        request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Booking not found.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                }
            } else if ("delete".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    boolean deleted = bookingService.deleteBooking(bookingId);
                    if (deleted) {
                        request.setAttribute("success", "Booking deleted successfully!");
                    } else {
                        request.setAttribute("error", "Failed to delete booking.");
                    }
                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                }
                List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
            } else if ("generateReceipt".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    Booking booking = bookingService.getBookingById(bookingId);
                    Billing billing = billingService.getBillingByBookingId(bookingId);

                    if (booking != null) {
                        Customer customer = customerService.getCustomerById(booking.getCustomerId());
                        String customerName = customer != null ? customer.getName() : "Unknown Customer";

                        Vehicle vehicle = vehicleDAO.getVehicleById(booking.getVehicleId());
                        String vehicleModel = vehicle != null ? vehicle.getModel() : "N/A";
                        String plateNumber = vehicle != null ? vehicle.getPlateNumber() : "N/A";

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
                            if (billing != null) {
                                document.add(new Paragraph("Billing Details", titleFont));
                                document.add(new Paragraph("Total Amount: Rs. " + String.format("%.2f", billing.getTotalAmount()), normalFont));
                                document.add(new Paragraph("Tax: Rs. " + String.format("%.2f", billing.getTax()), normalFont));
                                document.add(new Paragraph("Discount: Rs. " + String.format("%.2f", billing.getDiscount()), normalFont));
                                document.add(new Paragraph("Final Amount: Rs. " + String.format("%.2f", billing.getFinalAmount()), normalFont));
                                document.add(new Paragraph("Payment Status: " + (billing.getStatus() != null ? billing.getStatus() : "Pending"), normalFont));
                                document.add(new Paragraph("Payment Type: " + (billing.getPaymentType() != null ? billing.getPaymentType() : "Pending"), normalFont));
                            } else {
                                document.add(new Paragraph("Billing Details", titleFont));
                                document.add(new Paragraph("Billing information not available.", normalFont));
                            }
                            document.add(new Paragraph("--------------------------------------------------", normalFont));
                            document.add(new Paragraph("Thank you for choosing Mega City Cab!", normalFont));

                            document.close();
                        } catch (DocumentException e) {
                            e.printStackTrace();
                            throw new IOException("Error generating PDF: " + e.getMessage());
                        }
                    } else {
                        request.setAttribute("error", "Booking details not found for booking ID: " + bookingId);
                        request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid action.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            BillingService billingService = new BillingService(conn);

            if ("save".equals(action)) {
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");
                String distanceKmStr = request.getParameter("distance_km");

                // Validate input
                if (customerIdStr == null || vehicleIdStr == null || pickupLocation == null || 
                    dropoffLocation == null || distanceKmStr == null || 
                    customerIdStr.isEmpty() || vehicleIdStr.isEmpty() || pickupLocation.isEmpty() || 
                    dropoffLocation.isEmpty() || distanceKmStr.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                int customerId;
                int vehicleId;
                double distanceKm;
                try {
                    customerId = Integer.parseInt(customerIdStr);
                    vehicleId = Integer.parseInt(vehicleIdStr);
                    distanceKm = Double.parseDouble(distanceKmStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid customer ID, vehicle ID, or distance format.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                if (distanceKm <= 0) {
                    request.setAttribute("error", "Distance must be greater than zero.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                Booking newBooking = new Booking();
                newBooking.setBookingNumber("BK" + System.currentTimeMillis());
                newBooking.setCustomerId(customerId);
                newBooking.setDriverId(bookingService.getDriverForVehicle(vehicleId));
                newBooking.setVehicleId(vehicleId);
                newBooking.setPickupLocation(pickupLocation);
                newBooking.setDropoffLocation(dropoffLocation);
                newBooking.setDistanceKm(distanceKm);

                int bookingId = bookingService.createBooking(newBooking);
                if (bookingId != -1) {
                    double finalAmount = bookingService.calculateFinalAmount(vehicleId, distanceKm);
                    if (finalAmount < 0) {
                        request.setAttribute("error", "Failed to calculate final amount.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                        return;
                    }

                    Billing billing = new Billing();
                    billing.setBookingId(bookingId);
                    // Let sp_create_billing calculate total_amount, tax, discount, and final_amount
                    int billingId = billingService.createBilling(billing);
                    if (billingId != -1) {
                        request.setAttribute("success", "Booking created successfully with ID: " + bookingId);
                        List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                        request.setAttribute("bookings", bookings);
                        request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("error", "Billing creation failed.");
                    }
                } else {
                    request.setAttribute("error", "Booking creation failed.");
                }
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String status = request.getParameter("status");
                String distanceKmStr = request.getParameter("distance_km");

                if (bookingIdStr == null || pickupLocation == null || dropoffLocation == null || 
                    customerIdStr == null || vehicleIdStr == null || status == null || 
                    distanceKmStr == null || distanceKmStr.isEmpty()) {
                    request.setAttribute("error", "Missing required fields.");
                    List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                    request.setAttribute("bookings", bookings);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    return;
                }

                int bookingId;
                int customerId;
                int vehicleId;
                double distanceKm;
                try {
                    bookingId = Integer.parseInt(bookingIdStr);
                    customerId = Integer.parseInt(customerIdStr);
                    vehicleId = Integer.parseInt(vehicleIdStr);
                    distanceKm = Double.parseDouble(distanceKmStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid booking ID, customer ID, vehicle ID, or distance format.");
                    List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                    request.setAttribute("bookings", bookings);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    return;
                }

                if (distanceKm <= 0) {
                    request.setAttribute("error", "Distance must be greater than zero.");
                    List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                    request.setAttribute("bookings", bookings);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    return;
                }

                Booking booking = bookingService.getBookingById(bookingId);
                if (booking != null) {
                    booking.setCustomerId(customerId);
                    booking.setVehicleId(vehicleId);
                    booking.setPickupLocation(pickupLocation);
                    booking.setDropoffLocation(dropoffLocation);
                    booking.setDistanceKm(distanceKm);
                    booking.setStatus(status);
                    bookingService.updateBooking(booking);
                    bookingService.updateBookingStatus(bookingId, status);

                    if (!"Cancelled".equals(status)) {
                        double finalAmount = bookingService.calculateFinalAmount(vehicleId, distanceKm);
                        if (finalAmount < 0) {
                            request.setAttribute("error", "Failed to calculate final amount.");
                        } else {
                            Billing billing = billingService.getBillingByBookingId(bookingId);
                            if (billing != null) {
                                billing.setFinalAmount(finalAmount); // Preview; sp_create_billing will override if re-run
                                billingService.updateBilling(billing);
                            }
                        }
                    } else {
                        Billing billing = billingService.getBillingByBookingId(bookingId);
                        if (billing != null) {
                            billingService.updateBillingStatusByBookingId(bookingId, "Cancelled", billing.getPaymentType(), null, null, null);
                            billingService.removePaymentDetails(bookingId);
                        }
                    }

                    request.setAttribute("success", "Booking updated successfully!");
                } else {
                    request.setAttribute("error", "Booking not found.");
                }

                List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
        }
    }
}