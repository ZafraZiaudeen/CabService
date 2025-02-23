package com.cabservice.controller;

import com.cabservice.model.Distance;
import com.cabservice.service.DistanceService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/distance")
public class DistanceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DistanceService distanceService;

    public DistanceController() {
        super();
        distanceService = new DistanceService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null || action.isEmpty()) {
                action = "list";
            }

            switch (action) {
                case "list":
                    request.setAttribute("distances", distanceService.getAllDistances());
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageDistance.jsp").forward(request, response);
                    break;

                case "edit":
                    try {
                        int distanceId = Integer.parseInt(request.getParameter("distanceId"));
                        Distance distance = distanceService.getDistanceById(distanceId);
                        if (distance != null) {
                            request.setAttribute("distance", distance);
                            request.getRequestDispatcher("/WEB-INF/view/admin/edit-distance.jsp").forward(request, response);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/distance?action=list&error=notfound");
                        }
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/distance?action=list&error=invalidId");
                    }
                    break;

                case "delete":
                    try {
                        String deleteIdParam = request.getParameter("distanceId");
                        if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
                            int deleteDistanceId = Integer.parseInt(deleteIdParam);
                            distanceService.deleteDistance(deleteDistanceId);
                        }
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/distance?action=list&error=invalidId");
                    }
                    response.sendRedirect(request.getContextPath() + "/distance?action=list");
                    break;

                case "add":
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-distance.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/distance?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/distance?action=list&error=serverError");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("save".equals(action)) {
                String fromLocation = request.getParameter("from_location");
                String toLocation = request.getParameter("to_location");
                String distanceStr = request.getParameter("distance_km");

                // Validation
                if (fromLocation == null || toLocation == null || distanceStr == null ||
                    fromLocation.trim().isEmpty() || toLocation.trim().isEmpty() || distanceStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/distance?action=add&error=missingFields");
                    return;
                }

                double distanceKm = Double.parseDouble(distanceStr.trim());
                distanceService.addDistance(new Distance(0, fromLocation.trim(), toLocation.trim(), distanceKm));
                response.sendRedirect(request.getContextPath() + "/distance?action=list");
            } 
            else if ("update".equals(action)) {
                String idStr = request.getParameter("distanceId");
                String fromLocation = request.getParameter("from_location");
                String toLocation = request.getParameter("to_location");
                String distanceStr = request.getParameter("distance_km");

                if (idStr == null || fromLocation == null || toLocation == null || distanceStr == null ||
                    idStr.trim().isEmpty() || fromLocation.trim().isEmpty() || toLocation.trim().isEmpty() || distanceStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/distance?action=edit&error=missingFields");
                    return;
                }

                int distanceId = Integer.parseInt(idStr.trim());
                double distanceKm = Double.parseDouble(distanceStr.trim());

                distanceService.updateDistance(distanceId, new Distance(distanceId, fromLocation.trim(), toLocation.trim(), distanceKm));
                response.sendRedirect(request.getContextPath() + "/distance?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/distance?action=list&error=invalidNumber");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/distance?action=list&error=serverError");
        }
    }
}
