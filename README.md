# Mega City Cab System

The **Mega City Cab System** is a web-based cab service application designed to provide an interactive, secure, and scalable platform for customers and administrators. Built using **Java Servlets, JSP, and MySQL**, the system enables efficient cab bookings, user management, and operational oversight. 

Key design patterns like **Singleton** and **Observer** enhance efficiency and ensure real-time updates, while **SMTP-based email functionality** enables secure customer verification.

## Repository
[GitHub: ZafraZiaudeen/CabService](https://github.com/ZafraZiaudeen/CabService)

## Version
**v1.0** (as of March 13, 2025)

## Features

### Customer Features
- **Registration:** Sign up with SMTP-driven email verification and receive a personalized welcome message.
- **Login/Logout:** Secure session-based authentication.
- **Booking:** Book rides with vehicle selection and real-time status tracking.
- **Profile Management:** Update personal details (e.g., name, address, phone number).
- **Billing:** View trip invoices with cash or card payment options.

### Admin Features
- **User Management:** Manage customer, driver, and admin accounts.
- **Vehicle & Driver Management:** Assign vehicles to drivers, register, and update fleet details via `AssignmentController`.
- **Booking Oversight:** Create, update, or delete bookings for customers.
- **System Configuration:** Adjust tax rates and discounts dynamically.
- **Reports:** Monitor operational metrics (e.g., total bookings, revenue) on a dashboard.

## Technologies Used
- **Backend:** Java (Servlets), Singleton & Observer Patterns
- **Frontend:** JSP (JavaServer Pages)
- **Database:** MySQL (`cab_service_db`)
- **Email:** JavaMail API with SMTP (`EmailUtil`)
- **Build Tool:** Maven
- **Testing:** JUnit 4, Mockito
- **Server:** Apache Tomcat
- **CI/CD:** GitHub Actions

## Prerequisites
- **Java:** JDK 11 or higher
- **Maven:** 3.6.0 or higher
- **MySQL:** 8.0 or higher
- **Apache Tomcat:** 9.0 or higher
- **Git:** For cloning the repository
- **SMTP Server:** Access to an SMTP server (e.g., Gmail SMTP)

### Access the Application
- **Default admin login:** 
  - **Username:** Admin
  - **Password:** Admin@12
 - **Default customer login:** 
  - **Username:** Customer
  - **Password:** Customer@12

## Usage

### Customer Flow
1. Register at `/user?action=register` (receive SMTP verification email).
2. Verify email via the link sent by `EmailUtil`.
3. Log in at `/user?action=login`.
4. Book a ride at `/customerBooking?action=book`.
5. View billing at `/billing`.
6. View billing and booking history `/booking/history`

### Admin Flow
1. Log in at `/user?action=login` with admin credentials.
2. Access the dashboard at `/dashboard`.
3. Assign vehicles to drivers at `/assignment?action=add` or manage assignments at `/assignment?action=list`.
4. Update system configuration at `/config`.

## Testing
Run the test suite with Junit

**Coverage includes:**
- `DBConnection`
- `User` model
- `UserDAO`
- `UserService`
- `UserController` (see `src/test/java`)

## CI/CD Pipeline
- **GitHub Actions** automates building and testing on pushes to `master`.
- View runs in the **Actions** tab on GitHub.

## Contributing
1. Fork the repository.
2. Create a feature branch:
```bash
git checkout -b feature/your-feature
```
3. Commit changes:
```bash
git commit -m "Add your feature"
```
4. Push to your fork:
```bash
git push origin feature/your-feature
```
5. Open a pull request against `master`.

---

**Happy Coding! 🚖**

