package com.cabservice.controller;

import com.cabservice.service.AssignmentService;
import com.cabservice.model.Assignment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/assignment")
public class AssignmentController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AssignmentService assignmentService;

    public AssignmentController() {
        super();
        assignmentService = new AssignmentService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        try {
            if (action == null || action.isEmpty()) {
                action = "list";
            }

            switch (action) {
                case "list":
                    List<Assignment> assignments = assignmentService.getAllAssignments();
                    request.setAttribute("assignments", assignments);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageAssignment.jsp").forward(request, response);
                    break;
                case "add":
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-assignment.jsp").forward(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/assignment?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/admin/manageAssignment.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("assign".equals(action)) {
                int driverId = Integer.parseInt(request.getParameter("driverId"));
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

                boolean success = assignmentService.assignVehicleToDriver(driverId, vehicleId);
                if (success) {
                    request.setAttribute("message", "Assignment successful!");
                } else {
                    request.setAttribute("error", "Assignment failed!");
                }
            } else if ("unassign".equals(action)) {
                int driverId = Integer.parseInt(request.getParameter("driverId"));
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

                boolean success = assignmentService.unassignVehicle(driverId, vehicleId);
                if (success) {
                    request.setAttribute("message", "Unassignment successful!");
                } else {
                    request.setAttribute("error", "Unassignment failed!");
                }
            }

            // After setting the message/error, forward to the list page instead of redirecting
            List<Assignment> assignments = assignmentService.getAllAssignments();
            request.setAttribute("assignments", assignments);
            request.getRequestDispatcher("/WEB-INF/view/admin/manageAssignment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            List<Assignment> assignments = assignmentService.getAllAssignments();
            request.setAttribute("assignments", assignments);
            request.getRequestDispatcher("/WEB-INF/view/admin/manageAssignment.jsp").forward(request, response);
        }
    }
}