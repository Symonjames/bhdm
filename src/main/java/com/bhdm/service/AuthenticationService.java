package com.bhdm.service;

import com.bhdm.dao.AuditLogDAO;
import com.bhdm.dao.UserDAO;
import com.bhdm.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;

public class AuthenticationService {
    private final UserDAO userDAO = new UserDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(10));
    }

    public User authenticate(String username, String password) throws SQLException {
        User user = userDAO.findActiveByUsername(username);
        if (user == null || password == null) return null;
        try {
            return BCrypt.checkpw(password, user.getPasswordHash()) ? user : null;
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }

    public int register(String firstName, String middleName, String lastName,
                        String username, String password, String confirmPassword,
                        UserDAO.RoleOption role, String contactNumber, String emailAddress) throws SQLException {
        String cleanFirst = firstName == null ? "" : firstName.trim();
        String cleanLast = lastName == null ? "" : lastName.trim();
        String cleanUser = username == null ? "" : username.trim();

        if (cleanFirst.isEmpty() || cleanLast.isEmpty()) {
            throw new IllegalArgumentException("First name and last name are required.");
        }
        if (cleanUser.isEmpty()) {
            throw new IllegalArgumentException("Username is required.");
        }
        if (cleanUser.length() > 50) {
            throw new IllegalArgumentException("Username must be 50 characters or fewer.");
        }
        if (role == null || role.roleName() == null) {
            throw new IllegalArgumentException("Please select a role.");
        }
        if ("admin".equalsIgnoreCase(role.roleName().trim())) {
            throw new IllegalArgumentException("Public registration cannot assign the Admin role.");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long.");
        }
        if (!password.equals(confirmPassword)) {
            throw new IllegalArgumentException("Passwords do not match.");
        }
        if (userDAO.usernameExists(cleanUser)) {
            throw new IllegalArgumentException("Username '" + cleanUser + "' is already taken.");
        }

        String hash = hashPassword(password);
        int userId = userDAO.createUser(
                role.roleId(), cleanUser, hash,
                cleanFirst, middleName, cleanLast,
                contactNumber, emailAddress
        );
        try {
            auditLogDAO.recordRegistration(userId, cleanUser, role.roleName());
        } catch (SQLException ignored) {
            // Registration succeeded even if audit logging failed
        }
        return userId;
    }
}
