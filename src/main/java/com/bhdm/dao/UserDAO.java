package com.bhdm.dao;

import com.bhdm.config.DatabaseConnection;
import com.bhdm.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public record RoleOption(int roleId, String roleName) {
        @Override
        public String toString() {
            return roleName;
        }
    }

    public User findActiveByUsername(String username) throws SQLException {
        String sql = "SELECT u.user_id, u.username, u.password_hash, "
                + "CONCAT_WS(' ', u.first_name, u.middle_name, u.last_name) AS full_name, "
                + "r.role_name FROM users u INNER JOIN roles r ON r.role_id = u.role_id "
                + "WHERE u.username = ? AND u.account_status = 'Active'";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return new User(result.getInt("user_id"), result.getString("username"),
                            result.getString("password_hash"), result.getString("full_name"),
                            result.getString("role_name"));
                }
            }
        }
        return null;
    }

    public RoleOption ensureStaffRole() throws SQLException {
        String selectSql = "SELECT role_id, role_name FROM roles WHERE LOWER(role_name) = 'staff' LIMIT 1";
        String insertSql = "INSERT INTO roles (role_name, description) VALUES ('Staff', 'Barangay health center staff (view-only access)')";
        try (Connection connection = DatabaseConnection.getConnection()) {
            try (PreparedStatement select = connection.prepareStatement(selectSql);
                 ResultSet rs = select.executeQuery()) {
                if (rs.next()) {
                    return new RoleOption(rs.getInt("role_id"), rs.getString("role_name"));
                }
            }
            try (PreparedStatement insert = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                insert.executeUpdate();
                try (ResultSet keys = insert.getGeneratedKeys()) {
                    if (keys.next()) {
                        return new RoleOption(keys.getInt(1), "Staff");
                    }
                }
            }
        }
        throw new SQLException("Unable to resolve or create the default Staff role.");
    }

    public List<RoleOption> findPublicRoles() throws SQLException {
        String sql = "SELECT role_id, role_name FROM roles WHERE LOWER(role_name) <> 'admin' ORDER BY role_name ASC";
        List<RoleOption> roles = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {
            while (result.next()) {
                roles.add(new RoleOption(result.getInt("role_id"), result.getString("role_name")));
            }
        }
        return roles;
    }

    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet result = statement.executeQuery()) {
                return result.next();
            }
        }
    }

    public int createUser(int roleId, String username, String passwordHash,
                          String firstName, String middleName, String lastName,
                          String contactNumber, String emailAddress) throws SQLException {
        String sql = "INSERT INTO users (role_id, username, password_hash, first_name, middle_name, "
                + "last_name, contact_number, email_address, account_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Active')";
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, roleId);
            statement.setString(2, username);
            statement.setString(3, passwordHash);
            statement.setString(4, firstName);
            setNullableString(statement, 5, middleName);
            statement.setString(6, lastName);
            setNullableString(statement, 7, contactNumber);
            setNullableString(statement, 8, emailAddress);
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("User was created, but no generated user_id was returned.");
    }

    private static void setNullableString(PreparedStatement statement, int index, String value) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            statement.setNull(index, Types.VARCHAR);
        } else {
            statement.setString(index, value.trim());
        }
    }
}
