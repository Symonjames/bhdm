package com.bhdm.model;

public class User {
    private final int userId;
    private final String username;
    private final String passwordHash;
    private final String fullName;
    private final String roleName;

    public User(int userId, String username, String passwordHash, String fullName, String roleName) {
        this.userId = userId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.roleName = roleName;
    }

    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getPasswordHash() { return passwordHash; }
    public String getFullName() { return fullName; }
    public String getRoleName() { return roleName; }
}
