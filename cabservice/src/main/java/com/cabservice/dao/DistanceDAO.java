package com.cabservice.dao;

import com.cabservice.model.Distance;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DistanceDAO {

    // Insert a new distance record into the database
    public void insertDistance(Distance distance) {
        String query = "INSERT INTO distance (from_location, to_location, distance_km) VALUES (?, ?, ?)";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, distance.getFromLocation());
            ps.setString(2, distance.getToLocation());
            ps.setDouble(3, distance.getDistanceKm());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Log properly in production
        }
    }

    // Update an existing distance using the ID
    public boolean updateDistance(int id, Distance distance) {
        String query = "UPDATE distance SET from_location = ?, to_location = ?, distance_km = ? WHERE id = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, distance.getFromLocation());
            ps.setString(2, distance.getToLocation());
            ps.setDouble(3, distance.getDistanceKm());
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete a distance record by ID
    public boolean deleteDistance(int distanceId) {
        String query = "DELETE FROM distance WHERE id = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, distanceId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Retrieve all distance records from the database
    public List<Distance> getAllDistances() {
        List<Distance> distances = new ArrayList<>();
        String query = "SELECT id, from_location, to_location, distance_km FROM distance";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                distances.add(new Distance(
                    rs.getInt("id"),
                    rs.getString("from_location"),
                    rs.getString("to_location"),
                    rs.getDouble("distance_km")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distances;
    }

    // Retrieve a single distance record by ID
    public Distance getDistanceById(int distanceId) {
        String query = "SELECT id, from_location, to_location, distance_km FROM distance WHERE id = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, distanceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Distance(
                        rs.getInt("id"),
                        rs.getString("from_location"),
                        rs.getString("to_location"),
                        rs.getDouble("distance_km")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
