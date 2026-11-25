package com.bhdm.view;

import com.bhdm.App;
import com.bhdm.dao.DashboardDAO;
import com.bhdm.service.SessionManager;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.layout.*;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardView extends BorderPane {
    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final int userId;
    private final String roleName;
    private final boolean isAdmin;
    private final Map<String, Button> navigation = new LinkedHashMap<>();
    private final Label headerTitle = new Label("Overview");
    private final Label headerSubtitle = new Label("Barangay Health Center Management System");

    public DashboardView(App app, int userId, String fullName, String roleName) {
        this.userId = userId;
        this.roleName = roleName == null ? "Staff" : roleName.trim();
        this.isAdmin = SessionManager.isLoggedIn()
                ? SessionManager.isAdmin()
                : "Admin".equalsIgnoreCase(this.roleName);

        String css = App.getStylesheetUrl();
        if (css != null) {
            getStylesheets().add(css);
        }

        setLeft(sidebar());

        BorderPane mainShell = new BorderPane();
        mainShell.setTop(header(app, fullName, this.roleName));
        setCenter(mainShell);

        showDashboard(mainShell);
    }

    private HBox header(App app, String name, String role) {
        HBox box = new HBox(12);
        box.setAlignment(Pos.CENTER_LEFT);
        box.getStyleClass().add("app-header");

        VBox titleGroup = new VBox(2);
        headerTitle.getStyleClass().add("header-title");
        headerSubtitle.getStyleClass().add("header-subtitle");
        titleGroup.getChildren().addAll(headerTitle, headerSubtitle);

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        Label roleBadge = new Label(isAdmin ? "Admin (Full Access)" : role + " (View-Only)");
        roleBadge.getStyleClass().add(isAdmin ? "role-badge-admin" : "role-badge-viewonly");

        Label userPill = new Label(name);
        userPill.getStyleClass().add("user-pill");

        Button logout = new Button("Sign Out");
        logout.getStyleClass().add("btn-danger");
        logout.setOnAction(event -> {
            SessionManager.logout();
            app.showLogin();
        });

        box.getChildren().addAll(titleGroup, spacer, roleBadge, userPill, logout);
        return box;
    }

    private VBox sidebar() {
        VBox nav = new VBox(6);
        nav.getStyleClass().add("sidebar");

        VBox brand = new VBox(2);
        Label brandName = new Label("BHDM Portal");
        brandName.getStyleClass().add("sidebar-brand");
        Label brandSub = new Label("Barangay Health Center");
        brandSub.getStyleClass().add("sidebar-brand-sub");
        brand.getChildren().addAll(brandName, brandSub);
        nav.getChildren().add(brand);

        if (!isAdmin) {
            Label viewOnlyBanner = new Label("Staff (View-Only)");
            viewOnlyBanner.setMaxWidth(Double.MAX_VALUE);
            viewOnlyBanner.getStyleClass().add("sidebar-role-banner");
            nav.getChildren().add(viewOnlyBanner);
        }

        Label section = new Label("MODULES");
        section.getStyleClass().add("sidebar-section");
        nav.getChildren().add(section);

        addNavigation(nav, "Dashboard", () -> showDashboard(mainShell()));
        addNavigation(nav, "Households & Visits", () -> showModule(new String[]{
                "households", "household_members", "health_visits", "assistance_records"
        }, "Households & Visits", "Manage resident households, members, clinic visits, and assistance"));
        addNavigation(nav, "Immunization", () -> showModule(new String[]{
                "vaccines", "vaccine_batches", "immunization_schedules",
                "immunization_preregistrations", "immunization_queue", "immunization_records"
        }, "Immunization", "Manage vaccines, batches, schedules, pre-registrations, queue, and records"));
        addNavigation(nav, "Medicine & Inventory", () -> showModule(new String[]{
                "medicines", "medicine_inventory", "medicine_batches", "medicine_requests",
                "stock_transactions", "deliveries", "delivery_items",
                "suppliers", "supplier_locations", "supplier_contacts"
        }, "Medicine & Inventory", "Track medicine catalog, stock levels, batches, deliveries, and suppliers"));
        addNavigation(nav, "Programs & Distribution", () -> showModule(new String[]{
                "government_programs", "household_program_memberships",
                "distribution_programs", "household_allocations", "distribution_claims"
        }, "Programs & Distribution", "Administer government programs, allocations, and distribution claims"));

        String[] staffModuleTables = isAdmin
                ? new String[]{"healthcare_personnel", "staff_attendance", "users", "roles", "notifications", "reports", "audit_logs"}
                : new String[]{"healthcare_personnel", "staff_attendance", "notifications", "reports", "audit_logs"};
        String staffModuleTitle = isAdmin ? "Staff & Administration" : "Staff & Reports";
        String staffModuleSubtitle = isAdmin
                ? "Manage personnel, attendance, user accounts, roles, notifications, and logs"
                : "View personnel directory, attendance, notifications, reports, and audit logs";
        addNavigation(nav, staffModuleTitle, () -> showModule(staffModuleTables, staffModuleTitle, staffModuleSubtitle));

        return nav;
    }

    private BorderPane mainShell() {
        return (BorderPane) getCenter();
    }

    private void addNavigation(VBox nav, String name, Runnable action) {
        Button button = new Button(name);
        button.setMaxWidth(Double.MAX_VALUE);
        button.setAlignment(Pos.CENTER_LEFT);
        button.getStyleClass().add("nav-button");
        button.setOnAction(event -> {
            setActiveNavigation(name);
            action.run();
        });
        navigation.put(name, button);
        nav.getChildren().add(button);
    }

    private void setActiveNavigation(String activeName) {
        navigation.forEach((name, btn) -> {
            btn.getStyleClass().remove("nav-button-active");
            if (name.equals(activeName)) {
                btn.getStyleClass().add("nav-button-active");
            }
        });
    }

    private void showDashboard(BorderPane shell) {
        setActiveNavigation("Dashboard");
        headerTitle.setText("Dashboard Overview");
        headerSubtitle.setText("Real-time public health center summary");
        shell.setCenter(overview());
    }

    private void showModule(String[] tableNames, String title, String subtitle) {
        headerTitle.setText(title);
        headerSubtitle.setText(subtitle);

        VBox content = new VBox(14);
        content.getStyleClass().add("page-container");

        TabPane tabs = new TabPane();
        tabs.setTabClosingPolicy(TabPane.TabClosingPolicy.UNAVAILABLE);
        for (String tableName : tableNames) {
            CrudTableView view = new CrudTableView(tableName, "medicine_inventory".equals(tableName));
            Tab tab = new Tab(pretty(tableName), view);
            tab.setClosable(false);
            tabs.getTabs().add(tab);
        }
        VBox.setVgrow(tabs, Priority.ALWAYS);
        content.getChildren().add(tabs);
        mainShell().setCenter(content);
    }

    private VBox overview() {
        VBox content = new VBox(22);
        content.getStyleClass().add("page-container");

        VBox headingBox = new VBox(4);
        Label welcome = new Label("Health Center Summary");
        welcome.getStyleClass().add("page-heading");
        Label sub = new Label("Live counts pulled from barangay_health_center_db.");
        sub.getStyleClass().add("page-subheading");
        headingBox.getChildren().addAll(welcome, sub);

        GridPane cards = new GridPane();
        cards.setHgap(18);
        cards.setVgap(18);
        for (int i = 0; i < 4; i++) {
            ColumnConstraints col = new ColumnConstraints();
            col.setPercentWidth(25);
            col.setHgrow(Priority.ALWAYS);
            cards.getColumnConstraints().add(col);
        }

        addCard(cards, 0, "Households", "households", "Registered households", false);
        addCard(cards, 1, "Visits Today", "today_visits", "Health center visits today", true);
        addCard(cards, 2, "Low Stock", "low_stock", "Medicine items at or below reorder", false);
        addCard(cards, 3, "Notifications", "notifications", "Unread notifications for you", false);

        VBox banner = new VBox(6);
        banner.getStyleClass().add("info-banner");
        Label bannerTitle = new Label(isAdmin ? "Quick Guidance (Admin — Full Access)" : "Quick Guidance (Staff — View-Only Mode)");
        bannerTitle.getStyleClass().add("stat-title");
        Label note = new Label(isAdmin
                ? "Select a module from the sidebar to view, search, add, edit, or delete records. "
                  + "Foreign key fields automatically load parent options in dropdown menus. "
                  + "Counts refresh whenever Dashboard is selected."
                : "You are signed in with Staff (View-Only) access. You can browse, search, and inspect "
                  + "all seeded and live health center records across every module. Add, Edit, and Delete "
                  + "actions are restricted to Admin accounts.");
        note.setWrapText(true);
        note.getStyleClass().add("stat-detail");
        banner.getChildren().addAll(bannerTitle, note);

        content.getChildren().addAll(headingBox, cards, banner);
        return content;
    }

    private void addCard(GridPane grid, int col, String title, String type, String subtitle, boolean tealAccent) {
        VBox card = new VBox(6);
        card.getStyleClass().add("stat-card");
        card.setMaxWidth(Double.MAX_VALUE);

        Label value = new Label("—");
        value.getStyleClass().add("stat-value");
        if (tealAccent) {
            value.getStyleClass().add("stat-value-teal");
        }

        Label name = new Label(title);
        name.getStyleClass().add("stat-title");
        Label detail = new Label(subtitle);
        detail.getStyleClass().add("stat-detail");
        detail.setWrapText(true);

        card.getChildren().addAll(value, name, detail);
        grid.add(card, col, 0);

        try {
            int count = switch (type) {
                case "today_visits" -> dashboardDAO.countTodayVisits();
                case "notifications" -> dashboardDAO.countUnreadNotifications(userId);
                case "low_stock" -> dashboardDAO.countLowStockItems();
                default -> dashboardDAO.count(type);
            };
            value.setText(String.valueOf(count));
            if ("low_stock".equals(type) && count > 0) {
                value.getStyleClass().add("stat-value-warning");
            }
        } catch (SQLException ex) {
            value.setText("!");
            value.getStyleClass().add("stat-value-warning");
            value.setTooltip(new Tooltip(ex.getMessage()));
        }
    }

    private static String pretty(String value) {
        return java.util.Arrays.stream(value.split("_"))
                .map(word -> word.substring(0, 1).toUpperCase() + word.substring(1))
                .reduce((a, b) -> a + " " + b).orElse(value);
    }
}
