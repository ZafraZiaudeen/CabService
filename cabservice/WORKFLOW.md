# GitHub Workflow: Mega City Cab System

This document outlines the development workflow for the **Mega City Cab System**, a web-based cab service. It covers setup instructions, Git branching strategy, commit history, development process, and CI/CD pipeline.

## Setup Instructions

### Clone the Repository
```bash
git clone https://github.com/ZafraZiaudeen/CabService.git
cd CabService
```

### Configure the Database
Create a MySQL database:
```sql
CREATE DATABASE cab_service_db;
```
Update database credentials in `DBConnection.java`.

### Configure SMTP for Email
Create `application.properties` in `src/main/resources/` and add SMTP details:
```text
email.username=your-email@gmail.com
email.password=your-app-password
email.host=smtp.gmail.com
email.port=587
```

### Build and Deploy
```bash
mvn clean install
```

### Access the Application
- **Default Admin Login:**
  - Username: `Admin`
  - Password: `Admin@12`
- **Default Customer Login:**
  - Username: `Customer`
  - Password: `Customer@12`

## Branching Strategy
The Mega City Cab System was developed using a single-branch workflow on the `master` branch to streamline solo development.

- **Branch Used:** `master` (default branch).
- **Rationale:** A single branch minimized complexity for a solo developer, allowing focus on feature implementation, testing, and deployment. Post-development, branch protection was added to enforce pull requests for future contributions.
- **Protection:** On March 13, 2025, the `master` branch was protected via GitHub settings:
  - Enabled "Require pull request reviews before merging."

## Commit History
The commit history spans February 11, 2025, to March 13, 2025, reflecting progressive development. Key commits include:

- **Feb 11–18, 2025:** Initial setup, database, and authentication.
- **Feb 19–26, 2025:** Admin features, booking system, and vehicle-driver assignments.
- **Feb 28–Mar 7, 2025:** Enhancements, UI improvements, and email integration.
- **Mar 11–13, 2025:** Final refinements, error handling, and deployment.

## Development Process

### Phases
- **Setup (Feb 11–12):** Initialized project with Maven, MySQL, and TDD.
- **Core Features (Feb 15–21):** Authentication, dashboard, and assignments.
- **Feature Expansion (Feb 22–26):** Booking, billing, and distance management.
- **Enhancements (Feb 28–Mar 10):** Profiles, email notifications, and stored procedures.
- **Finalization (Mar 11–13):** Observer pattern for registration, bug fixes, and documentation.

### Tools and Practices
- **TDD:** JUnit and Mockito for testing.
- **Design Patterns:** Singleton (`DBConnection`) and Observer (`RegistrationEventManager`).
- **SMTP Email:** `EmailUtil` for user verification and billing emails.
- **Version Control:** Managed via Git with a single-branch strategy.

## CI/CD Pipeline
A GitHub Actions workflow automates building, testing, and deployment simulation:

- **File:** `.github/workflows/build.yml`
- **Steps:**
  - Checkout repository
  - Setup Java and Maven
  - Build project with Maven
  - Run tests
  - Deploy (future implementation)

---
This workflow ensures an efficient and structured development process for the Mega City Cab System.

