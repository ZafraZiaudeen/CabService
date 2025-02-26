package com.cabservice.controller;

import com.cabservice.model.Vehicle;
import com.cabservice.service.VehicleService;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/vehicle")
public class VehicleController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VehicleService vehicleService;

    public VehicleController() {
        super();
        vehicleService = new VehicleService();
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
                    request.setAttribute("vehicles", vehicleService.getAllVehicles());
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageVehicle.jsp").forward(request, response);
                    break;
                case "edit":
                    int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                    Vehicle vehicle = vehicleService.getVehicleById(vehicleId);
                    request.setAttribute("vehicle", vehicle);
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-vehicle.jsp").forward(request, response);
                    break;
                case "delete":
                    int deleteVehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                    vehicleService.deleteVehicle(deleteVehicleId);
                    response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
                    break;
                case "add":
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-vehicle.jsp").forward(request, response);
                    break;
                case "available":
                    request.setAttribute("vehicles", vehicleService.getAvailableVehicles());
                    request.getRequestDispatcher("/WEB-INF/view/admin/available_vehicles.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("save".equals(action)) {
                String plateNumber = request.getParameter("plateNumber");
                String model = request.getParameter("model");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                double ratePerKm = Double.parseDouble(request.getParameter("ratePerKm"));
                String status = request.getParameter("status");

                vehicleService.addVehicle(plateNumber, model, capacity, ratePerKm, status);
                response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
            } else if ("update".equals(action)) {
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                String plateNumber = request.getParameter("plateNumber");
                String model = request.getParameter("model");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                double ratePerKm = Double.parseDouble(request.getParameter("ratePerKm"));
                String status = request.getParameter("status");

                vehicleService.updateVehicle(vehicleId, plateNumber, model, capacity, ratePerKm, status);
                response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/vehicle?action=list");
        }
    }
}