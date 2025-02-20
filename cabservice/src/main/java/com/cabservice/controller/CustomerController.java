package com.cabservice.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import com.cabservice.model.Customer;
import com.cabservice.service.CustomerService;

/**
 * Servlet implementation class CustomerController
 */
@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CustomerService customerService;

    public CustomerController() {
        super();
        customerService = new CustomerService(); 
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Do NOT create a new session

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=adminlogin");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
        } else if ("edit".equals(action)) {  // ✅ FIXED: Handle edit action
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            Customer customer = customerService.getCustomerById(customerId);

            if (customer == null) {
                request.setAttribute("errorMessage", "Customer not found!");
                request.getRequestDispatcher("/WEB-INF/view/admin/manageCustomer.jsp").forward(request, response);
                return;
            }

            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            // Delete customer logic
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            customerService.deleteCustomer(customerId);
            response.sendRedirect(request.getContextPath() + "/customer"); // Redirect back to customer management
        } else {
            // ✅ Fetch customers from CustomerService
            List<Customer> customers = customerService.fetchAllCustomers();
            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/WEB-INF/view/admin/manageCustomer.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("save".equals(action)) {
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phoneNumber = request.getParameter("phone");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String nic = request.getParameter("nic");

            // ✅ Hash the password before storing it
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            String role = "Customer"; // Default role

            // ✅ Call the service layer to add customer
            boolean success = customerService.addCustomer(name, address, phoneNumber, username, hashedPassword, role, nic);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer");
            } else {
                request.setAttribute("errorMessage", "Error adding customer.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {  // ✅ Handle customer update
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phoneNumber = request.getParameter("phone");
            String username = request.getParameter("username");
            String nic = request.getParameter("nic");

            boolean success = customerService.updateCustomer(customerId, name, address, phoneNumber, username, nic);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer");
            } else {
                request.setAttribute("errorMessage", "Error updating customer.");
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
            }
        }
    }
}
