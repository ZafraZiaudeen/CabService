package com.cabservice.service;

import com.cabservice.model.Customer;
import com.cabservice.util.EmailUtil;
import java.util.logging.Logger;
import java.util.logging.Level;

public class EmailNotifier implements RegistrationObserver {
    private static final Logger LOGGER = Logger.getLogger(EmailNotifier.class.getName());
    private final VerificationService verificationService;

    // Default constructor
    public EmailNotifier() {
        this.verificationService = new VerificationService();
    }

    // Constructor for dependency injection (optional, for testing)
    public EmailNotifier(VerificationService verificationService) {
        this.verificationService = verificationService;
    }

    @Override
    public void update(String event, Customer customer) {
        if ("Pending Registration".equals(event)) {
            // Generate token and send verification email
            String token = verificationService.storePendingUser(customer);
            if (token != null) {
                try {
                    EmailUtil.sendVerificationEmail(customer.getEmail(), token);
                    LOGGER.log(Level.INFO, "Verification email sent to: {0} with token: {1}", 
                        new Object[]{customer.getEmail(), token});
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Failed to send verification email to: " + customer.getEmail(), e);
                }
            } else {
                LOGGER.log(Level.SEVERE, "Failed to generate token for customer: " + customer.getUsername());
            }
        }
    }
}