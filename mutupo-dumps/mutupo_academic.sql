/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: mutupo_academic
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
-- Current Database: `mutupo_academic`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mutupo_academic` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `mutupo_academic`;

--
-- Table structure for table `applicants`
--

DROP TABLE IF EXISTS `applicants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_number` varchar(191) NOT NULL,
  `application_period` varchar(32) NOT NULL,
  `title` varchar(10) DEFAULT NULL,
  `surname` varchar(191) NOT NULL,
  `first_names` varchar(191) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `national_id` varchar(30) DEFAULT NULL,
  `passport_number` varchar(30) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'Zimbabwe',
  `entry_type` enum('normal','mature','transfer','international') NOT NULL DEFAULT 'normal',
  `entry_qualification` varchar(191) DEFAULT NULL,
  `study_choices` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`study_choices`)),
  `previous_education` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`previous_education`)),
  `status` enum('pending','under_review','accepted','rejected','waitlisted','enrolled') NOT NULL DEFAULT 'pending',
  `acceptance_code` varchar(20) DEFAULT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicants_application_number_unique` (`application_number`),
  UNIQUE KEY `applicants_acceptance_code_unique` (`acceptance_code`),
  KEY `applicants_programme_id_foreign` (`programme_id`),
  CONSTRAINT `applicants_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicants`
--

LOCK TABLES `applicants` WRITE;
/*!40000 ALTER TABLE `applicants` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment_types`
--

DROP TABLE IF EXISTS `assessment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `programme_id` bigint(20) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) NOT NULL,
  `weight_percentage` decimal(5,2) NOT NULL,
  `is_exam` tinyint(1) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assessment_types_programme_id_foreign` (`programme_id`),
  CONSTRAINT `assessment_types_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_types`
--

LOCK TABLES `assessment_types` WRITE;
/*!40000 ALTER TABLE `assessment_types` DISABLE KEYS */;
INSERT INTO `assessment_types` VALUES
(1,30,'Practical','practical',20.00,0,NULL,'2026-07-20 07:58:42','2026-07-20 07:58:42'),
(2,30,'Test','test',20.00,0,NULL,'2026-07-20 07:58:57','2026-07-20 07:58:57'),
(3,30,'Assignment','assignment',30.00,0,NULL,'2026-07-20 07:59:08','2026-07-20 07:59:08'),
(4,30,'Exam','exam',30.00,1,NULL,'2026-07-20 07:59:35','2026-07-20 07:59:35');
/*!40000 ALTER TABLE `assessment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_slips`
--

DROP TABLE IF EXISTS `attendance_slips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_slips` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `semester` varchar(32) NOT NULL,
  `programme_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `student_count` int(10) unsigned NOT NULL DEFAULT 0,
  `file_path` varchar(191) DEFAULT NULL,
  `generated_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attendance_slips_programme_id_foreign` (`programme_id`),
  KEY `attendance_slips_module_id_foreign` (`module_id`),
  KEY `attendance_slips_generated_by_foreign` (`generated_by`),
  CONSTRAINT `attendance_slips_generated_by_foreign` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`),
  CONSTRAINT `attendance_slips_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `attendance_slips_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_slips`
--

LOCK TABLES `attendance_slips` WRITE;
/*!40000 ALTER TABLE `attendance_slips` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_slips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_decisions`
--

DROP TABLE IF EXISTS `board_decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_decisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `decision_date` date NOT NULL,
  `meeting_id` bigint(20) unsigned DEFAULT NULL,
  `category` enum('policy','approval','directive','other') NOT NULL DEFAULT 'other',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `board_decisions_meeting_id_foreign` (`meeting_id`),
  KEY `board_decisions_decision_date_category_index` (`decision_date`,`category`),
  CONSTRAINT `board_decisions_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `board_meetings` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_decisions`
--

LOCK TABLES `board_decisions` WRITE;
/*!40000 ALTER TABLE `board_decisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_meetings`
--

DROP TABLE IF EXISTS `board_meetings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `board_meetings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `venue` varchar(255) NOT NULL,
  `agenda` text DEFAULT NULL,
  `status` enum('scheduled','completed','cancelled') NOT NULL DEFAULT 'scheduled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `board_meetings_date_status_index` (`date`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_meetings`
--

LOCK TABLES `board_meetings` WRITE;
/*!40000 ALTER TABLE `board_meetings` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_meetings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_exemptions`
--

DROP TABLE IF EXISTS `course_exemptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_exemptions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `source_institution` varchar(191) NOT NULL,
  `source_course_title` varchar(191) NOT NULL,
  `mark` decimal(5,2) NOT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `syllabus_match_pct` decimal(5,2) NOT NULL,
  `examined_on` date NOT NULL,
  `active_experience` tinyint(1) NOT NULL DEFAULT 0,
  `evidence_ref` varchar(255) DEFAULT NULL,
  `semester_start_date` date NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'pending_department',
  `requires_senate` tinyint(1) NOT NULL DEFAULT 0,
  `department_reviewed_by` varchar(191) DEFAULT NULL,
  `department_reviewed_at` timestamp NULL DEFAULT NULL,
  `school_reviewed_by` varchar(191) DEFAULT NULL,
  `school_reviewed_at` timestamp NULL DEFAULT NULL,
  `senate_reviewed_by` varchar(191) DEFAULT NULL,
  `senate_reviewed_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_exemptions_module_id_foreign` (`module_id`),
  KEY `course_exemptions_student_id_status_index` (`student_id`,`status`),
  CONSTRAINT `course_exemptions_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_exemptions`
--

LOCK TABLES `course_exemptions` WRITE;
/*!40000 ALTER TABLE `course_exemptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_exemptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `current_sessions`
--

DROP TABLE IF EXISTS `current_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `current_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `current_sessions_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `current_sessions`
--

LOCK TABLES `current_sessions` WRITE;
/*!40000 ALTER TABLE `current_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `current_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `faculty_id` bigint(20) unsigned NOT NULL,
  `code` varchar(16) NOT NULL,
  `name` varchar(128) NOT NULL,
  `hod_name` varchar(128) DEFAULT NULL,
  `hod_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `departments_code_unique` (`code`),
  KEY `departments_faculty_id_foreign` (`faculty_id`),
  KEY `departments_hod_id_foreign` (`hod_id`),
  CONSTRAINT `departments_faculty_id_foreign` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`) ON DELETE CASCADE,
  CONSTRAINT `departments_hod_id_foreign` FOREIGN KEY (`hod_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES
(1,1,'BMS-EC','Electronic Commerce',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(2,1,'BMS-FE','Financial Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(3,1,'BMS-FAA','Forensic Accounting and Auditing',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(4,2,'EST-CPE','Chemical and Process Systems Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(5,2,'EST-EE','Electronic Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(6,2,'EST-IME','Industrial and Manufacturing Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(7,2,'EST-PTE','Polymer Technology and Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(8,2,'EST-MTE','Mechatronics Technology and Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(9,2,'EST-BME','Biomedical Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(10,3,'IST-CS','Computer Science',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(11,3,'IST-IT','Information Technology',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(12,3,'IST-ISA','Information Security and Assurance',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(13,3,'IST-SE','Software Engineering',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(14,4,'SST-BT','Biotechnology',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(15,4,'SST-FPT','Food Processing Technology',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(16,5,'AHS-DR','Diagnostic Radiography',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(17,5,'AHS-TR','Therapeutic Radiography',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(18,5,'AHS-PH','Pharmacy',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_results`
--

DROP TABLE IF EXISTS `exam_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_results` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `semester` varchar(32) NOT NULL,
  `coursework_mark` decimal(5,2) DEFAULT NULL,
  `exam_mark` decimal(5,2) DEFAULT NULL,
  `final_mark` decimal(5,2) DEFAULT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `decision` enum('Pass','Fail','Supplementary','Repeat','Absent','Deferred','Withheld','Carry') DEFAULT NULL,
  `decision_status` enum('proposed','ratified') DEFAULT NULL,
  `proposed_by` bigint(20) unsigned DEFAULT NULL,
  `ratified_by` bigint(20) unsigned DEFAULT NULL,
  `ratified_meeting_id` bigint(20) unsigned DEFAULT NULL,
  `ratified_at` timestamp NULL DEFAULT NULL,
  `embossment_status` enum('pending','approved','embossed') NOT NULL DEFAULT 'pending',
  `embossed_at` timestamp NULL DEFAULT NULL,
  `published_to_students` tinyint(1) NOT NULL DEFAULT 0,
  `published_at` timestamp NULL DEFAULT NULL,
  `decided_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `exam_results_student_id_module_id_semester_unique` (`student_id`,`module_id`,`semester`),
  KEY `exam_results_module_id_foreign` (`module_id`),
  KEY `exam_results_decided_by_foreign` (`decided_by`),
  KEY `exam_results_ratified_meeting_id_foreign` (`ratified_meeting_id`),
  CONSTRAINT `exam_results_decided_by_foreign` FOREIGN KEY (`decided_by`) REFERENCES `users` (`id`),
  CONSTRAINT `exam_results_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `exam_results_ratified_meeting_id_foreign` FOREIGN KEY (`ratified_meeting_id`) REFERENCES `board_meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `exam_results_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_results`
--

LOCK TABLES `exam_results` WRITE;
/*!40000 ALTER TABLE `exam_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_timetable_entries`
--

DROP TABLE IF EXISTS `exam_timetable_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_timetable_entries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `semester` varchar(32) NOT NULL,
  `exam_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `level` tinyint(3) unsigned DEFAULT NULL,
  `venue` varchar(191) NOT NULL,
  `invigilator` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_timetable_entries_module_id_foreign` (`module_id`),
  KEY `exam_timetable_entries_programme_id_foreign` (`programme_id`),
  CONSTRAINT `exam_timetable_entries_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`),
  CONSTRAINT `exam_timetable_entries_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_timetable_entries`
--

LOCK TABLES `exam_timetable_entries` WRITE;
/*!40000 ALTER TABLE `exam_timetable_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_timetable_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculties`
--

DROP TABLE IF EXISTS `faculties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `faculties` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(16) NOT NULL,
  `name` varchar(128) NOT NULL,
  `dean_name` varchar(128) DEFAULT NULL,
  `dean_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `faculties_code_unique` (`code`),
  KEY `faculties_dean_id_foreign` (`dean_id`),
  CONSTRAINT `faculties_dean_id_foreign` FOREIGN KEY (`dean_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculties`
--

LOCK TABLES `faculties` WRITE;
/*!40000 ALTER TABLE `faculties` DISABLE KEYS */;
INSERT INTO `faculties` VALUES
(1,'BMS','School of Business and Management Sciences',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(2,'EST','School of Engineering and Technology',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(3,'IST','School of Information Science and Technology',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(4,'SST','School of Industrial Sciences and Technology',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45'),
(5,'AHS','School of Allied Health Sciences',NULL,NULL,'2026-07-17 09:42:45','2026-07-17 09:42:45');
/*!40000 ALTER TABLE `faculties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graduands`
--

DROP TABLE IF EXISTS `graduands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `graduands` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `award_type` varchar(191) NOT NULL,
  `classification` varchar(191) DEFAULT NULL,
  `final_cgpa` decimal(4,2) DEFAULT NULL,
  `status` enum('candidate','conferred') NOT NULL DEFAULT 'candidate',
  `conferred_at` timestamp NULL DEFAULT NULL,
  `graduation_fee_paid_at` timestamp NULL DEFAULT NULL,
  `regulation_code` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `graduands_student_id_unique` (`student_id`),
  KEY `graduands_status_programme_id_index` (`status`,`programme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graduands`
--

LOCK TABLES `graduands` WRITE;
/*!40000 ALTER TABLE `graduands` DISABLE KEYS */;
/*!40000 ALTER TABLE `graduands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_approval_history`
--

DROP TABLE IF EXISTS `mark_approval_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_approval_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mark_approval_id` bigint(20) unsigned NOT NULL,
  `from_status` varchar(30) NOT NULL,
  `to_status` varchar(30) NOT NULL,
  `actor_id` bigint(20) unsigned DEFAULT NULL,
  `actor_name` varchar(150) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mark_approval_history_mark_approval_id_index` (`mark_approval_id`),
  CONSTRAINT `mark_approval_history_mark_approval_id_foreign` FOREIGN KEY (`mark_approval_id`) REFERENCES `mark_approvals` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_approval_history`
--

LOCK TABLES `mark_approval_history` WRITE;
/*!40000 ALTER TABLE `mark_approval_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `mark_approval_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_approvals`
--

DROP TABLE IF EXISTS `mark_approvals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_approvals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mark_ref` bigint(20) unsigned NOT NULL,
  `module_code` varchar(20) NOT NULL,
  `assessment_type` varchar(30) DEFAULT NULL,
  `student_ref` bigint(20) unsigned NOT NULL,
  `student_number` varchar(30) DEFAULT NULL,
  `student_name` varchar(150) DEFAULT NULL,
  `lecturer_name` varchar(150) DEFAULT NULL,
  `final_mark` decimal(5,2) DEFAULT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `status` enum('pending','pending_dean','pending_exams_office','pending_board','pending_registry','approved','published','rejected') NOT NULL DEFAULT 'pending',
  `board_meeting_id` bigint(20) unsigned DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_by` varchar(100) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_by` varchar(100) DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `chairperson_approved_by` varchar(100) DEFAULT NULL,
  `chairperson_approved_at` timestamp NULL DEFAULT NULL,
  `dean_approved_by` varchar(100) DEFAULT NULL,
  `dean_approved_at` timestamp NULL DEFAULT NULL,
  `exams_verified_by` varchar(100) DEFAULT NULL,
  `exams_verified_at` timestamp NULL DEFAULT NULL,
  `board_approved_by` varchar(100) DEFAULT NULL,
  `board_approved_at` timestamp NULL DEFAULT NULL,
  `published_by` varchar(100) DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mark_approvals_mark_ref_unique` (`mark_ref`),
  KEY `mark_approvals_status_index` (`status`),
  KEY `module_status_idx` (`module_code`,`status`),
  KEY `mark_approvals_board_meeting_id_foreign` (`board_meeting_id`),
  CONSTRAINT `mark_approvals_board_meeting_id_foreign` FOREIGN KEY (`board_meeting_id`) REFERENCES `board_meetings` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_approvals`
--

LOCK TABLES `mark_approvals` WRITE;
/*!40000 ALTER TABLE `mark_approvals` DISABLE KEYS */;
INSERT INTO `mark_approvals` VALUES
(1,1,'ARG1101','practical',1,'H260001J','Ana Gusikowski','lecturer@hit.ac.zw',90.00,'A+','pending',NULL,'2026-07-20 07:58:48',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-20 07:58:42','2026-07-20 07:58:48'),
(2,2,'ARG1101','test',1,'H260001J','Ana Gusikowski','lecturer@hit.ac.zw',20.00,'F','pending',NULL,'2026-07-20 07:58:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-20 07:58:57','2026-07-20 07:58:57'),
(3,3,'ARG1101','assignment',1,'H260001J','Ana Gusikowski','lecturer@hit.ac.zw',90.00,'A+','pending',NULL,'2026-07-20 07:59:08',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-20 07:59:08','2026-07-20 07:59:08'),
(4,4,'ARG1101','exam',1,'H260001J','Ana Gusikowski','lecturer@hit.ac.zw',80.00,'A','pending',NULL,'2026-07-20 07:59:35',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-20 07:59:35','2026-07-20 07:59:35');
/*!40000 ALTER TABLE `mark_approvals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'2025_01_01_000000_create_users_table',1),
(2,'2025_01_01_000001_create_faculties_table',1),
(3,'2025_01_01_000002_create_departments_table',1),
(4,'2025_01_01_000003_create_programmes_table',1),
(5,'2025_01_01_000004_create_modules_table',1),
(6,'2025_01_01_000005_create_programme_modules_table',1),
(7,'2026_05_28_000001_add_lecturer_id_to_modules_table',1),
(8,'2026_06_02_000001_add_dean_and_chairperson_ids',1),
(9,'2026_06_02_000002_create_module_assignments_table',1),
(10,'2026_06_02_000003_rename_chairperson_id_to_hod_id_on_departments',1),
(11,'2026_06_03_000001_create_mark_approvals_table',1),
(12,'2026_06_05_000001_add_exam_workflow_to_mark_approvals_table',1),
(13,'2026_06_05_000002_create_mark_approval_history_table',1),
(14,'2026_06_05_000003_add_workflow_roles_to_users_table',1),
(15,'2026_06_06_000001_create_board_meetings_table',1),
(16,'2026_06_06_000002_create_board_decisions_table',1),
(17,'2026_06_16_000001_create_applicants_table',1),
(18,'2026_06_16_000002_create_students_table',1),
(19,'2026_06_16_000003_create_exam_results_table',1),
(20,'2026_06_16_000004_create_exam_timetable_entries_table',1),
(21,'2026_06_16_000005_create_attendance_slips_table',1),
(22,'2026_06_17_000001_create_grade_mappings_table',1),
(23,'2026_06_17_000002_create_assessment_types_table',1),
(24,'2026_06_17_000003_create_module_assessments_table',1),
(25,'2026_06_17_000004_create_student_assessment_marks_table',1),
(26,'2026_06_17_000005_create_student_module_results_table',1),
(27,'2026_06_17_000006_create_student_semester_gpas_table',1),
(28,'2026_06_17_000007_create_student_cumulative_gpas_table',1),
(29,'2026_07_01_000001_create_regulations_table',1),
(30,'2026_07_01_000002_create_regulation_parameters_table',1),
(31,'2026_07_01_000003_create_regulation_bindings_table',1),
(32,'2026_07_06_000001_create_course_exemptions_table',1),
(33,'2026_07_06_000002_add_is_exempt_to_student_module_results_table',1),
(34,'2026_07_07_000001_add_study_level_to_programmes_table',1),
(35,'2026_07_08_000001_add_board_meeting_to_mark_approvals_table',1),
(36,'2026_07_08_000001_add_is_practical_to_modules_table',1),
(37,'2026_07_08_000002_add_exam_barred_and_incomplete_status_to_student_module_results_table',1),
(38,'2026_07_08_000003_create_student_module_attendances_table',1),
(39,'2026_07_08_000004_add_vc_office_role_to_users_table',1),
(40,'2026_07_10_000001_replace_grading_params_with_scales',1),
(41,'2026_07_10_000002_drop_grade_mappings_table',1),
(42,'2026_07_12_000001_add_regulation_id_to_modules_table',1),
(43,'2026_07_12_000002_add_school_scope_to_regulations_table',1),
(44,'2026_07_12_000003_add_entry_requirements_and_mode_to_programmes_table',1),
(45,'2026_07_15_000001_add_programme_id_to_regulations_table',1),
(46,'2026_07_15_000002_create_student_module_registrations_table',1),
(47,'2026_07_16_000001_add_manual_curation_to_student_module_registrations',1),
(49,'2026_07_17_000002_add_phd_to_programmes_study_level',1),
(50,'2026_07_17_000001_add_level_to_regulation_bindings_table',2),
(51,'2026_07_18_000001_create_programme_types_and_backfill',3),
(52,'2026_07_17_000001_create_graduands_table',4),
(53,'2026_07_17_000003_create_current_sessions_table',4),
(54,'2026_07_17_000004_add_carry_and_decision_lifecycle_to_exam_results_table',4),
(55,'2026_07_18_000001_add_published_to_students_to_exam_results_table',5),
(56,'2026_07_18_000003_create_study_levels_and_make_level_dynamic',6),
(57,'2026_07_18_000002_add_graduation_fee_paid_at_to_graduands_table',7),
(58,'2026_07_18_000004_create_programme_type_study_level_table',8);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_assessments`
--

DROP TABLE IF EXISTS `module_assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_assessments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(20) unsigned NOT NULL,
  `assessment_type_id` bigint(20) unsigned NOT NULL,
  `semester` varchar(10) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `max_marks` int(11) NOT NULL DEFAULT 100,
  `weight_percentage` decimal(5,2) NOT NULL,
  `due_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_assessments_module_id_foreign` (`module_id`),
  KEY `module_assessments_assessment_type_id_foreign` (`assessment_type_id`),
  CONSTRAINT `module_assessments_assessment_type_id_foreign` FOREIGN KEY (`assessment_type_id`) REFERENCES `assessment_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `module_assessments_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_assessments`
--

LOCK TABLES `module_assessments` WRITE;
/*!40000 ALTER TABLE `module_assessments` DISABLE KEYS */;
INSERT INTO `module_assessments` VALUES
(1,58,1,'1','2026',100,20.00,NULL,'2026-07-20 07:58:42','2026-07-20 07:58:42'),
(2,58,2,'1','2026',100,20.00,NULL,'2026-07-20 07:58:57','2026-07-20 07:58:57'),
(3,58,3,'1','2026',100,30.00,NULL,'2026-07-20 07:59:08','2026-07-20 07:59:08'),
(4,58,4,'1','2026',100,30.00,NULL,'2026-07-20 07:59:35','2026-07-20 07:59:35');
/*!40000 ALTER TABLE `module_assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_assignments`
--

DROP TABLE IF EXISTS `module_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `module_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(20) unsigned NOT NULL,
  `lecturer_id` bigint(20) unsigned DEFAULT NULL,
  `academic_year` smallint(5) unsigned NOT NULL,
  `semester` tinyint(3) unsigned NOT NULL,
  `assigned_by` bigint(20) unsigned DEFAULT NULL,
  `assigned_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `module_year_semester_unique` (`module_id`,`academic_year`,`semester`),
  KEY `module_assignments_assigned_by_foreign` (`assigned_by`),
  KEY `lecturer_year_idx` (`lecturer_id`,`academic_year`),
  CONSTRAINT `module_assignments_assigned_by_foreign` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `module_assignments_lecturer_id_foreign` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `module_assignments_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_assignments`
--

LOCK TABLES `module_assignments` WRITE;
/*!40000 ALTER TABLE `module_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `module_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `modules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(16) NOT NULL,
  `name` varchar(191) NOT NULL,
  `credits` tinyint(3) unsigned NOT NULL,
  `level` tinyint(3) unsigned NOT NULL,
  `regulation_id` bigint(20) unsigned DEFAULT NULL,
  `semester` tinyint(3) unsigned NOT NULL,
  `is_practical` tinyint(1) NOT NULL DEFAULT 0,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `lecturer_id` bigint(20) unsigned DEFAULT NULL,
  `prerequisites_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`prerequisites_json`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `modules_code_unique` (`code`),
  KEY `modules_department_id_foreign` (`department_id`),
  KEY `modules_regulation_id_foreign` (`regulation_id`),
  CONSTRAINT `modules_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `modules_regulation_id_foreign` FOREIGN KEY (`regulation_id`) REFERENCES `regulations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modules`
--

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;
INSERT INTO `modules` VALUES
(4,'EBE1102','Engineering Physics',12,1,4,1,1,9,7,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(5,'EBE1103','Engineering Chemistry',12,1,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(6,'EEE1102','Analogue Electronics',12,1,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(7,'EEE1103','Electronic Workshop and Production',10,1,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(8,'EIM1103','Engineering Drawing I',12,1,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(9,'HIT1101','Technopreneurship I',10,1,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(10,'HIT1102','Engineering Mathematics I',12,1,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(11,'EST1101','Technical Communication Skills',10,1,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(12,'EBE1201','Biochemistry',12,1,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(13,'EBE1202','Biophysics',12,1,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(14,'EEE1203','Network Theory and Analysis',10,1,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(15,'EEE1204','Digital Electronics',12,1,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(16,'EIM1203','Engineering Drawing II',12,1,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(17,'HIT1201','Technopreneurship II',10,1,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(18,'HIT1202','Engineering Mathematics II',12,1,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(19,'EEE1202','Computer Engineering and Programming',12,1,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(20,'EBE2102','Molecular Biology',12,2,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(21,'EBE2101','Human Anatomy and Physiology I',12,2,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(22,'EEE2102','Microcomputer Based Systems',12,2,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(23,'HIT2101','Technopreneurship III',10,2,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(24,'HIT2102','Statistics for Engineers',12,2,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(25,'EBE2201','Human Anatomy and Physiology II',12,2,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(26,'HIT2203','Big Data & Data Analytics',12,2,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(27,'EBE2202','Bioelectricity',12,2,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(28,'EEE2202','Digital Signal Processing',12,2,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(29,'HIT2201','Technopreneurship IV',10,2,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(30,'HIT2202','Engineering Mathematics III',12,2,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(31,'HIT0200','Team Project',15,2,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(32,'EBE3101','Biomaterials',12,3,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(33,'EBE3102','Biomechanics',12,3,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(34,'EBE3103','Biomedical Instrumentation I',12,3,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(35,'EBE3104','Embedded Systems in Healthcare',12,3,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(36,'EBE3105','Sensor Technology',12,3,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(37,'EBE3201','Tissue Engineering',12,3,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(38,'EBE3202','Biomedical Informatics',12,3,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(39,'EBE3203','Biomedical Instrumentation II',12,3,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(40,'EBE3204','Neural Systems in Medicine',12,3,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(41,'EBE3205','Engineering Management',10,3,4,2,0,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(42,'HIT0300','Team Project',15,3,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(43,'HIT0400','Design and Innovation Project',30,4,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(44,'HIT0401','Internship',120,4,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(45,'HIT4101','Artificial Intelligence',12,4,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-20 08:33:28'),
(46,'EBE5101','Medical Imaging Technology',12,5,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(47,'EBE5102','Professional Ethics & Practice',12,5,4,1,0,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(48,'EBE5103','Biomedical Signal Processing',12,5,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(49,'EBE5104','Telemedicine',12,5,4,1,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(50,'EBE5201','Physiological Modeling',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(51,'EBE5202','Medical Implant Devices',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(52,'EBE5203','Rehabilitation Engineering',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(53,'EBE5204','Medical Robotics',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(54,'HIT0500','Capstone Design Project',40,5,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:48','2026-07-13 09:05:48'),
(55,'EBE5205','MEMs and NEMs for Biomedical Applications',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(56,'EBE5206','Nuclear Medicine',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(57,'EBE5207','Polymer Technology in Medicine',12,5,4,2,1,9,NULL,NULL,'2026-07-13 09:05:48','2026-07-17 09:42:45'),
(58,'ARG1101','Anatomy, Physiology & Pathology I',12,1,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(59,'ARG1102','General Physics I',4,1,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(60,'ARG1103','Radiobiology and Radiation Protection',5,1,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(61,'ARG1104','Professionalism and Patient Management I',6,1,5,1,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(62,'ARG1105','Clinical Practice I',20,1,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(63,'ICS110','Introduction to Computer Science',10,1,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(64,'HIT110','Technopreneurship I',10,1,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(65,'SST1101','Technical Communication Skills',10,1,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(66,'ARG1201','Anatomy, Physiology & Pathology II',12,1,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(67,'ARG1202','General Physics II',4,1,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(68,'ARG1203','Radiation Treatment and Imaging Sciences',12,1,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(69,'ARG1204','Professionalism and Patient Management II',9,1,5,2,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(70,'ARG1205','Clinical Practice II',20,1,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(71,'HIT120','Technopreneurship II',10,1,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(72,'ARG2101','Medical Ultrasound I',8,2,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(73,'ARG2102','Principles of Psychology & Patient Counseling',3,2,5,1,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(74,'ARG2103','Clinical Practice III',28,2,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(75,'ARG2104','Imaging Sciences and Equipment I',8,2,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(76,'ARG2105','Applied Anatomy and Imaging I',12,2,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(77,'SST2101','Biostatistics',12,2,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(78,'HIT200','Design Project',15,2,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(79,'ARG2201','Principles of Sociology',8,2,5,2,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(80,'ARG2202','Clinical Practice IV',28,2,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(81,'ARG2203','Imaging Sciences and Equipment II',8,2,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(82,'ARG2204','Applied Anatomy and Imaging II',12,2,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(83,'ARG2205','Special Imaging Procedures',8,2,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(84,'ARG3101','Medical Ultrasound II',8,3,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(85,'ARG3102','Research Methods',8,3,5,1,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(86,'ARG3103','Quality Management',8,3,5,1,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(87,'ARG3104','Clinical Practice V',32,3,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(88,'ARG3105','Image Interpretation and Radiographer Commenting I',8,3,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(89,'ARG3106','Imaging Sciences and Equipment III',8,3,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(90,'ARG3107','Interventional Imaging Procedures',8,3,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(91,'HIT300','Design and Innovation Project',15,3,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(92,'ARG3201','Nuclear Medicine I',8,3,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(93,'ARG3202','Clinical Practice VI',32,3,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(94,'HIT3203','Big Data Analysis',12,3,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(95,'ARG3204','Image Interpretation and Radiographer Commenting II',8,3,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(96,'ARG3205','Imaging Sciences and Equipment IV',8,3,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(97,'ARG3206','Special Needs Imaging',8,3,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(98,'ARG3207','Computed Tomography Imaging',8,3,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(99,'ARG4101','Ultrasound III (Abdomen)',8,4,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(100,'ARG4102','Medical Dosimetry',8,4,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(101,'ARG4103','Clinical Practice VII',32,4,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(102,'ARG4104','Advanced Radiographic Imaging Modalities',8,4,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(103,'ARG4105','Magnetic Resonance Imaging',8,4,5,1,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(104,'ARG4201','General Organizational Management',8,4,5,2,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(105,'ARG4202','Artificial Intelligence',12,4,5,2,0,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(106,'ARG4203','Clinical Practice VIII',32,4,5,2,1,16,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(107,'HIT400','Research Project',20,4,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(108,'SBT1102','Cell Biology',12,1,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(109,'SBT1103','Chemistry for Biotechnologists',12,1,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(110,'HIT1103','Mathematics for Technologists I',12,1,NULL,1,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(111,'SBT1104','Computer Applications',12,1,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(112,'SBT1101','Introduction to Biotechnology',10,1,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(113,'SBT1201','Microbiology',12,1,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(114,'SBT1202','Principles of Thermodynamics',12,1,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(115,'SBT1203','Biochemistry',12,1,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(116,'SBT1204','Analytical Biotechnology',12,1,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(117,'SBT1205','Bacteriology and Mycology',12,1,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(118,'SBT1206','Genetics',12,1,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(119,'HIT1203','Mathematics for Technologists II',12,1,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(120,'SBT2101','Molecular Biology',12,2,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(121,'SBT2102','Bioprocess Engineering',12,2,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(122,'SBT2103','Fermentation Biotechnology',12,2,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(123,'SBT2104','Biosafety, Ethics and Regulation',12,2,6,1,0,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(124,'SBT2106','Entrepreneurship',12,2,6,1,0,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(125,'SBT2107','Biostatistics',12,2,6,1,0,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(126,'SBT2201','Plant Biotechnology',12,2,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(127,'SBT2202','Animal Biotechnology',12,2,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(128,'SBT2203','Genetic Engineering',12,2,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(129,'SBT2204','Enzymology and Immunology',12,2,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(130,'HIT2205','Big Data and Big Data Analytics',12,2,NULL,2,0,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(131,'HIT2001','Team Product Development Project',15,2,NULL,2,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(132,'HIT3001','Design & Innovation Project',30,3,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(133,'HIT3002','Internship',120,3,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(134,'SBT4101','Bioinformatics',12,4,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(135,'SBT4102','Environmental Biotechnology',12,4,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(136,'SBT4103','Molecular Systematics',12,4,6,1,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(137,'HIT4001','Capstone Design Project',12,4,NULL,1,1,NULL,NULL,NULL,'2026-07-13 09:05:49','2026-07-13 09:05:49'),
(138,'SBT4201','Biotechnology Quality Assurance and Control',12,4,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(139,'SBT4202','Pharmaceutical and Medical Biotechnology',12,4,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(140,'SBT4203','Virology',12,4,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46'),
(141,'SBT4204','Food Biotechnology',12,4,6,2,1,14,NULL,NULL,'2026-07-13 09:05:49','2026-07-17 09:42:46');
/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
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
-- Table structure for table `programme_modules`
--

DROP TABLE IF EXISTS `programme_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme_modules` (
  `programme_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `year` tinyint(3) unsigned NOT NULL,
  `semester` tinyint(3) unsigned NOT NULL,
  `is_core` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`programme_id`,`module_id`),
  KEY `programme_modules_module_id_foreign` (`module_id`),
  CONSTRAINT `programme_modules_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE,
  CONSTRAINT `programme_modules_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme_modules`
--

LOCK TABLES `programme_modules` WRITE;
/*!40000 ALTER TABLE `programme_modules` DISABLE KEYS */;
INSERT INTO `programme_modules` VALUES
(14,4,1,1,1),
(14,5,1,1,1),
(14,6,1,1,1),
(14,7,1,1,1),
(14,8,1,1,1),
(14,9,1,1,1),
(14,10,1,1,1),
(14,11,1,1,1),
(14,12,1,2,1),
(14,13,1,2,1),
(14,14,1,2,1),
(14,15,1,2,1),
(14,16,1,2,1),
(14,17,1,2,1),
(14,18,1,2,1),
(14,19,1,2,1),
(14,20,2,1,1),
(14,21,2,1,1),
(14,22,2,1,1),
(14,23,2,1,1),
(14,24,2,1,1),
(14,25,2,2,1),
(14,26,2,2,1),
(14,27,2,2,1),
(14,28,2,2,1),
(14,29,2,2,1),
(14,30,2,2,1),
(14,31,2,2,1),
(14,32,3,1,1),
(14,33,3,1,1),
(14,34,3,1,1),
(14,35,3,1,1),
(14,36,3,1,1),
(14,37,3,2,1),
(14,38,3,2,1),
(14,39,3,2,1),
(14,40,3,2,1),
(14,41,3,2,1),
(14,42,3,2,1),
(14,43,4,1,1),
(14,44,4,1,1),
(14,45,5,1,1),
(14,46,5,1,1),
(14,47,5,1,1),
(14,48,5,1,1),
(14,49,5,1,1),
(14,50,5,2,1),
(14,51,5,2,1),
(14,52,5,2,1),
(14,53,5,2,1),
(14,54,5,2,1),
(14,55,5,2,0),
(14,56,5,2,0),
(14,57,5,2,0),
(25,9,1,1,1),
(25,17,1,2,1),
(25,23,2,1,1),
(25,29,2,2,1),
(25,45,4,1,1),
(25,65,1,1,1),
(25,108,1,1,1),
(25,109,1,1,1),
(25,110,1,1,1),
(25,111,1,1,1),
(25,112,1,1,0),
(25,113,1,2,1),
(25,114,1,2,1),
(25,115,1,2,1),
(25,116,1,2,1),
(25,117,1,2,1),
(25,118,1,2,1),
(25,119,1,2,1),
(25,120,2,1,1),
(25,121,2,1,1),
(25,122,2,1,1),
(25,123,2,1,1),
(25,124,2,1,1),
(25,125,2,1,1),
(25,126,2,2,1),
(25,127,2,2,1),
(25,128,2,2,1),
(25,129,2,2,1),
(25,130,2,2,1),
(25,131,2,2,1),
(25,132,3,1,1),
(25,133,3,1,1),
(25,134,4,1,1),
(25,135,4,1,1),
(25,136,4,1,1),
(25,137,4,1,1),
(25,138,4,2,1),
(25,139,4,2,1),
(25,140,4,2,1),
(25,141,4,2,1),
(30,23,2,1,1),
(30,58,1,1,1),
(30,59,1,1,1),
(30,60,1,1,1),
(30,61,1,1,1),
(30,62,1,1,1),
(30,63,1,1,1),
(30,64,1,1,1),
(30,65,1,1,1),
(30,66,1,2,1),
(30,67,1,2,1),
(30,68,1,2,1),
(30,69,1,2,1),
(30,70,1,2,1),
(30,71,1,2,1),
(30,72,2,1,1),
(30,73,2,1,1),
(30,74,2,1,1),
(30,75,2,1,1),
(30,76,2,1,1),
(30,77,2,1,1),
(30,78,2,2,1),
(30,79,2,2,1),
(30,80,2,2,1),
(30,81,2,2,1),
(30,82,2,2,1),
(30,83,2,2,1),
(30,84,3,1,1),
(30,85,3,1,1),
(30,86,3,1,1),
(30,87,3,1,1),
(30,88,3,1,1),
(30,89,3,1,1),
(30,90,3,1,1),
(30,91,3,2,1),
(30,92,3,2,1),
(30,93,3,2,1),
(30,94,3,2,1),
(30,95,3,2,1),
(30,96,3,2,1),
(30,97,3,2,1),
(30,98,3,2,1),
(30,99,4,1,1),
(30,100,4,1,1),
(30,101,4,1,1),
(30,102,4,1,1),
(30,103,4,1,1),
(30,104,4,2,1),
(30,105,4,2,1),
(30,106,4,2,1),
(30,107,4,2,1);
/*!40000 ALTER TABLE `programme_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programme_type_study_level`
--

DROP TABLE IF EXISTS `programme_type_study_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme_type_study_level` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `programme_type_id` bigint(20) unsigned NOT NULL,
  `study_level_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ptsl_type_level_unique` (`programme_type_id`,`study_level_id`),
  KEY `programme_type_study_level_study_level_id_foreign` (`study_level_id`),
  CONSTRAINT `programme_type_study_level_programme_type_id_foreign` FOREIGN KEY (`programme_type_id`) REFERENCES `programme_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `programme_type_study_level_study_level_id_foreign` FOREIGN KEY (`study_level_id`) REFERENCES `study_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme_type_study_level`
--

LOCK TABLES `programme_type_study_level` WRITE;
/*!40000 ALTER TABLE `programme_type_study_level` DISABLE KEYS */;
INSERT INTO `programme_type_study_level` VALUES
(1,1,1),
(5,1,2);
/*!40000 ALTER TABLE `programme_type_study_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programme_types`
--

DROP TABLE IF EXISTS `programme_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programme_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme_types`
--

LOCK TABLES `programme_types` WRITE;
/*!40000 ALTER TABLE `programme_types` DISABLE KEYS */;
INSERT INTO `programme_types` VALUES
(1,'degree','Degree',1,1,'2026-07-17 21:36:22','2026-07-17 21:36:22'),
(2,'diploma','Diploma',1,2,'2026-07-17 21:36:22','2026-07-17 21:36:22');
/*!40000 ALTER TABLE `programme_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programmes`
--

DROP TABLE IF EXISTS `programmes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programmes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` bigint(20) unsigned NOT NULL,
  `code` varchar(16) NOT NULL,
  `name` varchar(191) NOT NULL,
  `type` enum('degree','diploma','certificate') DEFAULT NULL,
  `programme_type_id` bigint(20) unsigned DEFAULT NULL,
  `study_level` varchar(30) NOT NULL DEFAULT 'undergraduate',
  `study_level_id` bigint(20) unsigned DEFAULT NULL,
  `duration_years` tinyint(3) unsigned NOT NULL,
  `total_credits` smallint(5) unsigned NOT NULL,
  `entry_requirements` text DEFAULT NULL,
  `study_mode` varchar(32) DEFAULT NULL,
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programmes_code_unique` (`code`),
  KEY `programmes_department_id_foreign` (`department_id`),
  KEY `programmes_study_level_index` (`study_level`),
  KEY `programmes_programme_type_id_foreign` (`programme_type_id`),
  KEY `programmes_study_level_id_foreign` (`study_level_id`),
  CONSTRAINT `programmes_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `programmes_programme_type_id_foreign` FOREIGN KEY (`programme_type_id`) REFERENCES `programme_types` (`id`) ON DELETE SET NULL,
  CONSTRAINT `programmes_study_level_id_foreign` FOREIGN KEY (`study_level_id`) REFERENCES `study_levels` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programmes`
--

LOCK TABLES `programmes` WRITE;
/*!40000 ALTER TABLE `programmes` DISABLE KEYS */;
INSERT INTO `programmes` VALUES
(2,1,'BEC','BTech Honours Degree in Electronic Commerce','degree',1,'undergraduate',1,4,480,'Two \'A\' level passes which should include one of the following: Mathematics, Accounting or Computer Science and any other subject(s) from the following: Business Studies, Economics, Physics or any relevant commercial subjects.\nOR National Diploma (ND) in E-Commerce or equivalent.\nOR Higher National Diploma (HND) in E-Commerce or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(3,2,'BFE','BTech Honours Degree in Financial Engineering','degree',1,'undergraduate',1,4,480,'Three \'A\' level passes in Commercial or Science subjects, including Mathematics.\nOR National Diploma (ND) in Financial Engineering or its equivalent.\nOR Higher National Diploma (HND) in Financial Engineering or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(4,3,'BFAA','BTech Honours Degree in Forensic Accounting and Auditing','degree',1,'undergraduate',1,4,480,'Two \'A\' level passes in Commercial or Science subjects, including Mathematics or Accounting or Computer Science.\nOR National Diploma (ND) in Forensic Accounting/Forensic Auditing or its equivalent.\nOR Higher National Diploma (HND) in Forensic Accounting/Forensic Auditing or its equivalent.\nNB: An accepted student must submit the Zimbabwe Republic Police Clearance Certificate (Local) or from the country of origin (International) on the registration day.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(5,1,'MSI','Master of Technology Degree in Strategy and Innovation','degree',1,'postgraduate',2,2,240,'Applicants must be holders of an undergraduate degree in the field of Business and Management from a recognized University. Applicants with undergraduate degree in Science, Technology, Engineering and Mathematics are also considered.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(6,1,'MEC','Master of Technology Degree in Electronic Commerce','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree in Electronic Commerce or its equivalence.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(7,2,'MFE','Master of Technology Degree in Financial Engineering','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree in Financial Engineering or its equivalence.\\nOR Any undergraduate degree in either Mathematics, Computer Science, Physics, Finance or Economics. Relevant work experience is an added advantage.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(8,3,'MFAA','Master of Technology Degree in Forensic Accounting and Auditing','degree',1,'postgraduate',2,2,240,'Applicants must be holders of an undergraduate degree in the field of Forensic Accounting and Auditing or any other related degree (field).\nNB: An accepted student must submit the Zimbabwe Republic Police Clearance Certificate (Local) or from Police Services of the country of origin (International) on the registration day.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(9,4,'BCPE','BTech Honours Degree in Chemical and Process Systems Engineering','degree',1,'undergraduate',1,4,480,'Three \'A\' level passes in Mathematics, Chemistry and a third approved subject such as Physics, Technical Drawing, Computer Science, Biology, Mechanical Engineering or Metallurgy.\nOR National Diploma (ND) in Chemical & Process Systems Engineering or equivalent.\nOR Higher National Diploma (HND) in Chemical & Process Systems Engineering or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(10,5,'BEE','BTech Honours Degree in Electronic Engineering','degree',1,'undergraduate',1,4,480,'Two \'A\' level passes in Mathematics and Physics and a third approved science subject.\nOR National Diploma (ND) in Electronic Engineering or its equivalent.\nOR Higher National Diploma (HND) in Electronic Engineering or its equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(11,6,'BIME','BTech Honours Degree in Industrial and Manufacturing Engineering','degree',1,'undergraduate',1,4,480,'Three \'A\' level passes in Mathematics and Physics/Physical Science plus any one of the following: Chemistry, Computer Science, Engineering Drawing, or equivalent.\nOR National Diploma (ND) in Industrial and Manufacturing Engineering or equivalent.\nOR Higher National Diploma (HND) in Industrial and Manufacturing Engineering or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(12,7,'BPTE','BTech Honours Degree in Polymer Technology and Engineering','degree',1,'undergraduate',1,4,480,'Two \'A\' Level passes in Chemistry and either Mathematics or Physics.\nOR National Diploma (ND) in Polymer Technology and Engineering or equivalent.\nOR Higher National Diploma (HND) in Polymer Technology and Engineering or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(13,7,'BMATE','BTech Honours Degree in Materials Technology and Engineering','degree',1,'undergraduate',1,4,480,'Three \'A\' Level passes in Mathematics, Chemistry and Physics or any other equivalent subject.\nOR National Diploma (ND) in Materials Technology and Engineering or equivalent.\nOR Higher National Diploma (HND) in Materials Technology and Engineering or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(14,9,'BBME','BTech Honours Degree in Biomedical Engineering','degree',1,'undergraduate',1,5,600,'Three \'A\' Level passes in Physics, Mathematics and a third approved subject such as Biology, Chemistry, Computer Science or equivalent subjects at \'A\' Level.\nOR National Diploma (ND) in Electronic Engineering, Electronic Instrumentation and Control Engineering, Biomedical Technology, Medical Electronics or equivalent.\nOR Higher National Diploma (HND) in Electronic Engineering, Electronic Instrumentation and Control Engineering, Biomedical Technology, Medical Electronics or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(15,6,'MMD','Master of Technology (MTech) Degree in Machine Design','degree',1,'postgraduate',2,2,240,'Applicants must be holders of a relevant Honours Degree from a recognized Institution. Relevant fields include but are not limited to Industrial and Manufacturing Engineering, Production Engineering, Mechanical Engineering and Mechatronics Engineering.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(16,4,'MPTC','Master of Technology Degree in Petrochemicals Technology','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in: Chemical and Process Systems Engineering, Process Engineering, Chemical Engineering, Fuels Engineering, Production/Industrial, Manufacturing Engineering or any other equivalent.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(17,5,'MTWS','Master of Technology Degree in Telecommunications and Wireless Systems','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in Electronic, Electrical Engineering, Telecommunications Engineering, Electronics and Instrumentation Engineering, Electronics and Communication Engineering or any other relevant degree programme.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(18,6,'MCIM','Master of Technology Degree in Computer Integrated Manufacturing','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in: Industrial and Manufacturing Engineering, Materials Technology and Engineering, Electronics Engineering, Chemical Engineering/Technology.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(19,6,'MIEM','Master of Technology Degree in Industrial Engineering and Management','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours degree (or equivalent) in Industrial and Manufacturing, Chemical Engineering/Technology, Biomedical Engineering, Polymer Engineering/Technology, Electronic Engineering, Industrial/Production Engineering, Mechanical Engineering, Mechatronics Engineering or any relevant engineering degree.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(20,7,'MPPE','Master of Technology Degree in Polymer Process Engineering','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in Polymer Technology and Engineering, Fibre and Polymer Engineering, Materials Engineering, Petroleum Technology and Engineering, Chemical Engineering/Technology, Chemical and Process Systems Engineering, Production/Industrial and Manufacturing Engineering or any other equivalent.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(21,7,'MMATE','Master of Technology Degree in Materials Technology and Engineering','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in: Materials Technology and Engineering, Chemical Engineering/Technology, Mechatronics Engineering, or any other Engineering related degree.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(22,6,'MEBR','Master of Technology Degree in Engineering by Research','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in: Chemical and Process Systems Engineering, Materials Technology and Engineering, Electronics Engineering, Fuels Engineering, Production/Industrial, Manufacturing Engineering or any other equivalent engineering degree.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(23,4,'MCPPD','Master of Technology Degree in Chemical Process and Plant Design','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in: Chemical and Process Systems Engineering, Process Engineering, Chemical Engineering, Fuels Engineering, Production/Industrial, Manufacturing Engineering or any other equivalent.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(24,8,'MIA','Master of Technology Degree in Industrial Automation','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree in Electronic Engineering, Electrical Engineering, Electronics and Instrumentation Engineering, Electronics and Communication Engineering, Mechatronics Engineering or any other relevant engineering degree.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(25,14,'BBT','BTech Honours Degree in Biotechnology','degree',1,'undergraduate',1,4,480,'Two \'A\' Level passes in Biology and Chemistry, and a third approved subject which could be either Physics or Mathematics.\nOR National Diploma (ND) in Biotechnology or its equivalent.\nOR Higher National Diploma (HND) in Biotechnology or its equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(26,15,'BFPT','BTech Honours Degree in Food Processing Technology','degree',1,'undergraduate',1,4,480,'Three \'A\' level passes in Chemistry and any other two in Biology, Physics, Mathematics or Food Science.\nOR National Diploma (ND) in Food Processing Technology or its equivalent.\nOR Higher National Diploma (HND) in Food Processing Technology or its equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(27,14,'MIBT','Master of Technology Degree in Industrial Biotechnology','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours Degree (or equivalent) in: Biotechnology, Food Processing Technology, Pharmaceutical Technology, Polymer Technology and Engineering, Chemical and Process Systems Engineering and Biomedical Engineering or any other related field.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(28,15,'MFPT','Master of Technology Degree in Food Processing Technology','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology (Hons) Degree in Food Processing Technology, or its equivalence.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(29,18,'BPHARM','Bachelor of Pharmacy Honours Degree','degree',1,'undergraduate',1,4,480,'Three \'A\' Level passes in Chemistry and either Biology, Mathematics or Physics.\nOR National Diploma (ND) in Pharmaceutical Technology or its equivalent.\nOR Higher National Diploma (HND) in Pharmaceutical Technology or its equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(30,16,'BDR','Bachelor of Science Honours Degree in Diagnostic Radiography','degree',1,'undergraduate',1,4,480,'Three good \'A\' Level passes in Mathematics, Physics, Biology, and Chemistry.\nOR National Diploma (ND) in Radiography or equivalent.\nOR Higher National Diploma (HND) in Radiography or equivalent.\nNB: An accepted student must submit proof of Hepatitis B vaccination on the day of registration.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(31,17,'BTR','Bachelor of Science Honours Degree in Therapeutic Radiography','degree',1,'undergraduate',1,4,480,'Three good \'A\' Level passes in Mathematics, Physics, Biology, and Chemistry.\nOR National Diploma (ND) in Radiography or equivalent.\nOR Higher National Diploma (HND) in Radiography or equivalent.\nNB: An accepted student must submit proof of Hepatitis B vaccination on the day of registration.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(32,16,'MMU','Master of Technology Degree in Medical Ultrasound','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Science or Bachelor of Technology in Radiography (Diagnostic/Therapeutic) or equivalent.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(33,10,'BCS','BTech Honours Degree in Computer Science','degree',1,'undergraduate',1,4,480,'Two \'A\' Level passes in Mathematics/Statistics and at least one of the following subjects or their equivalent; Physics, Computer Science or Software Engineering.\nOR National Diploma (ND) in Computer Science or equivalent.\nOR Higher National Diploma (HND) in Computer Science or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(34,11,'BIT','BTech Honours Degree in Information Technology','degree',1,'undergraduate',1,4,480,'Two \'A\' Level passes in Mathematics and Computer Science or any other relevant science subject.\nOR National Diploma (ND) in Information Technology or equivalent.\nOR Higher National Diploma (HND) in Information Technology or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(35,12,'BISA','BTech Honours Degree in Information Security & Assurance','degree',1,'undergraduate',1,4,480,'Two \'A\' Level passes in Mathematics and Computer Science/Computing/Physics or any other related subject.\nOR National Diploma (ND) in Information Security and Assurance or equivalent.\nOR Higher National Diploma (HND) in Information Security and Assurance or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(36,13,'BSE','BTech Honours Degree in Software Engineering','degree',1,'undergraduate',1,4,480,'Two \'A\' Level passes in Mathematics/Statistics and at least one of the following subjects or their equivalent: Physics, Computer Science or Software Engineering.\nOR National Diploma (ND) in Software Engineering or equivalent.\nOR Higher National Diploma (HND) in Software Engineering or equivalent.','Full Time','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(37,10,'MCC','Master of Technology Degree in Cloud Computing (IMCC)','degree',1,'postgraduate',2,2,240,'Applicants must be holders of a relevant Honours Degree from a recognized Institution. Relevant fields include but are not limited to Computer Science, Computer Science and Engineering, Software Engineering, Information Technology, Information Systems and Information Security & Assurance.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(38,10,'MCS','Master of Technology Degree in Computer Science','degree',1,'postgraduate',2,2,240,'Applicants must be holders of a relevant Honours Degree from a recognized Institution. Relevant fields include but are not limited to Computer Science and Computer Science & Engineering.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(39,11,'MIT','Master of Technology Degree in Information Technology','degree',1,'postgraduate',2,2,240,'Applicants must be holders of a relevant Honours Degree from a recognized Institution. Relevant fields include but are not limited to Information Technology, Information System, Computer Science, Information Security & Assurance and Software Engineering.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(40,13,'MSE','Master of Technology Degree in Software Engineering','degree',1,'postgraduate',2,2,240,'Applicants must be holders of a relevant Honours Degree from a recognized Institution. Relevant fields include but are not limited to Software Engineering, Information Technology, Computer Science and Computer Science & Engineering.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45'),
(41,10,'MDSA','Master of Technology Degree in Data Science and Analytics','degree',1,'postgraduate',2,2,240,'Applicants must be holders of Bachelor of Technology Honours degree (or equivalent) in: Computer Science, Information Technology/Systems, Software Engineering, E-Commerce, Financial Engineering or any other equivalent/relevant degree program.','Block Release','active','2026-07-17 09:42:45','2026-07-17 09:42:45');
/*!40000 ALTER TABLE `programmes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulation_bindings`
--

DROP TABLE IF EXISTS `regulation_bindings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulation_bindings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned DEFAULT NULL,
  `cohort_ref` varchar(64) DEFAULT NULL,
  `level` varchar(30) DEFAULT NULL,
  `regulation_id` bigint(20) unsigned NOT NULL,
  `consent_at` timestamp NULL DEFAULT NULL,
  `consent_ref` varchar(128) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regulation_bindings_student_id_unique` (`student_id`),
  UNIQUE KEY `regulation_bindings_cohort_ref_level_unique` (`cohort_ref`,`level`),
  KEY `regulation_bindings_regulation_id_foreign` (`regulation_id`),
  CONSTRAINT `regulation_bindings_regulation_id_foreign` FOREIGN KEY (`regulation_id`) REFERENCES `regulations` (`id`),
  CONSTRAINT `regulation_bindings_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulation_bindings`
--

LOCK TABLES `regulation_bindings` WRITE;
/*!40000 ALTER TABLE `regulation_bindings` DISABLE KEYS */;
INSERT INTO `regulation_bindings` VALUES
(2,NULL,'2026','undergraduate',1,NULL,NULL,'2026-07-17 09:43:29','2026-07-17 09:43:29');
/*!40000 ALTER TABLE `regulation_bindings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulation_parameters`
--

DROP TABLE IF EXISTS `regulation_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulation_parameters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `regulation_id` bigint(20) unsigned NOT NULL,
  `param_group` varchar(64) NOT NULL,
  `param_key` varchar(128) NOT NULL,
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`value`)),
  `data_type` varchar(16) NOT NULL DEFAULT 'json',
  `section_ref` varchar(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regulation_parameters_regulation_id_param_key_unique` (`regulation_id`,`param_key`),
  CONSTRAINT `regulation_parameters_regulation_id_foreign` FOREIGN KEY (`regulation_id`) REFERENCES `regulations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulation_parameters`
--

LOCK TABLES `regulation_parameters` WRITE;
/*!40000 ALTER TABLE `regulation_parameters` DISABLE KEYS */;
INSERT INTO `regulation_parameters` VALUES
(1,1,'grading','scales','{\"default\":{\"pass_mark\":45,\"bands\":[{\"grade\":\"O\",\"min\":91,\"max\":100,\"points\":10,\"description\":\"Outstanding\"},{\"grade\":\"A+\",\"min\":81,\"max\":90,\"points\":9,\"description\":\"Excellent\"},{\"grade\":\"A\",\"min\":75,\"max\":80,\"points\":8,\"description\":\"Very Good\"},{\"grade\":\"B+\",\"min\":70,\"max\":74,\"points\":7,\"description\":\"Good\"},{\"grade\":\"B\",\"min\":65,\"max\":69,\"points\":6,\"description\":\"Above Average\"},{\"grade\":\"C\",\"min\":55,\"max\":64,\"points\":5.5,\"description\":\"Average\"},{\"grade\":\"P\",\"min\":45,\"max\":54,\"points\":5,\"description\":\"Pass\"},{\"grade\":\"F\",\"min\":0,\"max\":44,\"points\":0,\"description\":\"Fail\"}]},\"by_school\":{\"AHS\":{\"pass_mark\":50,\"bands\":[{\"grade\":\"O\",\"min\":91,\"max\":100,\"points\":10,\"description\":\"Outstanding\"},{\"grade\":\"A+\",\"min\":81,\"max\":90,\"points\":9,\"description\":\"Excellent\"},{\"grade\":\"A\",\"min\":75,\"max\":80,\"points\":8,\"description\":\"Very Good\"},{\"grade\":\"B+\",\"min\":70,\"max\":74,\"points\":7,\"description\":\"Good\"},{\"grade\":\"B\",\"min\":65,\"max\":69,\"points\":6,\"description\":\"Above Average\"},{\"grade\":\"C\",\"min\":55,\"max\":64,\"points\":5.5,\"description\":\"Average\"},{\"grade\":\"P\",\"min\":50,\"max\":54,\"points\":5,\"description\":\"Pass\"},{\"grade\":\"F\",\"min\":0,\"max\":49,\"points\":0,\"description\":\"Fail\"}]}}}','object','§6.1','Grade bands and pass mark. `by_school` is keyed by faculty code and overrides `default`; the School of Allied Health Sciences passes at 50, every other school at 45.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(2,1,'classification','part_weights','{\"I\":15,\"II\":20,\"III\":20,\"IV\":45}','object','§6.3','Part contribution to the final weighted CGPA.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(3,1,'classification','thresholds','{\"distinction\":8.5,\"first\":7.5,\"upper_second\":6.5,\"lower_second\":5.5,\"pass\":4.5}','object','§6.3','Minimum weighted CGPA per degree class.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(4,1,'progression','carryover','{\"max_failed_pct\":25,\"cumulative_cap_pct\":40}','object','§11','Proceed-with-carryover caps: per-Part failed % and cumulative cap %.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(5,1,'progression','carryover_2nd_sitting_cap','45','int','§11','Mark cap on a carryover course passed at second sitting.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(6,1,'progression','repeat_course','{\"min_earned_pct\":50,\"min_aggregate\":35}','object','§11','Repeat-course band: earned credit % and minimum aggregate.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(7,1,'progression','repeat_part','{\"failed_min_pct\":50,\"failed_max_pct\":75}','object','§11','Repeat-Part band: failed 50-75% of credits.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(8,1,'progression','discontinue','{\"max_earned_pct\":25,\"min_aggregate\":35,\"max_cgpa\":3.5}','object','§11','Discontinue: earned ≤25%, or aggregate <35, or CGPA ≤3.5.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(9,1,'progression','withdraw','{\"max_earned_pct\":20,\"max_aggregate_pct\":20,\"failed_same_part_twice\":true,\"failed_two_programmes\":true}','object','§11','Withdraw: earned ≤20% and aggregate ≤20, failed the same Part twice, or failed two programmes.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(10,1,'progression','max_sittings','3','int','§11','Maximum examination sittings per course.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(11,1,'progression','no_part1_carry_to_final','true','bool','§11','A Part I carryover may not be carried into the final Part.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(12,1,'assessment','practical','{\"ca\":40,\"practical\":25,\"tests\":15,\"exam\":60}','object','§7.1','Practical courses: CA 40 (practical 25 + tests 15), exam 60.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(13,1,'assessment','non_practical','{\"ca\":25,\"exam\":75}','object','§7.1','Non-practical courses: CA 25, exam 75.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(14,1,'assessment','ca_pass','50','int','§7.2','Minimum continuous-assessment mark to sit the examination.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(15,1,'assessment','weights_sum','100','int','§7.1','Assessment component weights must sum to this total.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(16,1,'attendance','min_pct','80','int','§3.6.11','Minimum attendance percentage per course to remain eligible for the examination.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(17,1,'entry','normal','{\"min_o\":5,\"min_a\":2,\"required_o\":[\"English Language\",\"Mathematics\"],\"nd_route\":{\"qualification\":\"National Diploma\",\"min_relevant_experience_years\":2},\"hnd_route\":{\"qualification\":\"Higher National Diploma\"}}','object','§3.1','Normal entry: 5 O-levels + 2 A-levels incl English & Maths, or ND + 2yr experience, or HND.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(18,1,'entry','mature','{\"min_age\":25,\"min_o\":5,\"required_o\":[\"English Language\",\"Mathematics\"],\"years_since_school\":5}','object','§3.2','Mature entry: age ≥25, 5 O-levels incl English & Maths, ≥5 years since full-time schooling.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(19,1,'entry','special','{\"route\":\"senate_discretion\",\"requires_senate_approval\":true}','object','§3.3','Special entry: routed to Senate for discretionary approval.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(20,1,'entry','approved_subjects','[\"English Language\",\"Mathematics\",\"Combined Science\",\"Biology\",\"Chemistry\",\"Physics\",\"Geography\",\"History\",\"Accounting\",\"Business Studies\",\"Economics\",\"Computer Science\",\"Divinity\\/Religious Studies\",\"Shona\",\"Ndebele\",\"French\",\"Woodwork\",\"Metalwork\",\"Technical Graphics\",\"Food & Nutrition\",\"Agriculture\",\"Building Studies\",\"Fashion & Fabrics\"]','list','§3.1.3','O-level subjects approved for entry counting.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(21,1,'entry','overlapping_matrix','[[\"Woodwork\",\"Metalwork\",\"Technical Graphics\",\"Building Studies\"],[\"Food & Nutrition\",\"Fashion & Fabrics\"],[\"Accounting\",\"Business Studies\",\"Economics\"]]','matrix','§3.1.4','Overlapping-subject groups; at most one subject per group counts toward entry.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(22,1,'credit_load','default','{\"min\":45,\"max\":75,\"programme_override_allowed\":true}','object','§4','Default per-semester credit load; a programme document may override.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(23,1,'duration','limits','{\"normal_years\":4,\"max_years\":8,\"extension_semesters\":2}','object','§5','Programme duration: 4 years normal, 8 years maximum, extension of 2 semesters.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(24,1,'coding','scheme','{\"school_letters\":[\"B\",\"E\",\"I\",\"S\",\"A\"],\"school_codes\":[\"BMS\",\"EST\",\"IST\",\"SST\",\"AHS\"],\"institution_prefix\":\"HIT\",\"forms\":{\"semester\":\"^(?:BMS|EST|IST|SST|AHS)[1-9][1-9][0-9]{2}$\",\"full_year\":\"^(?:BMS|EST|IST|SST|AHS)[1-9]0[0-9]{2}$\",\"institution\":\"^HIT[0-9]{3,4}$\"}}','object','§21','Course-code scheme: school code + XXX0000 semester form, full-year 0+Part form, and HIT institution-wide prefix.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(25,1,'exemption','cap','{\"normal_pct\":50,\"senate_pct\":80}','object','§10.1.5','Max fraction of a year\'s courses that may be exempted: 50% normally, up to 80% on Senate appeal.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(26,1,'exemption','min_syllabus_match_pct','75','int','§10.2.3-4','Minimum syllabus match between the source course and the HIT course.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(27,1,'exemption','max_age_years','10','int','§10.2.6-7','Course must have been examined within this many years, unless active experience is proven.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(28,1,'exemption','min_grade','\"P\"','string','§10.2.2','Minimum grade on the HIT scale for an exemptable pass.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(29,1,'exemption','deadline_week','3','int','§10.1.4','Exemption assessment must be completed by this week of the semester.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(30,1,'exit_award','fractions','{\"diploma_fraction\":0.75,\"certificate_fraction\":0.5}','object','§20','Programme fraction completed for an exit award.','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(31,2,'grading','scales','{\"default\":{\"pass_mark\":50,\"bands\":[{\"grade\":\"O\",\"min\":91,\"max\":100,\"points\":10,\"description\":\"Outstanding\"},{\"grade\":\"A+\",\"min\":81,\"max\":90,\"points\":9,\"description\":\"Excellent\"},{\"grade\":\"A\",\"min\":75,\"max\":80,\"points\":8,\"description\":\"Very Good\"},{\"grade\":\"B+\",\"min\":71,\"max\":74,\"points\":7,\"description\":\"Good\"},{\"grade\":\"B\",\"min\":65,\"max\":70,\"points\":6,\"description\":\"Above Average\"},{\"grade\":\"C\",\"min\":55,\"max\":64,\"points\":5.5,\"description\":\"Average\"},{\"grade\":\"P\",\"min\":50,\"max\":54,\"points\":5,\"description\":\"Pass\"},{\"grade\":\"F\",\"min\":0,\"max\":49,\"points\":0,\"description\":\"Fail\"}]}}','object','§11.1, §11.4','MTech grade bands and pass mark. A single scale applies to all schools; the pass mark is 50 and the lowest passing grade is P (50-54).','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(32,2,'classification','time_buckets','{\"within_duration\":[{\"class\":\"Pass\",\"min\":5,\"lt\":5.5},{\"class\":\"Second Class\",\"min\":5.5,\"lt\":7.5},{\"class\":\"First Class\",\"min\":7.5,\"lt\":8.5},{\"class\":\"First Class with Distinction\",\"min\":8.5,\"requires_clean_record\":true,\"fallback_class\":\"First Class\"}],\"plus_two_semesters\":[{\"class\":\"Pass\",\"min\":5,\"lt\":5.5},{\"class\":\"Second Class\",\"min\":5.5,\"lt\":7.5},{\"class\":\"First Class\",\"min\":7.5}],\"double_duration\":[{\"class\":\"Pass\",\"min\":5,\"lt\":5.5},{\"class\":\"Second Class\",\"min\":5.5}]}','object','§14','CGPA→class bands per completion-time bucket. Bucket selection (within duration / +2 semesters / double duration) is engine logic; these are the bands each bucket uses.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(33,2,'classification','distinction_requires_clean_record','true','bool','§14','First Class with Distinction requires no F/Ab/I or temporary withdrawal in any semester; otherwise the award is First Class.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(34,2,'gpa','include_fail_grades_in_denominator','true','bool','§12.1','SGPA/CGPA denominators include the credits of courses graded F/Ab/I (they count as grade point 0), per the §12.1 formulae.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(35,2,'progression','proceed','{\"min_earned_pct\":50}','object','§13.2, §13.3','Decision to proceed / proceed-carrying: at least 50% of the relevant credits earned (prior year, or cumulative for a 3rd year).','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(36,2,'progression','repeat_failed','{\"max_earned_pct\":50}','object','§13.4','Below 50% of the relevant credits earned → repeat failed courses.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(37,2,'progression','ca_pass_pct','50','int','§13.5','A candidate scoring below this continuous-assessment percentage in a course is ineligible to sit its end-of-semester examination.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(38,2,'progression','endsem_only_from_attempt','4','int','§13.7.4','From this attempt onward the end-of-semester examination carries full weight (100%) and continuous-assessment marks are ignored. I and Ab attempts count as attempts.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(39,2,'progression','core_must_pass','true','bool','§13.6.1','A core course graded F/Ab/I must be passed for the award of the degree; it cannot be substituted.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(40,2,'progression','elective_options','{\"reappear\":true,\"replace\":true}','object','§13.6.2','A failed elective may be re-taken (reappear) or replaced by another elective.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(41,2,'progression','elective_locked_grades','[\"O\",\"A+\",\"A\",\"B+\",\"B\",\"C\",\"P\"]','list','§13.6.3','An elective already passed with any of these grades (O to P) cannot be withdrawn.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(42,2,'progression','reexam_both_components','true','bool','§13.7.3','A fail (F/Ab/I) in a course with both theory and practical components requires re-sitting the end-of-semester examination for both.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(43,2,'progression','course_completed_no_repeat','true','bool','§13.7.2','A course successfully completed cannot be repeated.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(44,2,'progression','special_supplementary','{\"final_year_only\":true,\"graded_pass_fail\":true}','object','§13.9','Special supplementary examinations clear failed final-year courses only and are marked Pass or Fail.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(45,2,'progression','continuous_fail_withdraw','true','bool','§13.8','A candidate who continuously fails a course up to the maximum completion time is withdrawn from the programme.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(46,2,'assessment','theory','{\"ca\":50,\"exam\":50}','object','§8.3 Table 1','Theory course (no practical component): continuous assessment 50, end-of-semester examination 50.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(47,2,'assessment','theory_practical','{\"ca_theory\":25,\"ca_practical\":25,\"exam\":50}','object','§8.3 Table 2','Course with theory and practical components: CA theory 25, CA practical 25, end-of-semester examination 50.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(48,2,'assessment','practical_with_exam','{\"lab\":60,\"exam\":40}','object','§8.3 Table 3','Purely laboratory-based course with an end-of-semester examination: laboratory work 60, end-of-semester practical examination 40.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(49,2,'assessment','practical_only','{\"lab\":100}','object','§8.3 Table 4','Purely laboratory-based course without an end-of-semester examination: laboratory work 100.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(50,2,'assessment','ca_pass','50','int','§11.4, §13.5','Minimum continuous-assessment mark to remain eligible for the examination and to pass the course.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(51,2,'assessment','must_sit_exam_to_pass','true','bool','§8.3.2','To be considered for a pass, a candidate must take the end-of-semester examination prescribed for the course (except purely practical courses under Table 4).','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(52,2,'assessment','weights_sum','100','int','§8.3','Assessment component weights must sum to this total.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(53,2,'project','code','\"HIT0800\"','string','§1.1.8, §10.6','Institute-wide course code for the MTech project work.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(54,2,'project','reviews','[{\"review\":\"Zeroth\",\"phase\":\"I\",\"definition\":\"Concept\",\"weight\":0},{\"review\":\"I\",\"phase\":\"I\",\"definition\":\"Proposal\",\"weight\":15},{\"review\":\"II\",\"phase\":\"I\",\"definition\":\"Mid-term presentation\",\"weight\":10},{\"review\":\"III\",\"phase\":\"II\",\"definition\":\"Report\",\"weight\":35},{\"review\":\"IV\",\"phase\":\"II\",\"definition\":\"Viva Voce\",\"weight\":40}]','object','§8.4 Table 5','Two-phase MTech project reviews and their weightings. The Zeroth review carries no marks.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(55,2,'project','publication_gate','{\"required\":true,\"accepted_channels\":[\"conference\",\"journal\"],\"acceptable_proof\":[\"acceptance\",\"publication\",\"under_review_confirmation\"],\"acknowledgement_sufficient\":false}','object','§8.4.3, §8.4.4','A candidate may only sit the final viva after submitting the work as a conference or journal paper. Proof of acceptance, publication, or a written under-review confirmation is required; an acknowledgement of receipt is not enough.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(56,2,'project','similarity_max_pct','12','int','§9.6','Maximum acceptable similarity index for MTech project reports and proposals.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(57,2,'project','referral_max_mark','50','int','§8.4.5','Maximum mark allowable for a dissertation/project submitted after a granted extension (normally within three months of the original deadline).','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(58,2,'project','extension_months','3','int','§8.4.5','Normal window, in months, for a late dissertation/project submission where the departmental board grants an extension.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(59,2,'project','report_review','{\"independent\":true,\"exclude_supervisor\":true,\"prefer_external\":true}','object','§9.4.2','The report must be reviewed independently of the supervisor or anyone with a direct interest; reviewers should ideally be external to the School and Institution.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(60,2,'project','viva_committee','{\"members\":[\"report_reviewers\",\"nominated_chair\",\"independent_member\"],\"chair_scores\":false,\"supervisor_role\":\"observer\",\"invite_only_after_report_pass\":true}','object','§9.5.2','Viva committee composition. The chair facilitates only (does not question or score); the supervisor may attend as a non-participating observer.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(61,2,'project','repository_deposit','\"HIT Scholar Institutional Repository\"','string','§9.7','On completion the project PDF is deposited to the library for upload into this institutional repository.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(62,2,'attendance','min_pct','75','int','§7.1','Minimum attendance percentage per course to remain eligible for the end-of-semester examination.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(63,2,'entry','normal','{\"qualification\":\"Honours Degree or equivalent\"}','object','§3.1','Normal entry: an appropriate Honours Degree or equivalent qualification.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(64,2,'entry','other','{\"route\":\"department_school_recommendation\",\"requires_senate_approval\":true}','object','§3.1.2','Other qualifications may be considered by Senate on the recommendation of the Department and School concerned.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(65,2,'credit_load','default','{\"programme_defined\":true,\"notional_hours_per_credit\":10}','object','§15, §21','Minimum and maximum credit load are prescribed in the programme regulations; each credit is worth 10 notional study hours.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(66,2,'duration','limits','{\"normal_years\":2,\"max_multiplier\":2}','object','§5','MTech duration: normally two years, with a maximum of double the programme duration from the date of admission.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(67,2,'deferment','window','{\"max_continuous_semesters\":2,\"request_window_weeks\":2}','object','§6','Deferment is normally for a maximum of two continuous semesters and may only be requested within the first two weeks of a semester.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(68,2,'coding','scheme','{\"institution_prefix\":\"HIT\",\"alpha_identifies\":[\"programme\",\"subject\"],\"numeric_prefix_indicates\":\"level_of_study\",\"includes_exam_units\":true,\"project_code\":\"HIT0800\"}','object','§1.1.8','Alpha/numeric codes: alphabetical codes identify Programmes and Subjects, a prefixing numerical code indicates the level of study, and individual examination components (units) are included. Institute-wide courses carry the HIT prefix.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(69,2,'plagiarism','minor','{\"first_level\":{\"action\":\"lecturer_warning\",\"resubmit_days\":5,\"max_mark\":50},\"high_similarity_pct\":50,\"second_level\":{\"action\":\"chair_written_warning\",\"mark\":0,\"resubmission_allowed\":false},\"third_level\":{\"action\":\"senate_discipline\",\"mark\":0},\"warning_lifespan_academic_years\":1}','object','§10.6.1','Minor cases (not project HIT0800 or seminar work). Level offences escalate; warnings live one academic year. A similarity index >50% lets the lecturer award zero and refer for a written warning.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(70,2,'plagiarism','major','{\"first\":{\"action\":\"project_invalidated\",\"resubmit_by\":\"June of the following year\",\"max_mark\":50},\"second\":{\"mark\":0,\"action\":\"senate_discipline\"}}','object','§10.6.2','Major cases (project HIT0800 or seminar work). A first offence invalidates the project; a second offence after resubmission is a zero plus Senate disciplinary action.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(71,2,'transfer','rules','{\"max_credits\":\"first_year_only\",\"min_qf_level\":9,\"min_grade\":\"school_defined\",\"requires_mbks_compliance\":true}','object','§20.1','Credit transfer: only first-year credits of the intended programme, SADC-QF level 9 (or equivalent), a school-defined minimum grade, and MBKS compliance.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(72,2,'award','eligibility','{\"all_courses_and_project_completed\":true,\"mbks_credits_attained\":true,\"min_credit_load_attained\":true,\"no_pending_discipline\":true}','object','§15.1','Conditions for eligibility to be awarded the MTech degree.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(73,2,'grade_revision','delete_on_pass','{\"grades\":[\"F\",\"I\"],\"recompute_cgpa\":true}','object','§16.3, §16.4','When a previously-failed course is later passed, the F/I grade is deleted from the grade card and the CGPA is revised accordingly.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(74,2,'posthumous','award','{\"unclassified\":true,\"requires_school_board_recommendation\":true}','object','§17.1','A posthumous award is unclassified and requires a School Board recommendation with sufficient evidence that the candidate would have qualified.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(75,2,'aegrotat','provisions','{\"unclassified\":true,\"requires_written_consent\":true,\"thesis_exemption\":false}','object','§17.2','An Aegrotat award is unclassified and ungraded, requires the candidate\'s written acceptance, and never exempts the candidate from submitting/defending a required thesis or dissertation.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(76,3,'entry','eligibility','{\"min_qualification\":\"Master\'s or MPhil\",\"requires_good_pass\":true,\"framework\":\"ZNQF\",\"min_qf_level\":9}','object','§2','A good pass in a relevant Master\'s or MPhil degree at a minimum of ZNQF Level 9 (or equivalent), in a field offered by the University.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(77,3,'application','window','{\"anytime\":true,\"directed_to\":\"Post Graduate Office\"}','object','§3.1','Applications for the PhD programme may be made at any time during the academic year, directed to the Post Graduate Office.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(78,3,'application','required_documents','[\"Proof of payment of the application fee\",\"Certified identity document and\\/or passport\",\"Certified marriage certificate where surname has changed\",\"Certified degree certificates and accompanying transcripts\",\"Motivation letter\",\"Statement of research interest \\/ concept note (2-3 pages)\",\"Curriculum Vitae\",\"Two academic reference letters\"]','list','§3.6','Documents that must accompany a PhD application.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(79,3,'application','offer_validity_months','3','int','§4.16','An offer letter is valid for this many months from issuance; failure to provisionally register within the period forfeits the offer.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(80,3,'committee','dhdc','{\"housed\":\"department\",\"chair\":\"earned PhD holder appointed by the DRC\",\"min_members\":5,\"min_phd_holders\":2}','object','§4.3, §4.4','Department Higher Degrees Committee: housed in the department, chaired by an earned-PhD holder appointed by the DRC, at least five members of whom at least two hold an earned PhD.','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(81,3,'committee','shdc','{\"housed\":\"school\",\"chair\":\"Dean of the School\",\"min_members\":5,\"all_members_phd_holders\":true}','object','§4.8','School Higher Degrees Committee: housed and chaired by the Dean of the School, at least five members who hold an earned PhD, including the relevant DHDC Chair.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(82,3,'committee','drc','{\"chair\":\"Chairperson of the Academic Board\",\"external_experts\":2,\"external_expert_min_qualification\":\"earned PhD\",\"expert_panel_size\":6}','object','§4.10','Doctoral Research Committee: chaired by the Chairperson of the Academic Board; includes Academic Board members and two external experts (each ≥ earned PhD) selected by the Dean from a panel of six.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(83,3,'selection','criteria','[\"Availability of an academic supervisor\",\"Access to appropriate resources and facilities\",\"Suitability of the area of study with the Department, School and Institute mandate\",\"Suitability and competence of the applicant for the area of study\",\"Proposed research contributes new and additional knowledge\"]','list','§4.6','DHDC criteria for deliberating on an applicant\'s fit within the Department.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(84,3,'selection','decisions','[\"approved_to_register\",\"not_approved_to_register\"]','list','§4.11','The DRC decision on the course of action for an applicant.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(85,3,'workflow','slas','{\"application_to_dhdc_members_days\":10,\"dhdc_meeting_after_distribution_days\":10,\"notify_dhdc_of_full_reg_intent_days\":5,\"facilitate_proposal_presentation_days\":5,\"extension_meeting_days\":5}','object','§4, §5, §6.7','Committee routing service levels, in working days, that the escalation engine enforces.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(86,3,'registration','provisional','{\"max_months\":12,\"proposal_max_months\":9,\"counts_toward_minimum\":true}','object','§5.1','Provisional registration: at most 12 months from acceptance, of which at most 9 months are for preparing the research proposal; counts toward the minimum period of registration.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(87,3,'registration','full','{\"apply_before_provisional_expiry_months\":3,\"corrections_days\":30,\"final_proposal_days\":30,\"per_semester\":true,\"discontinue_on_provisional_failure\":true}','object','§5.2','Full registration: apply at latest 3 months before provisional expiry; proposal corrections and final submission within 30 calendar days of presentation; candidates register every semester.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(88,3,'duration','limits','{\"min_years_fulltime\":3,\"min_years_parttime\":4,\"max_multiplier\":2,\"max_years\":8,\"disability_extra_years\":2,\"disability_max_years\":10,\"proposal_phase_included\":true}','object','§6.1-§6.5','PhD duration: minimum 3 years full-time / 4 years part-time; maximum twice the normal completion time; hard cap 8 years, extended to 10 years for persons with disabilities. The 9-month proposal phase is included.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(89,3,'duration','extension','{\"granted_once\":true,\"max_months\":12,\"apply_before_lapse_months\":3,\"requires_supervisor_support\":true}','object','§6.7','Extension is granted once for no longer than 12 months; the candidate must apply in writing at least 3 months before the approved period lapses, with reasons and supervisor support.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(90,3,'duration','cancellation','{\"no_contact_months\":6,\"cancel_on_nonsubmission\":true}','object','§6.8.1, §6.8.2','Registration is liable to cancellation after at least 6 months of no contact with the supervisor or unsatisfactory progress, or on non-submission by the end of the prescribed/extended period.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(91,3,'supervision','recognition','{\"min_post_phd_years\":2,\"exemption_approved_by\":[\"Vice-Chancellor\",\"Senate\"]}','object','§7','Recognition as a PhD supervisor requires a minimum of two years of research or teaching experience after acquiring a PhD; merit exemptions are approved by the Vice-Chancellor and Senate.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(92,3,'supervision','capacity','{\"professor\":8,\"associate_professor\":6,\"senior_lecturer\":4,\"lecturer\":2,\"lecturer_co_supervisor_only\":true}','object','§7.3.1','Maximum candidates a supervisor may guide at any time by rank. A tenured PhD-holding Lecturer supervises at most 2, and only as co-supervisor until they have supervised someone to completion.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(93,3,'supervision','categories','[\"research_supervisor\",\"co_supervisor\",\"assistant_supervisor\"]','list','§7.1.6','Recognised supervisor categories.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(94,3,'supervision','interim_trigger_months','6','int','§7.2.2','When a research supervisor is away for more than this many months, the DHDC nominates an interim research supervisor.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(95,3,'supervision','skills_training','{\"min_courses\":2,\"max_courses\":4,\"optional\":true,\"affects_result\":false,\"earns_credits\":true}','object','§7.5','Optional doctoral training courses: minimum 2, maximum 4. They have no bearing on the final result but earn transferable credits.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(96,3,'supervision','progress_report_months','6','int','§7.6.1','Interval at which the candidate submits a progress report, measured against research objectives, activities and milestones.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(97,3,'thesis','notice','{\"min_weeks_before\":12,\"max_months_before\":6}','object','§8.6.1','Notice to submit a thesis is made not less than 3 months (12 weeks) and not more than 6 months before submission.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(98,3,'thesis','early_submission','{\"fulltime_max_years_early\":1,\"parttime_max_years_early\":2}','object','§8.6.3','Early submission needs supervisory-team and University permission, granted up to 1 year before the end of the degree for full-time and 2 years for part-time candidates.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(99,3,'thesis','format','{\"electronic_copies\":1,\"electronic_format\":\"PDF\",\"paper_copies\":6}','object','§8.6.4','Submission format: one electronic PDF copy with a plain-text metadata record, plus six paper copies printed from the submitted electronic copy.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(100,3,'thesis','auto_lapse_on_nonsubmission','true','bool','§8.6.2','If a thesis is not submitted before the end of the degree timeline or submission-pending period, registration automatically lapses and the candidate cannot subsequently submit without further University approval.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(101,3,'adjudication','examiners','{\"count\":3,\"min_international\":1,\"nominated_by\":\"Vice-Chancellor\"}','object','§9.1','The thesis is evaluated by 3 examiners nominated by the Vice-Chancellor from the DRC-recommended panel; at least one must be affiliated with an institution outside the country.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(102,3,'adjudication','review_max_weeks','8','int','§9.2','Maximum period within which examiners should review and examine the thesis.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(103,3,'adjudication','outcomes','[{\"code\":\"pass_minor\",\"label\":\"Pass and proceed to viva voce with minor corrections\"},{\"code\":\"pass_major\",\"label\":\"Pass and proceed to viva voce with major corrections\",\"reassessment_within_months\":3},{\"code\":\"resubmit\",\"label\":\"Do not proceed to viva voce; resubmit thesis\",\"resubmit_within_months\":12,\"reassessment_within_months\":3}]','object','§9.3','Overall assessment categories an examiner may place the thesis in. Re-assessment of corrections is within 3 months; a resubmission is within 12 months.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(104,3,'viva','publication_rule','{\"min_publications\":2,\"min_research_papers\":1,\"refereed\":true,\"accepted_counts\":true}','object','§10.1','Eligibility for the viva requires a minimum of two publications in refereed journals (or evidence of acceptance for publication), at least one of which is a research paper.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(105,3,'viva','board','{\"convener\":\"Chair of the Doctoral Research Committee\",\"defense_type\":\"open\",\"members\":[\"chair_drc\",\"thesis_examiners\",\"external_examiner\",\"dean\",\"department_chair\"]}','object','§10.2-§10.4','The viva is an open-defense examination convened by the Chair of the DRC; the board includes the Chair of the DRC, the thesis examiners, the external examiner, the Dean of the School and the Chair of the Department.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(106,3,'viva','reappear','{\"max_months_after_first\":6,\"extra_examiner_on_second\":1,\"second_fail_to_vc_committee\":true,\"process_max_months\":6}','object','§10.5, §10.6, §10.7','A not-satisfactory viva may be reattempted once, ≤6 months after the first; the second board adds one VC-nominated examiner. A second not-satisfactory result goes to a VC committee (final). The whole evaluation completes within 6 months of submission.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(107,3,'award','approval','{\"recommended_by\":\"Senate\",\"approved_by\":\"Institute Board\",\"classified\":false}','object','§11','On a satisfactory viva the PhD is awarded on the recommendation of the Senate and with the approval of the Institute Board. The degree is unclassified.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(108,3,'award','repository','{\"deposit_to\":\"Institutional Electronic Repository\",\"publication_requires_university_approval\":true}','object','§11.6','The corrected, supervisor-certified thesis is deposited to the Institutional Electronic Repository; the thesis as a whole may not be published by the candidate without specific University approval.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(109,3,'references','related_policies','[\"Postgraduate Handbook\",\"Admissions Policy\",\"Registration Policy\",\"Research Policy\",\"Intellectual Property Policy\",\"Artificial Intelligence Policy\",\"Plagiarism Policy\",\"Guideline on the avoidance of plagiarism\",\"Students\' Disciplinary Regulations\",\"Postgraduate SOPs\",\"Data Management Policies\"]','list','§12','Policies and procedures these regulations must be read together with.','2026-07-11 16:58:04','2026-07-11 16:58:04'),
(110,4,'classification','part_weights','{\"I\":5,\"II\":10,\"III\":20,\"IV\":30,\"V\":35}','object','§11.0','Degree weighting per Part (five-year programme).','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(111,4,'classification','divisions','[{\"class\":\"1 (First Class)\",\"min\":75,\"max\":100},{\"class\":\"2.1 (Upper Second Class)\",\"min\":65,\"max\":74},{\"class\":\"2.2 (Lower Second Class)\",\"min\":55,\"max\":64},{\"class\":\"Pass (3 \\/ Third Class)\",\"min\":50,\"max\":54},{\"class\":\"Fail\",\"min\":0,\"max\":49}]','list','§10.0','Degree classification by final mark attained.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(112,4,'grading','pass_mark','50','int','§10.0','Programme pass mark.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(113,4,'assessment','practical','{\"exam\":60,\"ca\":40,\"tests\":15,\"practical\":25}','object','§9.1-9.2','Practical course: exam 60, CA 40 (tests/assignments 15 + practical work 25).','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(114,4,'assessment','non_practical','{\"exam\":75,\"ca\":25}','object','§9.3','Non-practical course: exam 75, CA 25.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(115,4,'assessment','ca_pass','50','int','§9.3','Minimum coursework mark to sit the final examination.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(116,4,'assessment','project_components','[{\"component\":\"Project proposal document\",\"pct\":10},{\"component\":\"Concept development & evaluation report\",\"pct\":15},{\"component\":\"Prototype development & evaluation\",\"pct\":25},{\"component\":\"Final written project report\",\"pct\":20},{\"component\":\"Oral presentation of project\\/report\",\"pct\":30}]','list','§9.4-9.5','Team Project (HIT0200/0300) and Design & Innovation Project (HIT0400) mark breakdown.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(117,4,'assessment','capstone_components','[{\"component\":\"Project proposal document\",\"pct\":10},{\"component\":\"Concept development & evaluation report\",\"pct\":15},{\"component\":\"Prototype development & evaluation\",\"pct\":25},{\"component\":\"Final written project report\",\"pct\":30},{\"component\":\"Oral presentation of project\\/report\",\"pct\":20}]','list','§9.7','Capstone Design Project (HIT0500) mark breakdown.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(118,4,'assessment','internship','{\"continuous_pct\":50,\"final_pct\":50,\"components\":[{\"component\":\"Clinical Supervisor\'s Assessment Form\",\"pct\":20},{\"component\":\"Internship Supervisor\'s Assessment Form\",\"pct\":30},{\"component\":\"Student\'s Clinical Practice Report\",\"pct\":30},{\"component\":\"Oral Examination\",\"pct\":20}]}','object','§9.6','Internship/clinical practice (HIT0401): 50% continuous + 50% final; both must be passed.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(119,4,'duration','limits','{\"normal_years\":5,\"max_years\":8,\"extension_semesters\":2}','object','§7.0','Five-year full-time programme; Part IV is a full-year internship.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(120,4,'coding','prefixes','[\"EBE\",\"EEE\",\"EIM\",\"EST\",\"HIT\"]','list','§8.0','Course-code prefixes used by the programme (EBE is department-owned; the rest are service courses).','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(121,4,'professional','bodies','[\"AHPCZ\",\"ZIE\"]','list','§1.0','Professional bodies students are encouraged to register with.','2026-07-13 09:05:48','2026-07-13 09:05:48'),
(122,5,'classification','part_weights','{\"I\":5,\"II\":20,\"III\":30,\"IV\":45}','object','§10.0','Degree weighting per Part.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(123,5,'classification','divisions','[{\"class\":\"First Class (1)\",\"min\":75,\"max\":100},{\"class\":\"Upper Second Class (2.1)\",\"min\":65,\"max\":74},{\"class\":\"Lower Second Class (2.2)\",\"min\":55,\"max\":64},{\"class\":\"Pass (P \\/ Third Class)\",\"min\":50,\"max\":54},{\"class\":\"Fail (F)\",\"min\":0,\"max\":49}]','list','§10.0','Degree classification by final mark attained.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(124,5,'classification','gpa_scale','[{\"grade\":\"O\",\"points\":10,\"min\":91,\"max\":100,\"remark\":\"Outstanding\"},{\"grade\":\"A+\",\"points\":9,\"min\":81,\"max\":90,\"remark\":\"Excellent\"},{\"grade\":\"A\",\"points\":8,\"min\":75,\"max\":80,\"remark\":\"Very Good\"},{\"grade\":\"B+\",\"points\":7,\"min\":70,\"max\":74,\"remark\":\"Good\"},{\"grade\":\"B\",\"points\":6,\"min\":65,\"max\":69,\"remark\":\"Above Average\"},{\"grade\":\"C\",\"points\":5,\"min\":55,\"max\":64,\"remark\":\"Average\"},{\"grade\":\"P\",\"points\":4,\"min\":50,\"max\":54,\"remark\":\"Pass\"},{\"grade\":\"F\",\"points\":0,\"min\":0,\"max\":49,\"remark\":\"Fail\"}]','list','§10.0','Letter-grade / grade-point scale in force from the 2026-2027 academic year.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(125,5,'grading','pass_mark','50','int','§9.5','Programme pass mark.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(126,5,'assessment','standard','{\"exam\":60,\"ca\":40}','object','§9.1','All Radiography courses: written examination 60, continuous assessment 40.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(127,5,'assessment','ca_pass','50','int','§9.1','Minimum continuous-assessment mark to sit the Institute examination.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(128,5,'assessment','clinical','{\"pass_mark\":50}','object','§9.3','Clinical practice: CA (clinical assessment + case study) plus a clinical exam (hands-on work + viva voce, averaged) marked by the clinical supervisor and an academic. Failing it bars the Institute examination.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(129,5,'assessment','project_components','[{\"component\":\"Concept note\",\"pct\":10},{\"component\":\"Progress report \\/ proposal document\",\"pct\":15},{\"component\":\"2nd progress report \\/ project evaluation\",\"pct\":15},{\"component\":\"Oral presentation\",\"pct\":20},{\"component\":\"Final written document\",\"pct\":40}]','list','§9.4','HIT200 (Team Development), HIT300 (Design & Innovation) and HIT400 (Research) project mark breakdown.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(130,5,'progression','graduation_all_courses','true','bool','§9.4','Students cannot graduate without passing all courses.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(131,5,'coding','prefixes','[\"ARG\",\"ICS\",\"SST\",\"HIT\"]','list','§8.0','Course-code prefixes used by the programme (ARG is department-owned; the rest are service courses).','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(132,5,'professional','bodies','[\"AHPCZ\"]','list','§1.0','Registration with this council is required for the duration of study; a one-year internship follows on its provisional register.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(133,6,'classification','part_weights','{\"I\":5,\"II\":20,\"III\":30,\"IV\":45}','object','§12.2','Degree weighting per Part.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(134,6,'classification','divisions','[{\"class\":\"First Class (1)\",\"min\":75,\"max\":100},{\"class\":\"Upper Second (2.1)\",\"min\":65,\"max\":74},{\"class\":\"Lower Second (2.2)\",\"min\":55,\"max\":64},{\"class\":\"Pass (P)\",\"min\":45,\"max\":54},{\"class\":\"Fail (F)\",\"min\":0,\"max\":44}]','list','§12.1','Degree classification by final mark attained (Pass band 45-54).','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(135,6,'grading','pass_mark','45','int','§12.1','Programme pass mark.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(136,6,'assessment','practical','{\"exam\":60,\"ca\":40,\"tests\":15,\"practical\":25}','object','§9.1','Practical course: exam 60, CA 40 (assignments/tests 15 + practical work 25).','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(137,6,'assessment','non_practical','{\"exam\":75,\"ca\":25}','object','§9.2','Non-practical course: exam 75, CA 25.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(138,6,'assessment','ca_pass','50','int','§9.3','Minimum coursework mark to sit the final examination.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(139,6,'attendance','min_pct','80','int','§9.3','Minimum class attendance.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(140,6,'assessment','project_components','[{\"component\":\"Project proposal document\",\"pct\":10},{\"component\":\"Concept development & evaluation presentations\",\"pct\":15},{\"component\":\"Research\\/Prototype development & evaluation\",\"pct\":25},{\"component\":\"Final written project report\",\"pct\":30},{\"component\":\"Oral presentation of project\\/report\",\"pct\":20}]','list','§9.4','Team Product Development Project (HIT2001) mark breakdown.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(141,6,'assessment','design_project_components','[{\"component\":\"Project proposal document\",\"pct\":10},{\"component\":\"Concept development & evaluation report\",\"pct\":15},{\"component\":\"Prototype development & evaluation\",\"pct\":25},{\"component\":\"Final written project report\",\"pct\":20},{\"component\":\"Oral presentation of project\\/report\",\"pct\":30}]','list','§10.4','Design & Innovation Project (HIT3001) mark breakdown.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(142,6,'assessment','capstone_components','[{\"component\":\"Project proposal document (panel)\",\"pct\":10},{\"component\":\"Concept development & evaluation presentations\",\"pct\":15},{\"component\":\"Research\\/Prototype development & evaluation report\",\"pct\":25},{\"component\":\"Final written project report\",\"pct\":30},{\"component\":\"Oral presentation of project\\/report\",\"pct\":20}]','list','§9.5','Capstone Design Project (HIT4001) mark breakdown.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(143,6,'assessment','internship','{\"components\":[{\"component\":\"Employer\'s assessment\",\"pct\":20},{\"component\":\"Internship supervisor\'s assessment\",\"pct\":30},{\"component\":\"Student\'s report\",\"pct\":30},{\"component\":\"Oral presentations\",\"pct\":20}]}','object','§11.0','Internship (HIT3002): both continuous and final components must be passed.','2026-07-13 09:05:49','2026-07-13 09:05:49'),
(144,6,'coding','prefixes','[\"SBT\",\"HIT\",\"SST\"]','list','§14.0','Course-code prefixes used by the programme (SBT is department-owned; the rest are service courses).','2026-07-13 09:05:49','2026-07-13 09:05:49');
/*!40000 ALTER TABLE `regulation_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulations`
--

DROP TABLE IF EXISTS `regulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `title` varchar(191) NOT NULL,
  `level` varchar(30) NOT NULL,
  `scope` varchar(16) NOT NULL DEFAULT 'general',
  `faculty_code` varchar(16) DEFAULT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `status` enum('draft','active','superseded','withdrawn') NOT NULL DEFAULT 'draft',
  `effective_date` date NOT NULL,
  `review_date` date DEFAULT NULL,
  `superseded_by_id` bigint(20) unsigned DEFAULT NULL,
  `approved_by` varchar(128) DEFAULT NULL,
  `source_ref` varchar(128) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regulations_code_unique` (`code`),
  KEY `regulations_superseded_by_id_foreign` (`superseded_by_id`),
  KEY `regulations_parent_id_foreign` (`parent_id`),
  KEY `regulations_programme_id_foreign` (`programme_id`),
  CONSTRAINT `regulations_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `regulations` (`id`) ON DELETE SET NULL,
  CONSTRAINT `regulations_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `regulations_superseded_by_id_foreign` FOREIGN KEY (`superseded_by_id`) REFERENCES `regulations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulations`
--

LOCK TABLES `regulations` WRITE;
/*!40000 ALTER TABLE `regulations` DISABLE KEYS */;
INSERT INTO `regulations` VALUES
(1,'SEN01/03/24','General Academic Regulations for Undergraduate Programmes','undergraduate','general',NULL,NULL,NULL,'active','2024-03-01',NULL,NULL,'Senate','SEN01/03/24','2026-07-11 11:26:50','2026-07-11 11:26:50'),
(2,'SEN03/25/22','General Academic Regulations for Postgraduate (MTech) Degrees','postgraduate','general',NULL,NULL,NULL,'active','2022-01-01',NULL,NULL,'Senate','SEN03/25/22','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(3,'SEN01/02/25(B)','Doctor of Philosophy General Regulations','phd','general',NULL,NULL,NULL,'active','2025-01-01',NULL,NULL,'Senate','SEN01/02/25(B)','2026-07-11 16:58:03','2026-07-11 16:58:03'),
(4,'BBME-REG','BTech (Hons) Biomedical Engineering Programme Regulations','undergraduate','department','EST',14,1,'active','2024-03-01',NULL,NULL,'Senate','BTech (Hons) Biomedical Engineering Programme Regulations','2026-07-13 09:05:48','2026-07-17 09:42:45'),
(5,'BDR-REG','BSc (Hons) Diagnostic Radiography Academic Regulations (2020)','undergraduate','department','AHS',30,1,'active','2020-01-01',NULL,NULL,'Senate','BSc (Hons) Diagnostic Radiography Academic Regulations (2020)','2026-07-13 09:05:49','2026-07-17 09:42:46'),
(6,'BBT-REG','BTech (Hons) Biotechnology Academic Regulations','undergraduate','department','SST',25,1,'active','2024-03-01',NULL,NULL,'Senate','BTech (Hons) Biotechnology Academic Regulations','2026-07-13 09:05:49','2026-07-17 09:42:46');
/*!40000 ALTER TABLE `regulations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_assessment_marks`
--

DROP TABLE IF EXISTS `student_assessment_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_assessment_marks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `module_assessment_id` bigint(20) unsigned NOT NULL,
  `marks_obtained` decimal(5,2) NOT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `graded_at` timestamp NULL DEFAULT NULL,
  `graded_by` bigint(20) unsigned DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_assessment_marks_module_assessment_id_foreign` (`module_assessment_id`),
  KEY `student_assessment_marks_graded_by_foreign` (`graded_by`),
  KEY `student_assessment_marks_student_id_module_assessment_id_index` (`student_id`,`module_assessment_id`),
  CONSTRAINT `student_assessment_marks_graded_by_foreign` FOREIGN KEY (`graded_by`) REFERENCES `users` (`id`),
  CONSTRAINT `student_assessment_marks_module_assessment_id_foreign` FOREIGN KEY (`module_assessment_id`) REFERENCES `module_assessments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_assessment_marks`
--

LOCK TABLES `student_assessment_marks` WRITE;
/*!40000 ALTER TABLE `student_assessment_marks` DISABLE KEYS */;
INSERT INTO `student_assessment_marks` VALUES
(1,1,1,90.00,'2026-07-20 07:58:48','2026-07-20 07:58:48',NULL,NULL,'2026-07-20 07:58:42','2026-07-20 07:58:48'),
(2,1,2,20.00,'2026-07-20 07:58:57','2026-07-20 07:58:57',NULL,NULL,'2026-07-20 07:58:57','2026-07-20 07:58:57'),
(3,1,3,90.00,'2026-07-20 07:59:08','2026-07-20 07:59:08',NULL,NULL,'2026-07-20 07:59:08','2026-07-20 07:59:08'),
(4,1,4,80.00,'2026-07-20 07:59:35','2026-07-20 07:59:35',NULL,NULL,'2026-07-20 07:59:35','2026-07-20 07:59:35');
/*!40000 ALTER TABLE `student_assessment_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_cumulative_gpas`
--

DROP TABLE IF EXISTS `student_cumulative_gpas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_cumulative_gpas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `cgpa` decimal(4,2) NOT NULL,
  `total_credits` int(11) NOT NULL,
  `total_credits_earned` int(11) NOT NULL,
  `classification` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_cumulative_gpas_student_id_unique` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_cumulative_gpas`
--

LOCK TABLES `student_cumulative_gpas` WRITE;
/*!40000 ALTER TABLE `student_cumulative_gpas` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_cumulative_gpas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_module_attendances`
--

DROP TABLE IF EXISTS `student_module_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_module_attendances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `semester` varchar(10) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `classes_held` int(10) unsigned NOT NULL,
  `classes_attended` int(10) unsigned NOT NULL,
  `attendance_percentage` decimal(5,2) NOT NULL,
  `attendance_slip_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_module_attendance_unique` (`student_id`,`module_id`,`semester`,`academic_year`),
  KEY `student_module_attendances_module_id_foreign` (`module_id`),
  KEY `student_module_attendances_attendance_slip_id_foreign` (`attendance_slip_id`),
  CONSTRAINT `student_module_attendances_attendance_slip_id_foreign` FOREIGN KEY (`attendance_slip_id`) REFERENCES `attendance_slips` (`id`) ON DELETE SET NULL,
  CONSTRAINT `student_module_attendances_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_module_attendances`
--

LOCK TABLES `student_module_attendances` WRITE;
/*!40000 ALTER TABLE `student_module_attendances` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_module_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_module_registrations`
--

DROP TABLE IF EXISTS `student_module_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_module_registrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `registration_number` varchar(191) NOT NULL,
  `programme_id` bigint(20) unsigned DEFAULT NULL,
  `module_code` varchar(20) NOT NULL,
  `status` enum('active','dropped') NOT NULL DEFAULT 'active',
  `source` enum('event','manual') NOT NULL DEFAULT 'event',
  `registered_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `smr_regno_module_unique` (`registration_number`,`module_code`),
  KEY `student_module_registrations_registration_number_index` (`registration_number`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_module_registrations`
--

LOCK TABLES `student_module_registrations` WRITE;
/*!40000 ALTER TABLE `student_module_registrations` DISABLE KEYS */;
INSERT INTO `student_module_registrations` VALUES
(1,'H228274H',NULL,'ICT101','active','event',NULL,'2026-07-17 08:28:06','2026-07-17 08:28:06'),
(2,'H228274H',NULL,'ICT102','active','event',NULL,'2026-07-17 08:28:06','2026-07-17 08:28:06'),
(3,'H227303P',NULL,'ICT101','dropped','event',NULL,'2026-07-17 08:28:20','2026-07-17 08:28:20'),
(4,'H237718I',NULL,'ICT101','dropped','event',NULL,'2026-07-17 08:28:23','2026-07-17 08:28:23'),
(5,'H215088T',NULL,'ICT101','active','event',NULL,'2026-07-17 10:05:42','2026-07-17 10:05:42'),
(6,'H215088T',NULL,'ICT102','active','event',NULL,'2026-07-17 10:05:42','2026-07-17 10:05:42'),
(7,'H196416L',NULL,'ICT101','dropped','event',NULL,'2026-07-17 10:05:53','2026-07-17 10:05:53'),
(8,'H192060H',NULL,'ICT101','dropped','event',NULL,'2026-07-17 10:05:56','2026-07-17 10:05:56'),
(9,'H172258K',NULL,'ICT101','active','event',NULL,'2026-07-17 10:42:12','2026-07-17 10:42:12'),
(10,'H172258K',NULL,'ICT102','active','event',NULL,'2026-07-17 10:42:12','2026-07-17 10:42:12'),
(11,'H225103M',NULL,'ICT101','dropped','event',NULL,'2026-07-17 10:42:29','2026-07-17 10:42:29'),
(12,'H163877E',NULL,'ICT101','dropped','event',NULL,'2026-07-17 10:42:33','2026-07-17 10:42:33'),
(13,'H180526R',NULL,'ICT101','active','event',NULL,'2026-07-17 11:13:55','2026-07-17 11:13:55'),
(14,'H180526R',NULL,'ICT102','active','event',NULL,'2026-07-17 11:13:55','2026-07-17 11:13:55'),
(15,'H233297Z',NULL,'ICT101','dropped','event',NULL,'2026-07-17 11:14:10','2026-07-17 11:14:10'),
(16,'H191690K',NULL,'ICT101','dropped','event',NULL,'2026-07-17 11:14:14','2026-07-17 11:14:14'),
(17,'H203477T',NULL,'ICT101','active','event',NULL,'2026-07-17 12:04:58','2026-07-17 12:04:58'),
(18,'H203477T',NULL,'ICT102','active','event',NULL,'2026-07-17 12:04:58','2026-07-17 12:04:58'),
(19,'H239418L',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:05:12','2026-07-17 12:05:12'),
(20,'H183357V',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:05:15','2026-07-17 12:05:15'),
(21,'H161633H',NULL,'ICT101','active','event',NULL,'2026-07-17 12:12:09','2026-07-17 12:12:09'),
(22,'H161633H',NULL,'ICT102','active','event',NULL,'2026-07-17 12:12:09','2026-07-17 12:12:09'),
(23,'H151975L',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:12:21','2026-07-17 12:12:21'),
(24,'H219740D',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:12:24','2026-07-17 12:12:24'),
(25,'H214951M',NULL,'ICT101','active','event',NULL,'2026-07-17 12:29:41','2026-07-17 12:29:41'),
(26,'H214951M',NULL,'ICT102','active','event',NULL,'2026-07-17 12:29:41','2026-07-17 12:29:41'),
(27,'H153047N',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:29:53','2026-07-17 12:29:53'),
(28,'H211729A',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:29:56','2026-07-17 12:29:56'),
(29,'H205372J',NULL,'ICT101','active','event',NULL,'2026-07-17 12:49:26','2026-07-17 12:49:26'),
(30,'H205372J',NULL,'ICT102','active','event',NULL,'2026-07-17 12:49:26','2026-07-17 12:49:26'),
(31,'H184237F',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:49:36','2026-07-17 12:49:36'),
(32,'H151394L',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:49:39','2026-07-17 12:49:39'),
(33,'H177192Y',NULL,'ICT101','active','event',NULL,'2026-07-17 12:59:16','2026-07-17 12:59:16'),
(34,'H177192Y',NULL,'ICT102','active','event',NULL,'2026-07-17 12:59:16','2026-07-17 12:59:16'),
(35,'H191754L',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:59:28','2026-07-17 12:59:28'),
(36,'H190480D',NULL,'ICT101','dropped','event',NULL,'2026-07-17 12:59:30','2026-07-17 12:59:30'),
(37,'H204778Y',NULL,'ICT101','active','event',NULL,'2026-07-17 15:56:48','2026-07-17 15:56:48'),
(38,'H204778Y',NULL,'ICT102','active','event',NULL,'2026-07-17 15:56:48','2026-07-17 15:56:48'),
(39,'H180797P',NULL,'ICT101','dropped','event',NULL,'2026-07-17 15:56:59','2026-07-17 15:56:59'),
(40,'H231716M',NULL,'ICT101','dropped','event',NULL,'2026-07-17 15:57:03','2026-07-17 15:57:03'),
(41,'H209138U',NULL,'ICT101','active','event',NULL,'2026-07-17 16:25:25','2026-07-17 16:25:25'),
(42,'H209138U',NULL,'ICT102','active','event',NULL,'2026-07-17 16:25:25','2026-07-17 16:25:25'),
(43,'H168846P',NULL,'ICT101','dropped','event',NULL,'2026-07-17 16:25:35','2026-07-17 16:25:35'),
(44,'H226480O',NULL,'ICT101','dropped','event',NULL,'2026-07-17 16:25:37','2026-07-17 16:25:37'),
(45,'H197781S',NULL,'ICT101','active','event',NULL,'2026-07-17 21:58:05','2026-07-17 21:58:05'),
(46,'H197781S',NULL,'ICT102','active','event',NULL,'2026-07-17 21:58:05','2026-07-17 21:58:05'),
(47,'H180706L',NULL,'ICT101','dropped','event',NULL,'2026-07-17 21:58:16','2026-07-17 21:58:16'),
(48,'H195491I',NULL,'ICT101','dropped','event',NULL,'2026-07-17 21:58:19','2026-07-17 21:58:19'),
(49,'HIT-2026-00001',7,'ICT101','active','event',NULL,'2026-07-17 22:02:38','2026-07-17 22:02:38'),
(50,'HIT-2026-00001',7,'ICT102','active','event',NULL,'2026-07-17 22:02:38','2026-07-17 22:02:38'),
(51,'H224758W',NULL,'ICT101','active','event',NULL,'2026-07-17 22:49:29','2026-07-17 22:49:29'),
(52,'H224758W',NULL,'ICT102','active','event',NULL,'2026-07-17 22:49:29','2026-07-17 22:49:29'),
(53,'H215101E',NULL,'ICT101','dropped','event',NULL,'2026-07-17 22:49:53','2026-07-17 22:49:53'),
(54,'H166362B',NULL,'ICT101','dropped','event',NULL,'2026-07-17 22:49:58','2026-07-17 22:49:58'),
(55,'H177524F',NULL,'ICT101','active','event',NULL,'2026-07-18 11:33:42','2026-07-18 11:33:42'),
(56,'H177524F',NULL,'ICT102','active','event',NULL,'2026-07-18 11:33:42','2026-07-18 11:33:42'),
(57,'H235362J',NULL,'ICT101','dropped','event',NULL,'2026-07-18 11:33:52','2026-07-18 11:33:52'),
(58,'H237573G',NULL,'ICT101','dropped','event',NULL,'2026-07-18 11:33:55','2026-07-18 11:33:55'),
(59,'H180027G',NULL,'ICT101','active','event',NULL,'2026-07-18 12:19:18','2026-07-18 12:19:18'),
(60,'H180027G',NULL,'ICT102','active','event',NULL,'2026-07-18 12:19:18','2026-07-18 12:19:18'),
(61,'H180158H',NULL,'ICT101','dropped','event',NULL,'2026-07-18 12:19:27','2026-07-18 12:19:27'),
(62,'H216987X',NULL,'ICT101','dropped','event',NULL,'2026-07-18 12:19:30','2026-07-18 12:19:30'),
(63,'H225622V',NULL,'ICT101','active','event',NULL,'2026-07-18 12:29:34','2026-07-18 12:29:34'),
(64,'H225622V',NULL,'ICT102','active','event',NULL,'2026-07-18 12:29:34','2026-07-18 12:29:34'),
(65,'H208278N',NULL,'ICT101','dropped','event',NULL,'2026-07-18 12:29:43','2026-07-18 12:29:43'),
(66,'H162010K',NULL,'ICT101','dropped','event',NULL,'2026-07-18 12:29:45','2026-07-18 12:29:45'),
(67,'H164800T',NULL,'ICT101','active','event',NULL,'2026-07-18 13:55:14','2026-07-18 13:55:14'),
(68,'H164800T',NULL,'ICT102','active','event',NULL,'2026-07-18 13:55:14','2026-07-18 13:55:14'),
(69,'H180117C',NULL,'ICT101','dropped','event',NULL,'2026-07-18 13:55:25','2026-07-18 13:55:25'),
(70,'H226551O',NULL,'ICT101','dropped','event',NULL,'2026-07-18 13:55:28','2026-07-18 13:55:28'),
(71,'H158350F',NULL,'ICT101','active','event',NULL,'2026-07-18 14:03:34','2026-07-18 14:03:34'),
(72,'H158350F',NULL,'ICT102','active','event',NULL,'2026-07-18 14:03:34','2026-07-18 14:03:34'),
(73,'H233484Z',NULL,'ICT101','dropped','event',NULL,'2026-07-18 14:03:45','2026-07-18 14:03:45'),
(74,'H171105V',NULL,'ICT101','dropped','event',NULL,'2026-07-18 14:03:47','2026-07-18 14:03:47'),
(75,'H181211Z',NULL,'ICT101','active','event',NULL,'2026-07-18 14:23:33','2026-07-18 14:23:33'),
(76,'H181211Z',NULL,'ICT102','active','event',NULL,'2026-07-18 14:23:33','2026-07-18 14:23:33'),
(77,'H162680M',NULL,'ICT101','dropped','event',NULL,'2026-07-18 14:23:42','2026-07-18 14:23:42'),
(78,'H162967B',NULL,'ICT101','dropped','event',NULL,'2026-07-18 14:23:44','2026-07-18 14:23:44'),
(79,'H176416V',NULL,'ICT101','active','event',NULL,'2026-07-18 14:37:19','2026-07-18 14:37:19'),
(80,'H176416V',NULL,'ICT102','active','event',NULL,'2026-07-18 14:37:19','2026-07-18 14:37:19'),
(81,'H210691V',NULL,'ICT101','dropped','event',NULL,'2026-07-18 14:37:29','2026-07-18 14:37:29'),
(82,'H188262N',NULL,'ICT101','dropped','event',NULL,'2026-07-18 14:37:31','2026-07-18 14:37:31'),
(83,'H228693E',NULL,'ICT101','active','event',NULL,'2026-07-18 15:00:06','2026-07-18 15:00:06'),
(84,'H228693E',NULL,'ICT102','active','event',NULL,'2026-07-18 15:00:06','2026-07-18 15:00:06'),
(85,'H235523F',NULL,'ICT101','dropped','event',NULL,'2026-07-18 15:00:26','2026-07-18 15:00:26'),
(86,'H178634K',NULL,'ICT101','dropped','event',NULL,'2026-07-18 15:00:31','2026-07-18 15:00:31'),
(87,'H177373C',NULL,'ICT101','active','event',NULL,'2026-07-18 15:30:22','2026-07-18 15:30:22'),
(88,'H177373C',NULL,'ICT102','active','event',NULL,'2026-07-18 15:30:22','2026-07-18 15:30:22'),
(89,'H168947U',NULL,'ICT101','dropped','event',NULL,'2026-07-18 15:30:37','2026-07-18 15:30:37'),
(90,'H171663N',NULL,'ICT101','dropped','event',NULL,'2026-07-18 15:30:40','2026-07-18 15:30:40'),
(91,'H177895Q',NULL,'ICT101','active','event',NULL,'2026-07-18 15:49:08','2026-07-18 15:49:08'),
(92,'H177895Q',NULL,'ICT102','active','event',NULL,'2026-07-18 15:49:08','2026-07-18 15:49:08'),
(93,'H170793I',NULL,'ICT101','dropped','event',NULL,'2026-07-18 15:49:21','2026-07-18 15:49:21'),
(94,'H201103Q',NULL,'ICT101','dropped','event',NULL,'2026-07-18 15:49:24','2026-07-18 15:49:24'),
(95,'H191871T',NULL,'ICT101','active','event',NULL,'2026-07-18 16:52:50','2026-07-18 16:52:50'),
(96,'H191871T',NULL,'ICT102','active','event',NULL,'2026-07-18 16:52:50','2026-07-18 16:52:50'),
(97,'H207973B',NULL,'ICT101','dropped','event',NULL,'2026-07-18 16:52:59','2026-07-18 16:52:59'),
(98,'H229544W',NULL,'ICT101','dropped','event',NULL,'2026-07-18 16:53:02','2026-07-18 16:53:02'),
(99,'H205538K',NULL,'ICT101','active','event',NULL,'2026-07-18 17:11:49','2026-07-18 17:11:49'),
(100,'H205538K',NULL,'ICT102','active','event',NULL,'2026-07-18 17:11:49','2026-07-18 17:11:49'),
(101,'H232391E',NULL,'ICT101','dropped','event',NULL,'2026-07-18 17:12:05','2026-07-18 17:12:05'),
(102,'H175008Q',NULL,'ICT101','dropped','event',NULL,'2026-07-18 17:12:07','2026-07-18 17:12:07'),
(103,'H260001J',10,'ARG1101','active','manual',144,'2026-07-20 07:58:11','2026-07-20 07:58:11');
/*!40000 ALTER TABLE `student_module_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_module_results`
--

DROP TABLE IF EXISTS `student_module_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_module_results` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `module_id` bigint(20) unsigned NOT NULL,
  `semester` varchar(10) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `final_mark` decimal(5,2) NOT NULL,
  `grade` varchar(5) NOT NULL,
  `grade_points` decimal(3,1) NOT NULL,
  `credits` int(11) NOT NULL,
  `status` enum('pass','fail','carry','incomplete') DEFAULT 'pass',
  `exam_barred` tinyint(1) NOT NULL DEFAULT 0,
  `is_exempt` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_module_results_module_id_foreign` (`module_id`),
  KEY `student_module_results_student_id_semester_academic_year_index` (`student_id`,`semester`,`academic_year`),
  CONSTRAINT `student_module_results_module_id_foreign` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_module_results`
--

LOCK TABLES `student_module_results` WRITE;
/*!40000 ALTER TABLE `student_module_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_module_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_semester_gpas`
--

DROP TABLE IF EXISTS `student_semester_gpas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_semester_gpas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `semester` varchar(10) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `sgpa` decimal(4,2) NOT NULL,
  `total_credits` int(11) NOT NULL,
  `credits_earned` int(11) NOT NULL,
  `status` enum('pass','proceed','carry') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_semester_gpas_student_id_semester_academic_year_unique` (`student_id`,`semester`,`academic_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_semester_gpas`
--

LOCK TABLES `student_semester_gpas` WRITE;
/*!40000 ALTER TABLE `student_semester_gpas` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_semester_gpas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `registration_number` varchar(191) NOT NULL,
  `applicant_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `programme_id` bigint(20) unsigned NOT NULL,
  `surname` varchar(191) NOT NULL,
  `first_names` varchar(191) NOT NULL,
  `national_id` varchar(30) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `current_level` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `current_semester` varchar(32) DEFAULT NULL,
  `status` enum('active','deferred','suspended','graduated','withdrawn') NOT NULL DEFAULT 'active',
  `intake_year` year(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `students_registration_number_unique` (`registration_number`),
  KEY `students_applicant_id_foreign` (`applicant_id`),
  KEY `students_user_id_foreign` (`user_id`),
  KEY `students_programme_id_foreign` (`programme_id`),
  CONSTRAINT `students_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`),
  CONSTRAINT `students_programme_id_foreign` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  CONSTRAINT `students_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES
(1,'H260001J',NULL,NULL,10,'Gusikowski','Ana','94-868836-0-26','rosemarie46@example.org','+1-410-595-5675',1,NULL,'active',2026,'2026-07-17 09:56:30','2026-07-18 17:01:01');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `study_levels`
--

DROP TABLE IF EXISTS `study_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `study_levels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `study_levels_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `study_levels`
--

LOCK TABLES `study_levels` WRITE;
/*!40000 ALTER TABLE `study_levels` DISABLE KEYS */;
INSERT INTO `study_levels` VALUES
(1,'undergraduate','Undergraduate',1,1,'2026-07-18 13:49:41','2026-07-18 17:23:12'),
(2,'postgraduate','Postgraduate',1,2,'2026-07-18 13:49:41','2026-07-18 13:49:41'),
(3,'phd','PhD',1,3,'2026-07-18 13:49:41','2026-07-18 13:49:41');
/*!40000 ALTER TABLE `study_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `role` enum('admin','viewer','hod','dean','exams_officer','records_officer','vc_office') NOT NULL DEFAULT 'viewer',
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
-- Dumping events for database 'mutupo_academic'
--

--
-- Dumping routines for database 'mutupo_academic'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-20 12:16:17
