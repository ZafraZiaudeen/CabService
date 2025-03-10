package com.cabservice.service;

import com.cabservice.model.Customer;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Manages registration events and notifies registered observers.
 */
public class RegistrationEventManager {
    private static final Logger LOGGER = Logger.getLogger(RegistrationEventManager.class.getName());
    private List<RegistrationObserver> observers = new ArrayList<>();

    /**
     * Adds an observer to the list.
     * @param observer The observer to add.
     */
    public void addObserver(RegistrationObserver observer) {
        observers.add(observer);
        LOGGER.log(Level.FINE, "Observer added: {0}", observer.getClass().getSimpleName());
    }

    /**
     * Removes an observer from the list.
     * @param observer The observer to remove.
     */
    public void removeObserver(RegistrationObserver observer) {
        observers.remove(observer);
        LOGGER.log(Level.FINE, "Observer removed: {0}", observer.getClass().getSimpleName());
    }

    /**
     * Notifies all observers of a registration event.
     * @param event The event type (e.g., "Pending Registration").
     * @param customer The customer associated with the event.
     */
    public void notifyObservers(String event, Customer customer) {
        LOGGER.log(Level.INFO, "Notifying observers of event: {0} for customer: {1}", 
            new Object[]{event, customer.getUsername()});
        for (RegistrationObserver observer : observers) {
            observer.update(event, customer);
        }
    }
}
