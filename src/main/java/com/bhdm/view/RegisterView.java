package com.bhdm.view;

import com.bhdm.App;
import com.bhdm.service.AuthenticationService;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;

import java.sql.SQLException;

public class RegisterView extends VBox {
    private final App app;
    private final TextField firstName = new TextField();
    private final TextField middleName = new TextField();
    private final TextField lastName = new TextField();
    private final TextField username = new TextField();
    private final TextField assignedRole = new TextField("Staff (View-Only)");
    private final TextField contactNumber = new TextField();
    private final TextField emailAddress = new TextField();
    private final PasswordField password = new PasswordField();
    private final PasswordField confirmPassword = new PasswordField();
    private final Label status = new Label();

    public RegisterView(App app) {
        this.app = app;
        String css = App.getStylesheetUrl();
        if (css != null) {
            getStylesheets().add(css);
        }

        getStyleClass().add("login-root");
        setAlignment(Pos.CENTER);

        VBox card = new VBox(12);
        card.getStyleClass().add("register-card");
        card.setAlignment(Pos.CENTER_LEFT);

        VBox header = new VBox(4);
        header.setAlignment(Pos.CENTER);
        Label badge = new Label("STAFF REGISTRATION");
        badge.getStyleClass().add("login-badge");
        Label title = new Label("Create Staff Account");
        title.getStyleClass().add("login-title");
        Label subtitle = new Label("New sign-ups are automatically assigned the Staff (View-Only) role");
        subtitle.getStyleClass().add("login-subtitle");
        header.getChildren().addAll(badge, title, subtitle);

        // Full Name row (first_name, middle_name, last_name)
        HBox nameRow = new HBox(10);
        firstName.setPromptText("First name");
        middleName.setPromptText("Middle (optional)");
        lastName.setPromptText("Last name");
        VBox firstGroup = labeledField("First Name *", firstName);
        VBox middleGroup = labeledField("Middle Name", middleName);
        VBox lastGroup = labeledField("Last Name *", lastName);
        HBox.setHgrow(firstGroup, Priority.ALWAYS);
        HBox.setHgrow(middleGroup, Priority.ALWAYS);
        HBox.setHgrow(lastGroup, Priority.ALWAYS);
        nameRow.getChildren().addAll(firstGroup, middleGroup, lastGroup);

        // Username & Auto-Assigned Role row
        HBox accountRow = new HBox(10);
        username.setPromptText("Choose a unique username");
        assignedRole.setEditable(false);
        assignedRole.setFocusTraversable(false);
        assignedRole.setDisable(true);
        VBox userGroup = labeledField("Username *", username);
        VBox roleGroup = labeledField("Assigned Role", assignedRole);
        HBox.setHgrow(userGroup, Priority.ALWAYS);
        HBox.setHgrow(roleGroup, Priority.ALWAYS);
        accountRow.getChildren().addAll(userGroup, roleGroup);

        // Contact & Email row (optional)
        HBox contactRow = new HBox(10);
        contactNumber.setPromptText("09XX-XXX-XXXX (optional)");
        emailAddress.setPromptText("name@example.com (optional)");
        VBox contactGroup = labeledField("Contact Number", contactNumber);
        VBox emailGroup = labeledField("Email Address", emailAddress);
        HBox.setHgrow(contactGroup, Priority.ALWAYS);
        HBox.setHgrow(emailGroup, Priority.ALWAYS);
        contactRow.getChildren().addAll(contactGroup, emailGroup);

        // Password & Confirm Password row (Enter submits form cleanly)
        HBox passRow = new HBox(10);
        password.setPromptText("Minimum 6 characters");
        confirmPassword.setPromptText("Re-enter password");
        password.setOnAction(e -> register());
        confirmPassword.setOnAction(e -> register());
        VBox passGroup = labeledField("Password *", password);
        VBox confirmGroup = labeledField("Confirm Password *", confirmPassword);
        HBox.setHgrow(passGroup, Priority.ALWAYS);
        HBox.setHgrow(confirmGroup, Priority.ALWAYS);
        passRow.getChildren().addAll(passGroup, confirmGroup);

        Button registerBtn = new Button("Create Staff Account");
        registerBtn.setDefaultButton(true);
        registerBtn.setDisable(false);
        registerBtn.setMaxWidth(Double.MAX_VALUE);
        registerBtn.getStyleClass().add("btn-primary");
        registerBtn.setOnAction(e -> register());

        HBox backRow = new HBox();
        backRow.setAlignment(Pos.CENTER);
        Button backBtn = new Button("← Back to Sign In");
        backBtn.getStyleClass().add("btn-link");
        backBtn.setOnAction(e -> app.showLogin());
        backRow.getChildren().add(backBtn);

        status.setWrapText(true);
        status.setMaxWidth(Double.MAX_VALUE);
        status.setAlignment(Pos.CENTER);
        status.getStyleClass().add("status-label");
        status.setVisible(false);
        status.setManaged(false);

        card.getChildren().addAll(
                header, new Separator(),
                status,
                nameRow, accountRow, contactRow, passRow,
                registerBtn, backRow
        );
        getChildren().add(card);
    }

    private VBox labeledField(String labelText, Control control) {
        VBox group = new VBox(4);
        Label label = new Label(labelText);
        label.getStyleClass().add("field-label");
        control.setMaxWidth(Double.MAX_VALUE);
        group.getChildren().addAll(label, control);
        return group;
    }

    private void register() {
        status.setVisible(false);
        status.setManaged(false);
        try {
            new AuthenticationService().registerStaff(
                    firstName.getText(),
                    middleName.getText(),
                    lastName.getText(),
                    username.getText(),
                    password.getText(),
                    confirmPassword.getText(),
                    contactNumber.getText(),
                    emailAddress.getText()
            );

            Alert success = new Alert(Alert.AlertType.INFORMATION,
                    "Your Staff account has been created successfully. You can now sign in with your credentials.",
                    ButtonType.OK);
            success.setTitle("Registration Complete");
            success.setHeaderText("Account Created (Staff — View-Only)");
            String css = App.getStylesheetUrl();
            if (css != null) {
                success.getDialogPane().getStylesheets().add(css);
            }
            success.showAndWait();
            app.showLogin();
        } catch (IllegalArgumentException ex) {
            showStatus(ex.getMessage(), false);
        } catch (SQLException | RuntimeException ex) {
            ex.printStackTrace();
            String msg = "Registration failed: " + ex.getMessage();
            showStatus(msg, false);
            showErrorAlert(msg);
        } catch (Throwable ex) {
            ex.printStackTrace();
            String msg = "Unexpected registration error: " + ex.getClass().getSimpleName() + " — " + ex.getMessage();
            showStatus(msg, false);
            showErrorAlert(msg);
        }
    }

    private void showErrorAlert(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR, message, ButtonType.OK);
        alert.setTitle("Sign Up Error");
        alert.setHeaderText("Unable to Create Account");
        String css = App.getStylesheetUrl();
        if (css != null) {
            alert.getDialogPane().getStylesheets().add(css);
        }
        alert.showAndWait();
    }

    private void showStatus(String message, boolean success) {
        status.getStyleClass().removeAll("status-success", "status-error");
        status.getStyleClass().add(success ? "status-success" : "status-error");
        status.setText(message);
        status.setVisible(true);
        status.setManaged(true);
    }
}
