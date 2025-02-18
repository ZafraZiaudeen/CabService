package com.cabservice.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import com.cabservice.model.Customer;
import com.cabservice.service.UserService;

@WebServlet("/user")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public UserController() {
        super();
    }

    public void init() throws ServletException {
        userService = UserService.getInstance();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.equals("home")) {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else if (action.equals("register")) {
            showRegisterPage(request, response);
        } else if (action.equals("login")) {
            showLoginPage(request, response);
        } else if (action.equals("adminlogin")) {
            showAdminLoginPage(request, response);
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
    }

    private void showAdminLoginPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/admin/adminlogin.jsp").forward(request, response);
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null && action.equals("register")) {
            processCustomerRegistration(request, response);
        } else {
            doGet(request, response);
        }
    }

    protected void processCustomerRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Customer customer = new Customer();
            customer.setName(request.getParameter("name"));
            customer.setAddress(request.getParameter("address"));
            customer.setPhoneNumber(request.getParameter("phoneNumber"));
            customer.setUsername(request.getParameter("username"));
            customer.setPassword(BCrypt.hashpw(request.getParameter("password"), BCrypt.gensalt()));
            customer.setRole("Customer");
            customer.setNic(request.getParameter("nic"));

            if (userService.addUser(customer) > 0) {
                response.sendRedirect("user?action=login");
            } else {
                request.setAttribute("errorMessage", "User registration failed.");
                request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        }
    }
}
