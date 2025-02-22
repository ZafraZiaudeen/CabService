package com.cabservice.dao;

import com.cabservice.model.Assignment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAO {

    // Method to retrieve all assignments
	public List<Assignment> getAllAssignments() {
	    List<Assignment> assignments = new ArrayList<>();
	    String query = "SELECT dv.driver_id, dv.vehicle_id, dv.assigned_at, " +
	                   "d.name AS driver_name, v.plate_number AS vehicle_plate, v.model AS vehicle_model " +
	                   "FROM driver_vehicle dv " +
	                   "JOIN driver d ON dv.driver_id = d.id " +
	                   "JOIN vehicle v ON dv.vehicle_id = v.id";

	    try (Connection conn = DBConnectionFactory.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            Assignment assignment = new Assignment();
	            assignment.setDriverId(rs.getInt("driver_id"));
	            assignment.setVehicleId(rs.getInt("vehicle_id"));
	            assignment.setAssignedAt(rs.getTimestamp("assigned_at"));
	            assignment.setDriverName(rs.getString("driver_name"));  
	            assignment.setVehiclePlate(rs.getString("vehicle_plate"));
	            assignment.setVehicleModel(rs.getString("vehicle_model"));  // Fetch vehicle model
	            assignments.add(assignment);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return assignments;
	}



    // Method to assign a vehicle to a driver
	public boolean assignVehicle(int driverId, int vehicleId) {
	    String checkQuery = "SELECT COUNT(*) FROM driver_vehicle WHERE driver_id = ? AND vehicle_id = ?";
	    String insertQuery = "INSERT INTO driver_vehicle (driver_id, vehicle_id) VALUES (?, ?)";

	    try (Connection conn = DBConnectionFactory.getConnection();
	         PreparedStatement checkPs = conn.prepareStatement(checkQuery)) {

	        checkPs.setInt(1, driverId);
	        checkPs.setInt(2, vehicleId);
	        ResultSet rs = checkPs.executeQuery();
	        if (rs.next() && rs.getInt(1) > 0) {
	            return false; // Already assigned
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    try (Connection conn = DBConnectionFactory.getConnection();
	         PreparedStatement insertPs = conn.prepareStatement(insertQuery)) {
	        insertPs.setInt(1, driverId);
	        insertPs.setInt(2, vehicleId);
	        int rowsAffected = insertPs.executeUpdate();
	        
	        if (rowsAffected > 0) {
	            // Update vehicle status to "In Use"
	            VehicleDAO vehicleDAO = new VehicleDAO();
	            vehicleDAO.updateVehicleStatus(vehicleId, "In Use");
	        }
	        
	        return rowsAffected > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return false;
	}



    // Method to remove an assignment (unassign vehicle from driver)
    public boolean unassignVehicle(int driverId, int vehicleId) {
        String query = "DELETE FROM driver_vehicle WHERE driver_id = ? AND vehicle_id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, driverId);
            ps.setInt(2, vehicleId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Method to get a specific assignment by driver ID and vehicle ID
    public Assignment getAssignment(int driverId, int vehicleId) {
        Assignment assignment = null;
        String query = "SELECT driver_id, vehicle_id, assigned_at FROM driver_vehicle WHERE driver_id = ? AND vehicle_id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, driverId);
            ps.setInt(2, vehicleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                assignment = new Assignment();
                assignment.setDriverId(rs.getInt("driver_id"));
                assignment.setVehicleId(rs.getInt("vehicle_id"));
                assignment.setAssignedAt(rs.getTimestamp("assigned_at"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return assignment;
    }

}
