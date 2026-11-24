package com.bhdm;

import com.bhdm.config.DatabaseConnection;
import com.bhdm.service.AuthenticationService;
import com.bhdm.view.LoginView;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class App extends Application {
    private static final Logger LOGGER = Logger.getLogger(App.class.getName());
    private Stage stage;

    @Override
    public void start(Stage primaryStage) {
        this.stage = primaryStage;
        stage.setTitle("Barangay Health Center Management System");
        ensureDefaultAdmin();
        showLogin();
        stage.show();
    }

    private void ensureDefaultAdmin() {
        String roleSql = "INSERT INTO roles (role_name, description) VALUES (?, ?) "
                + "ON DUPLICATE KEY UPDATE description = VALUES(description)";
        String roleIdSql = "SELECT role_id FROM roles WHERE role_name = ?";
        String userExistsSql = "SELECT 1 FROM users WHERE username = ?";
        String userSql = "INSERT INTO users (role_id, username, password_hash, first_name, middle_name, last_name, account_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                String[][] defaultRoles = {
                        {"Admin", "Full system administrator access"},
                        {"Nurse", "Barangay health center registered nurse"},
                        {"Midwife", "Barangay health center midwife"},
                        {"BHW", "Barangay Health Worker"},
                        {"Pharmacist", "Medicine inventory and dispensing pharmacist"}
                };
                try (PreparedStatement statement = connection.prepareStatement(roleSql)) {
                    for (String[] role : defaultRoles) {
                        statement.setString(1, role[0]);
                        statement.setString(2, role[1]);
                        statement.addBatch();
                    }
                    statement.executeBatch();
                }

                int roleId;
                try (PreparedStatement statement = connection.prepareStatement(roleIdSql)) {
                    statement.setString(1, "Admin");
                    try (ResultSet result = statement.executeQuery()) {
                        if (!result.next()) {
                            throw new SQLException("The Admin role could not be created.");
                        }
                        roleId = result.getInt("role_id");
                    }
                }

                boolean adminExists;
                try (PreparedStatement statement = connection.prepareStatement(userExistsSql)) {
                    statement.setString(1, "admin");
                    try (ResultSet result = statement.executeQuery()) {
                        adminExists = result.next();
                    }
                }

                if (!adminExists) {
                    try (PreparedStatement statement = connection.prepareStatement(userSql)) {
                        statement.setInt(1, roleId);
                        statement.setString(2, "admin");
                        statement.setString(3, AuthenticationService.hashPassword("admin123"));
                        statement.setString(4, "System");
                        statement.setNull(5, java.sql.Types.VARCHAR);
                        statement.setString(6, "Administrator");
                        statement.setString(7, "Active");
                        statement.executeUpdate();
                    }
                }
                connection.commit();
            } catch (SQLException | RuntimeException ex) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackException) {
                    ex.addSuppressed(rollbackException);
                }
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException | RuntimeException ex) {
            LOGGER.log(Level.WARNING, "Unable to ensure the default admin account exists.", ex);
        }
    }

    public static String getStylesheetUrl() {
        var resource = App.class.getResource("/styles/app.css");
        return resource != null ? resource.toExternalForm() : null;
    }

    public static void applyStylesheet(Scene scene) {
        String css = getStylesheetUrl();
        if (css != null && !scene.getStylesheets().contains(css)) {
            scene.getStylesheets().add(css);
        }
    }

    public void showLogin() {
        Scene scene = new Scene(new LoginView(this), 540, 640);
        applyStylesheet(scene);
        stage.setScene(scene);
        stage.setMinWidth(480);
        stage.setMinHeight(580);
    }

    public void showRegister() {
        Scene scene = new Scene(new com.bhdm.view.RegisterView(this), 580, 740);
        applyStylesheet(scene);
        stage.setScene(scene);
        stage.setMinWidth(520);
        stage.setMinHeight(660);
    }

    public void showDashboard(int userId, String fullName, String roleName) {
        Scene scene = new Scene(new com.bhdm.view.DashboardView(this, userId, fullName, roleName), 1240, 780);
        applyStylesheet(scene);
        stage.setScene(scene);
        stage.setMinWidth(1020);
        stage.setMinHeight(660);
    }

    public static void main(String[] args) {
        launch(args);
    }
}
