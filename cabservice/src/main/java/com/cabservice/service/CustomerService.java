package com.cabservice.service;

import com.cabservice.dao.CustomerDAO;
import com.cabservice.model.Customer;

import java.sql.SQLException;
import java.util.List;

public class CustomerService {
    private CustomerDAO customerDAO;

    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }

    public List<Customer> fetchAllCustomers() {
        return customerDAO.getAllCustomers();
    }
    
    public boolean deleteCustomer(int customerId) {
        return customerDAO.deleteCustomer(customerId);
    }

   
    public boolean addCustomer(String name, String address, String phoneNumber, String username, 
                             String hashedPassword, String role, String email, String nic) {
        return customerDAO.insertCustomer(name, address, phoneNumber, username, hashedPassword, role, email, nic);
    }
    
    public Customer getCustomerById(int customerId) {
        return customerDAO.getCustomerById(customerId);
    }

    public boolean updateCustomer(int customerId, String name, String address, String phoneNumber, 
                                String username, String email, String nic) {
        return customerDAO.updateCustomer(customerId, name, address, phoneNumber, username, email, nic);
    }

    public int getTotalCustomerCount() throws SQLException {
        return customerDAO.getTotalCustomerCount();
    }
    public void updateCustomerPassword(int customerId, String hashedPassword) throws SQLException {
        customerDAO.updateCustomerPassword(customerId, hashedPassword);
    }
}