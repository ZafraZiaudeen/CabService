package com.cabservice.dao;

import com.cabservice.model.Vehicle;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // Method to get all vehicles
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String query = "SELECT id, plate_number, model, capacity, rate_per_km, status FROM vehicle";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("id"));
                vehicle.setPlateNumber(rs.getString("plate_number"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setRatePerKm(rs.getDouble("rate_per_km"));
                vehicle.setStatus(rs.getString("status"));
                vehicles.add(vehicle);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    // Method to get a vehicle by ID
    public Vehicle getVehicleById(int vehicleId) {
        String query = "SELECT id, plate_number, model, capacity, rate_per_km, status FROM vehicle WHERE id = ?";
        Vehicle vehicle = null;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, vehicleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                vehicle = new Vehicle();
                vehicle.setId(rs.getInt("id"));
                vehicle.setPlateNumber(rs.getString("plate_number"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setRatePerKm(rs.getDouble("rate_per_km"));
                vehicle.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicle;
    }

    // Method to add a new vehicle
    public boolean addVehicle(Vehicle vehicle) {
        String query = "INSERT INTO vehicle (plate_number, model, capacity, rate_per_km, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setString(1, vehicle.getPlateNumber());
            ps.setString(2, vehicle.getModel());
            ps.setInt(3, vehicle.getCapacity());
            ps.setDouble(4, vehicle.getRatePerKm());
            ps.setString(5, vehicle.getStatus());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Method to update vehicle details
    public boolean updateVehicle(Vehicle vehicle) {
        String query = "UPDATE vehicle SET plate_number = ?, model = ?, capacity = ?, rate_per_km = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setString(1, vehicle.getPlateNumber());
            ps.setString(2, vehicle.getModel());
            ps.setInt(3, vehicle.getCapacity());
            ps.setDouble(4, vehicle.getRatePerKm());
            ps.setString(5, vehicle.getStatus());
            ps.setInt(6, vehicle.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Method to delete a vehicle
    public boolean deleteVehicle(int vehicleId) {
        String query = "DELETE FROM vehicle WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, vehicleId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    public List<Vehicle> getAvailableVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String query = "SELECT id, plate_number, model, capacity, rate_per_km, status FROM vehicle WHERE status = 'Available'";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("id"));
                vehicle.setPlateNumber(rs.getString("plate_number"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setRatePerKm(rs.getDouble("rate_per_km"));
                vehicle.setStatus(rs.getString("status"));
                vehicles.add(vehicle);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    public boolean updateVehicleStatus(int vehicleId, String status) {
        String query = "UPDATE vehicle SET status = ? WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, status);
            ps.setInt(2, vehicleId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


 // Method to get available vehicles based on driver availability (fixed)
    public List<Vehicle> getAvailableVehiclesForDriver() throws SQLException {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT v.* FROM vehicle v JOIN driver_vehicle dv ON v.id = dv.vehicle_id " +
                     "JOIN drivers d ON dv.driver_id = d.id WHERE d.availability = TRUE AND v.status = 'Available'";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setId(rs.getInt("id"));
                vehicle.setPlateNumber(rs.getString("plate_number"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setCapacity(rs.getInt("capacity"));
                vehicle.setRatePerKm(rs.getDouble("rate_per_km"));
                vehicle.setStatus(rs.getString("status"));
                vehicles.add(vehicle);
            }
        }
        return vehicles;
    }

}
