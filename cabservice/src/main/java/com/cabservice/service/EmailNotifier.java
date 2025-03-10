package com.cabservice.service;

import com.cabservice.model.Customer;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Observer that confirms email-related registration events.
 */
public class EmailNotifier implements RegistrationObserver {
    private static final Logger LOGGER = Logger.getLogger(EmailNotifier.class.getName());

    @Override
    public void update(String event, Customer customer) {
        if ("Verification Sent".equals(event)) {
            LOGGER.log(Level.INFO, "Verification email sent to: {0}", customer.getEmail());
        }
    }
}
