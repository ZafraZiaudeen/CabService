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
import com.cabservice.service.UserService;

@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerService customerService;

    public CustomerController() {
        super();
        customerService = new CustomerService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=adminlogin");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int customerId = Integer.parseInt(request.getParameter("customerId")); // This is customer.id
            Customer customer = customerService.getCustomerById(customerId);
            if (customer == null) {
                request.setAttribute("errorMessage", "Customer not found!");
                request.getRequestDispatcher("/WEB-INF/view/admin/manageCustomer.jsp").forward(request, response);
                return;
            }
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            customerService.deleteCustomer(customerId);
            response.sendRedirect(request.getContextPath() + "/customer");
        } else {
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
            String email = request.getParameter("email");
            String nic = request.getParameter("nic");

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            String role = "Customer";

            UserService userService = UserService.getInstance();
            if (userService.isUsernameTaken(username)) {
                request.setAttribute("errorMessage", "Username '" + username + "' is already taken.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
                return;
            }
            if (userService.isEmailTaken(email)) {
                request.setAttribute("errorMessage", "Email '" + email + "' is already taken.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
                return;
            }
            if (userService.isNICTaken(nic)) {
                request.setAttribute("errorMessage", "NIC '" + nic + "' is already taken.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
                return;
            }
            boolean success = customerService.addCustomer(name, address, phoneNumber, username, hashedPassword, role, email, nic);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer");
            } else {
                request.setAttribute("errorMessage", "Error adding customer.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-customer.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            int customerId = Integer.parseInt(request.getParameter("customerId")); // This is customer.id
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phoneNumber = request.getParameter("phone");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String nic = request.getParameter("nic");

            // Fetch the current customer to compare with new values
            Customer currentCustomer = customerService.getCustomerById(customerId);
            if (currentCustomer == null) {
                request.setAttribute("errorMessage", "Customer not found!");
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
                return;
            }

            // Check for uniqueness (excluding the current customer)
            List<Customer> allCustomers = customerService.fetchAllCustomers();
            for (Customer c : allCustomers) {
                if (c.getCustomerId() != customerId) { // Compare with customer_id
                    if (username.equals(c.getUsername())) {
                        request.setAttribute("errorMessage", "Username '" + username + "' is already taken by another user.");
                        request.setAttribute("customer", currentCustomer);
                        request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
                        return;
                    }
                    if (email.equals(c.getEmail())) {
                        request.setAttribute("errorMessage", "Email '" + email + "' is already taken by another user.");
                        request.setAttribute("customer", currentCustomer);
                        request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
                        return;
                    }
                    if (nic.equals(c.getNic())) {
                        request.setAttribute("errorMessage", "NIC '" + nic + "' is already taken by another user.");
                        request.setAttribute("customer", currentCustomer);
                        request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // If no conflicts, proceed with update
            boolean success = customerService.updateCustomer(customerId, name, address, phoneNumber, username, email, nic);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer");
            } else {
                request.setAttribute("errorMessage", "Error updating customer.");
                request.setAttribute("customer", currentCustomer);
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-customer.jsp").forward(request, response);
            }
        }
    }
}