package com.bhdm.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/barangay_health_center_db"
            + "?useSSL=false&serverTimezone=Asia/Manila&allowPublicKeyRetrieval=true"
            + "&connectTimeout=5000&socketTimeout=15000";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    private DatabaseConnection() { }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static String getUrl() { return URL; }

    public static void testConnection() throws SQLException {
        try (Connection connection = getConnection()) {
            if (!connection.isValid(3)) {
                throw new SQLException("The database connection is not valid.");
            }
        }
    }
}
