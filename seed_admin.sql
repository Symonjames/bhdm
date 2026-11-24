-- Step 1 seed data for barangay_health_center_db.
-- Password: admin123
-- BCrypt hash generated with jBCrypt cost factor 10 for admin123.

INSERT INTO roles (role_name, description)
VALUES ('Admin', 'Full system administrator access')
ON DUPLICATE KEY UPDATE description = VALUES(description);

INSERT INTO users (
    role_id,
    username,
    password_hash,
    first_name,
    middle_name,
    last_name,
    account_status
)
SELECT
    r.role_id,
    'admin',
    '$2a$10$F5XnO1zIIPE1y3PsXtVhSOQG5I/t3BCrULBIJV7dZugmD.ARbKL8e',
    'System',
    NULL,
    'Administrator',
    'Active'
FROM roles r
WHERE r.role_name = 'Admin'
  AND NOT EXISTS (SELECT 1 FROM users u WHERE u.username = 'admin');
