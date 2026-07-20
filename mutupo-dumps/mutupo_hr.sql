/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: mutupo_hr
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
-- Current Database: `mutupo_hr`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mutupo_hr` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `mutupo_hr`;

--
-- Table structure for table `applicant_certifications`
--

DROP TABLE IF EXISTS `applicant_certifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_certifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `date_obtained` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant_certifications_applicant_id_foreign` (`applicant_id`),
  CONSTRAINT `applicant_certifications_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_certifications`
--

LOCK TABLES `applicant_certifications` WRITE;
/*!40000 ALTER TABLE `applicant_certifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicant_certifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_documents`
--

DROP TABLE IF EXISTS `applicant_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) unsigned NOT NULL,
  `type` enum('cv','cover_letter','certificate','transcript','membership','national_id') NOT NULL,
  `path` varchar(255) NOT NULL,
  `original_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant_documents_applicant_id_foreign` (`applicant_id`),
  CONSTRAINT `applicant_documents_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_documents`
--

LOCK TABLES `applicant_documents` WRITE;
/*!40000 ALTER TABLE `applicant_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicant_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_education`
--

DROP TABLE IF EXISTS `applicant_education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_education` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) unsigned NOT NULL,
  `institution` varchar(255) NOT NULL,
  `qualification` varchar(255) NOT NULL,
  `field_of_study` varchar(255) DEFAULT NULL,
  `grade` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant_education_applicant_id_foreign` (`applicant_id`),
  CONSTRAINT `applicant_education_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_education`
--

LOCK TABLES `applicant_education` WRITE;
/*!40000 ALTER TABLE `applicant_education` DISABLE KEYS */;
INSERT INTO `applicant_education` VALUES
(3,7,'UZ','Degree in software engineering',NULL,'10a',NULL,NULL,'2026-07-14 09:34:03','2026-07-14 09:34:03');
/*!40000 ALTER TABLE `applicant_education` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_employment`
--

DROP TABLE IF EXISTS `applicant_employment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_employment` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) unsigned NOT NULL,
  `employer` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `responsibilities` text DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant_employment_applicant_id_foreign` (`applicant_id`),
  CONSTRAINT `applicant_employment_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_employment`
--

LOCK TABLES `applicant_employment` WRITE;
/*!40000 ALTER TABLE `applicant_employment` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicant_employment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_skills`
--

DROP TABLE IF EXISTS `applicant_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_skills` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) unsigned NOT NULL,
  `type` enum('technical','professional') NOT NULL DEFAULT 'technical',
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `applicant_skills_applicant_id_foreign` (`applicant_id`),
  CONSTRAINT `applicant_skills_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_skills`
--

LOCK TABLES `applicant_skills` WRITE;
/*!40000 ALTER TABLE `applicant_skills` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicant_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicant_tokens`
--

DROP TABLE IF EXISTS `applicant_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicant_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `applicant_id` bigint(20) unsigned NOT NULL,
  `token` varchar(64) NOT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicant_tokens_token_unique` (`token`),
  KEY `applicant_tokens_applicant_id_foreign` (`applicant_id`),
  CONSTRAINT `applicant_tokens_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicant_tokens`
--

LOCK TABLES `applicant_tokens` WRITE;
/*!40000 ALTER TABLE `applicant_tokens` DISABLE KEYS */;
INSERT INTO `applicant_tokens` VALUES
(10,7,'e00d5d6ff6832d01ecc1f9be773fd80db20688f03bf69de2a25e8c61f8322304','2026-07-14 10:47:26','2026-07-14 09:34:53','2026-07-14 10:47:26');
/*!40000 ALTER TABLE `applicant_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicants`
--

DROP TABLE IF EXISTS `applicants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `applicants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `national_id` varchar(255) DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `email_verification_token` varchar(255) DEFAULT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `password_reset_expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `applicants_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicants`
--

LOCK TABLES `applicants` WRITE;
/*!40000 ALTER TABLE `applicants` DISABLE KEYS */;
INSERT INTO `applicants` VALUES
(6,'rnguwi@hit.ac.zw','$2y$12$v.Tu9Ji/nCLQMjhk2j7lI.XBM4F4GYxNZ0V1XRTR7n2KOwO6Pt7yG','Remedy',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'DBFUF2hoh167ow993hv9Wfna6iuSr0qbgYv70PzxO8nq0Ltl',NULL,NULL,'2026-06-29 11:58:16','2026-06-29 11:58:16'),
(7,'lmavondo@hit.ac.zw','$2y$12$6sXn7pzc6fO/pFHL6W0Ux.IiU4SwV2smQsqs19za9iNpHliedKtBe','Linda','21-234567L90','female','1988-02-02','zimbabwean','2323 belveder','0771234567',NULL,'NTfire6270RmkdVmxAlH6uJhtKKOhTFAo43zRlmCx7801P3X',NULL,NULL,'2026-07-14 09:32:11','2026-07-14 09:34:02');
/*!40000 ALTER TABLE `applicants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_scores`
--

DROP TABLE IF EXISTS `application_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_scores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `system_score` decimal(5,2) NOT NULL DEFAULT 0.00,
  `breakdown` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`breakdown`)),
  `ranked_position` int(10) unsigned DEFAULT NULL,
  `scored_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_scores_application_id_unique` (`application_id`),
  CONSTRAINT `application_scores_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `hr_recruitment_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_scores`
--

LOCK TABLES `application_scores` WRITE;
/*!40000 ALTER TABLE `application_scores` DISABLE KEYS */;
INSERT INTO `application_scores` VALUES
(1,21,0.00,'{\"qualification\":{\"score\":0,\"weight\":30,\"contribution\":0},\"experience\":{\"score\":0,\"weight\":30,\"contribution\":0},\"skills\":{\"score\":0,\"weight\":25,\"contribution\":0},\"certifications\":{\"score\":0,\"weight\":15,\"contribution\":0}}',1,'2026-07-14 09:09:35','2026-07-14 09:05:31','2026-07-14 09:09:35');
/*!40000 ALTER TABLE `application_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application_stages`
--

DROP TABLE IF EXISTS `application_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_stages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `stage` enum('hr_screening','technical','interview','final') NOT NULL,
  `status` varchar(255) NOT NULL,
  `comments` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `decided_by` bigint(20) unsigned DEFAULT NULL,
  `decided_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_stages_application_id_stage_unique` (`application_id`,`stage`),
  CONSTRAINT `application_stages_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `hr_recruitment_applications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_stages`
--

LOCK TABLES `application_stages` WRITE;
/*!40000 ALTER TABLE `application_stages` DISABLE KEYS */;
/*!40000 ALTER TABLE `application_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `entity` varchar(255) NOT NULL,
  `entity_id` bigint(20) unsigned DEFAULT NULL,
  `old_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_value`)),
  `new_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_value`)),
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_logs_entity_entity_id_index` (`entity`,`entity_id`),
  KEY `audit_logs_action_index` (`action`),
  KEY `audit_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES
(1,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',1,NULL,'{\"type\":\"applicants\",\"format\":\"pdf\"}','2026-06-26 15:45:34'),
(2,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',2,NULL,'{\"type\":\"shortlist\",\"format\":\"pdf\"}','2026-07-01 13:38:29'),
(3,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',3,NULL,'{\"type\":\"applicants\",\"format\":\"csv\"}','2026-07-14 07:22:28'),
(4,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',4,NULL,'{\"type\":\"applicants\",\"format\":\"pdf\"}','2026-07-14 07:38:10'),
(5,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',5,NULL,'{\"type\":\"applicants\",\"format\":\"pdf\"}','2026-07-14 07:38:54'),
(6,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',6,NULL,'{\"vacancy_id\":35,\"type\":\"summary\",\"format\":\"pdf\"}','2026-07-14 07:39:48'),
(7,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',7,NULL,'{\"vacancy_id\":35,\"type\":\"shortlist\",\"format\":\"pdf\"}','2026-07-14 07:44:13'),
(8,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',8,NULL,'{\"type\":\"applicants\",\"format\":\"pdf\"}','2026-07-14 08:09:16'),
(9,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',9,NULL,'{\"type\":\"shortlist\",\"format\":\"pdf\"}','2026-07-14 08:10:25'),
(10,145,'hr@hit.ac.zw','export.requested','RecruitmentExport',10,NULL,'{\"type\":\"applicants\",\"format\":\"pdf\"}','2026-07-14 08:10:59');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluation_criteria`
--

DROP TABLE IF EXISTS `evaluation_criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluation_criteria` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `vacancy_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `weight` smallint(5) unsigned NOT NULL DEFAULT 1,
  `position` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `evaluation_criteria_vacancy_id_foreign` (`vacancy_id`),
  CONSTRAINT `evaluation_criteria_vacancy_id_foreign` FOREIGN KEY (`vacancy_id`) REFERENCES `hr_recruitment_vacancies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluation_criteria`
--

LOCK TABLES `evaluation_criteria` WRITE;
/*!40000 ALTER TABLE `evaluation_criteria` DISABLE KEYS */;
INSERT INTO `evaluation_criteria` VALUES
(10,35,'Criterion',1,0,'2026-07-14 09:11:32','2026-07-14 09:11:32'),
(11,35,'Top 2',2,1,'2026-07-14 09:11:32','2026-07-14 09:11:32');
/*!40000 ALTER TABLE `evaluation_criteria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluations`
--

DROP TABLE IF EXISTS `evaluations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `application_id` bigint(20) unsigned NOT NULL,
  `criterion_id` bigint(20) unsigned NOT NULL,
  `evaluator_id` bigint(20) unsigned NOT NULL,
  `evaluator_name` varchar(255) DEFAULT NULL,
  `score` decimal(5,2) NOT NULL DEFAULT 0.00,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eval_unique` (`application_id`,`criterion_id`,`evaluator_id`),
  KEY `evaluations_criterion_id_foreign` (`criterion_id`),
  CONSTRAINT `evaluations_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `hr_recruitment_applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `evaluations_criterion_id_foreign` FOREIGN KEY (`criterion_id`) REFERENCES `evaluation_criteria` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluations`
--

LOCK TABLES `evaluations` WRITE;
/*!40000 ALTER TABLE `evaluations` DISABLE KEYS */;
/*!40000 ALTER TABLE `evaluations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_allowance_types`
--

DROP TABLE IF EXISTS `hr_allowance_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_allowance_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` varchar(500) NOT NULL DEFAULT '',
  `calculation` enum('fixed','percentage') NOT NULL DEFAULT 'fixed',
  `default_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `percentage_of` varchar(100) DEFAULT NULL,
  `taxable` tinyint(1) NOT NULL DEFAULT 1,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `currency` enum('ZWG','USD') NOT NULL DEFAULT 'USD',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_allowance_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_allowance_types`
--

LOCK TABLES `hr_allowance_types` WRITE;
/*!40000 ALTER TABLE `hr_allowance_types` DISABLE KEYS */;
INSERT INTO `hr_allowance_types` VALUES
(1,'HOUSING','Housing Allowance','Monthly housing allowance','percentage',15.00,'basic_salary',1,1,'USD','2026-06-25 16:12:55','2026-06-25 16:12:56');
/*!40000 ALTER TABLE `hr_allowance_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_clearance_items`
--

DROP TABLE IF EXISTS `hr_clearance_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_clearance_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `termination_id` bigint(20) unsigned NOT NULL,
  `department` varchar(255) NOT NULL,
  `item_description` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `cleared_by` bigint(20) unsigned DEFAULT NULL,
  `cleared_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_clearance_items_termination_id_status_index` (`termination_id`,`status`),
  CONSTRAINT `hr_clearance_items_termination_id_foreign` FOREIGN KEY (`termination_id`) REFERENCES `hr_terminations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_clearance_items`
--

LOCK TABLES `hr_clearance_items` WRITE;
/*!40000 ALTER TABLE `hr_clearance_items` DISABLE KEYS */;
INSERT INTO `hr_clearance_items` VALUES
(1,1,'Finance','Outstanding advances and loans cleared','not_applicable',145,'2026-07-14 07:15:43','2026-07-14 07:15:05','2026-07-14 07:15:43'),
(2,1,'IT','Company equipment and access credentials returned','not_applicable',145,'2026-07-14 07:15:45','2026-07-14 07:15:05','2026-07-14 07:15:45'),
(3,1,'HR','Employee file and benefits review completed','cleared',145,'2026-07-14 07:15:46','2026-07-14 07:15:05','2026-07-14 07:15:46'),
(4,1,'Library','Library materials returned','cleared',145,'2026-07-14 07:15:48','2026-07-14 07:15:05','2026-07-14 07:15:48'),
(5,1,'Security','Access cards and keys returned','cleared',145,'2026-07-14 07:15:50','2026-07-14 07:15:05','2026-07-14 07:15:50'),
(6,1,'Department','Department handover completed','not_applicable',145,'2026-07-14 07:15:51','2026-07-14 07:15:05','2026-07-14 07:15:51'),
(7,2,'Finance','Outstanding advances and loans cleared','cleared',145,'2026-07-14 10:29:01','2026-07-14 10:28:36','2026-07-14 10:29:01'),
(8,2,'IT','Company equipment and access credentials returned','cleared',145,'2026-07-14 10:29:02','2026-07-14 10:28:36','2026-07-14 10:29:02'),
(9,2,'HR','Employee file and benefits review completed','cleared',145,'2026-07-14 10:29:03','2026-07-14 10:28:36','2026-07-14 10:29:03'),
(10,2,'Library','Library materials returned','cleared',145,'2026-07-14 10:29:03','2026-07-14 10:28:36','2026-07-14 10:29:03'),
(11,2,'Security','Access cards and keys returned','cleared',145,'2026-07-14 10:29:04','2026-07-14 10:28:36','2026-07-14 10:29:04'),
(12,2,'Department','Department handover completed','cleared',145,'2026-07-14 10:29:05','2026-07-14 10:28:36','2026-07-14 10:29:05');
/*!40000 ALTER TABLE `hr_clearance_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_deduction_types`
--

DROP TABLE IF EXISTS `hr_deduction_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_deduction_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` varchar(500) NOT NULL DEFAULT '',
  `category` enum('statutory','voluntary','loan') NOT NULL DEFAULT 'voluntary',
  `calculation` enum('fixed','percentage') NOT NULL DEFAULT 'fixed',
  `default_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `percentage_of` varchar(100) DEFAULT NULL,
  `max_amount` decimal(12,2) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `currency` enum('ZWG','USD') NOT NULL DEFAULT 'USD',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_deduction_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_deduction_types`
--

LOCK TABLES `hr_deduction_types` WRITE;
/*!40000 ALTER TABLE `hr_deduction_types` DISABLE KEYS */;
INSERT INTO `hr_deduction_types` VALUES
(1,'PAYE','PAYE (ZIMRA)','Pay As You Earn — ZIMRA progressive tax','statutory','percentage',0.00,'gross_salary',NULL,1,'USD','2026-06-25 16:12:55','2026-06-25 16:12:56'),
(2,'NSSA','NSSA Employee Contribution','National Social Security Authority — 3% of basic','statutory','percentage',3.00,'basic_salary',NULL,1,'USD','2026-06-25 16:12:55','2026-06-25 16:12:56'),
(3,'ZIMDEF','ZIMDEF Levy','Zimbabwe Manpower Development Fund — 1% of basic','statutory','percentage',1.00,'basic_salary',NULL,1,'USD','2026-06-25 16:12:55','2026-06-25 16:12:56'),
(4,'PENSION','Pension Fund','Voluntary pension scheme contribution','voluntary','percentage',5.00,'basic_salary',NULL,1,'USD','2026-06-25 16:12:55','2026-06-25 16:12:55'),
(5,'UNION','Union Dues','Workers union membership fees','voluntary','fixed',10.00,NULL,NULL,1,'USD','2026-06-25 16:12:55','2026-06-25 16:12:55');
/*!40000 ALTER TABLE `hr_deduction_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_department_budgets`
--

DROP TABLE IF EXISTS `hr_department_budgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_department_budgets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` bigint(20) unsigned NOT NULL,
  `fiscal_year` smallint(5) unsigned NOT NULL,
  `allocated_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `spent_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(5) NOT NULL DEFAULT 'USD',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_department_budgets_department_id_fiscal_year_currency_unique` (`department_id`,`fiscal_year`,`currency`),
  CONSTRAINT `hr_department_budgets_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `hr_departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_department_budgets`
--

LOCK TABLES `hr_department_budgets` WRITE;
/*!40000 ALTER TABLE `hr_department_budgets` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_department_budgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_departments`
--

DROP TABLE IF EXISTS `hr_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_departments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) NOT NULL,
  `head_employee_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_departments_code_unique` (`code`),
  KEY `hr_departments_head_employee_id_index` (`head_employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_departments`
--

LOCK TABLES `hr_departments` WRITE;
/*!40000 ALTER TABLE `hr_departments` DISABLE KEYS */;
INSERT INTO `hr_departments` VALUES
(1,'Human Resources','HR',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(2,'Information and Communication Technology','ICT',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(3,'Electronic Engineering','EE',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(4,'Industrial and Manufacturing Engineering','IME',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(5,'Chemical and Process Systems Engineering','CPSE',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(6,'Computer Science','CS',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(7,'Sports Science and Coaching','SSC',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(8,'Library and Information Science','LIS',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(9,'Finance','FIN',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(10,'Academic Affairs','AA',NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55');
/*!40000 ALTER TABLE `hr_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_disciplinary_cases`
--

DROP TABLE IF EXISTS `hr_disciplinary_cases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_disciplinary_cases` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `case_number` varchar(30) NOT NULL,
  `offence_category` varchar(20) NOT NULL,
  `offence_description` text NOT NULL,
  `incident_date` date NOT NULL,
  `action_taken` text DEFAULT NULL,
  `hearing_date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'reported',
  `reported_by` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_disciplinary_cases_case_number_unique` (`case_number`),
  KEY `hr_disciplinary_cases_employee_id_status_index` (`employee_id`,`status`),
  KEY `hr_disciplinary_cases_status_index` (`status`),
  CONSTRAINT `hr_disciplinary_cases_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_disciplinary_cases`
--

LOCK TABLES `hr_disciplinary_cases` WRITE;
/*!40000 ALTER TABLE `hr_disciplinary_cases` DISABLE KEYS */;
INSERT INTO `hr_disciplinary_cases` VALUES
(1,11,'DC-2026-0001','minor','Misconduct','2026-07-15','good','2026-07-15','resolved',145,'Misconduct','2026-07-14 10:05:16','2026-07-14 10:09:39');
/*!40000 ALTER TABLE `hr_disciplinary_cases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employee_allowances`
--

DROP TABLE IF EXISTS `hr_employee_allowances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employee_allowances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `allowance_type_id` bigint(20) unsigned NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `currency` enum('ZWG','USD') NOT NULL DEFAULT 'USD',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_employee_allowances_employee_fk` (`employee_id`),
  KEY `hr_employee_allowances_type_fk` (`allowance_type_id`),
  CONSTRAINT `hr_employee_allowances_employee_fk` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_employee_allowances_type_fk` FOREIGN KEY (`allowance_type_id`) REFERENCES `hr_allowance_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employee_allowances`
--

LOCK TABLES `hr_employee_allowances` WRITE;
/*!40000 ALTER TABLE `hr_employee_allowances` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_employee_allowances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employee_contracts`
--

DROP TABLE IF EXISTS `hr_employee_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employee_contracts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `contract_type` enum('permanent','fixed_term','probation','consultancy') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `basic_salary` decimal(12,2) NOT NULL,
  `currency` enum('ZWG','USD') NOT NULL,
  `outcome` varchar(20) NOT NULL DEFAULT 'active',
  `renewal_of_contract_id` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_employee_contracts_employee_id_start_date_index` (`employee_id`,`start_date`),
  KEY `hr_employee_contracts_renewal_of_contract_id_foreign` (`renewal_of_contract_id`),
  CONSTRAINT `hr_employee_contracts_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_employee_contracts_renewal_of_contract_id_foreign` FOREIGN KEY (`renewal_of_contract_id`) REFERENCES `hr_employee_contracts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employee_contracts`
--

LOCK TABLES `hr_employee_contracts` WRITE;
/*!40000 ALTER TABLE `hr_employee_contracts` DISABLE KEYS */;
INSERT INTO `hr_employee_contracts` VALUES
(1,1,'permanent','2015-01-15',NULL,3000.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(2,1,'permanent','2015-01-15',NULL,1500000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(3,2,'permanent','2016-03-01',NULL,2500.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(4,2,'permanent','2016-03-01',NULL,1250000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(5,3,'permanent','2017-06-15',NULL,2000.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(6,3,'permanent','2017-06-15',NULL,1000000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(7,4,'permanent','2018-01-10',NULL,2000.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(8,4,'permanent','2018-01-10',NULL,1000000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(9,5,'permanent','2019-02-01',NULL,2500.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(10,5,'permanent','2019-02-01',NULL,1250000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(11,6,'permanent','2019-08-15',NULL,1500.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(12,6,'permanent','2019-08-15',NULL,750000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(13,7,'permanent','2020-01-06',NULL,2000.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(14,7,'permanent','2020-01-06',NULL,1000000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(15,8,'fixed_term','2020-06-01',NULL,1000.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(16,8,'fixed_term','2020-06-01',NULL,500000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(17,9,'permanent','2021-01-15',NULL,700.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(18,9,'permanent','2021-01-15',NULL,350000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(19,10,'permanent','2021-07-01',NULL,1500.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(20,10,'permanent','2021-07-01',NULL,750000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(21,11,'permanent','2022-01-10',NULL,1500.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(22,11,'permanent','2022-01-10',NULL,750000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(23,12,'fixed_term','2022-06-01',NULL,1000.00,'USD','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(24,12,'fixed_term','2022-06-01',NULL,500000.00,'ZWG','active',NULL,NULL,'2026-06-25 16:12:55','2026-06-25 16:12:55');
/*!40000 ALTER TABLE `hr_employee_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employee_deductions`
--

DROP TABLE IF EXISTS `hr_employee_deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employee_deductions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `deduction_type_id` bigint(20) unsigned NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `currency` enum('ZWG','USD') NOT NULL DEFAULT 'USD',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `total_amount` decimal(12,2) DEFAULT NULL COMMENT 'For loans: original loan amount',
  `amount_paid` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'For loans: total repaid so far',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_employee_deductions_employee_fk` (`employee_id`),
  KEY `hr_employee_deductions_type_fk` (`deduction_type_id`),
  CONSTRAINT `hr_employee_deductions_employee_fk` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_employee_deductions_type_fk` FOREIGN KEY (`deduction_type_id`) REFERENCES `hr_deduction_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employee_deductions`
--

LOCK TABLES `hr_employee_deductions` WRITE;
/*!40000 ALTER TABLE `hr_employee_deductions` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_employee_deductions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employee_documents`
--

DROP TABLE IF EXISTS `hr_employee_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employee_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `document_type` enum('id','cv','contract','certificate','other') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_name` varchar(180) NOT NULL,
  `uploaded_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_employee_documents_employee_id_document_type_index` (`employee_id`,`document_type`),
  CONSTRAINT `hr_employee_documents_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employee_documents`
--

LOCK TABLES `hr_employee_documents` WRITE;
/*!40000 ALTER TABLE `hr_employee_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_employee_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employee_promotions`
--

DROP TABLE IF EXISTS `hr_employee_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employee_promotions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `promotion_type` varchar(30) NOT NULL,
  `from_job_grade_id` bigint(20) unsigned DEFAULT NULL,
  `to_job_grade_id` bigint(20) unsigned DEFAULT NULL,
  `from_department_id` bigint(20) unsigned DEFAULT NULL,
  `to_department_id` bigint(20) unsigned DEFAULT NULL,
  `effective_date` date NOT NULL,
  `reason` text DEFAULT NULL,
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_employee_promotions_from_job_grade_id_foreign` (`from_job_grade_id`),
  KEY `hr_employee_promotions_to_job_grade_id_foreign` (`to_job_grade_id`),
  KEY `hr_employee_promotions_from_department_id_foreign` (`from_department_id`),
  KEY `hr_employee_promotions_to_department_id_foreign` (`to_department_id`),
  KEY `hr_employee_promotions_employee_id_effective_date_index` (`employee_id`,`effective_date`),
  CONSTRAINT `hr_employee_promotions_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_employee_promotions_from_department_id_foreign` FOREIGN KEY (`from_department_id`) REFERENCES `hr_departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_employee_promotions_from_job_grade_id_foreign` FOREIGN KEY (`from_job_grade_id`) REFERENCES `hr_job_grades` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_employee_promotions_to_department_id_foreign` FOREIGN KEY (`to_department_id`) REFERENCES `hr_departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_employee_promotions_to_job_grade_id_foreign` FOREIGN KEY (`to_job_grade_id`) REFERENCES `hr_job_grades` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employee_promotions`
--

LOCK TABLES `hr_employee_promotions` WRITE;
/*!40000 ALTER TABLE `hr_employee_promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_employee_promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employee_qualifications`
--

DROP TABLE IF EXISTS `hr_employee_qualifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employee_qualifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `qualification_type` varchar(30) NOT NULL,
  `title` varchar(255) NOT NULL,
  `institution` varchar(255) NOT NULL,
  `date_obtained` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `document_path` varchar(255) DEFAULT NULL,
  `verification_status` varchar(20) NOT NULL DEFAULT 'pending',
  `verified_by` bigint(20) unsigned DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `submitted_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_employee_qualifications_employee_id_verification_status_index` (`employee_id`,`verification_status`),
  KEY `hr_employee_qualifications_verification_status_index` (`verification_status`),
  CONSTRAINT `hr_employee_qualifications_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employee_qualifications`
--

LOCK TABLES `hr_employee_qualifications` WRITE;
/*!40000 ALTER TABLE `hr_employee_qualifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_employee_qualifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_employees`
--

DROP TABLE IF EXISTS `hr_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_employees` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ec_number` varchar(20) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(180) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `national_id` varchar(30) DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `marital_status` enum('single','married','divorced','widowed') DEFAULT NULL,
  `hire_date` date NOT NULL,
  `employment_type` enum('permanent','contract','part_time','intern') NOT NULL,
  `status` enum('active','on_leave','suspended','terminated') NOT NULL DEFAULT 'active',
  `expected_retirement_date` date DEFAULT NULL,
  `retirement_notified_at` timestamp NULL DEFAULT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `job_grade_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_employees_ec_number_unique` (`ec_number`),
  UNIQUE KEY `hr_employees_email_unique` (`email`),
  UNIQUE KEY `hr_employees_national_id_unique` (`national_id`),
  KEY `hr_employees_status_index` (`status`),
  KEY `hr_employees_department_id_status_index` (`department_id`,`status`),
  KEY `hr_employees_job_grade_id_foreign` (`job_grade_id`),
  KEY `hr_employees_user_id_index` (`user_id`),
  KEY `idx_employees_status` (`status`),
  KEY `idx_employees_dept_status` (`department_id`,`status`),
  KEY `idx_employees_hire_date` (`hire_date`),
  CONSTRAINT `hr_employees_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `hr_departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_employees_job_grade_id_foreign` FOREIGN KEY (`job_grade_id`) REFERENCES `hr_job_grades` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_employees`
--

LOCK TABLES `hr_employees` WRITE;
/*!40000 ALTER TABLE `hr_employees` DISABLE KEYS */;
INSERT INTO `hr_employees` VALUES
(1,'HIT001',145,'John','Moyo','j.moyo@hit.ac.zw','+263771000001',NULL,'63-100001A01','male',NULL,'2015-01-15','permanent','active',NULL,NULL,1,4,'2026-06-25 16:12:55','2026-06-25 16:12:55',NULL),
(2,'HIT002',157,'Mary','Ncube','m.ncube@hit.ac.zw','+263771000002',NULL,'63-100002B02','female',NULL,'2016-03-01','permanent','active',NULL,NULL,9,5,'2026-06-25 16:12:55','2026-07-09 14:23:11',NULL),
(3,'HIT003',158,'Tinashe','Chikwanha','t.chikwanha@hit.ac.zw','+263771000003',NULL,'63-100003C03','male',NULL,'2017-06-15','permanent','active',NULL,NULL,2,6,'2026-06-25 16:12:55','2026-07-09 14:23:12',NULL),
(4,'HIT004',159,'Grace','Mutasa','g.mutasa@hit.ac.zw','+263771000004',NULL,'63-100004D04','female',NULL,'2018-01-10','permanent','active',NULL,NULL,6,6,'2026-06-25 16:12:55','2026-07-09 14:23:13',NULL),
(5,'HIT005',160,'Tendai','Madziva','t.madziva@hit.ac.zw','+263771000005',NULL,'63-100005E05','male',NULL,'2019-02-01','permanent','active',NULL,NULL,3,5,'2026-06-25 16:12:55','2026-07-09 14:23:14',NULL),
(6,'HIT006',161,'Rumbidzai','Zvobgo','r.zvobgo@hit.ac.zw','+263771000006',NULL,'63-100006F06','female',NULL,'2019-08-15','permanent','active',NULL,NULL,4,7,'2026-06-25 16:12:55','2026-07-09 14:23:16',NULL),
(7,'HIT007',5,'Blessing','Chinotimba','b.chinotimba@hit.ac.zw','+263771000007',NULL,'63-100007G07','male',NULL,'2020-01-06','permanent','active',NULL,NULL,5,6,'2026-06-25 16:12:55','2026-07-09 14:14:43',NULL),
(8,'HIT008',162,'Farai','Maposa','f.maposa@hit.ac.zw','+263771000008',NULL,'63-100008H08','male',NULL,'2020-06-01','contract','active',NULL,NULL,8,8,'2026-06-25 16:12:55','2026-07-09 14:23:17',NULL),
(9,'HIT009',163,'Nyasha','Gumbo','n.gumbo@hit.ac.zw','+263771000009',NULL,'63-100009I09','female',NULL,'2021-01-15','permanent','active',NULL,NULL,10,9,'2026-06-25 16:12:55','2026-07-09 14:23:18',NULL),
(10,'HIT010',164,'Tatenda','Zimba','t.zimba@hit.ac.zw','+263771000010',NULL,'63-100010J10','male',NULL,'2021-07-01','permanent','terminated',NULL,NULL,7,7,'2026-06-25 16:12:55','2026-07-14 07:15:56',NULL),
(11,'HIT011',165,'Chiedza','Mukwena','c.mukwena@hit.ac.zw','+263771000011',NULL,'63-100011K11','female',NULL,'2022-01-10','permanent','terminated',NULL,NULL,1,7,'2026-06-25 16:12:55','2026-07-14 10:29:06',NULL),
(12,'HIT012',166,'Kudakwashe','Nhamo','k.nhamo@hit.ac.zw','+263771000012',NULL,'63-100012L12','male',NULL,'2022-06-01','contract','active',NULL,NULL,2,8,'2026-06-25 16:12:55','2026-07-09 14:23:22',NULL),
(17,'EC-400',167,'Lyeonn','Mavende','lmavondo@hit.ac.zw','0779815102',NULL,NULL,NULL,NULL,'2026-07-14','contract','active',NULL,NULL,10,10,'2026-07-13 09:51:49','2026-07-20 11:43:16',NULL);
/*!40000 ALTER TABLE `hr_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_grade_allowances`
--

DROP TABLE IF EXISTS `hr_grade_allowances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_grade_allowances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `job_grade_id` bigint(20) unsigned NOT NULL,
  `allowance_type_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `amount_zwg` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_grade_allowances_grade_type_unique` (`job_grade_id`,`allowance_type_id`),
  KEY `hr_grade_allowances_type_fk` (`allowance_type_id`),
  CONSTRAINT `hr_grade_allowances_grade_fk` FOREIGN KEY (`job_grade_id`) REFERENCES `hr_job_grades` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_grade_allowances_type_fk` FOREIGN KEY (`allowance_type_id`) REFERENCES `hr_allowance_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_grade_allowances`
--

LOCK TABLES `hr_grade_allowances` WRITE;
/*!40000 ALTER TABLE `hr_grade_allowances` DISABLE KEYS */;
INSERT INTO `hr_grade_allowances` VALUES
(1,1,1,750.00,375000.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(4,2,1,600.00,300000.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(7,3,1,525.00,262500.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(10,4,1,450.00,225000.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(13,5,1,375.00,187500.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(16,6,1,300.00,150000.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(19,7,1,225.00,112500.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(22,8,1,150.00,75000.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(25,9,1,105.00,52500.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(28,10,1,75.00,37500.00,'2026-06-25 16:12:56','2026-06-25 16:12:56');
/*!40000 ALTER TABLE `hr_grade_allowances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_grade_deductions`
--

DROP TABLE IF EXISTS `hr_grade_deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_grade_deductions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `job_grade_id` bigint(20) unsigned NOT NULL,
  `deduction_type_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `amount_zwg` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_grade_deductions_grade_type_unique` (`job_grade_id`,`deduction_type_id`),
  KEY `hr_grade_deductions_type_fk` (`deduction_type_id`),
  CONSTRAINT `hr_grade_deductions_grade_fk` FOREIGN KEY (`job_grade_id`) REFERENCES `hr_job_grades` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_grade_deductions_type_fk` FOREIGN KEY (`deduction_type_id`) REFERENCES `hr_deduction_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_grade_deductions`
--

LOCK TABLES `hr_grade_deductions` WRITE;
/*!40000 ALTER TABLE `hr_grade_deductions` DISABLE KEYS */;
INSERT INTO `hr_grade_deductions` VALUES
(1,1,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(2,1,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(3,1,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(4,2,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(5,2,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(6,2,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(7,3,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(8,3,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(9,3,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(10,4,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(11,4,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(12,4,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(13,5,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(14,5,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(15,5,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(16,6,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(17,6,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(18,6,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(19,7,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(20,7,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(21,7,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(22,8,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(23,8,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(24,8,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(25,9,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(26,9,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(27,9,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(28,10,1,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(29,10,2,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(30,10,3,0.00,0.00,'2026-06-25 16:12:56','2026-06-25 16:12:56');
/*!40000 ALTER TABLE `hr_grade_deductions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_job_grades`
--

DROP TABLE IF EXISTS `hr_job_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_job_grades` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `grade_code` varchar(20) NOT NULL,
  `title` varchar(150) NOT NULL,
  `min_salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `max_salary` decimal(12,2) NOT NULL DEFAULT 0.00,
  `min_salary_zwg` decimal(12,2) NOT NULL DEFAULT 0.00,
  `max_salary_zwg` decimal(12,2) NOT NULL DEFAULT 0.00,
  `currency` enum('ZWG','USD') NOT NULL DEFAULT 'USD',
  `level` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_job_grades_grade_code_unique` (`grade_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_job_grades`
--

LOCK TABLES `hr_job_grades` WRITE;
/*!40000 ALTER TABLE `hr_job_grades` DISABLE KEYS */;
INSERT INTO `hr_job_grades` VALUES
(1,'E1','Executive Director',5000.00,5000.00,2500000.00,2500000.00,'USD',1,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(2,'E2','Director',4000.00,4000.00,2000000.00,2000000.00,'USD',2,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(3,'E3','Senior Manager',3500.00,3500.00,1750000.00,1750000.00,'USD',3,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(4,'M1','Manager',3000.00,3000.00,1500000.00,1500000.00,'USD',4,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(5,'M2','Senior Lecturer / Specialist',2500.00,2500.00,1250000.00,1250000.00,'USD',5,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(6,'P1','Lecturer / Professional',2000.00,2000.00,1000000.00,1000000.00,'USD',6,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(7,'P2','Assistant Lecturer / Officer',1500.00,1500.00,750000.00,750000.00,'USD',7,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(8,'T1','Technician / Senior Clerk',1000.00,1000.00,500000.00,500000.00,'USD',8,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(9,'T2','Junior Technician / Clerk',700.00,700.00,350000.00,350000.00,'USD',9,'2026-06-25 16:12:55','2026-06-25 16:12:55'),
(10,'S1','Support Staff',500.00,500.00,250000.00,250000.00,'USD',10,'2026-06-25 16:12:55','2026-06-25 16:12:55');
/*!40000 ALTER TABLE `hr_job_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_leave_approval_steps`
--

DROP TABLE IF EXISTS `hr_leave_approval_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_leave_approval_steps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `leave_request_id` bigint(20) unsigned NOT NULL,
  `step_order` tinyint(3) unsigned NOT NULL,
  `approver_role` varchar(50) NOT NULL,
  `approver_user_id` bigint(20) unsigned DEFAULT NULL,
  `status` enum('pending','approved','rejected','skipped') NOT NULL DEFAULT 'pending',
  `comment` text DEFAULT NULL,
  `acted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `approval_step_request_order_unique` (`leave_request_id`,`step_order`),
  CONSTRAINT `hr_leave_approval_steps_leave_request_id_foreign` FOREIGN KEY (`leave_request_id`) REFERENCES `hr_leave_requests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_leave_approval_steps`
--

LOCK TABLES `hr_leave_approval_steps` WRITE;
/*!40000 ALTER TABLE `hr_leave_approval_steps` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_leave_approval_steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_leave_balances`
--

DROP TABLE IF EXISTS `hr_leave_balances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_leave_balances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `leave_type_id` bigint(20) unsigned NOT NULL,
  `year` smallint(5) unsigned NOT NULL,
  `entitled_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `accrued_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `used_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `carried_over_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `adjustment_days` decimal(5,1) NOT NULL DEFAULT 0.0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_leave_bal_emp_type_year_uniq` (`employee_id`,`leave_type_id`,`year`),
  KEY `hr_leave_balances_leave_type_id_foreign` (`leave_type_id`),
  CONSTRAINT `hr_leave_balances_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_leave_balances_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `hr_leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_leave_balances`
--

LOCK TABLES `hr_leave_balances` WRITE;
/*!40000 ALTER TABLE `hr_leave_balances` DISABLE KEYS */;
INSERT INTO `hr_leave_balances` VALUES
(1,1,1,2026,22.0,0.0,0.0,0.0,0.0,'2026-06-25 16:29:22','2026-06-25 16:29:22'),
(2,1,2,2026,12.0,0.0,0.0,0.0,0.0,'2026-06-25 16:29:22','2026-06-25 16:29:22'),
(3,1,4,2026,10.0,0.0,0.0,0.0,0.0,'2026-06-25 16:29:22','2026-06-25 16:29:22'),
(4,1,5,2026,10.0,0.0,0.0,0.0,0.0,'2026-06-25 16:29:22','2026-06-25 16:29:22'),
(5,17,1,2026,22.0,0.0,0.0,0.0,0.0,'2026-07-13 10:18:41','2026-07-13 10:18:41'),
(6,17,2,2026,12.0,0.0,0.0,0.0,0.0,'2026-07-13 10:18:41','2026-07-13 10:18:41'),
(7,17,5,2026,10.0,0.0,0.0,0.0,0.0,'2026-07-13 10:18:41','2026-07-13 10:18:41'),
(8,12,1,2026,22.0,0.0,0.0,0.0,0.0,'2026-07-13 10:20:18','2026-07-13 10:20:18'),
(9,12,2,2026,12.0,0.0,0.0,0.0,0.0,'2026-07-13 10:20:18','2026-07-13 10:20:18'),
(10,12,4,2026,10.0,0.0,0.0,0.0,0.0,'2026-07-13 10:20:18','2026-07-13 10:20:18'),
(11,12,5,2026,10.0,0.0,0.0,0.0,0.0,'2026-07-13 10:20:18','2026-07-13 10:20:18');
/*!40000 ALTER TABLE `hr_leave_balances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_leave_requests`
--

DROP TABLE IF EXISTS `hr_leave_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_leave_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `leave_type` enum('annual','sick','maternity','paternity','study') NOT NULL,
  `leave_type_id` bigint(20) unsigned DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `days` smallint(5) unsigned NOT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('pending','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  `current_step` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `total_steps` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_by` bigint(20) unsigned DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `cancelled_by` bigint(20) unsigned DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_leave_requests_employee_id_status_index` (`employee_id`,`status`),
  KEY `hr_leave_requests_employee_id_leave_type_status_index` (`employee_id`,`leave_type`,`status`),
  KEY `hr_leave_requests_status_index` (`status`),
  KEY `idx_leave_employee_status` (`employee_id`,`status`),
  KEY `idx_leave_status_start` (`status`,`start_date`),
  KEY `idx_leave_date_range` (`start_date`,`end_date`),
  KEY `hr_leave_requests_leave_type_id_foreign` (`leave_type_id`),
  CONSTRAINT `hr_leave_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_leave_requests_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `hr_leave_types` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_leave_requests`
--

LOCK TABLES `hr_leave_requests` WRITE;
/*!40000 ALTER TABLE `hr_leave_requests` DISABLE KEYS */;
INSERT INTO `hr_leave_requests` VALUES
(1,1,'sick',NULL,'2026-07-31','2026-08-07',6,'nil','approved',0,0,145,'2026-07-03 11:03:42',NULL,NULL,NULL,NULL,NULL,'2026-07-03 11:03:14','2026-07-03 11:03:42'),
(2,1,'annual',NULL,'2026-07-14','2026-07-30',13,'Personal reasons','approved',0,0,145,'2026-07-13 13:29:30',NULL,NULL,NULL,NULL,NULL,'2026-07-13 10:41:51','2026-07-13 13:29:30');
/*!40000 ALTER TABLE `hr_leave_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_leave_type_approval_chains`
--

DROP TABLE IF EXISTS `hr_leave_type_approval_chains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_leave_type_approval_chains` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `leave_type_id` bigint(20) unsigned NOT NULL,
  `step_order` tinyint(3) unsigned NOT NULL,
  `approver_role` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `approval_chain_type_step_unique` (`leave_type_id`,`step_order`),
  CONSTRAINT `hr_leave_type_approval_chains_leave_type_id_foreign` FOREIGN KEY (`leave_type_id`) REFERENCES `hr_leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_leave_type_approval_chains`
--

LOCK TABLES `hr_leave_type_approval_chains` WRITE;
/*!40000 ALTER TABLE `hr_leave_type_approval_chains` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_leave_type_approval_chains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_leave_types`
--

DROP TABLE IF EXISTS `hr_leave_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_leave_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  `default_days_per_year` smallint(5) unsigned NOT NULL,
  `max_accrual_days` smallint(5) unsigned DEFAULT NULL,
  `accrual_rate_per_month` decimal(5,2) NOT NULL DEFAULT 0.00,
  `requires_document` tinyint(1) NOT NULL DEFAULT 0,
  `approval_levels` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `carry_over_max_days` smallint(5) unsigned NOT NULL DEFAULT 0,
  `gender_restricted` enum('all','male','female') NOT NULL DEFAULT 'all',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_leave_types_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_leave_types`
--

LOCK TABLES `hr_leave_types` WRITE;
/*!40000 ALTER TABLE `hr_leave_types` DISABLE KEYS */;
INSERT INTO `hr_leave_types` VALUES
(1,'annual','Annual Leave',22,30,1.83,0,1,5,'all',1,1,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(2,'sick','Sick Leave',12,NULL,0.00,1,1,0,'all',1,2,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(3,'maternity','Maternity Leave',98,NULL,0.00,1,2,0,'female',1,3,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(4,'paternity','Paternity Leave',10,NULL,0.00,1,1,0,'male',1,4,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(5,'study','Study Leave',10,NULL,0.00,1,2,0,'all',1,5,'2026-06-25 16:12:56','2026-06-25 16:12:56'),
(6,'Lyeonn leave test','Leave test',30,3,0.03,0,1,20,'all',1,0,'2026-07-13 13:38:37','2026-07-13 13:38:37');
/*!40000 ALTER TABLE `hr_leave_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_payroll_items`
--

DROP TABLE IF EXISTS `hr_payroll_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_payroll_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payroll_run_id` bigint(20) unsigned NOT NULL,
  `item_type` enum('allowance','deduction') NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_payroll_items_payroll_run_id_index` (`payroll_run_id`),
  CONSTRAINT `hr_payroll_items_payroll_run_id_foreign` FOREIGN KEY (`payroll_run_id`) REFERENCES `hr_payroll_runs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_payroll_items`
--

LOCK TABLES `hr_payroll_items` WRITE;
/*!40000 ALTER TABLE `hr_payroll_items` DISABLE KEYS */;
INSERT INTO `hr_payroll_items` VALUES
(1,1,'allowance','Housing Allowance (Grade)',225000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(2,1,'deduction','PAYE (ZIMRA)',463750.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(3,1,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(4,1,'deduction','ZIMDEF Levy',15000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(5,2,'allowance','Housing Allowance (Grade)',450.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(6,2,'deduction','NSSA Employee Contribution',90.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(7,2,'deduction','ZIMDEF Levy',30.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(8,3,'allowance','Housing Allowance (Grade)',187500.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(9,3,'deduction','PAYE (ZIMRA)',363125.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(10,3,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(11,3,'deduction','ZIMDEF Levy',12500.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(12,4,'allowance','Housing Allowance (Grade)',375.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(13,4,'deduction','NSSA Employee Contribution',75.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(14,4,'deduction','ZIMDEF Levy',25.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(15,5,'allowance','Housing Allowance (Grade)',150000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(16,5,'deduction','PAYE (ZIMRA)',275000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(17,5,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(18,5,'deduction','ZIMDEF Levy',10000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(19,6,'allowance','Housing Allowance (Grade)',300.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(20,6,'deduction','NSSA Employee Contribution',60.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(21,6,'deduction','ZIMDEF Levy',20.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(22,7,'allowance','Housing Allowance (Grade)',150000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(23,7,'deduction','PAYE (ZIMRA)',275000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(24,7,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(25,7,'deduction','ZIMDEF Levy',10000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(26,8,'allowance','Housing Allowance (Grade)',300.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(27,8,'deduction','NSSA Employee Contribution',60.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(28,8,'deduction','ZIMDEF Levy',20.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(29,9,'allowance','Housing Allowance (Grade)',187500.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(30,9,'deduction','PAYE (ZIMRA)',363125.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(31,9,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(32,9,'deduction','ZIMDEF Levy',12500.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(33,10,'allowance','Housing Allowance (Grade)',375.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(34,10,'deduction','NSSA Employee Contribution',75.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(35,10,'deduction','ZIMDEF Levy',25.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(36,11,'allowance','Housing Allowance (Grade)',112500.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(37,11,'deduction','PAYE (ZIMRA)',188750.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(38,11,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(39,11,'deduction','ZIMDEF Levy',7500.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(40,12,'allowance','Housing Allowance (Grade)',225.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(41,12,'deduction','NSSA Employee Contribution',45.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(42,12,'deduction','ZIMDEF Levy',15.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(43,13,'allowance','Housing Allowance (Grade)',150000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(44,13,'deduction','PAYE (ZIMRA)',275000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(45,13,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(46,13,'deduction','ZIMDEF Levy',10000.00,'2026-06-26 15:49:55','2026-06-26 15:49:55'),
(47,14,'allowance','Housing Allowance (Grade)',300.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(48,14,'deduction','NSSA Employee Contribution',60.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(49,14,'deduction','ZIMDEF Levy',20.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(50,15,'allowance','Housing Allowance (Grade)',75000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(51,15,'deduction','PAYE (ZIMRA)',108750.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(52,15,'deduction','NSSA Employee Contribution',15000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(53,15,'deduction','ZIMDEF Levy',5000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(54,16,'allowance','Housing Allowance (Grade)',150.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(55,16,'deduction','NSSA Employee Contribution',30.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(56,16,'deduction','ZIMDEF Levy',10.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(57,17,'allowance','Housing Allowance (Grade)',52500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(58,17,'deduction','PAYE (ZIMRA)',65625.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(59,17,'deduction','NSSA Employee Contribution',10500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(60,17,'deduction','ZIMDEF Levy',3500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(61,18,'allowance','Housing Allowance (Grade)',105.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(62,18,'deduction','NSSA Employee Contribution',21.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(63,18,'deduction','ZIMDEF Levy',7.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(64,19,'allowance','Housing Allowance (Grade)',112500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(65,19,'deduction','PAYE (ZIMRA)',188750.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(66,19,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(67,19,'deduction','ZIMDEF Levy',7500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(68,20,'allowance','Housing Allowance (Grade)',225.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(69,20,'deduction','NSSA Employee Contribution',45.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(70,20,'deduction','ZIMDEF Levy',15.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(71,21,'allowance','Housing Allowance (Grade)',112500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(72,21,'deduction','PAYE (ZIMRA)',188750.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(73,21,'deduction','NSSA Employee Contribution',21000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(74,21,'deduction','ZIMDEF Levy',7500.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(75,22,'allowance','Housing Allowance (Grade)',225.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(76,22,'deduction','NSSA Employee Contribution',45.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(77,22,'deduction','ZIMDEF Levy',15.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(78,23,'allowance','Housing Allowance (Grade)',75000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(79,23,'deduction','PAYE (ZIMRA)',108750.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(80,23,'deduction','NSSA Employee Contribution',15000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(81,23,'deduction','ZIMDEF Levy',5000.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(82,24,'allowance','Housing Allowance (Grade)',150.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(83,24,'deduction','NSSA Employee Contribution',30.00,'2026-06-26 15:49:56','2026-06-26 15:49:56'),
(84,24,'deduction','ZIMDEF Levy',10.00,'2026-06-26 15:49:56','2026-06-26 15:49:56');
/*!40000 ALTER TABLE `hr_payroll_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_payroll_periods`
--

DROP TABLE IF EXISTS `hr_payroll_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_payroll_periods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `status` enum('draft','submitted','approved','confirmed') NOT NULL DEFAULT 'draft',
  `approved_by` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_payroll_periods_period_start_period_end_index` (`period_start`,`period_end`),
  KEY `hr_payroll_periods_status_index` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_payroll_periods`
--

LOCK TABLES `hr_payroll_periods` WRITE;
/*!40000 ALTER TABLE `hr_payroll_periods` DISABLE KEYS */;
INSERT INTO `hr_payroll_periods` VALUES
(1,'June 2026','2026-06-01','2026-06-30',NULL,'approved',145,'2026-06-26 15:49:58','2026-06-26 15:49:50','2026-06-26 15:49:58');
/*!40000 ALTER TABLE `hr_payroll_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_payroll_runs`
--

DROP TABLE IF EXISTS `hr_payroll_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_payroll_runs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payroll_period_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `basic_salary` decimal(12,2) NOT NULL,
  `housing_allowance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `transport_allowance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `medical_allowance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `gross_salary` decimal(12,2) NOT NULL,
  `paye_deduction` decimal(12,2) NOT NULL DEFAULT 0.00,
  `nssa_employee_deduction` decimal(12,2) NOT NULL DEFAULT 0.00,
  `zimdef_deduction` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_deductions` decimal(12,2) NOT NULL DEFAULT 0.00,
  `net_salary` decimal(12,2) NOT NULL,
  `currency` enum('ZWG','USD') NOT NULL,
  `status` enum('pending','calculated','paid') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_payroll_runs_period_employee_currency_unique` (`payroll_period_id`,`employee_id`,`currency`),
  KEY `hr_payroll_runs_employee_id_index` (`employee_id`),
  KEY `idx_payroll_runs_period` (`payroll_period_id`),
  KEY `idx_payroll_runs_employee` (`employee_id`),
  KEY `idx_payroll_runs_currency` (`currency`),
  CONSTRAINT `hr_payroll_runs_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_payroll_runs_payroll_period_id_foreign` FOREIGN KEY (`payroll_period_id`) REFERENCES `hr_payroll_periods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_payroll_runs`
--

LOCK TABLES `hr_payroll_runs` WRITE;
/*!40000 ALTER TABLE `hr_payroll_runs` DISABLE KEYS */;
INSERT INTO `hr_payroll_runs` VALUES
(1,1,1,1500000.00,225000.00,0.00,0.00,1725000.00,463750.00,21000.00,15000.00,499750.00,1225250.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(2,1,1,3000.00,450.00,0.00,0.00,3450.00,0.00,90.00,30.00,120.00,3330.00,'USD','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(3,1,2,1250000.00,187500.00,0.00,0.00,1437500.00,363125.00,21000.00,12500.00,396625.00,1040875.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(4,1,2,2500.00,375.00,0.00,0.00,2875.00,0.00,75.00,25.00,100.00,2775.00,'USD','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(5,1,3,1000000.00,150000.00,0.00,0.00,1150000.00,275000.00,21000.00,10000.00,306000.00,844000.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(6,1,3,2000.00,300.00,0.00,0.00,2300.00,0.00,60.00,20.00,80.00,2220.00,'USD','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(7,1,4,1000000.00,150000.00,0.00,0.00,1150000.00,275000.00,21000.00,10000.00,306000.00,844000.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(8,1,4,2000.00,300.00,0.00,0.00,2300.00,0.00,60.00,20.00,80.00,2220.00,'USD','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(9,1,5,1250000.00,187500.00,0.00,0.00,1437500.00,363125.00,21000.00,12500.00,396625.00,1040875.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(10,1,5,2500.00,375.00,0.00,0.00,2875.00,0.00,75.00,25.00,100.00,2775.00,'USD','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(11,1,6,750000.00,112500.00,0.00,0.00,862500.00,188750.00,21000.00,7500.00,217250.00,645250.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(12,1,6,1500.00,225.00,0.00,0.00,1725.00,0.00,45.00,15.00,60.00,1665.00,'USD','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(13,1,7,1000000.00,150000.00,0.00,0.00,1150000.00,275000.00,21000.00,10000.00,306000.00,844000.00,'ZWG','calculated','2026-06-26 15:49:55','2026-06-26 15:49:55'),
(14,1,7,2000.00,300.00,0.00,0.00,2300.00,0.00,60.00,20.00,80.00,2220.00,'USD','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(15,1,8,500000.00,75000.00,0.00,0.00,575000.00,108750.00,15000.00,5000.00,128750.00,446250.00,'ZWG','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(16,1,8,1000.00,150.00,0.00,0.00,1150.00,0.00,30.00,10.00,40.00,1110.00,'USD','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(17,1,9,350000.00,52500.00,0.00,0.00,402500.00,65625.00,10500.00,3500.00,79625.00,322875.00,'ZWG','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(18,1,9,700.00,105.00,0.00,0.00,805.00,0.00,21.00,7.00,28.00,777.00,'USD','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(19,1,10,750000.00,112500.00,0.00,0.00,862500.00,188750.00,21000.00,7500.00,217250.00,645250.00,'ZWG','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(20,1,10,1500.00,225.00,0.00,0.00,1725.00,0.00,45.00,15.00,60.00,1665.00,'USD','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(21,1,11,750000.00,112500.00,0.00,0.00,862500.00,188750.00,21000.00,7500.00,217250.00,645250.00,'ZWG','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(22,1,11,1500.00,225.00,0.00,0.00,1725.00,0.00,45.00,15.00,60.00,1665.00,'USD','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(23,1,12,500000.00,75000.00,0.00,0.00,575000.00,108750.00,15000.00,5000.00,128750.00,446250.00,'ZWG','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56'),
(24,1,12,1000.00,150.00,0.00,0.00,1150.00,0.00,30.00,10.00,40.00,1110.00,'USD','calculated','2026-06-26 15:49:56','2026-06-26 15:49:56');
/*!40000 ALTER TABLE `hr_payroll_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_performance_cycles`
--

DROP TABLE IF EXISTS `hr_performance_cycles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_performance_cycles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `year` smallint(5) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('draft','active','closed') NOT NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_performance_cycles_year_index` (`year`),
  KEY `hr_performance_cycles_status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_performance_cycles`
--

LOCK TABLES `hr_performance_cycles` WRITE;
/*!40000 ALTER TABLE `hr_performance_cycles` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_performance_cycles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_performance_goals`
--

DROP TABLE IF EXISTS `hr_performance_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_performance_goals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `review_id` bigint(20) unsigned NOT NULL,
  `description` varchar(500) NOT NULL,
  `target` varchar(255) DEFAULT NULL,
  `achievement` varchar(255) DEFAULT NULL,
  `weight` decimal(5,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_performance_goals_review_id_foreign` (`review_id`),
  CONSTRAINT `hr_performance_goals_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `hr_performance_reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_performance_goals`
--

LOCK TABLES `hr_performance_goals` WRITE;
/*!40000 ALTER TABLE `hr_performance_goals` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_performance_goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_performance_reviews`
--

DROP TABLE IF EXISTS `hr_performance_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_performance_reviews` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cycle_id` bigint(20) unsigned NOT NULL,
  `employee_id` bigint(20) unsigned NOT NULL,
  `reviewer_id` bigint(20) unsigned DEFAULT NULL,
  `self_assessment` text DEFAULT NULL,
  `reviewer_assessment` text DEFAULT NULL,
  `rating` tinyint(3) unsigned DEFAULT NULL COMMENT '1-5 scale',
  `goals_achieved` text DEFAULT NULL,
  `areas_improvement` text DEFAULT NULL,
  `status` enum('pending','self_review','manager_review','completed') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_performance_reviews_status_index` (`status`),
  KEY `hr_performance_reviews_cycle_id_employee_id_index` (`cycle_id`,`employee_id`),
  KEY `hr_performance_reviews_reviewer_id_foreign` (`reviewer_id`),
  KEY `idx_perf_reviews_cycle` (`cycle_id`),
  KEY `idx_perf_reviews_employee` (`employee_id`),
  KEY `idx_perf_reviews_rating` (`rating`),
  CONSTRAINT `hr_performance_reviews_cycle_id_foreign` FOREIGN KEY (`cycle_id`) REFERENCES `hr_performance_cycles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_performance_reviews_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_performance_reviews_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `hr_employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_performance_reviews`
--

LOCK TABLES `hr_performance_reviews` WRITE;
/*!40000 ALTER TABLE `hr_performance_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_performance_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_policy_versions`
--

DROP TABLE IF EXISTS `hr_policy_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_policy_versions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `document_path` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `summary` text DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_policy_versions_status_index` (`status`),
  KEY `hr_policy_versions_effective_date_index` (`effective_date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_policy_versions`
--

LOCK TABLES `hr_policy_versions` WRITE;
/*!40000 ALTER TABLE `hr_policy_versions` DISABLE KEYS */;
INSERT INTO `hr_policy_versions` VALUES
(1,'2.1','Employee Handbook','2026-08-01','2027-07-31',NULL,'superseded',NULL,145,'2026-07-14 10:26:06','2026-07-14 10:26:57'),
(2,'2.1','Employee Handbook','2026-07-15','2026-07-31',NULL,'active',NULL,145,'2026-07-14 10:26:55','2026-07-14 10:26:57');
/*!40000 ALTER TABLE `hr_policy_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_probation_records`
--

DROP TABLE IF EXISTS `hr_probation_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_probation_records` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `contract_id` bigint(20) unsigned DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `extended_to` date DEFAULT NULL,
  `outcome` varchar(20) NOT NULL DEFAULT 'pending',
  `reviewed_by` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_probation_records_contract_id_foreign` (`contract_id`),
  KEY `hr_probation_records_employee_id_outcome_index` (`employee_id`,`outcome`),
  CONSTRAINT `hr_probation_records_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `hr_employee_contracts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_probation_records_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_probation_records`
--

LOCK TABLES `hr_probation_records` WRITE;
/*!40000 ALTER TABLE `hr_probation_records` DISABLE KEYS */;
INSERT INTO `hr_probation_records` VALUES
(1,17,NULL,'2026-07-01','2026-10-01','2026-07-30','extended',NULL,NULL,'2026-07-14 07:12:29','2026-07-14 07:12:49'),
(2,12,NULL,'2026-08-01','2026-10-31',NULL,'confirmed',145,'We are taking him in','2026-07-14 07:13:12','2026-07-14 07:13:49'),
(3,10,NULL,'2026-07-16','2026-07-30',NULL,'terminated',145,'Misconduct','2026-07-14 07:13:30','2026-07-14 07:14:00');
/*!40000 ALTER TABLE `hr_probation_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_recruitment_applications`
--

DROP TABLE IF EXISTS `hr_recruitment_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_recruitment_applications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `vacancy_id` bigint(20) unsigned NOT NULL,
  `applicant_id` bigint(20) unsigned DEFAULT NULL,
  `applicant_name` varchar(200) NOT NULL,
  `applicant_email` varchar(180) NOT NULL,
  `applicant_phone` varchar(30) DEFAULT NULL,
  `cv_path` varchar(500) DEFAULT NULL,
  `cover_letter` text DEFAULT NULL,
  `highest_qualification` varchar(150) DEFAULT NULL,
  `years_experience` smallint(5) unsigned DEFAULT NULL,
  `current_employer` varchar(200) DEFAULT NULL,
  `tracking_token` varchar(64) DEFAULT NULL,
  `status` enum('applied','shortlisted','interviewed','offered','rejected') NOT NULL DEFAULT 'applied',
  `applied_at` timestamp NULL DEFAULT NULL,
  `withdrawn_at` timestamp NULL DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `scored_by` bigint(20) unsigned DEFAULT NULL,
  `scored_at` timestamp NULL DEFAULT NULL,
  `interview_date` datetime DEFAULT NULL,
  `interview_notes` text DEFAULT NULL,
  `interview_scheduled_by` bigint(20) unsigned DEFAULT NULL,
  `offer_salary` decimal(12,2) DEFAULT NULL,
  `offer_date` date DEFAULT NULL,
  `offered_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_application_vacancy_email` (`vacancy_id`,`applicant_email`),
  UNIQUE KEY `hr_recruitment_applications_tracking_token_unique` (`tracking_token`),
  KEY `hr_recruitment_applications_status_index` (`status`),
  KEY `idx_recruitment_vacancy_status` (`vacancy_id`,`status`),
  KEY `idx_recruitment_status` (`status`),
  KEY `hr_recruitment_applications_applicant_id_foreign` (`applicant_id`),
  KEY `hr_recruitment_applications_vacancy_id_status_index` (`vacancy_id`,`status`),
  KEY `hr_recruitment_applications_applicant_email_index` (`applicant_email`),
  KEY `hr_recruitment_applications_applicant_name_index` (`applicant_name`),
  CONSTRAINT `hr_recruitment_applications_applicant_id_foreign` FOREIGN KEY (`applicant_id`) REFERENCES `applicants` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_recruitment_applications_vacancy_id_foreign` FOREIGN KEY (`vacancy_id`) REFERENCES `hr_recruitment_vacancies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_recruitment_applications`
--

LOCK TABLES `hr_recruitment_applications` WRITE;
/*!40000 ALTER TABLE `hr_recruitment_applications` DISABLE KEYS */;
INSERT INTO `hr_recruitment_applications` VALUES
(21,35,NULL,'Tadiwa','Tadiwa@hit.ac.zw','098765432',NULL,'hie testing my exporr','Masters in Software Engineer',6,'Senior developer','uHvj5GZCbPhcIr76wmd9wfxJaACUu1IrKmkTtKucz25qTWhm','offered','2026-07-14 08:08:44',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-14 08:08:44','2026-07-20 11:43:31');
/*!40000 ALTER TABLE `hr_recruitment_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_recruitment_vacancies`
--

DROP TABLE IF EXISTS `hr_recruitment_vacancies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_recruitment_vacancies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `department_id` bigint(20) unsigned DEFAULT NULL,
  `job_grade_id` bigint(20) unsigned DEFAULT NULL,
  `employment_type` enum('permanent','contract','temporary','internship') DEFAULT NULL,
  `reporting_line` varchar(255) DEFAULT NULL,
  `duty_station` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `public_description` text DEFAULT NULL,
  `min_qualification` varchar(255) DEFAULT NULL,
  `auto_reject_after_days` smallint(5) unsigned DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `requirements` text DEFAULT NULL,
  `required_qualifications` text DEFAULT NULL,
  `required_experience` text DEFAULT NULL,
  `required_skills` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`required_skills`)),
  `supporting_documents` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`supporting_documents`)),
  `positions_available` int(10) unsigned NOT NULL DEFAULT 1,
  `closing_date` date DEFAULT NULL,
  `status` enum('open','closed','filled') NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_recruitment_vacancies_status_index` (`status`),
  KEY `hr_recruitment_vacancies_closing_date_index` (`closing_date`),
  KEY `hr_recruitment_vacancies_department_id_foreign` (`department_id`),
  KEY `hr_recruitment_vacancies_job_grade_id_foreign` (`job_grade_id`),
  CONSTRAINT `hr_recruitment_vacancies_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `hr_departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `hr_recruitment_vacancies_job_grade_id_foreign` FOREIGN KEY (`job_grade_id`) REFERENCES `hr_job_grades` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_recruitment_vacancies`
--

LOCK TABLES `hr_recruitment_vacancies` WRITE;
/*!40000 ALTER TABLE `hr_recruitment_vacancies` DISABLE KEYS */;
INSERT INTO `hr_recruitment_vacancies` VALUES
(34,'uiiii',10,5,'permanent','hjjjj','hjjj','hjjjjjj','hhhhhhh','ghhhhhh',NULL,1,'ghhhhh','hhhhhh','gggggg','[\"PHP\"]','[\"CV\"]',1,'2026-07-14','open','2026-06-29 07:37:18','2026-07-14 07:22:04'),
(35,'Software Engineer',2,5,'permanent','Reports to Head of Department','Main Campus Harare',NULL,NULL,NULL,NULL,1,NULL,'Degree in IT or relevant qualification','4 years of experience','[\"JAVA\"]','[\"CV\"]',2,'2026-07-31','open','2026-07-14 07:21:48','2026-07-14 07:21:48');
/*!40000 ALTER TABLE `hr_recruitment_vacancies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_settings`
--

DROP TABLE IF EXISTS `hr_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` enum('string','integer','boolean','json') NOT NULL DEFAULT 'string',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_settings_setting_key_unique` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_settings`
--

LOCK TABLES `hr_settings` WRITE;
/*!40000 ALTER TABLE `hr_settings` DISABLE KEYS */;
INSERT INTO `hr_settings` VALUES
(1,'retirement_age','65','integer','Default retirement age for employees','2026-06-25 16:12:57','2026-06-25 16:12:57'),
(2,'probation_reminder_days','90','integer','Days before probation end to send reminder','2026-06-25 16:12:57','2026-06-25 16:12:57'),
(3,'contract_reminder_days','90','integer','Days before contract expiry to send reminder','2026-06-25 16:12:57','2026-06-25 16:12:57'),
(4,'leave_year_start_month','1','integer','Month when the leave year begins (1=January)','2026-06-25 16:12:57','2026-06-25 16:12:57'),
(5,'allow_negative_leave_balance','0','boolean','Whether employees can go into negative leave balance','2026-06-25 16:12:57','2026-06-25 16:12:57'),
(6,'default_currency','USD','string','Default currency for payroll and budgets','2026-06-25 16:12:57','2026-06-25 16:12:57'),
(7,'Birthdays','1','boolean','Date of bith','2026-07-14 10:38:25','2026-07-14 10:38:25');
/*!40000 ALTER TABLE `hr_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_terminations`
--

DROP TABLE IF EXISTS `hr_terminations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_terminations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `termination_type` varchar(30) NOT NULL,
  `effective_date` date NOT NULL,
  `reason` text DEFAULT NULL,
  `clearance_status` varchar(20) NOT NULL DEFAULT 'not_started',
  `processed_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_terminations_employee_id_unique` (`employee_id`),
  KEY `hr_terminations_clearance_status_index` (`clearance_status`),
  CONSTRAINT `hr_terminations_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_terminations`
--

LOCK TABLES `hr_terminations` WRITE;
/*!40000 ALTER TABLE `hr_terminations` DISABLE KEYS */;
INSERT INTO `hr_terminations` VALUES
(1,10,'dismissal','2026-07-19',NULL,'completed',145,'2026-07-14 07:15:05','2026-07-14 07:15:56'),
(2,11,'retirement','2026-07-17',NULL,'completed',145,'2026-07-14 10:28:36','2026-07-14 10:29:06');
/*!40000 ALTER TABLE `hr_terminations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_training_requests`
--

DROP TABLE IF EXISTS `hr_training_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_training_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` bigint(20) unsigned NOT NULL,
  `department_id` bigint(20) unsigned NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `estimated_cost` decimal(15,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(5) NOT NULL DEFAULT 'USD',
  `training_type` varchar(30) NOT NULL DEFAULT 'workshop',
  `status` varchar(20) NOT NULL DEFAULT 'requested',
  `justification` text DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `requested_by` bigint(20) unsigned DEFAULT NULL,
  `hod_approved_by` bigint(20) unsigned DEFAULT NULL,
  `hod_approved_at` timestamp NULL DEFAULT NULL,
  `hr_approved_by` bigint(20) unsigned DEFAULT NULL,
  `hr_approved_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_training_requests_employee_id_foreign` (`employee_id`),
  KEY `hr_training_requests_department_id_status_index` (`department_id`,`status`),
  KEY `hr_training_requests_status_index` (`status`),
  CONSTRAINT `hr_training_requests_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `hr_departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hr_training_requests_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `hr_employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_training_requests`
--

LOCK TABLES `hr_training_requests` WRITE;
/*!40000 ALTER TABLE `hr_training_requests` DISABLE KEYS */;
INSERT INTO `hr_training_requests` VALUES
(1,17,6,'Advanced Project Management','Excess',350.00,'USD','certification','hod_approved','It boosts my skills for the job','2026-07-17','2026-07-17',145,145,'2026-07-14 10:03:17',NULL,NULL,NULL,'2026-07-14 09:59:54','2026-07-14 10:03:17');
/*!40000 ALTER TABLE `hr_training_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_type_plans`
--

DROP TABLE IF EXISTS `hr_type_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_type_plans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `plan_type` varchar(20) NOT NULL,
  `type_id` bigint(20) unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL DEFAULT '',
  `amount` decimal(12,2) NOT NULL,
  `amount_zwg` decimal(12,2) NOT NULL DEFAULT 0.00,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hr_type_plans_plan_type_type_id_name_unique` (`plan_type`,`type_id`,`name`),
  KEY `hr_type_plans_plan_type_type_id_active_index` (`plan_type`,`type_id`,`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_type_plans`
--

LOCK TABLES `hr_type_plans` WRITE;
/*!40000 ALTER TABLE `hr_type_plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_type_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_webhook_deliveries`
--

DROP TABLE IF EXISTS `hr_webhook_deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_webhook_deliveries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `webhook_id` bigint(20) unsigned NOT NULL,
  `event` varchar(100) NOT NULL,
  `payload_hash` char(64) NOT NULL,
  `attempt_number` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `response_status` smallint(5) unsigned DEFAULT NULL,
  `error` text DEFAULT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `delivered_at` timestamp NULL DEFAULT NULL,
  `failed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `hr_webhook_deliveries_webhook_id_index` (`webhook_id`),
  KEY `hr_webhook_deliveries_event_index` (`event`),
  CONSTRAINT `hr_webhook_deliveries_webhook_id_foreign` FOREIGN KEY (`webhook_id`) REFERENCES `hr_webhooks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_webhook_deliveries`
--

LOCK TABLES `hr_webhook_deliveries` WRITE;
/*!40000 ALTER TABLE `hr_webhook_deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_webhook_deliveries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr_webhooks`
--

DROP TABLE IF EXISTS `hr_webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr_webhooks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(2048) NOT NULL,
  `events` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`events`)),
  `secret` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_triggered_at` timestamp NULL DEFAULT NULL,
  `last_status` smallint(5) unsigned DEFAULT NULL,
  `consecutive_failures` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_webhooks_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr_webhooks`
--

LOCK TABLES `hr_webhooks` WRITE;
/*!40000 ALTER TABLE `hr_webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `hr_webhooks` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'2026_05_12_000001_create_hr_departments_table',1),
(2,'2026_05_12_000002_create_hr_job_grades_table',1),
(3,'2026_05_12_000003_create_hr_employees_table',1),
(4,'2026_05_12_000004_create_hr_employee_contracts_table',1),
(5,'2026_05_12_000005_create_hr_employee_documents_table',1),
(6,'2026_05_13_000006_create_hr_payroll_periods_table',1),
(7,'2026_05_13_000007_create_hr_payroll_runs_table',1),
(8,'2026_05_13_000008_create_hr_payroll_items_table',1),
(9,'2026_05_13_000009_create_hr_performance_cycles_table',1),
(10,'2026_05_13_000010_create_hr_performance_reviews_table',1),
(11,'2026_05_13_000011_create_hr_performance_goals_table',1),
(12,'2026_05_13_000012_create_hr_recruitment_vacancies_table',1),
(13,'2026_05_13_000013_create_hr_recruitment_applications_table',1),
(14,'2026_05_20_000001_create_hr_leave_requests_table',1),
(15,'2026_05_20_000001_create_hr_webhooks_table',1),
(16,'2026_05_20_000002_add_performance_indexes',1),
(17,'2026_05_20_000002_add_workflow_fields_to_hr_recruitment_applications',1),
(18,'2026_05_22_000001_add_delivery_tracking_to_hr_webhooks',1),
(19,'2026_05_22_000002_create_hr_webhook_deliveries_table',1),
(20,'2026_05_22_000003_add_cancelled_status_to_hr_leave_requests',1),
(21,'2026_06_18_000001_create_hr_allowance_types_table',1),
(22,'2026_06_18_000002_create_hr_deduction_types_table',1),
(23,'2026_06_18_000003_add_level_to_hr_job_grades_table',1),
(24,'2026_06_18_100001_create_hr_settings_table',1),
(25,'2026_06_18_100002_create_hr_leave_types_table',1),
(26,'2026_06_18_100003_create_hr_leave_balances_table',1),
(27,'2026_06_18_100004_add_personal_fields_to_hr_employees_table',1),
(28,'2026_06_18_100005_add_leave_type_id_to_hr_leave_requests_table',1),
(29,'2026_06_19_100001_create_hr_leave_type_approval_chains_table',1),
(30,'2026_06_19_100002_create_hr_leave_approval_steps_table',1),
(31,'2026_06_19_100003_add_approval_tracking_to_hr_leave_requests_table',1),
(32,'2026_06_19_200001_create_hr_employee_qualifications_table',1),
(33,'2026_06_19_200002_create_hr_employee_promotions_table',1),
(34,'2026_06_19_300001_add_tracking_fields_to_hr_employee_contracts_table',1),
(35,'2026_06_19_300002_create_hr_probation_records_table',1),
(36,'2026_06_19_300003_create_hr_terminations_table',1),
(37,'2026_06_19_300004_create_hr_clearance_items_table',1),
(38,'2026_06_19_400001_create_hr_disciplinary_cases_table',1),
(39,'2026_06_19_400002_create_hr_department_budgets_table',1),
(40,'2026_06_19_400003_create_hr_training_requests_table',1),
(41,'2026_06_19_500001_create_hr_policy_versions_table',1),
(42,'2026_06_19_500002_add_retirement_fields_to_hr_employees_table',1),
(43,'2026_06_19_500003_add_public_fields_to_hr_recruitment_vacancies_table',1),
(44,'2026_06_22_000001_make_payroll_period_currency_nullable',1),
(45,'2026_06_22_000002_update_payroll_runs_unique_index_for_currency',1),
(46,'2026_06_22_000003_add_zwg_salary_to_job_grades',1),
(47,'2026_06_22_000004_create_grade_allowances_and_deductions_pivots',1),
(48,'2026_06_22_000005_create_employee_deductions_table',1),
(49,'2026_06_23_000001_create_employee_allowances_table',1),
(50,'2026_06_23_100001_create_type_plans_table',1),
(51,'2026_06_25_000001_add_phase1_fields_to_hr_recruitment_vacancies',1),
(52,'2026_06_25_000002_create_applicants_tables',1),
(53,'2026_06_25_000003_create_applicant_profile_tables',1),
(54,'2026_06_25_000004_link_applicants_to_recruitment_applications',1),
(55,'2026_06_26_000001_create_recruitment_scoring_tables',2),
(56,'2026_06_26_000002_create_recruitment_evaluation_tables',3),
(57,'2026_06_26_000003_create_recruitment_delivery_tables',4),
(58,'2026_06_26_000010_add_public_application_fields_to_hr_recruitment_applications',5);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recruitment_exports`
--

DROP TABLE IF EXISTS `recruitment_exports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recruitment_exports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `vacancy_id` bigint(20) unsigned DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `format` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `file_path` varchar(255) DEFAULT NULL,
  `requested_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recruitment_exports`
--

LOCK TABLES `recruitment_exports` WRITE;
/*!40000 ALTER TABLE `recruitment_exports` DISABLE KEYS */;
INSERT INTO `recruitment_exports` VALUES
(1,NULL,'applicants','pdf','pending',NULL,145,'2026-06-26 15:45:34','2026-06-26 15:45:34'),
(2,NULL,'shortlist','pdf','pending',NULL,145,'2026-07-01 13:38:29','2026-07-01 13:38:29'),
(3,NULL,'applicants','csv','pending',NULL,145,'2026-07-14 07:22:28','2026-07-14 07:22:28'),
(4,NULL,'applicants','pdf','pending',NULL,145,'2026-07-14 07:38:10','2026-07-14 07:38:10'),
(5,NULL,'applicants','pdf','pending',NULL,145,'2026-07-14 07:38:54','2026-07-14 07:38:54'),
(6,35,'summary','pdf','pending',NULL,145,'2026-07-14 07:39:48','2026-07-14 07:39:48'),
(7,35,'shortlist','pdf','pending',NULL,145,'2026-07-14 07:44:13','2026-07-14 07:44:13'),
(8,NULL,'applicants','pdf','pending',NULL,145,'2026-07-14 08:09:16','2026-07-14 08:09:16'),
(9,NULL,'shortlist','pdf','pending',NULL,145,'2026-07-14 08:10:25','2026-07-14 08:10:25'),
(10,NULL,'applicants','pdf','pending',NULL,145,'2026-07-14 08:10:59','2026-07-14 08:10:59');
/*!40000 ALTER TABLE `recruitment_exports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screening_rules`
--

DROP TABLE IF EXISTS `screening_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `screening_rules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `vacancy_id` bigint(20) unsigned NOT NULL,
  `criterion` enum('qualification','experience','skills','certifications') NOT NULL,
  `weight` smallint(5) unsigned NOT NULL DEFAULT 0,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `screening_rules_vacancy_id_criterion_unique` (`vacancy_id`,`criterion`),
  CONSTRAINT `screening_rules_vacancy_id_foreign` FOREIGN KEY (`vacancy_id`) REFERENCES `hr_recruitment_vacancies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screening_rules`
--

LOCK TABLES `screening_rules` WRITE;
/*!40000 ALTER TABLE `screening_rules` DISABLE KEYS */;
INSERT INTO `screening_rules` VALUES
(1,35,'qualification',30,NULL,'2026-07-14 09:05:31','2026-07-14 09:05:31'),
(2,35,'experience',30,NULL,'2026-07-14 09:05:31','2026-07-14 09:05:31'),
(3,35,'skills',25,NULL,'2026-07-14 09:05:31','2026-07-14 09:05:31'),
(4,35,'certifications',15,NULL,'2026-07-14 09:05:31','2026-07-14 09:05:31');
/*!40000 ALTER TABLE `screening_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shortlists`
--

DROP TABLE IF EXISTS `shortlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shortlists` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `vacancy_id` bigint(20) unsigned NOT NULL,
  `application_id` bigint(20) unsigned NOT NULL,
  `mode` enum('auto','manual') NOT NULL DEFAULT 'auto',
  `included` tinyint(1) NOT NULL DEFAULT 1,
  `reason` varchar(255) DEFAULT NULL,
  `decided_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shortlists_vacancy_id_application_id_unique` (`vacancy_id`,`application_id`),
  KEY `shortlists_application_id_foreign` (`application_id`),
  CONSTRAINT `shortlists_application_id_foreign` FOREIGN KEY (`application_id`) REFERENCES `hr_recruitment_applications` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shortlists_vacancy_id_foreign` FOREIGN KEY (`vacancy_id`) REFERENCES `hr_recruitment_vacancies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shortlists`
--

LOCK TABLES `shortlists` WRITE;
/*!40000 ALTER TABLE `shortlists` DISABLE KEYS */;
INSERT INTO `shortlists` VALUES
(1,35,21,'auto',1,'auto:top_n',NULL,'2026-07-14 09:10:56','2026-07-14 09:10:56');
/*!40000 ALTER TABLE `shortlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'mutupo_hr'
--

--
-- Dumping routines for database 'mutupo_hr'
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
