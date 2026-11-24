package com.bhdm.dao;

import com.bhdm.config.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {
    public int count(String table) throws SQLException {
        if (!table.matches("[a-z_]+")) throw new IllegalArgumentException("Invalid table name");
        String sql = "SELECT COUNT(*) FROM " + table;
        try (Connection c = DatabaseConnection.getConnection();
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {
            r.next();
            return r.getInt(1);
        }
    }

    public int countTodayVisits() throws SQLException {
        String sql = "SELECT COUNT(*) FROM health_visits WHERE visit_date = CURRENT_DATE()";
        try (Connection c = DatabaseConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) { r.next(); return r.getInt(1); }
    }

    public int countUnreadNotifications(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND read_status = 0";
        try (Connection c = DatabaseConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, userId);
            try (ResultSet r = s.executeQuery()) { r.next(); return r.getInt(1); }
        }
    }

    public int countLowStockItems() throws SQLException {
        String sql = "SELECT COUNT(*) FROM medicine_inventory WHERE available_quantity <= reorder_level";
        try (Connection c = DatabaseConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) { r.next(); return r.getInt(1); }
    }
}
