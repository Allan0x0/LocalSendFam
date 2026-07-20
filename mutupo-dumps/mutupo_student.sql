/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: mutupo_student
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `mutupo_student`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mutupo_student` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `mutupo_student`;

--
-- Table structure for table `academic_sessions`
--

DROP TABLE IF EXISTS `academic_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'upcoming',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `academic_sessions_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_sessions`
--

LOCK TABLES `academic_sessions` WRITE;
/*!40000 ALTER TABLE `academic_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounting_settings`
--

DROP TABLE IF EXISTS `accounting_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounting_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` enum('string','integer','boolean','json') NOT NULL DEFAULT 'string',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounting_settings_setting_key_unique` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounting_settings`
--

LOCK TABLES `accounting_settings` WRITE;
/*!40000 ALTER TABLE `accounting_settings` DISABLE KEYS */;
INSERT INTO `accounting_settings` VALUES
(1,'results_fees_tolerance','0','string','Max outstanding balance (in the accounting currency) a student may carry and still see released results. 0 = must be fully cleared.','2026-07-18 17:13:20','2026-07-18 17:13:20'),
(2,'clearance_tolerance','0','string','Max outstanding balance a student may carry and still pass the finance clearance item. 0 = must be fully cleared.','2026-07-18 17:13:20','2026-07-18 17:13:20');
/*!40000 ALTER TABLE `accounting_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admission_settings`
--

DROP TABLE IF EXISTS `admission_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admission_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` enum('string','integer','boolean','json') NOT NULL DEFAULT 'boolean',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admission_settings_setting_key_unique` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admission_settings`
--

LOCK TABLES `admission_settings` WRITE;
/*!40000 ALTER TABLE `admission_settings` DISABLE KEYS */;
INSERT INTO `admission_settings` VALUES
(1,'undergraduate_applications_open','1','boolean','Whether undergraduate applicants can start new applications.','2026-07-07 18:08:36','2026-07-07 18:26:51'),
(2,'postgraduate_applications_open','1','boolean','Whether postgraduate applicants can start new applications.','2026-07-07 18:08:36','2026-07-07 18:08:36'),
(3,'selection_open','1','boolean','Whether student selection (HOD recommend / Admissions finalize) is open.','2026-07-07 18:08:36','2026-07-17 10:36:31');
/*!40000 ALTER TABLE `admission_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admissions`
--

DROP TABLE IF EXISTS `admissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `admissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_number` varchar(50) NOT NULL,
  `applicant_name` varchar(191) NOT NULL,
  `applicant_email` varchar(191) NOT NULL,
  `programme_id` bigint(20) unsigned NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_by` bigint(20) unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admissions_application_number_unique` (`application_number`),
  KEY `admissions_status_index` (`status`),
  KEY `admissions_programme_id_index` (`programme_id`),
  KEY `admissions_created_at_index` (`created_at`),
  KEY `admissions_application_number_index` (`application_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admissions`
--

LOCK TABLES `admissions` WRITE;
/*!40000 ALTER TABLE `admissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `admissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_clearance_items`
--

DROP TABLE IF EXISTS `application_clearance_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_clearance_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `item` enum('documents','eligibility','fee') NOT NULL,
  `status` enum('pending','cleared','rejected') NOT NULL DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `cleared_by` bigint(20) unsigned DEFAULT NULL,
  `cleared_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_clearance_items_application_id_item_unique` (`application_id`,`item`),
  CONSTRAINT `application_clearance_items_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_clearance_items`
--

LOCK TABLES `application_clearance_items` WRITE;
/*!40000 ALTER TABLE `application_clearance_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_clearance_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_documents`
--

DROP TABLE IF EXISTS `application_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `document_type` varchar(50) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_size` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `application_documents_application_id_foreign` (`application_id`),
  CONSTRAINT `application_documents_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_documents`
--

LOCK TABLES `application_documents` WRITE;
/*!40000 ALTER TABLE `application_documents` DISABLE KEYS */;
INSERT INTO `application_documents` VALUES
(1,6,'id_copy','application-documents/6/ONb2n6hkhwnLhIYCiiyJ9ThD13NB0ROEguMzED8l.pdf','Musasa_Projects-Statement (3).pdf',33576,'2026-07-07 19:25:25','2026-07-07 19:25:25'),
(2,6,'birth_certificate','application-documents/6/ciW68Esqm9WaMXvQmHUiSWn9SG4WyK6PgpvPGZZA.pdf','Musasa_Projects-Statement (3).pdf',33576,'2026-07-07 19:25:33','2026-07-07 19:25:33'),
(3,10,'a_level_certificate','application-documents/10/a-level-certificate.pdf','a-level-certificate.pdf',55,'2026-07-16 11:24:02','2026-07-16 11:24:02'),
(4,10,'national_id','application-documents/10/national-id.jpg','national-id.jpg',37,'2026-07-16 11:24:02','2026-07-16 11:24:02'),
(5,11,'a_level_certificate','application-documents/11/a-level-certificate.pdf','a-level-certificate.pdf',55,'2026-07-16 11:24:02','2026-07-16 11:24:02'),
(6,12,'a_level_certificate','application-documents/12/a-level-certificate.pdf','a-level-certificate.pdf',55,'2026-07-16 11:24:02','2026-07-16 11:24:02');
/*!40000 ALTER TABLE `application_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_payments`
--

DROP TABLE IF EXISTS `application_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `merchant_reference` varchar(40) NOT NULL,
  `channel` enum('ecocash','visa') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'USD',
  `status` enum('pending','paid','failed','cancelled') NOT NULL DEFAULT 'pending',
  `paynow_reference` varchar(80) DEFAULT NULL,
  `paynow_poll_url` text DEFAULT NULL,
  `payer_phone` varchar(30) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_payments_merchant_reference_unique` (`merchant_reference`),
  KEY `application_payments_application_id_index` (`application_id`),
  KEY `application_payments_status_index` (`status`),
  CONSTRAINT `application_payments_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_payments`
--

LOCK TABLES `application_payments` WRITE;
/*!40000 ALTER TABLE `application_payments` DISABLE KEYS */;
INSERT INTO `application_payments` VALUES
(1,6,'APP-TB0D1ASTPLHB','ecocash',40.00,'USD','failed',NULL,NULL,'0773618566',NULL,'2026-07-07 19:26:07','2026-07-07 19:26:07'),
(2,6,'APP-S26YSXCEBPUX','ecocash',40.00,'USD','failed',NULL,NULL,'0773618566',NULL,'2026-07-07 19:26:18','2026-07-07 19:26:18'),
(3,6,'APP-QMHTBBEXAQ8W','ecocash',40.00,'USD','failed',NULL,NULL,'0773618566',NULL,'2026-07-07 19:27:00','2026-07-07 19:27:01');
/*!40000 ALTER TABLE `application_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_qualifications`
--

DROP TABLE IF EXISTS `application_qualifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_qualifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `institution` varchar(200) NOT NULL,
  `qualification` varchar(100) NOT NULL,
  `subjects` varchar(255) DEFAULT NULL,
  `grades` varchar(255) DEFAULT NULL,
  `year_completed` year(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `application_qualifications_application_id_foreign` (`application_id`),
  CONSTRAINT `application_qualifications_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_qualifications`
--

LOCK TABLES `application_qualifications` WRITE;
/*!40000 ALTER TABLE `application_qualifications` DISABLE KEYS */;
INSERT INTO `application_qualifications` VALUES
(1,2,'Prince Edward High School','A-Level','Mathematics, Physics','A, B',2025,'2026-06-18 06:56:24','2026-06-18 06:56:24'),
(2,3,'Churchill High School','A-Level','Mathematics, Physics, Chemistry','A, A, B',2025,'2026-06-18 06:57:32','2026-06-18 06:57:32'),
(3,3,'Churchill High School','O-Level','Mathematics, English, Science, History, Geography','A, B, A, B, B',2023,'2026-06-18 06:57:32','2026-06-18 06:57:32'),
(4,7,'Zengeza High','A-Level',NULL,'Maths A, Accounts C, Computer Science A',2016,'2026-07-14 08:45:42','2026-07-14 08:45:42'),
(5,8,'HIT','Degree',NULL,NULL,2025,'2026-07-14 08:53:01','2026-07-14 08:53:01'),
(6,10,'Prince Edward High School','A Level','Mathematics, Accounting, Economics','A, B, B',2025,'2026-07-16 11:24:02','2026-07-16 11:24:02'),
(7,10,'Prince Edward High School','O Level','English, Mathematics, Science, Geography','A, A, B, B',2023,'2026-07-16 11:24:02','2026-07-16 11:24:02'),
(8,11,'Churchill Boys High','A Level','Mathematics, Computer Science, Economics','B, A, C',2025,'2026-07-16 11:24:02','2026-07-16 11:24:02'),
(9,12,'Girls High School','A Level','Accounting, Business Studies, Economics','A, A, B',2025,'2026-07-16 11:24:02','2026-07-16 11:24:02');
/*!40000 ALTER TABLE `application_qualifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_number` varchar(20) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `id_number` varchar(30) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `special_needs` tinyint(1) NOT NULL DEFAULT 0,
  `special_needs_details` text DEFAULT NULL,
  `nok_name` varchar(150) DEFAULT NULL,
  `nok_phone` varchar(30) DEFAULT NULL,
  `nok_relationship` varchar(60) DEFAULT NULL,
  `declaration_accepted_at` timestamp NULL DEFAULT NULL,
  `payment_status` enum('unpaid','pending','paid','failed') NOT NULL DEFAULT 'unpaid',
  `submitted_at` timestamp NULL DEFAULT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `programme_type` enum('ug','pg') DEFAULT NULL,
  `current_step` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `first_choice_programme_id` bigint(20) unsigned DEFAULT NULL,
  `second_choice_programme_id` bigint(20) unsigned DEFAULT NULL,
  `third_choice_programme_id` bigint(20) unsigned DEFAULT NULL,
  `intake_id` bigint(20) unsigned DEFAULT NULL,
  `intake` varchar(20) DEFAULT NULL,
  `status` enum('draft','submitted','under_review','hod_recommended','approved','rejected','offered','accepted','registered','enrolled') NOT NULL DEFAULT 'draft',
  `rejection_reason` text DEFAULT NULL,
  `admissions_override_reason` text DEFAULT NULL,
  `reviewed_by` bigint(20) unsigned DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applications_application_number_unique` (`application_number`),
  KEY `applications_status_index` (`status`),
  KEY `applications_email_index` (`email`),
  KEY `applications_intake_id_foreign` (`intake_id`),
  KEY `applications_user_id_status_index` (`user_id`,`status`),
  KEY `applications_payment_status_index` (`payment_status`),
  CONSTRAINT `applications_intake_id_foreign` FOREIGN KEY (`intake_id`) REFERENCES `intakes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES
(1,'APP-2026-0001',NULL,'Tendai','Moyo','tendai.test@example.com','+263771234567',NULL,NULL,'male',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,2,NULL,1,NULL,NULL,NULL,NULL,NULL,'registered',NULL,NULL,NULL,NULL,'2026-06-18 06:50:21','2026-07-14 19:31:46'),
(2,'APP-2026-0002',NULL,'Chipo','Dziva','chipo.dziva@example.com','+263772345678',NULL,NULL,'female',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,3,NULL,1,NULL,NULL,NULL,NULL,NULL,'registered',NULL,NULL,NULL,NULL,'2026-06-18 06:56:24','2026-07-14 19:31:46'),
(3,'APP-2026-0003',NULL,'Tatenda','Mutasa','tatenda.mutasa@example.com','+263773456789','63-2345678-T-63','2000-05-15','male',NULL,'123 Samora Machel Ave, Harare',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,4,NULL,1,NULL,NULL,NULL,NULL,'August 2026','registered',NULL,NULL,NULL,NULL,'2026-06-18 06:57:32','2026-07-14 19:31:46'),
(4,'APP-2026-0004',NULL,'Test','User','test2@example.com',NULL,NULL,NULL,'other',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,9,NULL,1,NULL,NULL,NULL,NULL,NULL,'registered',NULL,NULL,NULL,NULL,'2026-06-18 06:57:55','2026-07-14 19:32:16'),
(6,'HIT-2026-00005',150,'Remedy','Nguwi','nguwir@gmail.com','+263773618566','24-187101b12','2014-01-07','male','Zimbabwean','eeeeee','Harare','Harare','0263',0,NULL,'hjjjj','ghhhh','hjjjj','2026-07-12 18:41:06','failed',NULL,NULL,'ug',6,NULL,NULL,NULL,NULL,NULL,'draft',NULL,NULL,NULL,NULL,'2026-07-07 19:23:31','2026-07-12 18:41:06'),
(7,'HIT-2026-00006',NULL,'Charity','Makwara','cmakwara@hit.ac.zw','0782136852','63-2511346-G-83','2000-12-06','female','Zimbabwean','ghvshdre\n28747 hhbf',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,36,'ug',1,36,NULL,NULL,NULL,'2026 Semester 1','registered',NULL,NULL,NULL,NULL,'2026-07-14 08:45:42','2026-07-14 19:31:46'),
(8,'HIT-2026-00007',NULL,'Anotida','Chivore','achivore@hit.ac.zw','6ruyuiy','74 563477 G 83','2003-07-07','female','Zimbabwean','se4y5r',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,6,'pg',1,6,NULL,NULL,NULL,'2026 Semester 1','registered',NULL,NULL,NULL,NULL,'2026-07-14 08:53:01','2026-07-15 07:27:17'),
(10,'HIT-2026-90011',NULL,'Rudo','Makoni','rudo.makoni@demo.local',NULL,'63-9008007X',NULL,'Female',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'paid','2026-07-16 11:12:36',NULL,'ug',7,2,NULL,NULL,NULL,'August 2026','hod_recommended',NULL,NULL,NULL,NULL,'2026-07-16 11:12:36','2026-07-16 11:14:30'),
(11,'HIT-2026-90012',NULL,'Tafara','Sibanda','tafara.sibanda@demo.local',NULL,'63-1122334K',NULL,'Male',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'paid','2026-07-16 11:12:36',NULL,'ug',7,2,NULL,NULL,NULL,'August 2026','hod_recommended',NULL,NULL,NULL,NULL,'2026-07-16 11:12:36','2026-07-16 11:14:43'),
(12,'HIT-2026-90013',NULL,'Nyasha','Dube','nyasha.dube@demo.local',NULL,'63-5566778L',NULL,'Female',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,'paid','2026-07-16 11:12:36',NULL,'ug',7,2,NULL,NULL,NULL,'August 2026','hod_recommended',NULL,NULL,NULL,NULL,'2026-07-16 11:12:36','2026-07-16 11:14:45'),
(13,'HIT-2026-00011',168,'Remedy','Nguwi','remedy@ehost.co.zw','26377261000','24-187101b12','2022-12-01','male','Zimbabwean','5380 Gillingham Estate Dz ex Harare\nHarare','Harare','Harare','0263',0,NULL,NULL,NULL,NULL,NULL,'unpaid',NULL,NULL,'ug',2,NULL,NULL,NULL,NULL,NULL,'draft',NULL,NULL,NULL,NULL,'2026-07-17 10:18:13','2026-07-17 10:21:17');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_payments`
--

DROP TABLE IF EXISTS `bank_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reg_number` varchar(40) NOT NULL,
  `bank_reference` varchar(80) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'USD',
  `posted_at` datetime NOT NULL,
  `session_ref` varchar(40) DEFAULT NULL,
  `source` varchar(20) NOT NULL DEFAULT 'ndarama',
  `raw` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`raw`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bank_payments_bank_reference_unique` (`bank_reference`),
  KEY `bank_payments_reg_number_index` (`reg_number`),
  KEY `bank_payments_reg_number_session_ref_index` (`reg_number`,`session_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_payments`
--

LOCK TABLES `bank_payments` WRITE;
/*!40000 ALTER TABLE `bank_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clearance_items`
--

DROP TABLE IF EXISTS `clearance_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clearance_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `department` varchar(30) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `notes` varchar(255) DEFAULT NULL,
  `cleared_by` bigint(20) unsigned DEFAULT NULL,
  `cleared_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clearance_items_student_id_department_unique` (`student_id`,`department`),
  CONSTRAINT `clearance_items_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clearance_items`
--

LOCK TABLES `clearance_items` WRITE;
/*!40000 ALTER TABLE `clearance_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `clearance_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_invoices`
--

DROP TABLE IF EXISTS `fee_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_invoices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `registration_id` bigint(20) unsigned DEFAULT NULL,
  `invoice_number` varchar(40) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `amount_paid` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(20) NOT NULL DEFAULT 'unpaid',
  `fee_type` varchar(20) NOT NULL DEFAULT 'tuition',
  `due_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fee_invoices_invoice_number_unique` (`invoice_number`),
  KEY `fee_invoices_registration_id_foreign` (`registration_id`),
  KEY `fee_invoices_student_id_index` (`student_id`),
  KEY `fee_invoices_fee_type_index` (`fee_type`),
  CONSTRAINT `fee_invoices_registration_id_foreign` FOREIGN KEY (`registration_id`) REFERENCES `student_registrations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fee_invoices_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_invoices`
--

LOCK TABLES `fee_invoices` WRITE;
/*!40000 ALTER TABLE `fee_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_payment_transactions`
--

DROP TABLE IF EXISTS `fee_payment_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_payment_transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fee_invoice_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned NOT NULL,
  `reg_number` varchar(40) DEFAULT NULL,
  `payer_email` varchar(255) DEFAULT NULL,
  `merchant_reference` varchar(40) NOT NULL,
  `channel` enum('ecocash','visa') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'USD',
  `status` enum('pending','paid','failed','cancelled') NOT NULL DEFAULT 'pending',
  `paynow_reference` varchar(80) DEFAULT NULL,
  `paynow_poll_url` text DEFAULT NULL,
  `payer_phone` varchar(30) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `settled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fee_payment_transactions_merchant_reference_unique` (`merchant_reference`),
  KEY `fee_payment_transactions_fee_invoice_id_foreign` (`fee_invoice_id`),
  KEY `fee_payment_transactions_student_id_index` (`student_id`),
  KEY `fee_payment_transactions_status_index` (`status`),
  CONSTRAINT `fee_payment_transactions_fee_invoice_id_foreign` FOREIGN KEY (`fee_invoice_id`) REFERENCES `fee_invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_payment_transactions`
--

LOCK TABLES `fee_payment_transactions` WRITE;
/*!40000 ALTER TABLE `fee_payment_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_payment_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_payments`
--

DROP TABLE IF EXISTS `fee_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fee_invoice_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `method` varchar(30) NOT NULL DEFAULT 'cash',
  `reference` varchar(60) DEFAULT NULL,
  `paid_at` datetime NOT NULL,
  `recorded_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fee_payments_fee_invoice_id_index` (`fee_invoice_id`),
  CONSTRAINT `fee_payments_fee_invoice_id_foreign` FOREIGN KEY (`fee_invoice_id`) REFERENCES `fee_invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_payments`
--

LOCK TABLES `fee_payments` WRITE;
/*!40000 ALTER TABLE `fee_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_structures`
--

DROP TABLE IF EXISTS `fee_structures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_structures` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `fee_type` varchar(20) NOT NULL,
  `study_level` varchar(30) DEFAULT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'USD',
  `description` varchar(191) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fee_structures_fee_type_study_level_is_active_index` (`fee_type`,`study_level`,`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_structures`
--

LOCK TABLES `fee_structures` WRITE;
/*!40000 ALTER TABLE `fee_structures` DISABLE KEYS */;
INSERT INTO `fee_structures` VALUES
(1,'application','undergraduate',NULL,40.00,'USD',NULL,1,'2026-07-07 18:26:19','2026-07-07 18:26:19');
/*!40000 ALTER TABLE `fee_structures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees`
--

DROP TABLE IF EXISTS `fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `name` varchar(100) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `session_id` bigint(20) unsigned DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fees_code_unique` (`code`),
  KEY `fees_session_id_foreign` (`session_id`),
  CONSTRAINT `fees_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `academic_sessions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees`
--

LOCK TABLES `fees` WRITE;
/*!40000 ALTER TABLE `fees` DISABLE KEYS */;
/*!40000 ALTER TABLE `fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graduation_ceremonies`
--

DROP TABLE IF EXISTS `graduation_ceremonies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `graduation_ceremonies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `ceremony_date` date NOT NULL,
  `venue` varchar(150) DEFAULT NULL,
  `session_ref` varchar(40) DEFAULT NULL,
  `status` enum('scheduled','completed','cancelled') NOT NULL DEFAULT 'scheduled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `graduation_ceremonies_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graduation_ceremonies`
--

LOCK TABLES `graduation_ceremonies` WRITE;
/*!40000 ALTER TABLE `graduation_ceremonies` DISABLE KEYS */;
/*!40000 ALTER TABLE `graduation_ceremonies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graduation_rsvps`
--

DROP TABLE IF EXISTS `graduation_rsvps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `graduation_rsvps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ceremony_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned NOT NULL,
  `rsvp` enum('pending','attending','not_attending') NOT NULL DEFAULT 'pending',
  `attended` tinyint(1) NOT NULL DEFAULT 0,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `graduation_rsvps_ceremony_id_student_id_unique` (`ceremony_id`,`student_id`),
  KEY `graduation_rsvps_student_id_index` (`student_id`),
  CONSTRAINT `graduation_rsvps_ceremony_id_foreign` FOREIGN KEY (`ceremony_id`) REFERENCES `graduation_ceremonies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graduation_rsvps`
--

LOCK TABLES `graduation_rsvps` WRITE;
/*!40000 ALTER TABLE `graduation_rsvps` DISABLE KEYS */;
/*!40000 ALTER TABLE `graduation_rsvps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intakes`
--

DROP TABLE IF EXISTS `intakes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `intakes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` bigint(20) unsigned NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `max_students` smallint(5) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `intakes_code_unique` (`code`),
  KEY `intakes_session_id_foreign` (`session_id`),
  CONSTRAINT `intakes_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `academic_sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intakes`
--

LOCK TABLES `intakes` WRITE;
/*!40000 ALTER TABLE `intakes` DISABLE KEYS */;
/*!40000 ALTER TABLE `intakes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migration_batch_tracking`
--

DROP TABLE IF EXISTS `migration_batch_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_batch_tracking` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `total_legacy_rows` bigint(20) unsigned NOT NULL DEFAULT 0,
  `migrated_rows` bigint(20) unsigned NOT NULL DEFAULT 0,
  `last_synced_at` timestamp NULL DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `error_log` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migration_batch_tracking`
--

LOCK TABLES `migration_batch_tracking` WRITE;
/*!40000 ALTER TABLE `migration_batch_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `migration_batch_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'2025_01_01_000001_create_users_table',1),
(2,'2025_01_01_000002_create_personal_access_tokens_table',1),
(3,'2025_01_01_000003_create_students_table',1),
(4,'2025_01_01_000004_create_student_personal_details_table',1),
(5,'2025_01_01_000005_create_student_contacts_table',1),
(6,'2025_01_01_000006_create_student_next_of_kin_table',1),
(7,'2025_01_01_000007_create_migration_batch_tracking_table',1),
(8,'2025_01_01_000008_create_academic_sessions_table',1),
(9,'2025_01_01_000009_create_intakes_table',1),
(10,'2025_01_01_000010_create_student_registrations_table',1),
(11,'2025_01_01_000011_create_registered_modules_table',1),
(12,'2025_01_01_000012_create_module_marks_table',1),
(13,'2025_01_01_000013_create_grade_boundaries_table',1),
(14,'2026_05_20_103906_create_admissions_table',1),
(15,'2026_05_27_000001_add_performance_indexes_to_students_table',1),
(16,'2026_06_02_000001_add_assessment_fields_to_module_marks_table',1),
(17,'2026_06_17_000001_create_applications_table',1),
(18,'2026_06_17_000002_create_application_documents_table',1),
(19,'2026_06_17_000003_create_application_qualifications_table',1),
(20,'2026_06_18_000001_create_fees_table',2),
(21,'2026_06_18_000002_create_fee_invoices_table',2),
(22,'2026_06_18_000003_create_fee_payments_table',2),
(23,'2026_06_18_000004_create_clearance_items_table',2),
(24,'2026_07_03_000001_add_duration_tracking_to_students_table',2),
(25,'2026_07_03_000002_create_study_suspensions_table',2),
(26,'2026_07_07_000001_extend_applications_for_wizard',2),
(27,'2026_07_07_000002_create_application_payments_table',2),
(28,'2026_07_07_000003_create_admission_settings_table',2),
(29,'2026_07_07_000004_create_programme_selection_settings_table',2),
(30,'2026_07_08_000001_create_selection_recommendations_table',2),
(31,'2026_07_08_000002_create_fee_structures_table',2),
(32,'2026_07_08_000003_create_application_clearance_items_table',2),
(33,'2026_07_10_000001_drop_grade_boundaries_table',3),
(34,'2026_07_17_000001_backfill_programme_start_date_for_converted_students',4),
(35,'2026_07_17_000010_create_bank_payments_table',5),
(36,'2026_07_17_000011_create_fee_payment_transactions_table',5),
(37,'2026_07_17_000012_add_published_to_students_to_module_marks_table',5),
(38,'2026_07_17_000013_add_fee_type_to_fee_invoices_table',5),
(39,'2026_07_17_000014_create_graduation_ceremonies_table',5),
(40,'2026_07_17_000015_create_graduation_rsvps_table',5),
(41,'2026_07_17_000016_add_decision_to_module_marks_table',5),
(42,'2026_07_18_000001_widen_fee_structures_fee_type_and_study_level',6),
(43,'2026_07_18_000002_create_accounting_settings_table',7);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_marks`
--

DROP TABLE IF EXISTS `module_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_marks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `registered_module_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned NOT NULL,
  `module_code` varchar(20) NOT NULL,
  `assessment_type` enum('coursework','exam','supplementary') DEFAULT NULL,
  `coursework_mark` decimal(5,2) DEFAULT NULL,
  `exam_mark` decimal(5,2) DEFAULT NULL,
  `final_mark` decimal(5,2) DEFAULT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `decision` varchar(20) DEFAULT NULL,
  `status` enum('pending','submitted','approved','rejected') NOT NULL DEFAULT 'pending',
  `published_to_students` tinyint(1) NOT NULL DEFAULT 0,
  `published_to_students_at` timestamp NULL DEFAULT NULL,
  `submitted_by` varchar(100) DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_by` varchar(100) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_by` varchar(100) DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `module_marks_registered_module_id_unique` (`registered_module_id`),
  KEY `module_marks_student_id_foreign` (`student_id`),
  CONSTRAINT `module_marks_registered_module_id_foreign` FOREIGN KEY (`registered_module_id`) REFERENCES `registered_modules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `module_marks_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_marks`
--

LOCK TABLES `module_marks` WRITE;
/*!40000 ALTER TABLE `module_marks` DISABLE KEYS */;
/*!40000 ALTER TABLE `module_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programme_selection_settings`
--

DROP TABLE IF EXISTS `programme_selection_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme_selection_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `programme_id` bigint(20) unsigned NOT NULL,
  `is_open` tinyint(1) NOT NULL DEFAULT 1,
  `updated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programme_selection_settings_programme_id_unique` (`programme_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme_selection_settings`
--

LOCK TABLES `programme_selection_settings` WRITE;
/*!40000 ALTER TABLE `programme_selection_settings` DISABLE KEYS */;
INSERT INTO `programme_selection_settings` VALUES
(1,40,1,140,'2026-07-14 09:23:40','2026-07-14 09:44:25'),
(2,38,1,140,'2026-07-14 09:44:40','2026-07-14 09:50:04');
/*!40000 ALTER TABLE `programme_selection_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registered_modules`
--

DROP TABLE IF EXISTS `registered_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `registered_modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `registration_id` bigint(20) unsigned NOT NULL,
  `module_code` varchar(20) NOT NULL,
  `module_name` varchar(100) NOT NULL,
  `credits` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `registered_modules_registration_id_module_code_unique` (`registration_id`,`module_code`),
  CONSTRAINT `registered_modules_registration_id_foreign` FOREIGN KEY (`registration_id`) REFERENCES `student_registrations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registered_modules`
--

LOCK TABLES `registered_modules` WRITE;
/*!40000 ALTER TABLE `registered_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `registered_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selection_recommendations`
--

DROP TABLE IF EXISTS `selection_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `selection_recommendations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `programme_id` bigint(20) unsigned NOT NULL,
  `department_id` bigint(20) unsigned NOT NULL,
  `recommended_by` bigint(20) unsigned NOT NULL,
  `recommendation` enum('accept','reject','waitlist') NOT NULL,
  `comments` text DEFAULT NULL,
  `recommended_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `selection_recommendations_application_id_unique` (`application_id`),
  KEY `selection_recommendations_department_id_index` (`department_id`),
  KEY `selection_recommendations_recommendation_index` (`recommendation`),
  CONSTRAINT `selection_recommendations_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selection_recommendations`
--

LOCK TABLES `selection_recommendations` WRITE;
/*!40000 ALTER TABLE `selection_recommendations` DISABLE KEYS */;
INSERT INTO `selection_recommendations` VALUES
(2,10,2,2,142,'accept',NULL,'2026-07-16 11:14:30','2026-07-16 11:14:30','2026-07-16 11:14:30'),
(3,11,2,2,142,'waitlist',NULL,'2026-07-16 11:14:43','2026-07-16 11:14:43','2026-07-16 11:14:43'),
(4,12,2,2,142,'accept',NULL,'2026-07-16 11:14:45','2026-07-16 11:14:45','2026-07-16 11:14:45');
/*!40000 ALTER TABLE `selection_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_contacts`
--

DROP TABLE IF EXISTS `student_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_contacts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `contact_type` varchar(30) NOT NULL,
  `contact_name` varchar(150) NOT NULL,
  `relationship` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_contacts_student_id_foreign` (`student_id`),
  CONSTRAINT `student_contacts_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_contacts`
--

LOCK TABLES `student_contacts` WRITE;
/*!40000 ALTER TABLE `student_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_next_of_kin`
--

DROP TABLE IF EXISTS `student_next_of_kin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_next_of_kin` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `name` varchar(150) NOT NULL,
  `relationship` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_next_of_kin_student_id_foreign` (`student_id`),
  CONSTRAINT `student_next_of_kin_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_next_of_kin`
--

LOCK TABLES `student_next_of_kin` WRITE;
/*!40000 ALTER TABLE `student_next_of_kin` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_next_of_kin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_personal_details`
--

DROP TABLE IF EXISTS `student_personal_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_personal_details` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `id_number` varchar(50) DEFAULT NULL,
  `passport_number` varchar(50) DEFAULT NULL,
  `home_address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_personal_details_student_id_foreign` (`student_id`),
  CONSTRAINT `student_personal_details_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_personal_details`
--

LOCK TABLES `student_personal_details` WRITE;
/*!40000 ALTER TABLE `student_personal_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_personal_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_registrations`
--

DROP TABLE IF EXISTS `student_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_registrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `session_id` bigint(20) unsigned NOT NULL,
  `intake_id` bigint(20) unsigned DEFAULT NULL,
  `registration_date` date NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_registrations_student_id_session_id_unique` (`student_id`,`session_id`),
  KEY `student_registrations_session_id_foreign` (`session_id`),
  KEY `student_registrations_intake_id_foreign` (`intake_id`),
  CONSTRAINT `student_registrations_intake_id_foreign` FOREIGN KEY (`intake_id`) REFERENCES `intakes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `student_registrations_session_id_foreign` FOREIGN KEY (`session_id`) REFERENCES `academic_sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_registrations_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_registrations`
--

LOCK TABLES `student_registrations` WRITE;
/*!40000 ALTER TABLE `student_registrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `reg_number` varchar(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(60) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `intake_year` smallint(5) unsigned DEFAULT NULL,
  `programme_start_date` date DEFAULT NULL,
  `duration_status` varchar(20) DEFAULT NULL,
  `deregistration_flagged_at` timestamp NULL DEFAULT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `students_reg_number_unique` (`reg_number`),
  UNIQUE KEY `students_email_unique` (`email`),
  KEY `idx_students_created_intake` (`created_at`,`intake_year`),
  KEY `idx_students_gender` (`gender`),
  KEY `idx_students_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES
(8,'H260001J','Tendai','Moyo','tendai.test@example.com',NULL,NULL,NULL,NULL,'active',2026,'2026-07-14',NULL,NULL,2,'2026-07-14 19:31:46','2026-07-15 12:36:07',NULL),
(9,'H260002K','Chipo','Dziva','chipo.dziva@example.com',NULL,NULL,NULL,NULL,'active',2026,'2026-07-14',NULL,NULL,3,'2026-07-14 19:31:46','2026-07-15 12:36:07',NULL),
(10,'H260003L','Tatenda','Mutasa','tatenda.mutasa@example.com',NULL,NULL,NULL,NULL,'active',2026,'2026-07-14',NULL,NULL,4,'2026-07-14 19:31:46','2026-07-15 12:36:07',NULL),
(11,'H260004M','Charity','Makwara','cmakwara@hit.ac.zw',NULL,NULL,NULL,NULL,'active',2026,'2026-07-14',NULL,NULL,36,'2026-07-14 19:31:46','2026-07-15 12:36:07',NULL),
(13,'H260005N','Test','User','test2@example.com',NULL,NULL,NULL,NULL,'active',2026,'2026-07-14',NULL,NULL,9,'2026-07-14 19:32:16','2026-07-15 12:36:07',NULL),
(14,'H260006O','Anotida','Chivore','achivore@hit.ac.zw',NULL,NULL,NULL,NULL,'active',2026,'2026-07-15',NULL,NULL,6,'2026-07-15 07:27:17','2026-07-15 12:36:07',NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_suspensions`
--

DROP TABLE IF EXISTS `study_suspensions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_suspensions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `reason` varchar(255) DEFAULT NULL,
  `approved_by` varchar(128) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `study_suspensions_student_id_status_index` (`student_id`,`status`),
  CONSTRAINT `study_suspensions_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_suspensions`
--

LOCK TABLES `study_suspensions` WRITE;
/*!40000 ALTER TABLE `study_suspensions` DISABLE KEYS */;
/*!40000 ALTER TABLE `study_suspensions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'viewer',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'mutupo_student'
--

--
-- Dumping routines for database 'mutupo_student'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-20 12:16:16
