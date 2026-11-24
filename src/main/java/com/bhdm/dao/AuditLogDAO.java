package com.bhdm.dao;

import com.bhdm.config.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

public class AuditLogDAO {
    public void recordLogin(int userId) throws SQLException {
        String sql = "INSERT INTO audit_logs (user_id, action_type, entity_name, transaction_id, remarks, tab_name, clicked_action) "
                + "VALUES (?, 'LOGIN', 'users', ?, ?, 'Login', 'Sign in')";
        try (Connection c = DatabaseConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, userId);
            s.setString(2, UUID.randomUUID().toString());
            s.setString(3, "Successful login");
            s.executeUpdate();
        }
    }

    public void recordRegistration(int userId, String username, String roleName) throws SQLException {
        String sql = "INSERT INTO audit_logs (user_id, action_type, entity_name, record_id, transaction_id, remarks, tab_name, clicked_action) "
                + "VALUES (?, 'REGISTER', 'users', ?, ?, ?, 'Register', 'Create Account')";
        try (Connection c = DatabaseConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, userId);
            s.setString(2, String.valueOf(userId));
            s.setString(3, UUID.randomUUID().toString());
            s.setString(4, "Self-registered account (" + roleName + "): " + username);
            s.executeUpdate();
        }
    }
}
