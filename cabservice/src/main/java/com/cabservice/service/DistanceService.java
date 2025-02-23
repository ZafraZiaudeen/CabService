package com.cabservice.service;

import com.cabservice.dao.DistanceDAO;
import com.cabservice.model.Distance;
import java.util.List;

public class DistanceService {
    private final DistanceDAO distanceDAO;

    // Constructor for better dependency management (useful for testing)
    public DistanceService() {
        this.distanceDAO = new DistanceDAO();
    }

    // Add new distance entry
    public void addDistance(Distance distance) {
        try {
            distanceDAO.insertDistance(distance);
        } catch (Exception e) {
            e.printStackTrace();  // Log the error properly in production
        }
    }

    // Update an existing distance (Fixed method signature)
    public void updateDistance(int id, Distance distance) {
        try {
            distanceDAO.updateDistance(id, distance);
        } catch (Exception e) {
            e.printStackTrace();  // Log the error properly in production
        }
    }

    // Delete a distance entry by ID
    public void deleteDistance(int id) {
        try {
            distanceDAO.deleteDistance(id);
        } catch (Exception e) {
            e.printStackTrace();  
        }
    }

    // Retrieve all distances
    public List<Distance> getAllDistances() {
        try {
            return distanceDAO.getAllDistances();
        } catch (Exception e) {
            e.printStackTrace();  // Log the error properly in production
            return null;
        }
    }

    // Retrieve a single distance entry by ID
    public Distance getDistanceById(int distanceId) {
        try {
            return distanceDAO.getDistanceById(distanceId);
        } catch (Exception e) {
            e.printStackTrace();  // Log the error properly in production
            return null;
        }
    }
}
