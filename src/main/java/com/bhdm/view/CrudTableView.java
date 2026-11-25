package com.bhdm.view;

import com.bhdm.App;
import com.bhdm.config.DatabaseConnection;
import com.bhdm.dao.CrudDAO;
import com.bhdm.service.AuthenticationService;
import com.bhdm.service.SessionManager;
import javafx.animation.PauseTransition;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Node;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.util.Duration;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

/** A reusable prepared-statement CRUD screen for one schema table. */
public class CrudTableView extends BorderPane {
    private static final Map<String, String[]> DISPLAY_COLUMN_PREFERENCES = Map.ofEntries(
            Map.entry("users", new String[]{"username", "first_name", "last_name"}),
            Map.entry("roles", new String[]{"role_name"}),
            Map.entry("households", new String[]{"household_number", "household_name"}),
            Map.entry("household_members", new String[]{"first_name", "last_name"}),
            Map.entry("healthcare_personnel", new String[]{"first_name", "last_name", "position"}),
            Map.entry("medicines", new String[]{"medicine_name", "dosage_form"}),
            Map.entry("medicine_batches", new String[]{"batch_number", "expiration_date"}),
            Map.entry("vaccines", new String[]{"vaccine_name", "vaccine_type"}),
            Map.entry("vaccine_batches", new String[]{"batch_number", "expiration_date"}),
            Map.entry("suppliers", new String[]{"supplier_name"}),
            Map.entry("supplier_locations", new String[]{"office_name", "warehouse_name", "address"}),
            Map.entry("government_programs", new String[]{"program_name", "agency_name"}),
            Map.entry("distribution_programs", new String[]{"program_name", "distribution_date"}),
            Map.entry("household_allocations", new String[]{"claim_number", "allocation_status"}),
            Map.entry("health_visits", new String[]{"visit_date", "visit_type"}),
            Map.entry("immunization_schedules", new String[]{"scheduled_date", "schedule_status"}),
            Map.entry("deliveries", new String[]{"delivery_date", "delivery_status"}),
            Map.entry("medicine_requests", new String[]{"request_date", "approval_status"})
    );

    private final String tableName;
    private final boolean highlightLowStock;
    private final boolean readOnly;
    private final CrudDAO crudDAO = new CrudDAO();
    private final TableView<Map<String, Object>> table = new TableView<>();
    private final TextField search = new TextField();
    private final Label countLabel = new Label("0 records");
    private final ObservableList<Map<String, Object>> rows = FXCollections.observableArrayList();
    private final List<ColumnInfo> columns = new ArrayList<>();
    private final Map<String, ForeignKeyInfo> foreignKeys = new LinkedHashMap<>();
    private final PauseTransition searchDebounce = new PauseTransition(Duration.millis(220));
    private String primaryKey;

    public CrudTableView(String tableName, boolean highlightLowStock) {
        this.tableName = Objects.requireNonNull(tableName);
        this.highlightLowStock = highlightLowStock;
        this.readOnly = SessionManager.isViewOnly();
        getStyleClass().add("crud-container");
        setTop(toolbar());
        Label loading = new Label("Loading " + pretty(tableName) + "...");
        loading.getStyleClass().add("stat-detail");
        setCenter(loading);
        loadMetadataAndRows();
    }

    private HBox toolbar() {
        HBox bar = new HBox(10);
        bar.setAlignment(Pos.CENTER_LEFT);
        bar.setPadding(new Insets(0, 0, 14, 0));

        Label title = new Label(pretty(tableName));
        title.getStyleClass().add("crud-title");

        search.setPromptText("Search " + pretty(tableName).toLowerCase() + "...");
        search.setPrefWidth(260);
        search.getStyleClass().add("search-field");
        searchDebounce.setOnFinished(e -> loadRows(false));
        search.textProperty().addListener((obs, oldVal, newVal) -> searchDebounce.playFromStart());

        Button add = new Button("+ Add");
        add.getStyleClass().add("btn-primary");
        Button edit = new Button("Edit");
        edit.getStyleClass().add("btn-secondary");
        Button delete = new Button("Delete");
        delete.getStyleClass().add("btn-danger");
        Button viewDetails = new Button("View Details");
        viewDetails.getStyleClass().add("btn-ghost");
        Button refresh = new Button("Refresh");
        refresh.getStyleClass().add("btn-ghost");

        add.setOnAction(event -> showForm(null));
        edit.setOnAction(event -> {
            Map<String, Object> selected = table.getSelectionModel().getSelectedItem();
            if (selected == null) {
                showError("Please select a row to edit.");
            } else {
                showForm(selected);
            }
        });
        viewDetails.setOnAction(event -> {
            Map<String, Object> selected = table.getSelectionModel().getSelectedItem();
            if (selected == null) {
                showError("Please select a row to view.");
            } else {
                showForm(selected);
            }
        });
        delete.setOnAction(event -> deleteSelected());
        refresh.setOnAction(event -> loadRows(true));

        countLabel.getStyleClass().add("record-count-pill");

        Region spacer = new Region();
        HBox.setHgrow(spacer, Priority.ALWAYS);

        if (readOnly) {
            add.setVisible(false);
            add.setManaged(false);
            edit.setVisible(false);
            edit.setManaged(false);
            delete.setVisible(false);
            delete.setManaged(false);
            Label viewOnlyTag = new Label("View-Only");
            viewOnlyTag.getStyleClass().add("role-badge-viewonly");
            bar.getChildren().addAll(title, countLabel, viewOnlyTag, spacer, search, viewDetails, refresh);
        } else {
            bar.getChildren().addAll(title, countLabel, spacer, search, add, edit, delete, refresh);
        }
        return bar;
    }

    private void loadMetadataAndRows() {
        columns.clear();
        foreignKeys.clear();
        primaryKey = null;

        try (Connection connection = DatabaseConnection.getConnection()) {
            DatabaseMetaData meta = connection.getMetaData();
            String catalog = connection.getCatalog();

            try (ResultSet result = meta.getColumns(catalog, null, tableName, "%")) {
                while (result.next()) {
                    columns.add(new ColumnInfo(
                            result.getString("COLUMN_NAME"),
                            result.getInt("DATA_TYPE"),
                            result.getString("TYPE_NAME"),
                            result.getInt("COLUMN_SIZE"),
                            result.getString("IS_NULLABLE"),
                            result.getString("IS_AUTOINCREMENT"),
                            result.getString("IS_GENERATEDCOLUMN"),
                            result.getString("COLUMN_DEF")
                    ));
                }
            }

            try (ResultSet result = meta.getPrimaryKeys(catalog, null, tableName)) {
                if (result.next()) {
                    primaryKey = result.getString("COLUMN_NAME");
                }
            }

            try (ResultSet result = meta.getImportedKeys(catalog, null, tableName)) {
                while (result.next()) {
                    String fkColumn = result.getString("FKCOLUMN_NAME");
                    String pkTable = result.getString("PKTABLE_NAME");
                    String pkColumn = result.getString("PKCOLUMN_NAME");
                    foreignKeys.put(fkColumn, new ForeignKeyInfo(fkColumn, pkTable, pkColumn));
                }
            }

            if (columns.isEmpty() || primaryKey == null) {
                throw new SQLException("No metadata or primary key was found for table " + tableName + ".");
            }
            buildColumns();
            loadRows(false);
        } catch (SQLException ex) {
            showError("Unable to open " + tableName + ": " + ex.getMessage());
        }
    }

    private void buildColumns() {
        table.getColumns().clear();
        table.setItems(rows);
        table.setPlaceholder(new Label("No records found in " + pretty(tableName) + "."));

        if (highlightLowStock) {
            TableColumn<Map<String, Object>, Map<String, Object>> statusCol = new TableColumn<>("Stock Status");
            statusCol.setCellValueFactory(cell -> new SimpleObjectProperty<>(cell.getValue()));
            statusCol.setPrefWidth(125);
            statusCol.setMinWidth(115);
            statusCol.setSortable(false);
            statusCol.setCellFactory(col -> new TableCell<>() {
                @Override
                protected void updateItem(Map<String, Object> item, boolean empty) {
                    super.updateItem(item, empty);
                    if (empty || item == null) {
                        setGraphic(null);
                        setText(null);
                    } else {
                        boolean low = isLowStock(item);
                        Label badge = new Label(low ? "LOW STOCK" : "IN STOCK");
                        badge.getStyleClass().add(low ? "badge-low-stock" : "badge-in-stock");
                        setGraphic(badge);
                        setText(null);
                    }
                }
            });
            table.getColumns().add(statusCol);
        }

        for (ColumnInfo info : columns) {
            TableColumn<Map<String, Object>, Object> column = new TableColumn<>(pretty(info.name));
            column.setUserData(info.name);
            column.setCellValueFactory(cell -> new SimpleObjectProperty<>(cell.getValue().get(info.name)));
            column.setPrefWidth(Math.max(130, Math.min(240, pretty(info.name).length() * 9.5 + 52)));
            if ("password_hash".equalsIgnoreCase(info.name)) {
                column.setCellFactory(col -> new TableCell<>() {
                    @Override
                    protected void updateItem(Object item, boolean empty) {
                        super.updateItem(item, empty);
                        setText(empty || item == null ? "" : "••••••••");
                    }
                });
            }
            table.getColumns().add(column);
        }

        if (table.getColumns().size() <= 8) {
            table.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY_ALL_COLUMNS);
        } else {
            for (TableColumn<Map<String, Object>, ?> col : table.getColumns()) {
                col.setMinWidth(130);
            }
            table.setColumnResizePolicy(TableView.UNCONSTRAINED_RESIZE_POLICY);
        }
        table.setRowFactory(view -> new TableRow<>() {
            @Override
            protected void updateItem(Map<String, Object> item, boolean empty) {
                super.updateItem(item, empty);
                getStyleClass().remove("low-stock-row");
                if (highlightLowStock && !empty && item != null && isLowStock(item)) {
                    getStyleClass().add("low-stock-row");
                }
            }
        });

        VBox.setVgrow(table, Priority.ALWAYS);
        setCenter(table);
    }

    private boolean isLowStock(Map<String, Object> item) {
        Object available = item.get("available_quantity");
        Object reorder = item.get("reorder_level");
        if (available == null || reorder == null) {
            return false;
        }
        try {
            return new BigDecimal(String.valueOf(available))
                    .compareTo(new BigDecimal(String.valueOf(reorder))) <= 0;
        } catch (NumberFormatException ignored) {
            return false;
        }
    }

    private void loadRows(boolean showResult) {
        if (columns.isEmpty()) {
            return;
        }
        List<String> columnNames = columns.stream().map(info -> info.name).toList();
        try {
            List<Map<String, Object>> loaded = crudDAO.selectRows(tableName, columnNames, primaryKey, search.getText());
            rows.setAll(loaded);
            countLabel.setText(rows.size() + " record" + (rows.size() == 1 ? "" : "s"));
            if (showResult) {
                showInfo("The " + pretty(tableName) + " table was refreshed.");
            }
        } catch (SQLException ex) {
            showError("Unable to load " + tableName + ": " + ex.getMessage());
        }
    }

    private void showForm(Map<String, Object> selected) {
        boolean editing = selected != null;
        if (readOnly && !editing) {
            showError("Staff accounts have view-only access and cannot add new records.");
            return;
        }

        Dialog<ButtonType> dialog = new Dialog<>();
        if (readOnly) {
            dialog.setTitle("View " + pretty(tableName) + " (Read-Only)");
            dialog.setHeaderText("Record Details — Staff View-Only Mode");
        } else {
            dialog.setTitle((editing ? "Edit " : "Add ") + pretty(tableName));
            dialog.setHeaderText((editing ? "Update existing " : "Create new ") + pretty(tableName) + " record");
        }
        applyDialogStyles(dialog.getDialogPane());

        ButtonType saveButtonType = new ButtonType(editing ? "Save Changes" : "Add Record", ButtonBar.ButtonData.OK_DONE);
        if (readOnly) {
            dialog.getDialogPane().getButtonTypes().add(ButtonType.CLOSE);
        } else {
            dialog.getDialogPane().getButtonTypes().addAll(ButtonType.CANCEL, saveButtonType);
        }

        VBox wrapper = new VBox(12);
        Label errorBanner = new Label();
        errorBanner.getStyleClass().add("form-error-banner");
        errorBanner.setWrapText(true);
        errorBanner.setMaxWidth(Double.MAX_VALUE);
        errorBanner.setVisible(false);
        errorBanner.setManaged(false);

        GridPane grid = new GridPane();
        grid.getStyleClass().add("form-grid");
        grid.setHgap(16);
        grid.setVgap(12);

        ColumnConstraints labelCol = new ColumnConstraints();
        labelCol.setMinWidth(180);
        labelCol.setPrefWidth(200);
        ColumnConstraints fieldCol = new ColumnConstraints();
        fieldCol.setHgrow(Priority.ALWAYS);
        fieldCol.setMinWidth(340);
        fieldCol.setPrefWidth(380);
        grid.getColumnConstraints().addAll(labelCol, fieldCol);

        List<ColumnInfo> editable = columns.stream()
                .filter(info -> !info.autoIncrement && !info.generated)
                .filter(info -> editing || !info.isAutoTimestampDefault())
                .toList();

        Map<String, FormField> formFields = new LinkedHashMap<>();
        int rowIdx = 0;

        for (ColumnInfo info : editable) {
            HBox labelBox = new HBox(4);
            labelBox.setAlignment(Pos.CENTER_LEFT);
            Label label = new Label(pretty(info.name));
            label.getStyleClass().add("form-label");
            labelBox.getChildren().add(label);

            if (info.isRequiredOnInput(editing)) {
                Label star = new Label("*");
                star.getStyleClass().add("form-required-star");
                labelBox.getChildren().add(star);
            }

            Object currentVal = editing ? selected.get(info.name) : null;
            FormField field = createFormField(info, currentVal, editing);
            if (readOnly) {
                field.control.setDisable(true);
            }
            formFields.put(info.name, field);

            VBox inputContainer = new VBox(3);
            inputContainer.getChildren().add(field.control);
            if (field.hint != null && !field.hint.isEmpty()) {
                Label hintLabel = new Label(field.hint);
                hintLabel.getStyleClass().add("form-hint");
                hintLabel.setWrapText(true);
                inputContainer.getChildren().add(hintLabel);
            }

            grid.add(labelBox, 0, rowIdx);
            grid.add(inputContainer, 1, rowIdx);
            rowIdx++;
        }

        ScrollPane scroll = new ScrollPane(grid);
        scroll.setFitToWidth(true);
        scroll.setPrefViewportHeight(Math.min(520, Math.max(220, rowIdx * 54)));
        scroll.setPrefViewportWidth(640);

        wrapper.getChildren().addAll(errorBanner, scroll);
        dialog.getDialogPane().setContent(wrapper);

        if (!readOnly) {
            Node saveButton = dialog.getDialogPane().lookupButton(saveButtonType);
            saveButton.getStyleClass().add("btn-primary");
            Node cancelButton = dialog.getDialogPane().lookupButton(ButtonType.CANCEL);
            if (cancelButton != null) {
                cancelButton.getStyleClass().add("btn-ghost");
            }

            saveButton.addEventFilter(javafx.event.ActionEvent.ACTION, event -> {
                errorBanner.setVisible(false);
                errorBanner.setManaged(false);
                formFields.values().forEach(f -> f.control.getStyleClass().remove("input-error"));

                List<String> validationErrors = validateForm(formFields, editing);
                if (!validationErrors.isEmpty()) {
                    errorBanner.setText(String.join("\n", validationErrors));
                    errorBanner.setVisible(true);
                    errorBanner.setManaged(true);
                    event.consume();
                    return;
                }

                try {
                    if (editing) {
                        update(selected, formFields);
                    } else {
                        insert(formFields);
                    }
                    loadRows(false);
                } catch (SQLException | IllegalArgumentException | SecurityException ex) {
                    errorBanner.setText(friendlySqlError(ex));
                    errorBanner.setVisible(true);
                    errorBanner.setManaged(true);
                    event.consume();
                }
            });
        } else {
            Node closeButton = dialog.getDialogPane().lookupButton(ButtonType.CLOSE);
            if (closeButton != null) {
                closeButton.getStyleClass().add("btn-ghost");
            }
        }

        dialog.showAndWait();
    }

    private FormField createFormField(ColumnInfo info, Object currentVal, boolean editing) {
        // 1. Foreign Key ComboBox
        ForeignKeyInfo fk = foreignKeys.get(info.name);
        if (fk != null) {
            ComboBox<ForeignKeyOption> combo = new ComboBox<>();
            combo.setMaxWidth(Double.MAX_VALUE);
            ObservableList<ForeignKeyOption> options = loadForeignKeyOptions(fk, info.nullable);
            combo.setItems(options);

            String currentStr = currentVal == null ? null : String.valueOf(currentVal);
            if (currentStr != null) {
                options.stream()
                        .filter(opt -> currentStr.equals(opt.id))
                        .findFirst()
                        .ifPresent(combo::setValue);
            } else if (info.nullable && !options.isEmpty()) {
                combo.setValue(options.get(0));
            }

            boolean parentEmpty = options.stream().noneMatch(opt -> opt.id != null);
            String hint = parentEmpty
                    ? "No records found in " + pretty(fk.parentTable) + ". Add a record there first."
                    : "References " + pretty(fk.parentTable) + " (" + fk.parentColumn + ")";
            return new FormField(info, combo, hint, parentEmpty);
        }

        // 2. Boolean / TINYINT(1) / BIT ComboBox
        if (info.isBooleanLike()) {
            ComboBox<ForeignKeyOption> combo = new ComboBox<>();
            combo.setMaxWidth(Double.MAX_VALUE);
            ObservableList<ForeignKeyOption> options = FXCollections.observableArrayList(
                    new ForeignKeyOption("0", "0 — No / Unread"),
                    new ForeignKeyOption("1", "1 — Yes / Read")
            );
            combo.setItems(options);
            boolean isTrue = currentVal != null && ("true".equalsIgnoreCase(String.valueOf(currentVal))
                    || "1".equals(String.valueOf(currentVal)));
            combo.setValue(options.get(isTrue ? 1 : 0));
            return new FormField(info, combo, null, false);
        }

        // 3. DatePicker for SQL DATE
        if (info.sqlType == Types.DATE) {
            DatePicker picker = new DatePicker();
            picker.setMaxWidth(Double.MAX_VALUE);
            picker.setPromptText("YYYY-MM-DD");
            if (currentVal != null) {
                try {
                    picker.setValue(LocalDate.parse(String.valueOf(currentVal)));
                } catch (DateTimeParseException ignored) {
                    picker.getEditor().setText(String.valueOf(currentVal));
                }
            }
            return new FormField(info, picker, "Format: YYYY-MM-DD", false);
        }

        // 4. PasswordField for users.password_hash
        if ("password_hash".equalsIgnoreCase(info.name)) {
            PasswordField pw = new PasswordField();
            pw.setMaxWidth(Double.MAX_VALUE);
            pw.setPromptText(editing ? "Leave blank to keep existing password" : "Enter password (auto-hashed)");
            return new FormField(info, pw, editing ? "Leave blank to keep current password." : "Stored securely with BCrypt.", false);
        }

        // 5. TextArea for TEXT / LONGTEXT
        if (info.isTextArea()) {
            TextArea area = new TextArea();
            area.setPrefRowCount(3);
            area.setWrapText(true);
            area.setMaxWidth(Double.MAX_VALUE);
            area.setPromptText(buildPrompt(info));
            if (currentVal != null) {
                area.setText(String.valueOf(currentVal));
            }
            return new FormField(info, area, null, false);
        }

        // 6. Standard TextField
        TextField tf = new TextField();
        tf.setMaxWidth(Double.MAX_VALUE);
        tf.setPromptText(buildPrompt(info));
        if (currentVal != null) {
            tf.setText(formatValueForDisplay(info, currentVal));
        }
        if (editing && info.name.equals(primaryKey)) {
            tf.setDisable(true);
        }
        String hint = null;
        if (info.sqlType == Types.TIME) {
            hint = "Format: HH:MM or HH:MM:SS (24-hour)";
        } else if (info.sqlType == Types.TIMESTAMP || info.sqlType == Types.TIMESTAMP_WITH_TIMEZONE) {
            hint = "Format: YYYY-MM-DD HH:MM:SS" + (info.defaultValue != null ? " (default: current timestamp)" : "");
        } else if (info.defaultValue != null && !editing) {
            hint = "Optional — defaults to: " + info.defaultValue;
        }
        return new FormField(info, tf, hint, false);
    }

    private ObservableList<ForeignKeyOption> loadForeignKeyOptions(ForeignKeyInfo fk, boolean nullable) {
        ObservableList<ForeignKeyOption> options = FXCollections.observableArrayList();
        if (nullable) {
            options.add(new ForeignKeyOption(null, "— None (Optional) —"));
        }

        try (Connection connection = DatabaseConnection.getConnection()) {
            List<String> displayCols = resolveDisplayColumns(connection, fk.parentTable, fk.parentColumn);
            String selectExpr = displayCols.isEmpty()
                    ? quote(fk.parentColumn) + " AS _label"
                    : "CONCAT_WS(' ', " + displayCols.stream().map(CrudTableView::quote).collect(Collectors.joining(", ")) + ") AS _label";
            String sql = "SELECT " + quote(fk.parentColumn) + " AS _id, " + selectExpr
                    + " FROM " + quote(fk.parentTable)
                    + " ORDER BY " + quote(fk.parentColumn) + " DESC LIMIT 500";

            try (PreparedStatement stmt = connection.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String id = String.valueOf(rs.getObject("_id"));
                    String lbl = rs.getString("_label");
                    String formatted = (lbl == null || lbl.isBlank() || lbl.equals(id))
                            ? "#" + id
                            : "#" + id + " — " + lbl;
                    options.add(new ForeignKeyOption(id, formatted));
                }
            }
        } catch (SQLException ignored) {
            // If parent lookup fails, dropdown stays empty and validation informs user
        }
        return options;
    }

    private List<String> resolveDisplayColumns(Connection connection, String parentTable, String pkCol) throws SQLException {
        Set<String> availableCols = new LinkedHashSet<>();
        DatabaseMetaData meta = connection.getMetaData();
        try (ResultSet rs = meta.getColumns(connection.getCatalog(), null, parentTable, "%")) {
            while (rs.next()) {
                availableCols.add(rs.getString("COLUMN_NAME"));
            }
        }

        String[] preferred = DISPLAY_COLUMN_PREFERENCES.get(parentTable);
        if (preferred != null) {
            List<String> matched = Arrays.stream(preferred).filter(availableCols::contains).toList();
            if (!matched.isEmpty()) {
                return matched;
            }
        }

        // Fallback: first non-PK column
        return availableCols.stream().filter(c -> !c.equals(pkCol)).limit(2).toList();
    }

    private List<String> validateForm(Map<String, FormField> formFields, boolean editing) {
        List<String> errors = new ArrayList<>();

        for (FormField field : formFields.values()) {
            ColumnInfo info = field.info;
            String raw = field.extractRawValue();
            boolean isEmpty = raw == null || raw.isBlank();

            if (isEmpty) {
                if (info.isRequiredOnInput(editing)) {
                    field.control.getStyleClass().add("input-error");
                    if (field.parentEmpty) {
                        ForeignKeyInfo fk = foreignKeys.get(info.name);
                        errors.add("• " + pretty(info.name) + " is required, but " + pretty(fk.parentTable) + " has no records yet.");
                    } else {
                        errors.add("• " + pretty(info.name) + " is required.");
                    }
                }
                continue;
            }

            // Type-specific validation
            try {
                parseValue(info, raw);
            } catch (IllegalArgumentException | DateTimeParseException ex) {
                field.control.getStyleClass().add("input-error");
                errors.add("• " + pretty(info.name) + ": " + ex.getMessage());
            }
        }

        return errors;
    }

    private void insert(Map<String, FormField> formFields) throws SQLException {
        SessionManager.requireAdminWriteAccess("INSERT into " + tableName);
        List<Map.Entry<ColumnInfo, String>> toInsert = new ArrayList<>();
        for (FormField field : formFields.values()) {
            String raw = field.extractRawValue();
            if (raw != null && !raw.isBlank()) {
                if ("password_hash".equalsIgnoreCase(field.info.name) && !isBcryptHash(raw)) {
                    raw = AuthenticationService.hashPassword(raw);
                }
                toInsert.add(Map.entry(field.info, raw));
            }
        }

        if (toInsert.isEmpty()) {
            throw new IllegalArgumentException("Please enter at least one value.");
        }

        List<String> colNames = toInsert.stream().map(e -> e.getKey().name).toList();
        crudDAO.executeInsert(tableName, colNames, statement -> {
            int index = 1;
            for (Map.Entry<ColumnInfo, String> entry : toInsert) {
                bind(statement, index++, entry.getKey(), entry.getValue());
            }
        });
        showInfo("Record added successfully.");
    }

    private void update(Map<String, Object> selected, Map<String, FormField> formFields) throws SQLException {
        SessionManager.requireAdminWriteAccess("UPDATE on " + tableName);
        List<Map.Entry<ColumnInfo, String>> toUpdate = new ArrayList<>();
        for (FormField field : formFields.values()) {
            ColumnInfo info = field.info;
            if (info.name.equals(primaryKey)) {
                continue;
            }
            String raw = field.extractRawValue();
            boolean isEmpty = raw == null || raw.isBlank();

            if ("password_hash".equalsIgnoreCase(info.name)) {
                if (isEmpty) {
                    continue;
                }
                if (!isBcryptHash(raw)) {
                    raw = AuthenticationService.hashPassword(raw);
                }
            } else if (isEmpty && !info.nullable && info.defaultValue != null) {
                continue;
            }

            toUpdate.add(Map.entry(info, raw));
        }

        if (toUpdate.isEmpty()) {
            throw new IllegalArgumentException("No editable columns to update.");
        }

        List<String> colNames = toUpdate.stream().map(e -> e.getKey().name).toList();
        int updated = crudDAO.executeUpdate(tableName, colNames, primaryKey, statement -> {
            int index = 1;
            for (Map.Entry<ColumnInfo, String> entry : toUpdate) {
                bind(statement, index++, entry.getKey(), entry.getValue());
            }
            ColumnInfo key = findColumn(primaryKey);
            bind(statement, index, key, String.valueOf(selected.get(primaryKey)));
        });
        if (updated != 1) {
            throw new SQLException("The selected record no longer exists.");
        }
        showInfo("Record updated successfully.");
    }

    private void deleteSelected() {
        if (readOnly) {
            showError("Staff accounts have view-only access and cannot delete records.");
            return;
        }
        Map<String, Object> selected = table.getSelectionModel().getSelectedItem();
        if (selected == null) {
            showError("Please select a row to delete.");
            return;
        }
        Alert confirm = new Alert(Alert.AlertType.CONFIRMATION,
                "Are you sure you want to permanently delete this " + pretty(tableName) + " record?",
                ButtonType.CANCEL, ButtonType.OK);
        confirm.setHeaderText("Confirm Deletion");
        applyDialogStyles(confirm.getDialogPane());
        Node okBtn = confirm.getDialogPane().lookupButton(ButtonType.OK);
        if (okBtn != null) {
            okBtn.getStyleClass().add("btn-danger");
        }
        if (confirm.showAndWait().orElse(ButtonType.CANCEL) != ButtonType.OK) {
            return;
        }

        try {
            crudDAO.executeDelete(tableName, primaryKey,
                    statement -> bind(statement, 1, findColumn(primaryKey), String.valueOf(selected.get(primaryKey))));
            loadRows(false);
            showInfo("Record deleted successfully.");
        } catch (SQLException | IllegalArgumentException | SecurityException ex) {
            showError(friendlySqlError(ex));
        }
    }

    private Object parseValue(ColumnInfo info, String value) {
        String trimmed = value.trim();
        if (info.isBooleanLike()) {
            if ("true".equalsIgnoreCase(trimmed) || "1".equals(trimmed) || "yes".equalsIgnoreCase(trimmed)) {
                return 1;
            }
            if ("false".equalsIgnoreCase(trimmed) || "0".equals(trimmed) || "no".equalsIgnoreCase(trimmed)) {
                return 0;
            }
            throw new IllegalArgumentException("Enter 0/1 or true/false.");
        }
        return switch (info.sqlType) {
            case Types.TINYINT, Types.SMALLINT, Types.INTEGER -> {
                try {
                    yield Integer.valueOf(trimmed);
                } catch (NumberFormatException ex) {
                    throw new IllegalArgumentException("Must be a whole number.");
                }
            }
            case Types.BIGINT -> {
                try {
                    yield Long.valueOf(trimmed);
                } catch (NumberFormatException ex) {
                    throw new IllegalArgumentException("Must be an integer.");
                }
            }
            case Types.DECIMAL, Types.NUMERIC, Types.FLOAT, Types.REAL, Types.DOUBLE -> {
                try {
                    yield new BigDecimal(trimmed);
                } catch (NumberFormatException ex) {
                    throw new IllegalArgumentException("Must be a valid decimal number.");
                }
            }
            case Types.DATE -> {
                try {
                    yield java.sql.Date.valueOf(LocalDate.parse(trimmed));
                } catch (DateTimeParseException ex) {
                    throw new IllegalArgumentException("Use YYYY-MM-DD format (e.g., 2026-11-24).");
                }
            }
            case Types.TIME -> {
                try {
                    yield Time.valueOf(LocalTime.parse(trimmed));
                } catch (DateTimeParseException ex) {
                    throw new IllegalArgumentException("Use HH:MM or HH:MM:SS format (e.g., 09:30:00).");
                }
            }
            case Types.TIMESTAMP, Types.TIMESTAMP_WITH_TIMEZONE -> {
                try {
                    String normalized = trimmed.replace(' ', 'T');
                    yield Timestamp.valueOf(LocalDateTime.parse(normalized));
                } catch (DateTimeParseException ex) {
                    throw new IllegalArgumentException("Use YYYY-MM-DD HH:MM:SS format.");
                }
            }
            default -> trimmed;
        };
    }

    private void bind(PreparedStatement statement, int index, ColumnInfo info, String value) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            statement.setNull(index, info.sqlType);
            return;
        }
        Object parsed = parseValue(info, value);
        statement.setObject(index, parsed);
    }

    private static boolean isBcryptHash(String value) {
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }

    private static String formatValueForDisplay(ColumnInfo info, Object val) {
        if (val instanceof Timestamp ts) {
            return ts.toLocalDateTime().toString().replace('T', ' ');
        }
        if (val instanceof LocalDateTime ldt) {
            return ldt.toString().replace('T', ' ');
        }
        return String.valueOf(val);
    }

    private static String buildPrompt(ColumnInfo info) {
        if (info.defaultValue != null) {
            return "Default: " + info.defaultValue;
        }
        return switch (info.sqlType) {
            case Types.TIME -> "HH:MM:SS";
            case Types.TIMESTAMP, Types.TIMESTAMP_WITH_TIMEZONE -> "YYYY-MM-DD HH:MM:SS";
            case Types.INTEGER, Types.BIGINT, Types.SMALLINT -> "Enter whole number";
            case Types.DECIMAL, Types.NUMERIC, Types.DOUBLE -> "0.00";
            default -> "Enter " + pretty(info.name).toLowerCase();
        };
    }

    private static String friendlySqlError(Exception ex) {
        if (ex instanceof SQLIntegrityConstraintViolationException) {
            String msg = ex.getMessage() != null ? ex.getMessage() : "";
            if (msg.toLowerCase().contains("foreign key")) {
                if (msg.toLowerCase().contains("delete or update a parent row")) {
                    return "Cannot delete this record because other records reference it.";
                }
                return "Foreign key constraint failed: please select a valid parent record.";
            }
            if (msg.toLowerCase().contains("duplicate entry")) {
                return "Duplicate value detected: a unique field already exists in the database.";
            }
        }
        return ex.getMessage();
    }

    private ColumnInfo findColumn(String name) {
        return columns.stream().filter(info -> info.name.equals(name)).findFirst().orElseThrow();
    }

    private static String quote(String identifier) {
        return "`" + identifier.replace("`", "``") + "`";
    }

    private static String pretty(String value) {
        return Arrays.stream(value.split("_"))
                .map(word -> word.isEmpty() ? word : word.substring(0, 1).toUpperCase() + word.substring(1))
                .collect(Collectors.joining(" "));
    }

    private static void applyDialogStyles(DialogPane pane) {
        String css = App.getStylesheetUrl();
        if (css != null && !pane.getStylesheets().contains(css)) {
            pane.getStylesheets().add(css);
        }
    }

    private static void showInfo(String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION, message, ButtonType.OK);
        alert.setHeaderText(null);
        applyDialogStyles(alert.getDialogPane());
        alert.showAndWait();
    }

    private static void showError(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR, message, ButtonType.OK);
        alert.setHeaderText("Action Required");
        applyDialogStyles(alert.getDialogPane());
        alert.showAndWait();
    }

    private static final class ForeignKeyInfo {
        private final String fkColumn;
        private final String parentTable;
        private final String parentColumn;

        private ForeignKeyInfo(String fkColumn, String parentTable, String parentColumn) {
            this.fkColumn = fkColumn;
            this.parentTable = parentTable;
            this.parentColumn = parentColumn;
        }
    }

    private static final class ForeignKeyOption {
        private final String id;
        private final String label;

        private ForeignKeyOption(String id, String label) {
            this.id = id;
            this.label = label;
        }

        @Override
        public String toString() {
            return label;
        }
    }

    private static final class FormField {
        private final ColumnInfo info;
        private final Control control;
        private final String hint;
        private final boolean parentEmpty;

        private FormField(ColumnInfo info, Control control, String hint, boolean parentEmpty) {
            this.info = info;
            this.control = control;
            this.hint = hint;
            this.parentEmpty = parentEmpty;
        }

        @SuppressWarnings("unchecked")
        private String extractRawValue() {
            if (control instanceof ComboBox<?> combo) {
                Object selected = combo.getValue();
                if (selected instanceof ForeignKeyOption opt) {
                    return opt.id;
                }
                return selected == null ? null : String.valueOf(selected);
            }
            if (control instanceof DatePicker picker) {
                LocalDate date = picker.getValue();
                if (date != null) {
                    return date.toString();
                }
                String editorText = picker.getEditor().getText();
                return editorText == null ? null : editorText.trim();
            }
            if (control instanceof TextInputControl tic) {
                return tic.getText();
            }
            return null;
        }
    }

    private static final class ColumnInfo {
        private final String name;
        private final int sqlType;
        private final String typeName;
        private final int columnSize;
        private final boolean nullable;
        private final boolean autoIncrement;
        private final boolean generated;
        private final String defaultValue;

        private ColumnInfo(String name, int sqlType, String typeName, int columnSize,
                           String isNullable, String autoIncrement, String generated, String defaultValue) {
            this.name = name;
            this.sqlType = sqlType;
            this.typeName = typeName == null ? "" : typeName;
            this.columnSize = columnSize;
            this.nullable = "YES".equalsIgnoreCase(isNullable);
            this.autoIncrement = "YES".equalsIgnoreCase(autoIncrement);
            this.generated = "YES".equalsIgnoreCase(generated);
            this.defaultValue = defaultValue;
        }

        private boolean isBooleanLike() {
            return sqlType == Types.BOOLEAN
                    || sqlType == Types.BIT
                    || (sqlType == Types.TINYINT && columnSize == 1);
        }

        private boolean isTextArea() {
            String upper = typeName.toUpperCase(Locale.ROOT);
            return upper.contains("TEXT") || sqlType == Types.LONGVARCHAR || sqlType == Types.CLOB;
        }

        private boolean isAutoTimestampDefault() {
            return defaultValue != null && defaultValue.toLowerCase(Locale.ROOT).contains("current_timestamp");
        }

        private boolean isRequiredOnInput(boolean editing) {
            if (editing && "password_hash".equalsIgnoreCase(name)) {
                return false;
            }
            return !nullable && defaultValue == null;
        }
    }
}
