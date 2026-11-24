-- ============================================================================
-- Barangay Health Center Management System (BHDM)
-- Demo Seed Script: seed_sample_data.sql
-- Safe to re-run (uses INSERT IGNORE and dynamic role_id lookups)
-- Matches barangay_health_center_db (3).sql exact schema & FK constraints
-- ============================================================================

USE `barangay_health_center_db`;

START TRANSACTION;

-- ----------------------------------------------------------------------------
-- 1. roles (10 roles — preserves existing seeded roles)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `roles` (`role_name`, `description`) VALUES
('Admin', 'Full system administrator access'),
('Nurse', 'Barangay health center registered nurse'),
('Midwife', 'Barangay health center midwife'),
('BHW', 'Barangay Health Worker'),
('Pharmacist', 'Medicine inventory and dispensing pharmacist'),
('Doctor', 'Barangay health center physician'),
('Barangay Captain', 'Punong Barangay oversight and approvals'),
('Sanitary Inspector', 'Environmental sanitation and hygiene officer'),
('Nutrition Scholar', 'Barangay Nutrition Scholar (BNS)'),
('Encoder', 'Health records and data entry clerk');

SET @role_admin      = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'Admin' LIMIT 1);
SET @role_nurse      = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'Nurse' LIMIT 1);
SET @role_midwife    = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'Midwife' LIMIT 1);
SET @role_bhw        = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'BHW' LIMIT 1);
SET @role_pharmacist = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'Pharmacist' LIMIT 1);
SET @role_doctor     = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'Doctor' LIMIT 1);
SET @role_encoder    = (SELECT `role_id` FROM `roles` WHERE `role_name` = 'Encoder' LIMIT 1);

-- ----------------------------------------------------------------------------
-- 2. users (preserves existing admin user_id=1; adds 10 demo staff accounts)
-- Default demo password hash is BCrypt for "admin123"
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `users`
(`user_id`, `role_id`, `username`, `password_hash`, `first_name`, `middle_name`, `last_name`, `contact_number`, `alternate_contact`, `email_address`, `account_status`) VALUES
(1,  @role_admin,      'admin',         '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'System',     NULL,        'Administrator', '09171000001', NULL,          'admin@bhdm.local',       'Active'),
(2,  @role_nurse,      'nurse.maria',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Maria',      'Santos',    'Reyes',         '09171234501', '09281234501', 'maria.reyes@bhdm.local', 'Active'),
(3,  @role_midwife,    'midwife.elena', '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Elena',      'Cruz',      'Bautista',      '09171234502', NULL,          'elena.bautista@bhdm.local', 'Active'),
(4,  @role_bhw,        'bhw.rosario',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Rosario',    'Mendoza',   'Villanueva',    '09171234503', NULL,          'rosario.v@bhdm.local',   'Active'),
(5,  @role_pharmacist, 'pharm.carlo',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Carlo',      'Dizon',     'Aquino',        '09171234504', NULL,          'carlo.aquino@bhdm.local','Active'),
(6,  @role_doctor,     'dr.ramon',      '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Ramon',      'Garcia',    'Dela Cruz',     '09171234505', '09991234505', 'ramon.dc@bhdm.local',    'Active'),
(7,  @role_nurse,      'nurse.paolo',   '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Paolo',      'Lim',       'Soriano',       '09171234506', NULL,          'paolo.soriano@bhdm.local','Active'),
(8,  @role_bhw,        'bhw.liza',      '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Liza',       'Torres',    'Navarro',       '09171234507', NULL,          'liza.navarro@bhdm.local','Active'),
(9,  @role_midwife,    'midwife.grace', '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Grace',      'Ocampo',    'Fernandez',     '09171234508', NULL,          'grace.f@bhdm.local',     'Active'),
(10, @role_encoder,    'enc.mark',      '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Mark',       'Ramos',     'Castillo',      '09171234509', NULL,          'mark.castillo@bhdm.local','Active'),
(11, @role_bhw,        'bhw.teresa',    '$2a$10$7EqJtq98hPqEX7fNZaFWoOhi5E2iJ3bB0n0s5P5e6fF0H8nH1zQ2K', 'Teresa',     'Flores',    'Salazar',       '09171234510', NULL,          'teresa.s@bhdm.local',    'Active');

-- ----------------------------------------------------------------------------
-- 3. healthcare_personnel (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `healthcare_personnel`
(`personnel_id`, `first_name`, `middle_name`, `last_name`, `professional_title`, `license_number`, `position`, `contact_number`, `personnel_status`) VALUES
(1,  'Ramon',   'Garcia',   'Dela Cruz',  'MD',  'PRC-MD-010245', 'Rural Health Physician',    '09171234505', 'Active'),
(2,  'Maria',   'Santos',   'Reyes',      'RN',  'PRC-RN-045821', 'Public Health Nurse II',    '09171234501', 'Active'),
(3,  'Elena',   'Cruz',     'Bautista',   'RM',  'PRC-RM-031190', 'Rural Health Midwife II',   '09171234502', 'Active'),
(4,  'Carlo',   'Dizon',    'Aquino',     'RPh', 'PRC-RP-022844', 'Barangay Pharmacist',       '09171234504', 'Active'),
(5,  'Paolo',   'Lim',      'Soriano',    'RN',  'PRC-RN-058912', 'Public Health Nurse I',     '09171234506', 'Active'),
(6,  'Grace',   'Ocampo',   'Fernandez',  'RM',  'PRC-RM-039402', 'Rural Health Midwife I',    '09171234508', 'Active'),
(7,  'Rosario', 'Mendoza',  'Villanueva', 'BHW', NULL,            'Senior Barangay Health Worker', '09171234503', 'Active'),
(8,  'Liza',    'Torres',   'Navarro',    'BHW', NULL,            'Barangay Health Worker',    '09171234507', 'Active'),
(9,  'Teresa',  'Flores',   'Salazar',    'BNS', NULL,            'Barangay Nutrition Scholar','09171234510', 'Active'),
(10, 'Danilo',  'Vega',     'Pascual',    'RMT', 'PRC-MT-019330', 'Medical Technologist',      '09171234511', 'Active');

-- ----------------------------------------------------------------------------
-- 4. vaccines (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `vaccines`
(`vaccine_id`, `vaccine_name`, `vaccine_type`, `description`, `recommended_age`, `dosage_volume_ml`) VALUES
(1,  'BCG Vaccine',                 'Live Attenuated', 'Protects infants against severe tuberculosis.',           'At birth',                 0.050),
(2,  'Hepatitis B Vaccine',         'Recombinant',     'Prevents Hepatitis B viral infection.',                   'At birth',                 0.500),
(3,  'Pentavalent (DPT-HepB-Hib)',  'Combination',     'Protects against diphtheria, pertussis, tetanus, HepB, Hib.','6, 10, 14 weeks',       0.500),
(4,  'Oral Polio Vaccine (OPV)',    'Live Attenuated', 'Oral vaccine preventing poliomyelitis.',                  '6, 10, 14 weeks',          0.100),
(5,  'Inactivated Polio (IPV)',     'Inactivated',     'Injectable polio booster vaccine.',                       '14 weeks and 9 months',    0.500),
(6,  'Pneumococcal Conjugate (PCV13)','Conjugate',     'Prevents pneumococcal pneumonia and meningitis.',         '6, 10, 14 weeks',          0.500),
(7,  'MMR Vaccine',                 'Live Attenuated', 'Protects against measles, mumps, and rubella.',           '9 and 12 months',          0.500),
(8,  'Anti-Rabies Vaccine (PVRV)',  'Inactivated',     'Post-exposure prophylaxis for animal bites.',             'All ages (as needed)',     0.500),
(9,  'Quadrivalent Influenza (Flu)','Inactivated',     'Seasonal flu protection for seniors and high-risk adults.','6 months and above',      0.500),
(10, 'Tetanus Toxoid (TT)',         'Toxoid',          'Maternal and wound tetanus immunization.',                'Pregnant women / Adults',  0.500);

-- ----------------------------------------------------------------------------
-- 5. medicines (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `medicines`
(`medicine_id`, `medicine_name`, `medicine_type`, `brand`, `dosage_form`, `strength`, `volume_ml`, `unit_of_measure`, `description`) VALUES
(1,  'Paracetamol 500mg',         'Analgesic / Antipyretic', 'Biogesic / Generic', 'Tablet',      500.000, NULL,    'tablet', 'Relief of fever and mild to moderate pain.'),
(2,  'Amoxicillin 500mg',         'Antibiotic',              'Amoxil / Generic',   'Capsule',     500.000, NULL,    'capsule','Broad-spectrum penicillin antibiotic for bacterial infections.'),
(3,  'Losartan 50mg',             'Antihypertensive',        'Lifezar / Generic',  'Tablet',       50.000, NULL,    'tablet', 'Angiotensin II receptor blocker for hypertension maintenance.'),
(4,  'Metformin 500mg',           'Antidiabetic',            'Glucophage / Generic','Tablet',     500.000, NULL,    'tablet', 'First-line oral maintenance medication for Type 2 diabetes.'),
(5,  'Amlodipine 5mg',            'Antihypertensive',        'Norvasc / Generic',  'Tablet',        5.000, NULL,    'tablet', 'Calcium channel blocker for blood pressure control.'),
(6,  'Salbutamol 2mg/5mL Syrup',  'Bronchodilator',          'Ventolin / Generic', 'Syrup',         2.000, 60.000,  'bottle', 'Relief of bronchospasm in asthma and COPD.'),
(7,  'Cetirizine 10mg',           'Antihistamine',           'Alnix / Generic',    'Tablet',       10.000, NULL,    'tablet', 'Non-drowsy relief for allergic rhinitis and urticaria.'),
(8,  'Oral Rehydration Salts',    'Electrolyte Replacement', 'Hydrite / DOH ORS',  'Sachet',       20.500, NULL,    'sachet', 'Prevents dehydration from acute diarrhea.'),
(9,  'Ferrous Sulfate + Folic Acid','Hematinic Supplement',  'DOH Maternal Iron',  'Tablet',       60.000, NULL,    'tablet', 'Prenatal iron and folic acid supplementation.'),
(10, 'Mefenamic Acid 500mg',      'NSAID',                   'Dolfenal / Generic', 'Capsule',     500.000, NULL,    'capsule','Short-term relief of acute pain and dysmenorrhea.');

-- ----------------------------------------------------------------------------
-- 6. suppliers (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `suppliers`
(`supplier_id`, `supplier_name`, `contact_person`, `email_address`, `address`, `supplier_status`) VALUES
(1,  'DOH Regional Logistics Hub',     'Engr. Joel Mercado',   'logistics@doh-r4a.gov.ph',   'QMMC Compound, Quezon City, Metro Manila', 'Active'),
(2,  'Unilab Public Health Division',  'Maricel Tan',          'publichealth@unilab.com.ph', '66 United St., Mandaluyong City',          'Active'),
(3,  'Zuellig Pharma Philippines',     'Arthur Villanueva',    'orders@zuelligpharma.ph',    'Km 14 West Service Rd., Paranaque City',   'Active'),
(4,  'Metro Drug Municipal Supply',    'Lorna Panganiban',     'sales@metrodrug.com.ph',     'Mañalac Ave., Taguig City',                'Active'),
(5,  'Provincial Health Office Depot', 'Dr. Clarissa Mendoza', 'depot@pho-cavite.gov.ph',    'Trece Martires City, Cavite',              'Active'),
(6,  'RiteMED LGU Distribution',       'Dennis Alcantara',     'lgu@ritemed.com.ph',         'Shaw Blvd., Pasig City',                   'Active'),
(7,  'PhilPharma Cold-Chain Corp.',    'Sheila Bautista',      'coldchain@philpharma.ph',    'Alabang-Zapote Rd., Muntinlupa City',      'Active'),
(8,  'Generika Community Meds Inc.',   'Rico Evangelista',     'supply@generika.com.ph',     'Sta. Rosa Industrial Park, Laguna',        'Active'),
(9,  'Mercury LGU Institutional Desk', 'Nadine Corpuz',        'lgu@mercurydrug.com.ph',     'Bagumbayan, Quezon City',                  'Active'),
(10, 'Bayanihan Medical Supplies Co.', 'Ferdinand Cruz',       'info@bayanihanmed.ph',       'Dasmariñas City, Cavite',                  'Active');

-- ----------------------------------------------------------------------------
-- 7. supplier_contacts (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `supplier_contacts`
(`contact_id`, `supplier_id`, `contact_number`, `contact_type`, `contact_person`) VALUES
(1,  1,  '09178001001', 'Primary',   'Engr. Joel Mercado'),
(2,  2,  '09178001002', 'Primary',   'Maricel Tan'),
(3,  3,  '09178001003', 'Primary',   'Arthur Villanueva'),
(4,  4,  '09178001004', 'Primary',   'Lorna Panganiban'),
(5,  5,  '09178001005', 'Primary',   'Dr. Clarissa Mendoza'),
(6,  6,  '09178001006', 'Primary',   'Dennis Alcantara'),
(7,  7,  '09178001007', 'Emergency', 'Sheila Bautista'),
(8,  8,  '09178001008', 'Primary',   'Rico Evangelista'),
(9,  9,  '09178001009', 'Primary',   'Nadine Corpuz'),
(10, 10, '09178001010', 'Primary',   'Ferdinand Cruz');

-- ----------------------------------------------------------------------------
-- 8. supplier_locations (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `supplier_locations`
(`supplier_location_id`, `supplier_id`, `office_name`, `warehouse_name`, `address`, `contact_person`, `contact_number`) VALUES
(1,  1,  'DOH Region IV-A Office',    'Central Cold-Chain Warehouse', 'Quezon City, Metro Manila',      'Engr. Joel Mercado',   '09178001001'),
(2,  2,  'Unilab Institutional Desk', 'Mandaluyong Depot B',          'Mandaluyong City, Metro Manila', 'Maricel Tan',          '09178001002'),
(3,  3,  'Zuellig South Hub',         'Sucat Pharma Warehouse',       'Paranaque City, Metro Manila',   'Arthur Villanueva',    '09178001003'),
(4,  4,  'Metro Drug Taguig',         'Taguig Distribution Center',   'Taguig City, Metro Manila',      'Lorna Panganiban',     '09178001004'),
(5,  5,  'PHO Cavite Supply Unit',    'Provincial Meds Depot',        'Trece Martires City, Cavite',    'Dr. Clarissa Mendoza', '09178001005'),
(6,  6,  'RiteMED Pasig Office',      'Pasig LGU Staging Hub',        'Pasig City, Metro Manila',       'Dennis Alcantara',     '09178001006'),
(7,  7,  'PhilPharma Cold-Chain',     'Alabang Cold Room 2',          'Muntinlupa City, Metro Manila',  'Sheila Bautista',      '09178001007'),
(8,  8,  'Generika Laguna Office',    'Sta. Rosa Logistics Bay',      'Sta. Rosa, Laguna',              'Rico Evangelista',     '09178001008'),
(9,  9,  'Mercury LGU Desk',          'Libis Central Depot',          'Quezon City, Metro Manila',      'Nadine Corpuz',        '09178001009'),
(10, 10, 'Bayanihan Med Cavite',      'Dasmariñas Supply Room',       'Dasmariñas City, Cavite',        'Ferdinand Cruz',       '09178001010');

-- ----------------------------------------------------------------------------
-- 9. government_programs (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `government_programs`
(`program_id`, `program_name`, `agency_name`, `program_type`, `description`, `eligibility_criteria`, `program_status`) VALUES
(1,  'Pantawid Pamilyang Pilipino Program (4Ps)', 'DSWD',           'Social Protection', 'Conditional cash transfer for indigent families.',              'Listahanan-identified poor households with children 0-18.', 'Active'),
(2,  'PhilHealth Konsulta Package',               'PhilHealth',     'Primary Care',      'Outpatient consultations, labs, and essential medicines.',      'Registered PhilHealth members and dependents.',             'Active'),
(3,  'Expanded Program on Immunization (EPI)',    'DOH',            'Immunization',      'Free routine childhood vaccination at barangay health stations.','Infants and children 0-59 months.',                         'Active'),
(4,  'Senior Citizen Maintenance Meds Club',      'DOH / LGU',      'Chronic Care',      'Free monthly hypertension and diabetes maintenance medicines.', 'Barangay residents aged 60 and above with diagnosis.',      'Active'),
(5,  'Safe Motherhood & Prenatal Care',           'DOH',            'Maternal Health',   'Prenatal checkups, iron-folic supplements, and TT vaccination.','Pregnant and postpartum mothers in the barangay.',          'Active'),
(6,  'National TB-DOTS Program',                  'DOH',            'Infectious Disease','Free sputum testing and directly observed TB treatment.',       'Presumptive and confirmed tuberculosis patients.',          'Active'),
(7,  'Operation Timbang & Feeding Program',       'NNC / LGU',      'Nutrition',         'Supplemental feeding for underweight and stunted children.',    'Children 6-59 months identified as malnourished.',          'Active'),
(8,  'PWD Health & Assistive Care',               'DSWD / LGU',     'Disability Care',   'Priority medical consultations and basic medicine subsidy.',    'Registered Persons with Disability (PWD ID holders).',      'Active'),
(9,  'Assistance to Individuals in Crisis (AICS)','DSWD',           'Medical Aid',       'Emergency medical and prescription financial assistance.',      'Indigent residents with medical abstract/prescription.',    'Active'),
(10, 'Barangay Dengue Aksyon Kontra Lamok',       'DOH / Barangay', 'Vector Control',    'Larvicide distribution, misting, and NS1 rapid testing.',       'All households in high-risk puroks.',                       'Active');

-- ----------------------------------------------------------------------------
-- 10. households (10 records — Filipino barangay households)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `households`
(`household_id`, `household_number`, `household_name`, `household_head_member_id`, `household_type`, `primary_contact_number`, `alternate_contact_number`, `email_address`, `house_number`, `street`, `purok_sitio`, `barangay`, `municipality`, `province`, `total_members`, `total_children`, `total_adults`, `total_senior_citizens`, `application_date`, `application_status`, `approved_by`, `approval_date`, `household_status`) VALUES
(1,  'HH-2026-0001', 'Dela Cruz Family',   NULL, 'Regular',  '09175550101', NULL,          'delacruz.hh@mail.ph',   '12-A', 'Rizal St.',       'Purok 1 - Mabini',    'Brgy. San Isidro', 'Imus', 'Cavite', 5, 2, 2, 1, '2026-01-10', 'Approved', 1, '2026-01-12 09:00:00', 'Active'),
(2,  'HH-2026-0002', 'Santos Family',      NULL, 'Indigent', '09175550102', '09285550102', 'santos.hh@mail.ph',     '45',   'Bonifacio St.',   'Purok 2 - Maligaya',  'Brgy. San Isidro', 'Imus', 'Cavite', 6, 3, 2, 1, '2026-01-14', 'Approved', 1, '2026-01-15 10:30:00', 'Active'),
(3,  'HH-2026-0003', 'Bautista Family',    NULL, 'Regular',  '09175550103', NULL,          'bautista.hh@mail.ph',   '88',   'Aguinaldo Hwy.',  'Purok 3 - Sampaguita','Brgy. San Isidro', 'Imus', 'Cavite', 4, 2, 2, 0, '2026-01-20', 'Approved', 1, '2026-01-21 14:00:00', 'Active'),
(4,  'HH-2026-0004', 'Mendoza Family',     NULL, '4Ps',      '09175550104', NULL,          NULL,                    '19',   'Narra St.',       'Purok 4 - Bagong Silang','Brgy. San Isidro','Imus','Cavite', 7, 4, 2, 1, '2026-02-02', 'Approved', 1, '2026-02-03 11:00:00', 'Active'),
(5,  'HH-2026-0005', 'Garcia Family',      NULL, 'Regular',  '09175550105', NULL,          'garcia.hh@mail.ph',     '103',  'Molave St.',      'Purok 1 - Mabini',    'Brgy. San Isidro', 'Imus', 'Cavite', 3, 1, 2, 0, '2026-02-11', 'Approved', 1, '2026-02-12 08:45:00', 'Active'),
(6,  'HH-2026-0006', 'Ramos Family',       NULL, 'Senior',   '09175550106', '09995550106', NULL,                    '7',    'Sampaloc Rd.',    'Purok 5 - Masagana',  'Brgy. San Isidro', 'Imus', 'Cavite', 2, 0, 0, 2, '2026-02-18', 'Approved', 1, '2026-02-19 15:20:00', 'Active'),
(7,  'HH-2026-0007', 'Villanueva Family',  NULL, 'Regular',  '09175550107', NULL,          'villanueva.hh@mail.ph', '214',  'Acacia St.',      'Purok 2 - Maligaya',  'Brgy. San Isidro', 'Imus', 'Cavite', 5, 2, 3, 0, '2026-03-04', 'Approved', 1, '2026-03-05 09:30:00', 'Active'),
(8,  'HH-2026-0008', 'Aquino Family',      NULL, 'Indigent', '09175550108', NULL,          NULL,                    '56-B', 'Kamagong St.',    'Purok 6 - Riverside', 'Brgy. San Isidro', 'Imus', 'Cavite', 6, 3, 2, 1, '2026-03-15', 'Approved', 1, '2026-03-16 13:15:00', 'Active'),
(9,  'HH-2026-0009', 'Castillo Family',    NULL, 'Regular',  '09175550109', NULL,          'castillo.hh@mail.ph',   '31',   'Ilang-Ilang St.', 'Purok 3 - Sampaguita','Brgy. San Isidro', 'Imus', 'Cavite', 4, 1, 2, 1, '2026-04-01', 'Approved', 1, '2026-04-02 10:00:00', 'Active'),
(10, 'HH-2026-0010', 'Fernandez Family',   NULL, '4Ps',      '09175550110', NULL,          NULL,                    '90',   'Mahogany St.',    'Purok 4 - Bagong Silang','Brgy. San Isidro','Imus','Cavite', 5, 3, 2, 0, '2026-04-12', 'Pending',  NULL, NULL,                 'Active');

-- ----------------------------------------------------------------------------
-- 11. household_members (10 records — linked to households 1..10)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `household_members`
(`member_id`, `household_id`, `first_name`, `middle_name`, `last_name`, `relationship_to_head`, `date_of_birth`, `sex`, `civil_status`, `employment_status`, `occupation`, `monthly_income`, `education_status`, `educational_level`, `school_name`, `disability_status`, `senior_citizen_status`, `member_status`) VALUES
(1,  1,  'Roberto',  'Cruz',    'Dela Cruz',  'Head',  '1982-05-14', 'Male',   'Married', 'Employed',      'Tricycle Driver',     14500.00, 'Graduate', 'High School',     'Imus National HS',        'No',  0, 'Active'),
(2,  2,  'Marites',  'Dizon',   'Santos',     'Head',  '1988-09-22', 'Female', 'Married', 'Self-Employed', 'Sari-Sari Store',     11000.00, 'Graduate', 'High School',     'Cavite National HS',      'No',  0, 'Active'),
(3,  3,  'Jerome',   'Reyes',   'Bautista',   'Head',  '1990-02-11', 'Male',   'Married', 'Employed',      'Factory Technician',  21000.00, 'Graduate', 'Vocational',      'TESDA Cavite',            'No',  0, 'Active'),
(4,  4,  'Analyn',   'Torres',  'Mendoza',    'Head',  '1993-07-08', 'Female', 'Married', 'Unemployed',    'Homemaker',               0.00, 'Graduate', 'High School',     'San Isidro HS',           'No',  0, 'Active'),
(5,  5,  'Gabriel',  'Lim',     'Garcia',     'Child', '2025-08-19', 'Male',   'Single',  'Not Applicable','Infant',                  0.00, 'None',     'Not Applicable',  NULL,                      'No',  0, 'Active'),
(6,  6,  'Ernesto',  'Vega',    'Ramos',      'Head',  '1958-11-30', 'Male',   'Married', 'Retired',       'Retired Carpenter',    6000.00, 'Graduate', 'Elementary',      'San Isidro Elem.',        'No',  1, 'Active'),
(7,  7,  'Clarisse', 'Ocampo',  'Villanueva', 'Spouse','1995-04-03', 'Female', 'Married', 'Employed',      'BPO Representative',  24000.00, 'Graduate', 'College',         'Cavite State Univ.',      'No',  0, 'Active'),
(8,  8,  'Lourdes',  'Flores',  'Aquino',     'Head',  '1961-01-17', 'Female', 'Widowed', 'Self-Employed', 'Laundry Service',      7500.00, 'Graduate', 'Elementary',      'Imus Pilot Elem.',        'No',  1, 'Active'),
(9,  9,  'Mateo',    'Ramos',   'Castillo',   'Child', '2025-11-05', 'Male',   'Single',  'Not Applicable','Infant',                  0.00, 'None',     'Not Applicable',  NULL,                      'No',  0, 'Active'),
(10, 10, 'Jocelyn',  'Pascual', 'Fernandez',  'Head',  '1986-06-25', 'Female', 'Married', 'Self-Employed', 'Market Vendor',        9500.00, 'Graduate', 'High School',     'Imus National HS',        'Yes', 0, 'Active');

-- Link household heads where applicable
UPDATE `households` SET `household_head_member_id` = 1  WHERE `household_id` = 1  AND `household_head_member_id` IS NULL;
UPDATE `households` SET `household_head_member_id` = 2  WHERE `household_id` = 2  AND `household_head_member_id` IS NULL;
UPDATE `households` SET `household_head_member_id` = 3  WHERE `household_id` = 3  AND `household_head_member_id` IS NULL;
UPDATE `households` SET `household_head_member_id` = 4  WHERE `household_id` = 4  AND `household_head_member_id` IS NULL;
UPDATE `households` SET `household_head_member_id` = 6  WHERE `household_id` = 6  AND `household_head_member_id` IS NULL;
UPDATE `households` SET `household_head_member_id` = 8  WHERE `household_id` = 8  AND `household_head_member_id` IS NULL;
UPDATE `households` SET `household_head_member_id` = 10 WHERE `household_id` = 10 AND `household_head_member_id` IS NULL;

-- ----------------------------------------------------------------------------
-- 12. medicine_inventory (10 records — 3 LOW STOCK items for Dashboard/Table alerts!)
-- Low stock condition: available_quantity <= reorder_level
-- Items #2 (Amoxicillin), #3 (Losartan), and #6 (Salbutamol) are LOW STOCK
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `medicine_inventory`
(`inventory_id`, `medicine_id`, `total_quantity`, `available_quantity`, `reserved_quantity`, `reorder_level`) VALUES
(1,  1,  500.000, 420.000, 80.000, 100.000),
(2,  2,   25.000,  15.000, 10.000,  50.000),  -- LOW STOCK
(3,  3,   30.000,  20.000, 10.000,  40.000),  -- LOW STOCK
(4,  4,  300.000, 260.000, 40.000,  60.000),
(5,  5,  240.000, 210.000, 30.000,  50.000),
(6,  6,   12.000,   8.000,  4.000,  25.000),  -- LOW STOCK
(7,  7,  180.000, 155.000, 25.000,  40.000),
(8,  8,  350.000, 310.000, 40.000,  80.000),
(9,  9,  400.000, 340.000, 60.000, 100.000),
(10, 10, 220.000, 190.000, 30.000,  50.000);

-- ----------------------------------------------------------------------------
-- 13. medicine_requests (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `medicine_requests`
(`request_id`, `requested_by`, `approved_by`, `request_date`, `approval_date`, `approval_status`, `remarks`) VALUES
(1,  5, 1, '2026-09-01 08:30:00', '2026-09-01 10:00:00', 'Approved',  'Q3 essential medicines replenishment'),
(2,  5, 1, '2026-09-15 09:15:00', '2026-09-15 11:00:00', 'Approved',  'Hypertension maintenance stock request'),
(3,  2, 1, '2026-10-01 08:45:00', '2026-10-01 13:20:00', 'Approved',  'EPI routine childhood vaccine restock'),
(4,  5, 1, '2026-10-10 10:00:00', '2026-10-10 14:00:00', 'Approved',  'Antibiotics and pediatric syrup batch'),
(5,  3, 1, '2026-10-20 09:00:00', '2026-10-21 09:30:00', 'Approved',  'Prenatal iron-folic acid allocation'),
(6,  5, 1, '2026-11-01 08:00:00', '2026-11-01 11:45:00', 'Approved',  'Monthly ORS and antipyretic supply'),
(7,  2, 1, '2026-11-08 10:30:00', '2026-11-08 15:00:00', 'Approved',  'Anti-rabies and flu vaccine replenishment'),
(8,  5, NULL, '2026-11-20 09:10:00', NULL,               'Pending',   'Urgent Amoxicillin 500mg low-stock reorder'),
(9,  5, NULL, '2026-11-22 11:00:00', NULL,               'Pending',   'Urgent Losartan 50mg low-stock reorder'),
(10, 5, NULL, NOW(),                 NULL,               'Pending',   'Urgent Salbutamol syrup low-stock reorder');

-- ----------------------------------------------------------------------------
-- 14. deliveries (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `deliveries`
(`delivery_id`, `request_id`, `supplier_location_id`, `sent_by`, `dispatched_by`, `dispatch_date`, `dispatch_time`, `delivered_by`, `delivery_date`, `delivery_time`, `received_by`, `received_date`, `received_time`, `receiving_signature_reference`, `delivery_status`, `recorded_by`) VALUES
(1,  1, 1,  5, 'Joel Mercado',     '2026-09-02', '07:30:00', 'R. Manalo',   '2026-09-02', '10:15:00', 5, '2026-09-02', '10:30:00', 'DR-2026-0901', 'Received', 5),
(2,  2, 2,  5, 'Maricel Tan',      '2026-09-16', '08:00:00', 'J. Castro',   '2026-09-16', '11:00:00', 5, '2026-09-16', '11:15:00', 'DR-2026-0916', 'Received', 5),
(3,  3, 7,  2, 'Sheila Bautista',  '2026-10-02', '06:45:00', 'ColdVan-04',  '2026-10-02', '09:00:00', 2, '2026-10-02', '09:10:00', 'DR-2026-1002', 'Received', 2),
(4,  4, 3,  5, 'Arthur Villanueva','2026-10-11', '08:20:00', 'M. Soriano',  '2026-10-11', '13:00:00', 5, '2026-10-11', '13:10:00', 'DR-2026-1011', 'Received', 5),
(5,  5, 5,  3, 'Clarissa Mendoza', '2026-10-22', '07:50:00', 'PHO-Truck2',  '2026-10-22', '10:00:00', 3, '2026-10-22', '10:20:00', 'DR-2026-1022', 'Received', 3),
(6,  6, 4,  5, 'Lorna Panganiban', '2026-11-02', '08:10:00', 'D. Tolentino','2026-11-02', '11:30:00', 5, '2026-11-02', '11:45:00', 'DR-2026-1102', 'Received', 5),
(7,  7, 1,  2, 'Joel Mercado',     '2026-11-09', '07:00:00', 'ColdVan-02',  '2026-11-09', '09:30:00', 2, '2026-11-09', '09:40:00', 'DR-2026-1109', 'Received', 2),
(8,  1, 6,  5, 'Dennis Alcantara', '2026-11-12', '08:30:00', 'A. Morales',  '2026-11-12', '14:00:00', 5, '2026-11-12', '14:15:00', 'DR-2026-1112', 'Received', 5),
(9,  8, 8,  5, 'Rico Evangelista', '2026-11-23', '09:00:00', 'L. Pineda',   NULL,         NULL,       NULL, NULL,      NULL,       NULL,           'In Transit', 5),
(10, 9, 9,  5, 'Nadine Corpuz',    CURDATE(),    '08:00:00', 'Pending Van', NULL,         NULL,       NULL, NULL,      NULL,       NULL,           'Pending',  5);

-- ----------------------------------------------------------------------------
-- 15. medicine_batches (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `medicine_batches`
(`batch_id`, `medicine_id`, `batch_number`, `manufacture_date`, `expiration_date`, `delivery_id`, `quantity_delivered`, `quantity_remaining`, `created_by`) VALUES
(1,  1,  'PARA-2026-A01', '2026-01-15', '2028-01-15', 1, 500.000, 420.000, 5),
(2,  2,  'AMOX-2026-B02', '2026-02-10', '2027-08-10', 4, 200.000,  15.000, 5),
(3,  3,  'LOSA-2026-C03', '2026-03-01', '2028-03-01', 2, 180.000,  20.000, 5),
(4,  4,  'METF-2026-D04', '2026-03-20', '2028-03-20', 2, 300.000, 260.000, 5),
(5,  5,  'AMLO-2026-E05', '2026-04-05', '2028-04-05', 2, 240.000, 210.000, 5),
(6,  6,  'SALB-2026-F06', '2026-04-12', '2027-10-12', 4,  60.000,   8.000, 5),
(7,  7,  'CETI-2026-G07', '2026-05-01', '2028-05-01', 6, 180.000, 155.000, 5),
(8,  8,  'ORS-2026-H08',  '2026-05-15', '2028-05-15', 6, 350.000, 310.000, 5),
(9,  9,  'FERR-2026-I09', '2026-06-01', '2028-06-01', 5, 400.000, 340.000, 5),
(10, 10, 'MEFE-2026-J10', '2026-06-18', '2028-06-18', 8, 220.000, 190.000, 5);

-- ----------------------------------------------------------------------------
-- 16. delivery_items (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `delivery_items`
(`delivery_item_id`, `delivery_id`, `batch_id`, `quantity_delivered`, `quantity_accepted`, `quantity_rejected`, `remarks`) VALUES
(1,  1, 1,  500.000, 500.000, 0.000, 'Sealed boxes intact'),
(2,  4, 2,  200.000, 200.000, 0.000, 'Verified expiry date'),
(3,  2, 3,  180.000, 180.000, 0.000, 'Good condition'),
(4,  2, 4,  300.000, 300.000, 0.000, 'Complete count'),
(5,  2, 5,  240.000, 240.000, 0.000, 'Complete count'),
(6,  4, 6,   60.000,  60.000, 0.000, 'No broken bottles'),
(7,  6, 7,  180.000, 180.000, 0.000, 'Verified batch number'),
(8,  6, 8,  350.000, 350.000, 0.000, 'Dry packaging intact'),
(9,  5, 9,  400.000, 400.000, 0.000, 'DOH prenatal stock'),
(10, 8, 10, 220.000, 218.000, 2.000, '2 blister packs damaged in transit');

-- ----------------------------------------------------------------------------
-- 17. stock_transactions (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `stock_transactions`
(`transaction_id`, `batch_id`, `user_id`, `transaction_type`, `quantity`, `remarks`, `admin_id`) VALUES
(1,  1,  5, 'Stock In',  500.000, 'Initial Q3 delivery received',          1),
(2,  1,  5, 'Dispense',   80.000, 'Dispensed during clinic consultations', 1),
(3,  2,  5, 'Dispense',  185.000, 'High demand for respiratory cases',     1),
(4,  3,  5, 'Dispense',  160.000, 'Senior citizen maintenance refills',    1),
(5,  4,  5, 'Dispense',   40.000, 'Diabetes club monthly release',         1),
(6,  5,  5, 'Dispense',   30.000, 'Hypertension outpatient dispensing',    1),
(7,  6,  5, 'Dispense',   52.000, 'Pediatric asthma nebulization & syrup', 1),
(8,  7,  5, 'Dispense',   25.000, 'Seasonal allergy relief dispensing',    1),
(9,  8,  5, 'Dispense',   40.000, 'Acute gastroenteritis home care kits',  1),
(10, 9,  3, 'Dispense',   60.000, 'Prenatal checkup iron-folic release',   1);

-- ----------------------------------------------------------------------------
-- 18. vaccine_batches (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `vaccine_batches`
(`vaccine_batch_id`, `vaccine_id`, `batch_number`, `manufacture_date`, `expiration_date`, `delivery_id`, `quantity_received`, `quantity_remaining`) VALUES
(1,  1,  'BCG-2026-01',  '2026-04-01', '2027-04-01', 3, 100.000, 82.000),
(2,  2,  'HEPB-2026-02', '2026-04-10', '2027-10-10', 3, 120.000, 95.000),
(3,  3,  'PENTA-2026-03','2026-05-01', '2027-11-01', 3, 150.000, 118.000),
(4,  4,  'OPV-2026-04',  '2026-05-15', '2027-05-15', 3, 200.000, 165.000),
(5,  5,  'IPV-2026-05',  '2026-05-20', '2027-11-20', 3, 100.000, 88.000),
(6,  6,  'PCV13-2026-06','2026-06-01', '2028-01-01', 7, 120.000, 102.000),
(7,  7,  'MMR-2026-07',  '2026-06-15', '2027-12-15', 7, 100.000, 85.000),
(8,  8,  'RAB-2026-08',  '2026-07-01', '2028-01-01', 7,  80.000, 64.000),
(9,  9,  'FLU-2026-09',  '2026-08-01', '2027-08-01', 7, 150.000, 120.000),
(10, 10, 'TT-2026-10',   '2026-07-15', '2028-07-15', 7, 140.000, 115.000);

-- ----------------------------------------------------------------------------
-- 19. health_visits (10 records — 4 visits dated CURDATE() for "Visits Today" card!)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `health_visits`
(`visit_id`, `member_id`, `visit_date`, `visit_time`, `visit_type`, `chief_complaint`, `diagnosis`, `treatment_given`, `next_visit_date`, `attending_personnel_id`, `assisting_personnel_id`, `recorded_by`) VALUES
(1,  1,  CURDATE(),                        '08:15:00', 'Consultation', 'Fever and body aches for 2 days',      'Acute Viral Fever',           'Paracetamol 500mg & hydration advice',  DATE_ADD(CURDATE(), INTERVAL 7 DAY),  1, 2, 2),
(2,  6,  CURDATE(),                        '08:45:00', 'Follow-up',    'BP monitoring & maintenance refill',   'Essential Hypertension',      'Losartan 50mg 30-day supply',           DATE_ADD(CURDATE(), INTERVAL 30 DAY), 1, 5, 2),
(3,  5,  CURDATE(),                        '09:20:00', 'Immunization', 'Scheduled infant vaccination',         'Well-Baby Visit',             'Pentavalent & OPV administered',        DATE_ADD(CURDATE(), INTERVAL 28 DAY), 2, 7, 2),
(4,  7,  CURDATE(),                        '10:05:00', 'Prenatal',     '2nd trimester routine prenatal check', 'Normal Pregnancy (22 weeks)', 'Ferrous Sulfate + Folic Acid & TT',     DATE_ADD(CURDATE(), INTERVAL 30 DAY), 3, 8, 3),
(5,  2,  DATE_SUB(CURDATE(), INTERVAL 1 DAY), '09:00:00', 'Consultation', 'Productive cough and mild sore throat','Upper Respiratory Infection', 'Amoxicillin 500mg 7-day course',        DATE_ADD(CURDATE(), INTERVAL 6 DAY),  1, 2, 2),
(6,  8,  DATE_SUB(CURDATE(), INTERVAL 2 DAY), '10:30:00', 'Follow-up',    'Fasting blood sugar checkup',          'Type 2 Diabetes Mellitus',    'Metformin 500mg maintenance refill',    DATE_ADD(CURDATE(), INTERVAL 28 DAY), 1, 5, 5),
(7,  9,  DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:30:00', 'Immunization', 'Routine infant immunization',          'Well-Baby Visit',             'MMR 1st dose administered',             DATE_ADD(CURDATE(), INTERVAL 90 DAY), 2, 7, 2),
(8,  3,  DATE_SUB(CURDATE(), INTERVAL 5 DAY), '13:45:00', 'Animal Bite',  'Minor dog scratch on right leg',       'Category II Animal Bite',     'Wound wash & Anti-Rabies Day 0 dose',   DATE_ADD(CURDATE(), INTERVAL 2 DAY),  1, 2, 2),
(9,  4,  DATE_SUB(CURDATE(), INTERVAL 7 DAY), '11:15:00', 'Consultation', 'Allergic sneezing and itchy eyes',     'Allergic Rhinitis',           'Cetirizine 10mg once daily',            NULL,                                 1, 6, 3),
(10, 10, DATE_SUB(CURDATE(), INTERVAL 9 DAY), '14:20:00', 'Consultation', 'Mild asthma wheezing',                 'Intermittent Bronchial Asthma','Salbutamol nebulization & syrup',      DATE_ADD(CURDATE(), INTERVAL 14 DAY), 1, 5, 2);

-- ----------------------------------------------------------------------------
-- 20. immunization_schedules (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `immunization_schedules`
(`schedule_id`, `member_id`, `vaccine_id`, `scheduled_date`, `scheduled_time`, `schedule_status`) VALUES
(1,  5,  1,  DATE_SUB(CURDATE(), INTERVAL 60 DAY), '08:30:00', 'Completed'),
(2,  5,  2,  DATE_SUB(CURDATE(), INTERVAL 60 DAY), '08:45:00', 'Completed'),
(3,  5,  3,  CURDATE(),                            '09:00:00', 'Completed'),
(4,  5,  4,  CURDATE(),                            '09:15:00', 'Completed'),
(5,  9,  6,  DATE_SUB(CURDATE(), INTERVAL 14 DAY), '09:00:00', 'Completed'),
(6,  9,  7,  DATE_SUB(CURDATE(), INTERVAL 3 DAY),  '08:30:00', 'Completed'),
(7,  3,  8,  DATE_SUB(CURDATE(), INTERVAL 5 DAY),  '13:30:00', 'Completed'),
(8,  6,  9,  DATE_ADD(CURDATE(), INTERVAL 2 DAY),  '09:00:00', 'Scheduled'),
(9,  8,  9,  DATE_ADD(CURDATE(), INTERVAL 2 DAY),  '09:30:00', 'Scheduled'),
(10, 7,  10, CURDATE(),                            '10:00:00', 'Completed');

-- ----------------------------------------------------------------------------
-- 21. immunization_preregistrations (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `immunization_preregistrations`
(`pre_registration_id`, `member_id`, `schedule_id`, `vaccine_id`, `dose_number`, `expected_date`, `registration_status`, `arrival_confirmed_at`, `daily_visit_number`) VALUES
(1,  5,  1,  1,  1, DATE_SUB(CURDATE(), INTERVAL 60 DAY), 'Completed',  NOW(), 1),
(2,  5,  2,  2,  1, DATE_SUB(CURDATE(), INTERVAL 60 DAY), 'Completed',  NOW(), 2),
(3,  5,  3,  3,  2, CURDATE(),                            'Confirmed',  NOW(), 1),
(4,  5,  4,  4,  2, CURDATE(),                            'Confirmed',  NOW(), 2),
(5,  9,  5,  6,  2, DATE_SUB(CURDATE(), INTERVAL 14 DAY), 'Completed',  NOW(), 1),
(6,  9,  6,  7,  1, DATE_SUB(CURDATE(), INTERVAL 3 DAY),  'Completed',  NOW(), 1),
(7,  3,  7,  8,  1, DATE_SUB(CURDATE(), INTERVAL 5 DAY),  'Completed',  NOW(), 3),
(8,  6,  8,  9,  1, DATE_ADD(CURDATE(), INTERVAL 2 DAY),  'Registered', NULL,  1),
(9,  8,  9,  9,  1, DATE_ADD(CURDATE(), INTERVAL 2 DAY),  'Registered', NULL,  2),
(10, 7,  10, 10, 2, CURDATE(),                            'Confirmed',  NOW(), 3);

-- ----------------------------------------------------------------------------
-- 22. immunization_queue (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `immunization_queue`
(`queue_id`, `member_id`, `schedule_id`, `registration_type`, `roll_call_status`, `roll_call_timestamp`, `queue_number`, `arrival_timestamp`, `service_start_timestamp`, `service_end_timestamp`, `queue_status`) VALUES
(1,  5,  3,  'Pre-Registered', 'Present', NOW(), 1, NOW(), NOW(), NOW(), 'Completed'),
(2,  5,  4,  'Pre-Registered', 'Present', NOW(), 2, NOW(), NOW(), NOW(), 'Completed'),
(3,  7,  10, 'Pre-Registered', 'Present', NOW(), 3, NOW(), NOW(), NOW(), 'Completed'),
(4,  6,  8,  'Pre-Registered', 'Pending', NULL,  4, NULL,  NULL,  NULL,  'Registered'),
(5,  8,  9,  'Pre-Registered', 'Pending', NULL,  5, NULL,  NULL,  NULL,  'Registered'),
(6,  1,  NULL,'Walk-In',       'Present', NOW(), 6, NOW(), NOW(), NULL,  'In Service'),
(7,  2,  NULL,'Walk-In',       'Present', NOW(), 7, NOW(), NULL,  NULL,  'Waiting'),
(8,  4,  NULL,'Walk-In',       'Present', NOW(), 8, NOW(), NULL,  NULL,  'Waiting'),
(9,  9,  6,  'Pre-Registered', 'Present', NOW(), 9, NOW(), NOW(), NOW(), 'Completed'),
(10, 3,  7,  'Walk-In',        'Present', NOW(), 10,NOW(), NOW(), NOW(), 'Completed');

-- ----------------------------------------------------------------------------
-- 23. immunization_records (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `immunization_records`
(`immunization_id`, `visit_id`, `member_id`, `vaccine_id`, `vaccine_batch_id`, `dose_number`, `vaccination_date`, `vaccination_time`, `administered_by`, `assisted_by`, `remarks`) VALUES
(1,  3,  5,  1,  1,  1, DATE_SUB(CURDATE(), INTERVAL 60 DAY), '08:35:00', 2, 7, 'Right deltoid intradermal, no adverse reaction'),
(2,  3,  5,  2,  2,  1, DATE_SUB(CURDATE(), INTERVAL 60 DAY), '08:50:00', 2, 7, 'Anterolateral thigh, tolerated well'),
(3,  3,  5,  3,  3,  2, CURDATE(),                            '09:25:00', 2, 7, '2nd dose Pentavalent completed'),
(4,  3,  5,  4,  4,  2, CURDATE(),                            '09:30:00', 2, 7, '2 drops oral polio vaccine given'),
(5,  7,  9,  5,  5,  1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), '09:00:00', 5, 7, 'IPV 1st dose administered'),
(6,  7,  9,  6,  6,  2, DATE_SUB(CURDATE(), INTERVAL 14 DAY), '09:15:00', 5, 8, 'PCV13 2nd dose completed'),
(7,  7,  9,  7,  7,  1, DATE_SUB(CURDATE(), INTERVAL 3 DAY),  '08:40:00', 2, 7, 'MMR 1st dose given at 12 months'),
(8,  8,  3,  8,  8,  1, DATE_SUB(CURDATE(), INTERVAL 5 DAY),  '13:55:00', 2, 5, 'Anti-rabies Day 0 intradermal'),
(9,  2,  6,  9,  9,  1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), '09:10:00', 5, 8, 'Annual senior citizen flu vaccine'),
(10, 4,  7,  10, 10, 2, CURDATE(),                            '10:15:00', 3, 8, 'Maternal Tetanus Toxoid 2nd dose');

-- ----------------------------------------------------------------------------
-- 24. household_program_memberships (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `household_program_memberships`
(`membership_id`, `household_id`, `program_id`, `enrollment_date`, `beneficiary_reference_number`, `verification_status`, `membership_status`, `verified_by`) VALUES
(1,  1,  2, '2026-01-15', 'PH-KONS-0001', 'Verified', 'Active', 1),
(2,  2,  1, '2026-01-18', 'DSWD-4PS-0002','Verified', 'Active', 1),
(3,  3,  2, '2026-01-25', 'PH-KONS-0003', 'Verified', 'Active', 1),
(4,  4,  1, '2026-02-05', 'DSWD-4PS-0004','Verified', 'Active', 1),
(5,  5,  3, '2026-02-15', 'DOH-EPI-0005', 'Verified', 'Active', 2),
(6,  6,  4, '2026-02-20', 'LGU-SC-0006',  'Verified', 'Active', 1),
(7,  7,  5, '2026-03-08', 'DOH-MAT-0007', 'Verified', 'Active', 3),
(8,  8,  4, '2026-03-18', 'LGU-SC-0008',  'Verified', 'Active', 1),
(9,  9,  3, '2026-04-04', 'DOH-EPI-0009', 'Verified', 'Active', 2),
(10, 10, 8, '2026-04-15', 'LGU-PWD-0010', 'Pending',  'Active', NULL);

-- ----------------------------------------------------------------------------
-- 25. distribution_programs (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `distribution_programs`
(`distribution_id`, `program_name`, `distribution_type`, `funding_source`, `distribution_date`, `eligibility_criteria`, `approved_by`, `program_status`) VALUES
(1,  'Q1 Hygiene & First Aid Kit Drive',      'Health Kits',     'Barangay Health Fund', '2026-02-15', 'All active indigent households',      1, 'Completed'),
(2,  'Senior Citizen Maintenance Pack Q1',    'Medicines',       'LGU Senior Fund',      '2026-03-10', 'Registered seniors with hypertension',1, 'Completed'),
(3,  'Maternal Prenatal Vitamin Pack',        'Supplements',     'DOH Maternal Grant',   '2026-04-20', 'Enrolled pregnant mothers',           1, 'Completed'),
(4,  'Childhood Micronutrient Powder Drive',  'Nutrition',       'NNC / LGU',            '2026-05-18', 'Households with children 6-23 mos',   1, 'Completed'),
(5,  'Anti-Dengue Mosquito Net Distribution', 'Vector Control',  'DOH Regional Office',  '2026-06-25', 'Riverside & high-risk puroks',        1, 'Completed'),
(6,  'Rainy Season ORS & Paracetamol Pack',   'Medicines',       'Barangay Calamity Fund','2026-07-30','All flood-prone households',          1, 'Completed'),
(7,  'Senior Citizen Maintenance Pack Q3',    'Medicines',       'LGU Senior Fund',      '2026-09-12', 'Registered seniors aged 60+',         1, 'Completed'),
(8,  'Flu Vaccination & Vitamin C Pack',      'Preventive Care', 'LGU Health Office',    '2026-10-15', 'Seniors and immunocompromised',       1, 'Ongoing'),
(9,  'PWD Essential Care Package',            'Health Kits',     'DSWD / LGU',           '2026-11-10', 'Verified PWD households',             1, 'Ongoing'),
(10, 'Year-End Family Wellness Pack',         'Health Kits',     'Barangay Health Fund', '2026-12-05', 'Priority 4Ps and indigent families',  1, 'Planned');

-- ----------------------------------------------------------------------------
-- 26. household_allocations (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `household_allocations`
(`allocation_id`, `distribution_id`, `household_id`, `claim_number`, `eligibility_status`, `allocation_date`, `allocation_status`) VALUES
(1,  1,  2,  'CLM-2026-0001', 'Eligible', '2026-02-10', 'Claimed'),
(2,  1,  4,  'CLM-2026-0002', 'Eligible', '2026-02-10', 'Claimed'),
(3,  2,  6,  'CLM-2026-0003', 'Eligible', '2026-03-05', 'Claimed'),
(4,  2,  8,  'CLM-2026-0004', 'Eligible', '2026-03-05', 'Claimed'),
(5,  3,  7,  'CLM-2026-0005', 'Eligible', '2026-04-15', 'Claimed'),
(6,  4,  5,  'CLM-2026-0006', 'Eligible', '2026-05-12', 'Claimed'),
(7,  5,  8,  'CLM-2026-0007', 'Eligible', '2026-06-20', 'Claimed'),
(8,  6,  1,  'CLM-2026-0008', 'Eligible', '2026-07-25', 'Claimed'),
(9,  8,  6,  'CLM-2026-0009', 'Eligible', '2026-10-12', 'Allocated'),
(10, 9,  10, 'CLM-2026-0010', 'Eligible', '2026-11-08', 'Allocated');

-- ----------------------------------------------------------------------------
-- 27. distribution_claims (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `distribution_claims`
(`claim_id`, `allocation_id`, `claim_number`, `claimed_by`, `claim_date`, `claim_time`, `released_by`, `proof_of_claim`, `claim_status`) VALUES
(1,  1,  'CLM-2026-0001', 'Marites Santos',      '2026-02-15', '09:10:00', 4, 'Signed Logbook #101', 'Claimed'),
(2,  2,  'CLM-2026-0002', 'Analyn Mendoza',      '2026-02-15', '09:30:00', 4, 'Signed Logbook #102', 'Claimed'),
(3,  3,  'CLM-2026-0003', 'Ernesto Ramos',       '2026-03-10', '08:45:00', 5, 'Senior ID Verified',  'Claimed'),
(4,  4,  'CLM-2026-0004', 'Lourdes Aquino',      '2026-03-10', '09:05:00', 5, 'Senior ID Verified',  'Claimed'),
(5,  5,  'CLM-2026-0005', 'Clarisse Villanueva', '2026-04-20', '10:00:00', 3, 'Prenatal Booklet',    'Claimed'),
(6,  6,  'CLM-2026-0006', 'Elena Garcia (Mother)','2026-05-18','09:20:00', 4, 'Child Health Card',   'Claimed'),
(7,  7,  'CLM-2026-0007', 'Lourdes Aquino',      '2026-06-25', '10:15:00', 8, 'Barangay ID Copy',    'Claimed'),
(8,  8,  'CLM-2026-0008', 'Roberto Dela Cruz',   '2026-07-30', '11:00:00', 8, 'Signed Release Slip', 'Claimed'),
(9,  9,  'CLM-2026-0009', 'Ernesto Ramos',       '2026-10-16', '09:40:00', 5, 'Senior ID Verified',  'Pending'),
(10, 10, 'CLM-2026-0010', 'Jocelyn Fernandez',   '2026-11-12', '10:30:00', 4, 'PWD ID Verified',     'Pending');

-- ----------------------------------------------------------------------------
-- 28. assistance_records (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `assistance_records`
(`assistance_id`, `household_id`, `member_id`, `program_id`, `assistance_type`, `funding_agency`, `assistance_description`, `amount`, `date_received`, `received_by`, `approved_by`, `recorded_by`, `receipt_reference`, `assistance_status`) VALUES
(1,  2,  2,  1,  'Cash Grant',       'DSWD',           '4Ps health compliance grant',             2200.00, '2026-02-28', 'Marites Santos',      1, 4, 'AICS-2026-001', 'Released'),
(2,  4,  4,  1,  'Cash Grant',       'DSWD',           '4Ps maternal & child health grant',       2800.00, '2026-03-30', 'Analyn Mendoza',      1, 4, 'AICS-2026-002', 'Released'),
(3,  6,  6,  4,  'Medicine Subsidy', 'LGU Imus',       'Monthly hypertension medicine pack',       850.00, '2026-04-10', 'Ernesto Ramos',       1, 5, 'MED-2026-003',  'Released'),
(4,  8,  8,  9,  'Medical Aid',      'DSWD AICS',      'Laboratory & prescription assistance',    3000.00, '2026-05-14', 'Lourdes Aquino',      1, 10,'AICS-2026-004', 'Released'),
(5,  10, 10, 8,  'PWD Medical Aid',  'LGU MSWDO',      'Asthma nebulizer & medicine voucher',     2500.00, '2026-06-19', 'Jocelyn Fernandez',   1, 10,'PWD-2026-005',  'Released'),
(6,  1,  1,  2,  'Lab Voucher',      'PhilHealth',     'CBC and urinalysis Konsulta voucher',      600.00, '2026-07-11', 'Roberto Dela Cruz',   1, 2, 'KONS-2026-006', 'Released'),
(7,  3,  3,  9,  'Emergency Aid',    'Barangay Fund',  'Anti-rabies booster assistance',          1500.00, '2026-08-22', 'Jerome Bautista',     1, 2, 'BRGY-2026-007', 'Released'),
(8,  5,  5,  7,  'Nutrition Pack',   'NNC / LGU',      'Infant milk & micronutrient pack',         950.00, '2026-09-18', 'Garcia Family',       1, 11,'NUT-2026-008',  'Released'),
(9,  7,  7,  5,  'Prenatal Kit',     'DOH',            'Safe motherhood delivery kit',            1200.00, '2026-10-25', 'Clarisse Villanueva', 1, 3, 'MAT-2026-009',  'Released'),
(10, 9,  9,  3,  'Immunization Kit', 'DOH / Barangay', 'Infant fever care & immunization booklet', 450.00, '2026-11-15', 'Castillo Family',     1, 2, 'EPI-2026-010',  'Pending');

-- ----------------------------------------------------------------------------
-- 29. staff_attendance (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `staff_attendance`
(`attendance_id`, `user_id`, `duty_date`, `shift`, `time_in`, `time_out`, `attendance_status`, `remarks`, `recorded_by`) VALUES
(1,  2,  CURDATE(), 'Morning (8AM-5PM)',  '07:52:00', NULL,       'Present', 'On duty at immunization station', 1),
(2,  3,  CURDATE(), 'Morning (8AM-5PM)',  '07:55:00', NULL,       'Present', 'Prenatal consultation clinic',    1),
(3,  4,  CURDATE(), 'Morning (8AM-5PM)',  '07:48:00', NULL,       'Present', 'Triage & vital signs desk',       1),
(4,  5,  CURDATE(), 'Morning (8AM-5PM)',  '08:00:00', NULL,       'Present', 'Pharmacy dispensing counter',     1),
(5,  6,  CURDATE(), 'Morning (8AM-5PM)',  '08:10:00', NULL,       'Present', 'Outpatient consultations',        1),
(6,  7,  CURDATE(), 'Morning (8AM-5PM)',  '07:58:00', NULL,       'Present', 'Vaccination cold-chain monitor',  1),
(7,  8,  CURDATE(), 'Morning (8AM-5PM)',  '08:05:00', NULL,       'Present', 'Purok 2 home visits',             1),
(8,  9,  CURDATE(), 'Morning (8AM-5PM)',  '08:15:00', NULL,       'Late',    'Traffic delay on Aguinaldo Hwy',  1),
(9,  10, CURDATE(), 'Morning (8AM-5PM)',  '07:50:00', NULL,       'Present', 'Records encoding & reporting',    1),
(10, 11, CURDATE(), 'Morning (8AM-5PM)',  NULL,       NULL,       'On Leave','Approved personal leave',         1);

-- ----------------------------------------------------------------------------
-- 30. notifications (10 records — 6 unread for admin user_id=1 so Dashboard shows 6!)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `notifications`
(`notification_id`, `user_id`, `notification_type`, `notification_message`, `read_status`) VALUES
(1,  1, 'Low Stock Alert',     'Amoxicillin 500mg is below reorder level (15 remaining vs 50 reorder level).', 0),
(2,  1, 'Low Stock Alert',     'Losartan 50mg is below reorder level (20 remaining vs 40 reorder level).',     0),
(3,  1, 'Low Stock Alert',     'Salbutamol 2mg/5mL Syrup is critically low (8 bottles remaining vs 25).',      0),
(4,  1, 'Pending Request',     'Medicine request #8 (Amoxicillin 500mg reorder) awaits admin approval.',       0),
(5,  1, 'Pending Request',     'Medicine request #9 (Losartan 50mg reorder) awaits admin approval.',           0),
(6,  1, 'Household Approval',  'New household application HH-2026-0010 (Fernandez Family) is pending review.', 0),
(7,  1, 'Delivery Update',     'Delivery #8 from RiteMED Pasig was received and verified.',                    1),
(8,  2, 'Immunization Queue',  '3 scheduled patients confirmed for today''s immunization clinic.',             0),
(9,  5, 'Delivery In Transit', 'Delivery #9 (Amoxicillin restock) is currently in transit from Generika.',     0),
(10, 3, 'Prenatal Follow-up',  'Clarisse Villanueva completed 2nd trimester prenatal checkup.',                1);

-- ----------------------------------------------------------------------------
-- 31. reports (10 records)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `reports`
(`report_id`, `user_id`, `report_type`, `report_description`) VALUES
(1,  1,  'Monthly Morbidity Report',       'Summary of top 10 outpatient diagnoses for Brgy. San Isidro.'),
(2,  2,  'EPI Immunization Coverage',      'Fully Immunized Child (FIC) percentage across Puroks 1-6.'),
(3,  5,  'Medicine Inventory Valuation',   'Current stock levels, low-stock items, and expiring batches.'),
(4,  3,  'Maternal & Prenatal Summary',    'Active pregnant mothers, TT coverage, and iron-folic distribution.'),
(5,  1,  'Senior Citizen Maintenance Log', 'Monthly hypertension and diabetes refill utilization report.'),
(6,  4,  'Household Masterlist Census',    'Updated count of registered households, children, and seniors.'),
(7,  5,  'Supplier Delivery Performance',  'On-time delivery and acceptance rates across 10 partner suppliers.'),
(8,  10, '4Ps & AICS Assistance Summary',  'Total financial and medical assistance disbursed by agency.'),
(9,  1,  'Staff Attendance Summary',       'Monthly duty logs, punctuality, and leave summary for clinic staff.'),
(10, 2,  'Animal Bite & Rabies Report',    'Category II/III bite cases and PVRV vaccine consumption.');

-- ----------------------------------------------------------------------------
-- 32. audit_logs (10 records — deterministic transaction_id for safe re-runs)
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `audit_logs`
(`audit_id`, `user_id`, `action_type`, `entity_name`, `record_id`, `old_value`, `new_value`, `remarks`, `transaction_id`, `admin_id`, `tab_name`, `clicked_action`, `note`) VALUES
(1,  1,  'APPROVE', 'households',         '1',  'Pending',   'Approved',  'Approved household HH-2026-0001',   'SEED-TXN-001', 1, 'Households',         'Edit',   'Verified barangay residency'),
(2,  2,  'CREATE',  'health_visits',      '1',  NULL,        'Visit #1',  'Logged outpatient fever consult',   'SEED-TXN-002', 1, 'Health Visits',      'Add',    'Routine consultation'),
(3,  2,  'CREATE',  'immunization_records','3', NULL,        'Dose 2',    'Administered Pentavalent Dose 2',   'SEED-TXN-003', 1, 'Immunization Records','Add',   'Batch PENTA-2026-03'),
(4,  5,  'UPDATE',  'medicine_inventory', '2',  '65.000',    '15.000',    'Updated Amoxicillin stock count',   'SEED-TXN-004', 1, 'Medicine Inventory', 'Edit',   'Triggered low-stock alert'),
(5,  5,  'CREATE',  'medicine_requests',  '8',  NULL,        'Pending',   'Submitted Amoxicillin reorder',     'SEED-TXN-005', 1, 'Medicine Requests',  'Add',    'Urgent restock'),
(6,  3,  'CREATE',  'health_visits',      '4',  NULL,        'Visit #4',  'Logged prenatal checkup',           'SEED-TXN-006', 1, 'Health Visits',      'Add',    '22 weeks AOG'),
(7,  4,  'CREATE',  'distribution_claims','1',  NULL,        'Claimed',   'Released Q1 hygiene kit',           'SEED-TXN-007', 1, 'Distribution Claims','Add',    'Signed logbook'),
(8,  1,  'APPROVE', 'medicine_requests',  '1',  'Pending',   'Approved',  'Approved Q3 replenishment',         'SEED-TXN-008', 1, 'Medicine Requests',  'Edit',   'Budget cleared'),
(9,  10, 'CREATE',  'reports',            '8',  NULL,        'Report #8', 'Generated 4Ps assistance summary',  'SEED-TXN-009', 1, 'Reports',            'Add',    'Submitted to Barangay Hall'),
(10, 1,  'LOGIN',   'users',              '1',  NULL,        NULL,        'Administrator demo session login',  'SEED-TXN-010', 1, 'Login',              'Sign in','System ready for demo');

COMMIT;
