-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2026 at 12:06 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barangay_health_center_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `assistance_records`
--

CREATE TABLE `assistance_records` (
  `assistance_id` int(11) NOT NULL,
  `household_id` int(11) NOT NULL,
  `member_id` int(11) DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  `assistance_type` varchar(80) NOT NULL,
  `funding_agency` varchar(150) NOT NULL,
  `assistance_description` text NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `date_received` date DEFAULT NULL,
  `received_by` varchar(100) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `recorded_by` int(11) NOT NULL,
  `receipt_reference` varchar(150) DEFAULT NULL,
  `assistance_status` varchar(30) NOT NULL DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `audit_id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `entity_name` varchar(100) NOT NULL,
  `record_id` varchar(100) DEFAULT NULL,
  `old_value` longtext DEFAULT NULL,
  `new_value` longtext DEFAULT NULL,
  `action_timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `remarks` text DEFAULT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `tab_name` varchar(100) DEFAULT NULL,
  `clicked_action` varchar(100) DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deliveries`
--

CREATE TABLE `deliveries` (
  `delivery_id` int(11) NOT NULL,
  `request_id` int(11) DEFAULT NULL,
  `supplier_location_id` int(11) NOT NULL,
  `sent_by` int(11) NOT NULL,
  `dispatched_by` varchar(100) DEFAULT NULL,
  `dispatch_date` date DEFAULT NULL,
  `dispatch_time` time DEFAULT NULL,
  `delivered_by` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `received_by` int(11) DEFAULT NULL,
  `received_date` date DEFAULT NULL,
  `received_time` time DEFAULT NULL,
  `receiving_signature_reference` varchar(255) DEFAULT NULL,
  `delivery_status` varchar(30) NOT NULL DEFAULT 'Pending',
  `recorded_by` int(11) NOT NULL,
  `system_entry_timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_items`
--

CREATE TABLE `delivery_items` (
  `delivery_item_id` int(11) NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `quantity_delivered` decimal(12,3) NOT NULL,
  `quantity_accepted` decimal(12,3) NOT NULL DEFAULT 0.000,
  `quantity_rejected` decimal(12,3) NOT NULL DEFAULT 0.000,
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `distribution_claims`
--

CREATE TABLE `distribution_claims` (
  `claim_id` int(11) NOT NULL,
  `allocation_id` int(11) NOT NULL,
  `claim_number` varchar(50) NOT NULL,
  `claimed_by` varchar(100) NOT NULL,
  `claim_date` date NOT NULL,
  `claim_time` time NOT NULL,
  `released_by` int(11) DEFAULT NULL,
  `proof_of_claim` varchar(255) DEFAULT NULL,
  `claim_status` varchar(30) NOT NULL DEFAULT 'Claimed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `distribution_programs`
--

CREATE TABLE `distribution_programs` (
  `distribution_id` int(11) NOT NULL,
  `program_name` varchar(150) NOT NULL,
  `distribution_type` varchar(80) NOT NULL,
  `funding_source` varchar(150) NOT NULL,
  `distribution_date` date NOT NULL,
  `eligibility_criteria` text DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `program_status` varchar(30) NOT NULL DEFAULT 'Planned'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `government_programs`
--

CREATE TABLE `government_programs` (
  `program_id` int(11) NOT NULL,
  `program_name` varchar(150) NOT NULL,
  `agency_name` varchar(150) NOT NULL,
  `program_type` varchar(80) NOT NULL,
  `description` text DEFAULT NULL,
  `eligibility_criteria` text DEFAULT NULL,
  `program_status` varchar(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `healthcare_personnel`
--

CREATE TABLE `healthcare_personnel` (
  `personnel_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `professional_title` varchar(100) DEFAULT NULL,
  `license_number` varchar(80) DEFAULT NULL,
  `position` varchar(100) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `personnel_status` varchar(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `health_visits`
--

CREATE TABLE `health_visits` (
  `visit_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `visit_date` date NOT NULL,
  `visit_time` time NOT NULL,
  `visit_type` varchar(50) NOT NULL,
  `chief_complaint` text DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `treatment_given` text DEFAULT NULL,
  `next_visit_date` date DEFAULT NULL,
  `attending_personnel_id` int(11) NOT NULL,
  `assisting_personnel_id` int(11) DEFAULT NULL,
  `recorded_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `households`
--

CREATE TABLE `households` (
  `household_id` int(11) NOT NULL,
  `household_number` varchar(30) NOT NULL,
  `household_name` varchar(150) NOT NULL,
  `household_head_member_id` int(11) DEFAULT NULL,
  `household_type` varchar(30) NOT NULL DEFAULT 'Regular',
  `primary_contact_number` varchar(20) DEFAULT NULL,
  `alternate_contact_number` varchar(20) DEFAULT NULL,
  `email_address` varchar(150) DEFAULT NULL,
  `house_number` varchar(50) DEFAULT NULL,
  `street` varchar(150) DEFAULT NULL,
  `purok_sitio` varchar(100) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `municipality` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `total_members` int(11) NOT NULL DEFAULT 0,
  `total_children` int(11) NOT NULL DEFAULT 0,
  `total_adults` int(11) NOT NULL DEFAULT 0,
  `total_senior_citizens` int(11) NOT NULL DEFAULT 0,
  `application_date` date NOT NULL,
  `application_status` varchar(30) NOT NULL DEFAULT 'Pending',
  `approved_by` int(11) DEFAULT NULL,
  `approval_date` datetime DEFAULT NULL,
  `household_status` varchar(30) NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `household_allocations`
--

CREATE TABLE `household_allocations` (
  `allocation_id` int(11) NOT NULL,
  `distribution_id` int(11) NOT NULL,
  `household_id` int(11) NOT NULL,
  `claim_number` varchar(50) NOT NULL,
  `eligibility_status` varchar(30) NOT NULL DEFAULT 'Pending',
  `allocation_date` date NOT NULL,
  `allocation_status` varchar(30) NOT NULL DEFAULT 'Allocated'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `household_members`
--

CREATE TABLE `household_members` (
  `member_id` int(11) NOT NULL,
  `household_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `relationship_to_head` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  `sex` varchar(20) NOT NULL,
  `civil_status` varchar(30) DEFAULT NULL,
  `employment_status` varchar(50) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `monthly_income` decimal(12,2) DEFAULT NULL,
  `education_status` varchar(40) DEFAULT NULL,
  `educational_level` varchar(100) DEFAULT NULL,
  `school_name` varchar(150) DEFAULT NULL,
  `disability_status` varchar(30) NOT NULL DEFAULT 'No',
  `senior_citizen_status` tinyint(1) NOT NULL DEFAULT 0,
  `member_status` varchar(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `household_program_memberships`
--

CREATE TABLE `household_program_memberships` (
  `membership_id` int(11) NOT NULL,
  `household_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `enrollment_date` date NOT NULL,
  `beneficiary_reference_number` varchar(100) DEFAULT NULL,
  `verification_status` varchar(30) NOT NULL DEFAULT 'Pending',
  `membership_status` varchar(30) NOT NULL DEFAULT 'Active',
  `verified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `immunization_preregistrations`
--

CREATE TABLE `immunization_preregistrations` (
  `pre_registration_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `vaccine_id` int(11) NOT NULL,
  `dose_number` int(11) NOT NULL,
  `expected_date` date NOT NULL,
  `registration_timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `registration_status` varchar(30) NOT NULL DEFAULT 'Registered',
  `arrival_confirmed_at` datetime DEFAULT NULL,
  `daily_visit_number` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `immunization_queue`
--

CREATE TABLE `immunization_queue` (
  `queue_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `schedule_id` int(11) DEFAULT NULL,
  `registration_type` varchar(30) NOT NULL,
  `registration_timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `roll_call_status` varchar(30) NOT NULL DEFAULT 'Pending',
  `roll_call_timestamp` datetime DEFAULT NULL,
  `queue_number` int(11) DEFAULT NULL,
  `arrival_timestamp` datetime DEFAULT NULL,
  `service_start_timestamp` datetime DEFAULT NULL,
  `service_end_timestamp` datetime DEFAULT NULL,
  `queue_status` varchar(30) NOT NULL DEFAULT 'Registered'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `immunization_records`
--

CREATE TABLE `immunization_records` (
  `immunization_id` bigint(20) NOT NULL,
  `visit_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `vaccine_id` int(11) NOT NULL,
  `vaccine_batch_id` int(11) NOT NULL,
  `dose_number` int(11) NOT NULL,
  `vaccination_date` date NOT NULL,
  `vaccination_time` time NOT NULL,
  `administered_by` int(11) NOT NULL,
  `assisted_by` int(11) DEFAULT NULL,
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `immunization_schedules`
--

CREATE TABLE `immunization_schedules` (
  `schedule_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `vaccine_id` int(11) NOT NULL,
  `scheduled_date` date NOT NULL,
  `scheduled_time` time DEFAULT NULL,
  `schedule_status` varchar(30) NOT NULL DEFAULT 'Scheduled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicines`
--

CREATE TABLE `medicines` (
  `medicine_id` int(11) NOT NULL,
  `medicine_name` varchar(150) NOT NULL,
  `medicine_type` varchar(60) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `dosage_form` varchar(60) NOT NULL,
  `strength` decimal(10,3) DEFAULT NULL,
  `volume_ml` decimal(10,3) DEFAULT NULL,
  `unit_of_measure` varchar(30) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicine_batches`
--

CREATE TABLE `medicine_batches` (
  `batch_id` int(11) NOT NULL,
  `medicine_id` int(11) NOT NULL,
  `batch_number` varchar(100) NOT NULL,
  `manufacture_date` date NOT NULL,
  `expiration_date` date NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `quantity_delivered` decimal(12,3) NOT NULL,
  `quantity_remaining` decimal(12,3) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicine_inventory`
--

CREATE TABLE `medicine_inventory` (
  `inventory_id` int(11) NOT NULL,
  `medicine_id` int(11) NOT NULL,
  `total_quantity` decimal(12,3) NOT NULL DEFAULT 0.000,
  `available_quantity` decimal(12,3) NOT NULL DEFAULT 0.000,
  `reserved_quantity` decimal(12,3) NOT NULL DEFAULT 0.000,
  `reorder_level` decimal(12,3) NOT NULL DEFAULT 0.000,
  `last_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicine_requests`
--

CREATE TABLE `medicine_requests` (
  `request_id` int(11) NOT NULL,
  `requested_by` int(11) NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `request_date` datetime NOT NULL DEFAULT current_timestamp(),
  `approval_date` datetime DEFAULT NULL,
  `approval_status` varchar(30) NOT NULL DEFAULT 'Pending',
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  `notification_message` text NOT NULL,
  `notification_timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `read_status` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `report_type` varchar(80) NOT NULL,
  `report_description` text DEFAULT NULL,
  `generated_timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff_attendance`
--

CREATE TABLE `staff_attendance` (
  `attendance_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `duty_date` date NOT NULL,
  `shift` varchar(50) NOT NULL,
  `time_in` time DEFAULT NULL,
  `time_out` time DEFAULT NULL,
  `attendance_status` varchar(30) NOT NULL,
  `remarks` text DEFAULT NULL,
  `recorded_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_transactions`
--

CREATE TABLE `stock_transactions` (
  `transaction_id` bigint(20) NOT NULL,
  `batch_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `transaction_type` varchar(30) NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `transaction_timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `remarks` text DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `supplier_name` varchar(150) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `email_address` varchar(150) DEFAULT NULL,
  `address` text NOT NULL,
  `supplier_status` varchar(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supplier_contacts`
--

CREATE TABLE `supplier_contacts` (
  `contact_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `contact_type` varchar(30) NOT NULL DEFAULT 'Primary',
  `contact_person` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supplier_locations`
--

CREATE TABLE `supplier_locations` (
  `supplier_location_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `office_name` varchar(150) DEFAULT NULL,
  `warehouse_name` varchar(150) DEFAULT NULL,
  `address` text NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `alternate_contact` varchar(20) DEFAULT NULL,
  `email_address` varchar(150) DEFAULT NULL,
  `account_status` varchar(20) NOT NULL DEFAULT 'Active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vaccines`
--

CREATE TABLE `vaccines` (
  `vaccine_id` int(11) NOT NULL,
  `vaccine_name` varchar(150) NOT NULL,
  `vaccine_type` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `recommended_age` varchar(100) DEFAULT NULL,
  `dosage_volume_ml` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vaccine_batches`
--

CREATE TABLE `vaccine_batches` (
  `vaccine_batch_id` int(11) NOT NULL,
  `vaccine_id` int(11) NOT NULL,
  `batch_number` varchar(100) NOT NULL,
  `manufacture_date` date NOT NULL,
  `expiration_date` date NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `quantity_received` decimal(12,3) NOT NULL,
  `quantity_remaining` decimal(12,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assistance_records`
--
ALTER TABLE `assistance_records`
  ADD PRIMARY KEY (`assistance_id`),
  ADD KEY `fk_assistance_records_household_id_45` (`household_id`),
  ADD KEY `fk_assistance_records_member_id_46` (`member_id`),
  ADD KEY `fk_assistance_records_program_id_47` (`program_id`),
  ADD KEY `fk_assistance_records_approved_by_48` (`approved_by`),
  ADD KEY `fk_assistance_records_recorded_by_49` (`recorded_by`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`audit_id`),
  ADD UNIQUE KEY `uq_audit_logs_1` (`transaction_id`),
  ADD KEY `idx_audit_user_timestamp` (`user_id`,`action_timestamp`),
  ADD KEY `fk_audit_logs_admin_id_58` (`admin_id`);

--
-- Indexes for table `deliveries`
--
ALTER TABLE `deliveries`
  ADD PRIMARY KEY (`delivery_id`),
  ADD KEY `fk_deliveries_request_id_16` (`request_id`),
  ADD KEY `fk_deliveries_supplier_location_id_17` (`supplier_location_id`),
  ADD KEY `fk_deliveries_sent_by_18` (`sent_by`),
  ADD KEY `fk_deliveries_received_by_19` (`received_by`),
  ADD KEY `fk_deliveries_recorded_by_20` (`recorded_by`);

--
-- Indexes for table `delivery_items`
--
ALTER TABLE `delivery_items`
  ADD PRIMARY KEY (`delivery_item_id`),
  ADD KEY `fk_delivery_items_delivery_id_21` (`delivery_id`),
  ADD KEY `fk_delivery_items_batch_id_22` (`batch_id`);

--
-- Indexes for table `distribution_claims`
--
ALTER TABLE `distribution_claims`
  ADD PRIMARY KEY (`claim_id`),
  ADD UNIQUE KEY `uq_distribution_claims_1` (`claim_number`),
  ADD KEY `fk_distribution_claims_allocation_id_53` (`allocation_id`),
  ADD KEY `fk_distribution_claims_released_by_54` (`released_by`);

--
-- Indexes for table `distribution_programs`
--
ALTER TABLE `distribution_programs`
  ADD PRIMARY KEY (`distribution_id`),
  ADD KEY `fk_distribution_programs_approved_by_50` (`approved_by`);

--
-- Indexes for table `government_programs`
--
ALTER TABLE `government_programs`
  ADD PRIMARY KEY (`program_id`);

--
-- Indexes for table `healthcare_personnel`
--
ALTER TABLE `healthcare_personnel`
  ADD PRIMARY KEY (`personnel_id`);

--
-- Indexes for table `health_visits`
--
ALTER TABLE `health_visits`
  ADD PRIMARY KEY (`visit_id`),
  ADD KEY `fk_health_visits_member_id_23` (`member_id`),
  ADD KEY `fk_health_visits_attending_personnel_id_24` (`attending_personnel_id`),
  ADD KEY `fk_health_visits_assisting_personnel_id_25` (`assisting_personnel_id`),
  ADD KEY `fk_health_visits_recorded_by_26` (`recorded_by`);

--
-- Indexes for table `households`
--
ALTER TABLE `households`
  ADD PRIMARY KEY (`household_id`),
  ADD UNIQUE KEY `uq_households_1` (`household_number`),
  ADD KEY `fk_households_household_head_member_id_2` (`household_head_member_id`),
  ADD KEY `fk_households_approved_by_3` (`approved_by`);

--
-- Indexes for table `household_allocations`
--
ALTER TABLE `household_allocations`
  ADD PRIMARY KEY (`allocation_id`),
  ADD UNIQUE KEY `uq_household_allocations_1` (`claim_number`),
  ADD KEY `fk_household_allocations_distribution_id_51` (`distribution_id`),
  ADD KEY `fk_household_allocations_household_id_52` (`household_id`);

--
-- Indexes for table `household_members`
--
ALTER TABLE `household_members`
  ADD PRIMARY KEY (`member_id`),
  ADD KEY `idx_members_household_name` (`household_id`,`last_name`,`first_name`);

--
-- Indexes for table `household_program_memberships`
--
ALTER TABLE `household_program_memberships`
  ADD PRIMARY KEY (`membership_id`),
  ADD KEY `fk_household_program_memberships_household_id_42` (`household_id`),
  ADD KEY `fk_household_program_memberships_program_id_43` (`program_id`),
  ADD KEY `fk_household_program_memberships_verified_by_44` (`verified_by`);

--
-- Indexes for table `immunization_preregistrations`
--
ALTER TABLE `immunization_preregistrations`
  ADD PRIMARY KEY (`pre_registration_id`),
  ADD KEY `idx_prereg_expected_date` (`expected_date`,`registration_status`),
  ADD KEY `fk_immunization_preregistrations_member_id_39` (`member_id`),
  ADD KEY `fk_immunization_preregistrations_schedule_id_40` (`schedule_id`),
  ADD KEY `fk_immunization_preregistrations_vaccine_id_41` (`vaccine_id`);

--
-- Indexes for table `immunization_queue`
--
ALTER TABLE `immunization_queue`
  ADD PRIMARY KEY (`queue_id`),
  ADD KEY `fk_immunization_queue_member_id_37` (`member_id`),
  ADD KEY `fk_immunization_queue_schedule_id_38` (`schedule_id`);

--
-- Indexes for table `immunization_records`
--
ALTER TABLE `immunization_records`
  ADD PRIMARY KEY (`immunization_id`),
  ADD KEY `idx_immunization_member_date` (`member_id`,`vaccination_date`),
  ADD KEY `fk_immunization_records_visit_id_29` (`visit_id`),
  ADD KEY `fk_immunization_records_vaccine_id_31` (`vaccine_id`),
  ADD KEY `fk_immunization_records_vaccine_batch_id_32` (`vaccine_batch_id`),
  ADD KEY `fk_immunization_records_administered_by_33` (`administered_by`),
  ADD KEY `fk_immunization_records_assisted_by_34` (`assisted_by`);

--
-- Indexes for table `immunization_schedules`
--
ALTER TABLE `immunization_schedules`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `fk_immunization_schedules_member_id_35` (`member_id`),
  ADD KEY `fk_immunization_schedules_vaccine_id_36` (`vaccine_id`);

--
-- Indexes for table `medicines`
--
ALTER TABLE `medicines`
  ADD PRIMARY KEY (`medicine_id`);

--
-- Indexes for table `medicine_batches`
--
ALTER TABLE `medicine_batches`
  ADD PRIMARY KEY (`batch_id`),
  ADD UNIQUE KEY `uq_medicine_batches_1` (`medicine_id`,`batch_number`),
  ADD KEY `idx_medicine_fifo` (`medicine_id`,`expiration_date`,`batch_id`),
  ADD KEY `fk_medicine_batches_delivery_id_6` (`delivery_id`),
  ADD KEY `fk_medicine_batches_created_by_7` (`created_by`);

--
-- Indexes for table `medicine_inventory`
--
ALTER TABLE `medicine_inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD UNIQUE KEY `uq_medicine_inventory_1` (`medicine_id`);

--
-- Indexes for table `medicine_requests`
--
ALTER TABLE `medicine_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `fk_medicine_requests_requested_by_14` (`requested_by`),
  ADD KEY `fk_medicine_requests_approved_by_15` (`approved_by`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `fk_notifications_user_id_55` (`user_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `fk_reports_user_id_56` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `uq_roles_1` (`role_name`);

--
-- Indexes for table `staff_attendance`
--
ALTER TABLE `staff_attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD KEY `fk_staff_attendance_user_id_59` (`user_id`),
  ADD KEY `fk_staff_attendance_recorded_by_60` (`recorded_by`);

--
-- Indexes for table `stock_transactions`
--
ALTER TABLE `stock_transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `idx_stock_batch_date` (`batch_id`,`transaction_timestamp`),
  ADD KEY `fk_stock_transactions_user_id_10` (`user_id`),
  ADD KEY `fk_stock_transactions_admin_id_11` (`admin_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `supplier_contacts`
--
ALTER TABLE `supplier_contacts`
  ADD PRIMARY KEY (`contact_id`),
  ADD KEY `fk_supplier_contacts_supplier_id_12` (`supplier_id`);

--
-- Indexes for table `supplier_locations`
--
ALTER TABLE `supplier_locations`
  ADD PRIMARY KEY (`supplier_location_id`),
  ADD KEY `fk_supplier_locations_supplier_id_13` (`supplier_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uq_users_1` (`username`),
  ADD KEY `fk_users_role_id_1` (`role_id`);

--
-- Indexes for table `vaccines`
--
ALTER TABLE `vaccines`
  ADD PRIMARY KEY (`vaccine_id`);

--
-- Indexes for table `vaccine_batches`
--
ALTER TABLE `vaccine_batches`
  ADD PRIMARY KEY (`vaccine_batch_id`),
  ADD UNIQUE KEY `uq_vaccine_batches_1` (`vaccine_id`,`batch_number`),
  ADD KEY `fk_vaccine_batches_delivery_id_28` (`delivery_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assistance_records`
--
ALTER TABLE `assistance_records`
  MODIFY `assistance_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `audit_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deliveries`
--
ALTER TABLE `deliveries`
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `delivery_items`
--
ALTER TABLE `delivery_items`
  MODIFY `delivery_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `distribution_claims`
--
ALTER TABLE `distribution_claims`
  MODIFY `claim_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `distribution_programs`
--
ALTER TABLE `distribution_programs`
  MODIFY `distribution_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `government_programs`
--
ALTER TABLE `government_programs`
  MODIFY `program_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `healthcare_personnel`
--
ALTER TABLE `healthcare_personnel`
  MODIFY `personnel_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `health_visits`
--
ALTER TABLE `health_visits`
  MODIFY `visit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `households`
--
ALTER TABLE `households`
  MODIFY `household_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `household_allocations`
--
ALTER TABLE `household_allocations`
  MODIFY `allocation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `household_members`
--
ALTER TABLE `household_members`
  MODIFY `member_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `household_program_memberships`
--
ALTER TABLE `household_program_memberships`
  MODIFY `membership_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `immunization_preregistrations`
--
ALTER TABLE `immunization_preregistrations`
  MODIFY `pre_registration_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `immunization_queue`
--
ALTER TABLE `immunization_queue`
  MODIFY `queue_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `immunization_records`
--
ALTER TABLE `immunization_records`
  MODIFY `immunization_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `immunization_schedules`
--
ALTER TABLE `immunization_schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicines`
--
ALTER TABLE `medicines`
  MODIFY `medicine_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicine_batches`
--
ALTER TABLE `medicine_batches`
  MODIFY `batch_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicine_inventory`
--
ALTER TABLE `medicine_inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicine_requests`
--
ALTER TABLE `medicine_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff_attendance`
--
ALTER TABLE `staff_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_transactions`
--
ALTER TABLE `stock_transactions`
  MODIFY `transaction_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier_contacts`
--
ALTER TABLE `supplier_contacts`
  MODIFY `contact_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier_locations`
--
ALTER TABLE `supplier_locations`
  MODIFY `supplier_location_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vaccines`
--
ALTER TABLE `vaccines`
  MODIFY `vaccine_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vaccine_batches`
--
ALTER TABLE `vaccine_batches`
  MODIFY `vaccine_batch_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assistance_records`
--
ALTER TABLE `assistance_records`
  ADD CONSTRAINT `fk_assistance_records_approved_by_48` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assistance_records_household_id_45` FOREIGN KEY (`household_id`) REFERENCES `households` (`household_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assistance_records_member_id_46` FOREIGN KEY (`member_id`) REFERENCES `household_members` (`member_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assistance_records_program_id_47` FOREIGN KEY (`program_id`) REFERENCES `government_programs` (`program_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assistance_records_recorded_by_49` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_logs_admin_id_58` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_audit_logs_user_id_57` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `deliveries`
--
ALTER TABLE `deliveries`
  ADD CONSTRAINT `fk_deliveries_received_by_19` FOREIGN KEY (`received_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_deliveries_recorded_by_20` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_deliveries_request_id_16` FOREIGN KEY (`request_id`) REFERENCES `medicine_requests` (`request_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_deliveries_sent_by_18` FOREIGN KEY (`sent_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_deliveries_supplier_location_id_17` FOREIGN KEY (`supplier_location_id`) REFERENCES `supplier_locations` (`supplier_location_id`) ON UPDATE CASCADE;

--
-- Constraints for table `delivery_items`
--
ALTER TABLE `delivery_items`
  ADD CONSTRAINT `fk_delivery_items_batch_id_22` FOREIGN KEY (`batch_id`) REFERENCES `medicine_batches` (`batch_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_delivery_items_delivery_id_21` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`delivery_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `distribution_claims`
--
ALTER TABLE `distribution_claims`
  ADD CONSTRAINT `fk_distribution_claims_allocation_id_53` FOREIGN KEY (`allocation_id`) REFERENCES `household_allocations` (`allocation_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_distribution_claims_released_by_54` FOREIGN KEY (`released_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `distribution_programs`
--
ALTER TABLE `distribution_programs`
  ADD CONSTRAINT `fk_distribution_programs_approved_by_50` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `health_visits`
--
ALTER TABLE `health_visits`
  ADD CONSTRAINT `fk_health_visits_assisting_personnel_id_25` FOREIGN KEY (`assisting_personnel_id`) REFERENCES `healthcare_personnel` (`personnel_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_health_visits_attending_personnel_id_24` FOREIGN KEY (`attending_personnel_id`) REFERENCES `healthcare_personnel` (`personnel_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_health_visits_member_id_23` FOREIGN KEY (`member_id`) REFERENCES `household_members` (`member_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_health_visits_recorded_by_26` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `households`
--
ALTER TABLE `households`
  ADD CONSTRAINT `fk_households_approved_by_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_households_household_head_member_id_2` FOREIGN KEY (`household_head_member_id`) REFERENCES `household_members` (`member_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `household_allocations`
--
ALTER TABLE `household_allocations`
  ADD CONSTRAINT `fk_household_allocations_distribution_id_51` FOREIGN KEY (`distribution_id`) REFERENCES `distribution_programs` (`distribution_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_household_allocations_household_id_52` FOREIGN KEY (`household_id`) REFERENCES `households` (`household_id`) ON UPDATE CASCADE;

--
-- Constraints for table `household_members`
--
ALTER TABLE `household_members`
  ADD CONSTRAINT `fk_household_members_household_id_4` FOREIGN KEY (`household_id`) REFERENCES `households` (`household_id`) ON UPDATE CASCADE;

--
-- Constraints for table `household_program_memberships`
--
ALTER TABLE `household_program_memberships`
  ADD CONSTRAINT `fk_household_program_memberships_household_id_42` FOREIGN KEY (`household_id`) REFERENCES `households` (`household_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_household_program_memberships_program_id_43` FOREIGN KEY (`program_id`) REFERENCES `government_programs` (`program_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_household_program_memberships_verified_by_44` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `immunization_preregistrations`
--
ALTER TABLE `immunization_preregistrations`
  ADD CONSTRAINT `fk_immunization_preregistrations_member_id_39` FOREIGN KEY (`member_id`) REFERENCES `household_members` (`member_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_preregistrations_schedule_id_40` FOREIGN KEY (`schedule_id`) REFERENCES `immunization_schedules` (`schedule_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_preregistrations_vaccine_id_41` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`vaccine_id`) ON UPDATE CASCADE;

--
-- Constraints for table `immunization_queue`
--
ALTER TABLE `immunization_queue`
  ADD CONSTRAINT `fk_immunization_queue_member_id_37` FOREIGN KEY (`member_id`) REFERENCES `household_members` (`member_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_queue_schedule_id_38` FOREIGN KEY (`schedule_id`) REFERENCES `immunization_schedules` (`schedule_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `immunization_records`
--
ALTER TABLE `immunization_records`
  ADD CONSTRAINT `fk_immunization_records_administered_by_33` FOREIGN KEY (`administered_by`) REFERENCES `healthcare_personnel` (`personnel_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_records_assisted_by_34` FOREIGN KEY (`assisted_by`) REFERENCES `healthcare_personnel` (`personnel_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_records_member_id_30` FOREIGN KEY (`member_id`) REFERENCES `household_members` (`member_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_records_vaccine_batch_id_32` FOREIGN KEY (`vaccine_batch_id`) REFERENCES `vaccine_batches` (`vaccine_batch_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_records_vaccine_id_31` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`vaccine_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_records_visit_id_29` FOREIGN KEY (`visit_id`) REFERENCES `health_visits` (`visit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `immunization_schedules`
--
ALTER TABLE `immunization_schedules`
  ADD CONSTRAINT `fk_immunization_schedules_member_id_35` FOREIGN KEY (`member_id`) REFERENCES `household_members` (`member_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_immunization_schedules_vaccine_id_36` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`vaccine_id`) ON UPDATE CASCADE;

--
-- Constraints for table `medicine_batches`
--
ALTER TABLE `medicine_batches`
  ADD CONSTRAINT `fk_medicine_batches_created_by_7` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_medicine_batches_delivery_id_6` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`delivery_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_medicine_batches_medicine_id_5` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`medicine_id`) ON UPDATE CASCADE;

--
-- Constraints for table `medicine_inventory`
--
ALTER TABLE `medicine_inventory`
  ADD CONSTRAINT `fk_medicine_inventory_medicine_id_8` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`medicine_id`) ON UPDATE CASCADE;

--
-- Constraints for table `medicine_requests`
--
ALTER TABLE `medicine_requests`
  ADD CONSTRAINT `fk_medicine_requests_approved_by_15` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_medicine_requests_requested_by_14` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user_id_55` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `fk_reports_user_id_56` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `staff_attendance`
--
ALTER TABLE `staff_attendance`
  ADD CONSTRAINT `fk_staff_attendance_recorded_by_60` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_attendance_user_id_59` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `stock_transactions`
--
ALTER TABLE `stock_transactions`
  ADD CONSTRAINT `fk_stock_transactions_admin_id_11` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_transactions_batch_id_9` FOREIGN KEY (`batch_id`) REFERENCES `medicine_batches` (`batch_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_transactions_user_id_10` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `supplier_contacts`
--
ALTER TABLE `supplier_contacts`
  ADD CONSTRAINT `fk_supplier_contacts_supplier_id_12` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `supplier_locations`
--
ALTER TABLE `supplier_locations`
  ADD CONSTRAINT `fk_supplier_locations_supplier_id_13` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role_id_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;

--
-- Constraints for table `vaccine_batches`
--
ALTER TABLE `vaccine_batches`
  ADD CONSTRAINT `fk_vaccine_batches_delivery_id_28` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`delivery_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vaccine_batches_vaccine_id_27` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccines` (`vaccine_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
