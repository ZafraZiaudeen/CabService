package com.cabservice.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Distance;
import com.cabservice.service.DistanceService;

@WebServlet("/routes")
public class RoutesController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DBConnectionFactory.getConnection()) {
            DistanceService distanceService = new DistanceService();
            List<Distance> distanceList = distanceService.getAllDistances();

            // Convert Distance objects to Map format expected by routes.jsp
            List<Map<String, Object>> routes = new ArrayList<>();
            for (Distance distance : distanceList) {
                Map<String, Object> route = new HashMap<>();
                route.put("id", distance.getId());
                route.put("from_location", distance.getFromLocation());
                route.put("to_location", distance.getToLocation());
                route.put("distance_km", distance.getDistanceKm());
                routes.add(route);
            }

            // Set routes attribute and forward to JSP
            request.setAttribute("routes", routes);
            request.getRequestDispatcher("/WEB-INF/view/customer/routes.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load routes: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/routes.jsp").forward(request, response);
        }
    }
}