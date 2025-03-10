package com.cabservice.service;

import com.cabservice.model.Customer;

/**
 * Interface for observers of registration events.
 */
public interface RegistrationObserver {
    /**
     * Called when a registration event occurs.
     * @param event The event type.
     * @param customer The customer involved in the event.
     */
    void update(String event, Customer customer);
}