package com.bhdm.view;

import com.bhdm.App;
import com.bhdm.config.DatabaseConnection;
import com.bhdm.dao.AuditLogDAO;
import com.bhdm.model.User;
import com.bhdm.service.AuthenticationService;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;

import java.sql.SQLException;

public class LoginView extends VBox {
    private final App app;
    private final TextField username = new TextField();
    private final PasswordField password = new PasswordField();
    private final Label status = new Label();

    public LoginView(App app) {
        this.app = app;
        String css = App.getStylesheetUrl();
        if (css != null) {
            getStylesheets().add(css);
        }

        getStyleClass().add("login-root");
        setAlignment(Pos.CENTER);

        VBox card = new VBox(16);
        card.getStyleClass().add("login-card");
        card.setAlignment(Pos.CENTER_LEFT);

        VBox header = new VBox(6);
        header.setAlignment(Pos.CENTER);
        Label badge = new Label("PUBLIC HEALTH PORTAL");
        badge.getStyleClass().add("login-badge");
        Label title = new Label("Barangay Health Center");
        title.getStyleClass().add("login-title");
        Label subtitle = new Label("Management System — Staff Sign In");
        subtitle.getStyleClass().add("login-subtitle");
        header.getChildren().addAll(badge, title, subtitle);

        VBox userGroup = new VBox(6);
        Label userLabel = new Label("Username");
        userLabel.getStyleClass().add("field-label");
        username.setPromptText("Enter your username");
        username.setMaxWidth(Double.MAX_VALUE);
        userGroup.getChildren().addAll(userLabel, username);

        VBox passGroup = new VBox(6);
        Label passLabel = new Label("Password");
        passLabel.getStyleClass().add("field-label");
        password.setPromptText("Enter your password");
        password.setMaxWidth(Double.MAX_VALUE);
        passGroup.getChildren().addAll(passLabel, password);

        Button login = new Button("Sign In");
        login.setDefaultButton(true);
        login.setMaxWidth(Double.MAX_VALUE);
        login.getStyleClass().add("btn-primary");
        login.setOnAction(e -> authenticate());

        Button test = new Button("Test Database Connection");
        test.setMaxWidth(Double.MAX_VALUE);
        test.getStyleClass().add("btn-ghost");
        test.setOnAction(e -> testConnection());

        Button signUp = new Button("Create Account / Sign Up");
        signUp.setMaxWidth(Double.MAX_VALUE);
        signUp.getStyleClass().add("btn-link");
        signUp.setOnAction(e -> app.showRegister());

        status.setWrapText(true);
        status.setMaxWidth(Double.MAX_VALUE);
        status.setAlignment(Pos.CENTER);
        status.getStyleClass().add("status-label");
        status.setVisible(false);
        status.setManaged(false);

        card.getChildren().addAll(header, new Separator(), userGroup, passGroup, login, test, signUp, status);
        getChildren().add(card);
    }

    private void showStatus(String message, boolean success) {
        status.getStyleClass().removeAll("status-success", "status-error");
        status.getStyleClass().add(success ? "status-success" : "status-error");
        status.setText(message);
        status.setVisible(true);
        status.setManaged(true);
    }

    private void testConnection() {
        try {
            DatabaseConnection.testConnection();
            showStatus("Connected to barangay_health_center_db.", true);
        } catch (SQLException ex) {
            showStatus("Database connection failed: " + ex.getMessage(), false);
        }
    }

    private void authenticate() {
        if (username.getText().trim().isEmpty() || password.getText().isEmpty()) {
            showStatus("Please enter your username and password.", false);
            return;
        }
        try {
            User user = new AuthenticationService().authenticate(username.getText().trim(), password.getText());
            if (user == null) {
                showStatus("Invalid credentials or inactive account.", false);
                return;
            }
            try {
                new AuditLogDAO().recordLogin(user.getUserId());
            } catch (SQLException ignored) {
                // Login proceeds even if audit insert fails
            }
            app.showDashboard(user.getUserId(), user.getFullName(), user.getRoleName());
        } catch (SQLException ex) {
            showStatus("Login failed: " + ex.getMessage(), false);
        }
    }
}
