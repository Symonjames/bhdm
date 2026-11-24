# Barangay Health Center Management System

Step 1 includes the JavaFX login, database connection test, audit logging, and initial dashboard.

## Database

Import the supplied SQL dump [`barangay_health_center_db (3).sql`](./barangay_health_center_db%20%283%29.sql) into XAMPP MariaDB/MySQL as `barangay_health_center_db`. It is the schema source used by this project; the application does not alter the schema.

Connection settings are in [`DatabaseConnection.java`](./src/main/java/com/bhdm/config/DatabaseConnection.java): `localhost:3306`, database `barangay_health_center_db`, user `root`, and an empty password.

Run [`seed_admin.sql`](./seed_admin.sql) after importing the schema to create the default admin account: `admin` / `admin123`. Store passwords as BCrypt hashes.

## Run

Use JDK 21 or newer and Maven:

```text
mvn clean compile
mvn clean javafx:run
```

The login screen's **Test database connection** button verifies the configured connection before login.
