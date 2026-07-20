/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: mutupo_elearning
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
-- Current Database: `mutupo_elearning`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mutupo_elearning` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `mutupo_elearning`;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `body` text NOT NULL,
  `target_type` enum('global','programme','course') NOT NULL DEFAULT 'global',
  `erp_programme_id` bigint(20) unsigned DEFAULT NULL,
  `erp_course_id` bigint(20) unsigned DEFAULT NULL,
  `status` enum('draft','published') NOT NULL DEFAULT 'draft',
  `published_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `announcements_erp_programme_id_foreign` (`erp_programme_id`),
  KEY `announcements_erp_course_id_foreign` (`erp_course_id`),
  CONSTRAINT `announcements_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `announcements_erp_programme_id_foreign` FOREIGN KEY (`erp_programme_id`) REFERENCES `erp_programmes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment_clo_map`
--

DROP TABLE IF EXISTS `assessment_clo_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_clo_map` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` bigint(20) unsigned NOT NULL,
  `portfolio_clo_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessment_clo_map_assessment_id_portfolio_clo_id_unique` (`assessment_id`,`portfolio_clo_id`),
  KEY `assessment_clo_map_portfolio_clo_id_foreign` (`portfolio_clo_id`),
  CONSTRAINT `assessment_clo_map_assessment_id_foreign` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assessment_clo_map_portfolio_clo_id_foreign` FOREIGN KEY (`portfolio_clo_id`) REFERENCES `portfolio_clos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_clo_map`
--

LOCK TABLES `assessment_clo_map` WRITE;
/*!40000 ALTER TABLE `assessment_clo_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessment_clo_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessment_questions`
--

DROP TABLE IF EXISTS `assessment_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_questions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` bigint(20) unsigned NOT NULL,
  `question_id` bigint(20) unsigned NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `pool_tag` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assessment_questions_assessment_id_question_id_unique` (`assessment_id`,`question_id`),
  KEY `assessment_questions_question_id_foreign` (`question_id`),
  CONSTRAINT `assessment_questions_assessment_id_foreign` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assessment_questions_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_questions`
--

LOCK TABLES `assessment_questions` WRITE;
/*!40000 ALTER TABLE `assessment_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessment_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments`
--

DROP TABLE IF EXISTS `assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `workspace_item_id` bigint(20) unsigned DEFAULT NULL,
  `type` enum('quiz','assignment','practical','project','group_work') NOT NULL DEFAULT 'quiz',
  `title` varchar(191) NOT NULL,
  `instructions` text DEFAULT NULL,
  `max_marks` decimal(6,2) NOT NULL DEFAULT 100.00,
  `pass_mark` decimal(6,2) NOT NULL DEFAULT 50.00,
  `duration_minutes` int(11) DEFAULT NULL,
  `randomise_questions` tinyint(1) NOT NULL DEFAULT 0,
  `questions_per_attempt` int(11) DEFAULT NULL,
  `proctored` tinyint(1) NOT NULL DEFAULT 0,
  `safe_browsing_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `turnitin_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `opens_at` timestamp NULL DEFAULT NULL,
  `closes_at` timestamp NULL DEFAULT NULL,
  `max_attempts` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `status` enum('DRAFT','PUBLISHED','CLOSED') NOT NULL DEFAULT 'DRAFT',
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assessments_erp_course_id_foreign` (`erp_course_id`),
  KEY `assessments_workspace_item_id_foreign` (`workspace_item_id`),
  CONSTRAINT `assessments_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assessments_workspace_item_id_foreign` FOREIGN KEY (`workspace_item_id`) REFERENCES `workspace_items` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments`
--

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;
INSERT INTO `assessments` VALUES
(1,2,NULL,'assignment','Asss',NULL,100.00,50.00,NULL,0,NULL,0,0,0,NULL,NULL,1,'DRAFT',144,'2026-07-20 11:29:50','2026-07-20 11:29:50',NULL);
/*!40000 ALTER TABLE `assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `course_delivery_topic_id` bigint(20) unsigned DEFAULT NULL,
  `session_date` date NOT NULL,
  `hours` decimal(4,1) NOT NULL DEFAULT 1.0,
  `status` enum('present','absent','late','excused') NOT NULL DEFAULT 'present',
  `notes` text DEFAULT NULL,
  `recorded_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attendance_erp_enrolment_id_erp_course_id_session_date_unique` (`erp_enrolment_id`,`erp_course_id`,`session_date`),
  KEY `attendance_erp_course_id_foreign` (`erp_course_id`),
  KEY `attendance_course_delivery_topic_id_foreign` (`course_delivery_topic_id`),
  CONSTRAINT `attendance_course_delivery_topic_id_foreign` FOREIGN KEY (`course_delivery_topic_id`) REFERENCES `course_delivery_topics` (`id`) ON DELETE SET NULL,
  CONSTRAINT `attendance_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `attendance_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `actor_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `actor_email` varchar(191) DEFAULT NULL,
  `action` varchar(64) NOT NULL COMMENT 'e.g. sync.school, erp.event.received',
  `entity_type` varchar(64) DEFAULT NULL,
  `entity_id` bigint(20) unsigned DEFAULT NULL,
  `before` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`before`)),
  `after` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`after`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `occurred_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `audit_logs_entity_type_entity_id_index` (`entity_type`,`entity_id`),
  KEY `audit_logs_actor_erp_user_id_index` (`actor_erp_user_id`),
  KEY `audit_logs_occurred_at_index` (`occurred_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES
(1,143,'dean@hit.ac.zw','nqf_level.create','NqfLevel',4,NULL,'{\"name\":\"Level 8 (verify)\",\"description\":\"Bachelor Degree Level \\u2014 post-migration verification\",\"created_by_erp_user_id\":143,\"updated_at\":\"2026-07-10T13:49:31.000000Z\",\"created_at\":\"2026-07-10T13:49:31.000000Z\",\"id\":4}','127.0.0.1','2026-07-10 13:49:31'),
(2,143,'dean@hit.ac.zw','nqf_descriptor.create','NqfDescriptor',5,NULL,'{\"nqf_level_id\":4,\"domain\":null,\"body\":\"Demonstrate advanced knowledge in the field.\",\"created_by_erp_user_id\":143,\"sequence_number\":1,\"updated_at\":\"2026-07-10T13:49:47.000000Z\",\"created_at\":\"2026-07-10T13:49:47.000000Z\",\"id\":5}','127.0.0.1','2026-07-10 13:49:47'),
(3,143,'dean@hit.ac.zw','nqf_descriptor.update','NqfDescriptor',1,'{\"id\":1,\"nqf_level_id\":2,\"sequence_number\":1,\"domain\":\"knowledge\",\"body\":\"Demonstrates broad, integrated knowledge of the discipline.\",\"created_by_erp_user_id\":null,\"updated_by_erp_user_id\":null,\"created_at\":\"2026-07-10T07:24:10.000000Z\",\"updated_at\":\"2026-07-10T07:24:10.000000Z\"}','{\"id\":1,\"nqf_level_id\":2,\"sequence_number\":1,\"domain\":\"knowledge\",\"body\":\"Demonstrate broad, integrated knowledge of the discipline.\",\"created_by_erp_user_id\":null,\"updated_by_erp_user_id\":143,\"created_at\":\"2026-07-10T07:24:10.000000Z\",\"updated_at\":\"2026-07-10T13:51:43.000000Z\"}','127.0.0.1','2026-07-10 13:51:43'),
(4,143,'dean@hit.ac.zw','nqf_descriptor.update','NqfDescriptor',1,'{\"id\":1,\"nqf_level_id\":2,\"sequence_number\":1,\"domain\":\"knowledge\",\"body\":\"Demonstrate broad, integrated knowledge of the discipline.\",\"created_by_erp_user_id\":null,\"updated_by_erp_user_id\":143,\"created_at\":\"2026-07-10T07:24:10.000000Z\",\"updated_at\":\"2026-07-10T13:51:43.000000Z\"}','{\"id\":1,\"nqf_level_id\":2,\"sequence_number\":1,\"domain\":\"knowledge\",\"body\":\"Demonstrates broad, integrated knowledge of the discipline.\",\"created_by_erp_user_id\":null,\"updated_by_erp_user_id\":143,\"created_at\":\"2026-07-10T07:24:10.000000Z\",\"updated_at\":\"2026-07-10T13:51:49.000000Z\"}','127.0.0.1','2026-07-10 13:51:49'),
(5,143,'dean@hit.ac.zw','nqf_descriptor.create','NqfDescriptor',6,NULL,'{\"nqf_level_id\":2,\"domain\":null,\"body\":\"Descriptor 3\",\"created_by_erp_user_id\":143,\"sequence_number\":3,\"updated_at\":\"2026-07-10T13:52:21.000000Z\",\"created_at\":\"2026-07-10T13:52:21.000000Z\",\"id\":6}','127.0.0.1','2026-07-10 13:52:21'),
(6,143,'dean@hit.ac.zw','nqf_descriptor.delete','NqfDescriptor',6,'{\"id\":6,\"nqf_level_id\":2,\"sequence_number\":3,\"domain\":null,\"body\":\"Descriptor 3\",\"created_by_erp_user_id\":143,\"updated_by_erp_user_id\":null,\"created_at\":\"2026-07-10T13:52:21.000000Z\",\"updated_at\":\"2026-07-10T13:52:21.000000Z\"}',NULL,'127.0.0.1','2026-07-10 13:52:24'),
(7,143,'dean@hit.ac.zw','nqf_descriptor.create','NqfDescriptor',7,NULL,'{\"nqf_level_id\":2,\"domain\":null,\"body\":\"Descriptor 3\",\"created_by_erp_user_id\":143,\"sequence_number\":3,\"updated_at\":\"2026-07-10T13:52:32.000000Z\",\"created_at\":\"2026-07-10T13:52:32.000000Z\",\"id\":7}','127.0.0.1','2026-07-10 13:52:32');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clo_plo_mappings`
--

DROP TABLE IF EXISTS `clo_plo_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clo_plo_mappings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `portfolio_clo_id` bigint(20) unsigned NOT NULL,
  `plo_id` bigint(20) unsigned NOT NULL,
  `mapping_level` enum('introduce','reinforce','master') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clo_plo_mappings_unique` (`portfolio_clo_id`,`plo_id`),
  KEY `clo_plo_mappings_plo_id_foreign` (`plo_id`),
  CONSTRAINT `clo_plo_mappings_plo_id_foreign` FOREIGN KEY (`plo_id`) REFERENCES `plos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `clo_plo_mappings_portfolio_clo_id_foreign` FOREIGN KEY (`portfolio_clo_id`) REFERENCES `portfolio_clos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clo_plo_mappings`
--

LOCK TABLES `clo_plo_mappings` WRITE;
/*!40000 ALTER TABLE `clo_plo_mappings` DISABLE KEYS */;
/*!40000 ALTER TABLE `clo_plo_mappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_item_completions`
--

DROP TABLE IF EXISTS `content_item_completions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_item_completions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content_item_id` bigint(20) unsigned NOT NULL,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `progress_pct` decimal(5,2) NOT NULL DEFAULT 0.00,
  `is_complete` tinyint(1) NOT NULL DEFAULT 0,
  `completed_at` timestamp NULL DEFAULT NULL,
  `last_accessed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_item_completions_content_item_id_erp_enrolment_id_unique` (`content_item_id`,`erp_enrolment_id`),
  KEY `content_item_completions_erp_enrolment_id_foreign` (`erp_enrolment_id`),
  CONSTRAINT `content_item_completions_content_item_id_foreign` FOREIGN KEY (`content_item_id`) REFERENCES `content_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_item_completions_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_item_completions`
--

LOCK TABLES `content_item_completions` WRITE;
/*!40000 ALTER TABLE `content_item_completions` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_item_completions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_item_delivery_subtopics`
--

DROP TABLE IF EXISTS `content_item_delivery_subtopics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_item_delivery_subtopics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content_item_id` bigint(20) unsigned NOT NULL,
  `course_delivery_subtopic_id` bigint(20) unsigned NOT NULL,
  `erp_course_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cids_content_subtopic_unique` (`content_item_id`,`course_delivery_subtopic_id`),
  KEY `cids_subtopic_foreign` (`course_delivery_subtopic_id`),
  CONSTRAINT `cids_subtopic_foreign` FOREIGN KEY (`course_delivery_subtopic_id`) REFERENCES `course_delivery_subtopics` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_item_workspace_content_item_id_foreign` FOREIGN KEY (`content_item_id`) REFERENCES `content_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_item_delivery_subtopics`
--

LOCK TABLES `content_item_delivery_subtopics` WRITE;
/*!40000 ALTER TABLE `content_item_delivery_subtopics` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_item_delivery_subtopics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_items`
--

DROP TABLE IF EXISTS `content_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `content_type` enum('pdf','powerpoint','word','scorm','video','h5p','link','opencast','bbb_recording') NOT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `external_url` varchar(500) DEFAULT NULL,
  `source_video_id` varchar(191) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size_bytes` bigint(20) unsigned DEFAULT NULL,
  `version_number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `parent_content_item_id` bigint(20) unsigned DEFAULT NULL,
  `is_global` tinyint(1) NOT NULL DEFAULT 0,
  `shared_with` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`shared_with`)),
  `copyright_owner` varchar(191) DEFAULT NULL,
  `copyright_year` year(4) DEFAULT NULL,
  `license` varchar(100) DEFAULT NULL,
  `status` enum('DRAFT','UNDER_REVIEW','APPROVED','PUBLISHED') NOT NULL DEFAULT 'DRAFT',
  `archived` tinyint(1) NOT NULL DEFAULT 0,
  `uploaded_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `content_items_parent_content_item_id_foreign` (`parent_content_item_id`),
  CONSTRAINT `content_items_parent_content_item_id_foreign` FOREIGN KEY (`parent_content_item_id`) REFERENCES `content_items` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_items`
--

LOCK TABLES `content_items` WRITE;
/*!40000 ALTER TABLE `content_items` DISABLE KEYS */;
INSERT INTO `content_items` VALUES
(1,'Testing','Test files','pdf',NULL,NULL,NULL,NULL,NULL,1,NULL,1,NULL,NULL,NULL,NULL,'DRAFT',0,144,NULL,NULL,NULL,'2026-07-14 08:21:15','2026-07-14 08:21:15',NULL),
(2,'Testing','Test files','pdf',NULL,NULL,NULL,NULL,NULL,2,1,1,NULL,NULL,NULL,NULL,'DRAFT',0,144,NULL,NULL,NULL,'2026-07-14 08:21:20','2026-07-14 08:21:20',NULL),
(3,'Week 1 — Lecture Slides (demo)',NULL,'pdf',NULL,NULL,NULL,NULL,NULL,1,NULL,0,NULL,NULL,NULL,NULL,'PUBLISHED',0,NULL,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06','2026-07-14 08:29:06',NULL);
/*!40000 ALTER TABLE `content_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_delivery_subtopics`
--

DROP TABLE IF EXISTS `course_delivery_subtopics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_delivery_subtopics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_delivery_topic_id` bigint(20) unsigned NOT NULL,
  `subtopic_uid` uuid NOT NULL,
  `title` varchar(191) NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `status` enum('active','archived') NOT NULL DEFAULT 'active',
  `release_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cds_topic_subtopic_uid_unique` (`course_delivery_topic_id`,`subtopic_uid`),
  CONSTRAINT `course_delivery_subtopics_course_delivery_topic_id_foreign` FOREIGN KEY (`course_delivery_topic_id`) REFERENCES `course_delivery_topics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_delivery_subtopics`
--

LOCK TABLES `course_delivery_subtopics` WRITE;
/*!40000 ALTER TABLE `course_delivery_subtopics` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_delivery_subtopics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_delivery_topics`
--

DROP TABLE IF EXISTS `course_delivery_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_delivery_topics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_offering_id` bigint(20) unsigned NOT NULL,
  `topic_uid` uuid NOT NULL,
  `source_outline_week_id` bigint(20) unsigned DEFAULT NULL,
  `week_number` tinyint(3) unsigned NOT NULL,
  `title` varchar(191) NOT NULL,
  `teaching_hours` decimal(4,1) DEFAULT NULL,
  `delivery_mode` enum('face_to_face','online','hybrid','paced') DEFAULT NULL,
  `status` enum('active','archived') NOT NULL DEFAULT 'active',
  `release_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_delivery_topics_course_offering_id_topic_uid_unique` (`course_offering_id`,`topic_uid`),
  KEY `course_delivery_topics_source_outline_week_id_foreign` (`source_outline_week_id`),
  CONSTRAINT `course_delivery_topics_course_offering_id_foreign` FOREIGN KEY (`course_offering_id`) REFERENCES `course_offerings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `course_delivery_topics_source_outline_week_id_foreign` FOREIGN KEY (`source_outline_week_id`) REFERENCES `outline_weeks` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_delivery_topics`
--

LOCK TABLES `course_delivery_topics` WRITE;
/*!40000 ALTER TABLE `course_delivery_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_delivery_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_offerings`
--

DROP TABLE IF EXISTS `course_offerings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_offerings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `erp_calendar_id` bigint(20) unsigned NOT NULL,
  `status` enum('planned','active','completed') NOT NULL DEFAULT 'planned',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_offerings_course_term_unique` (`erp_course_id`,`erp_calendar_id`),
  KEY `course_offerings_erp_calendar_id_foreign` (`erp_calendar_id`),
  CONSTRAINT `course_offerings_erp_calendar_id_foreign` FOREIGN KEY (`erp_calendar_id`) REFERENCES `erp_calendar` (`id`) ON DELETE CASCADE,
  CONSTRAINT `course_offerings_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_offerings`
--

LOCK TABLES `course_offerings` WRITE;
/*!40000 ALTER TABLE `course_offerings` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_offerings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_outlines`
--

DROP TABLE IF EXISTS `course_outlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_outlines` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `status` enum('DRAFT','SUBMITTED','UNDER_REVIEW','APPROVED','PUBLISHED','REJECTED') NOT NULL DEFAULT 'DRAFT',
  `version_number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `published_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_outlines_course_portfolio_id_unique` (`course_portfolio_id`),
  CONSTRAINT `course_outlines_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_outlines`
--

LOCK TABLES `course_outlines` WRITE;
/*!40000 ALTER TABLE `course_outlines` DISABLE KEYS */;
INSERT INTO `course_outlines` VALUES
(1,1,'PUBLISHED',1,NULL,NULL,NULL,NULL,'2026-07-14 08:29:05','2026-07-14 08:29:05','2026-07-14 08:29:05',NULL);
/*!40000 ALTER TABLE `course_outlines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_permission_delegations`
--

DROP TABLE IF EXISTS `course_permission_delegations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_permission_delegations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_offering_id` bigint(20) unsigned NOT NULL,
  `delegated_to_erp_user_id` bigint(20) unsigned NOT NULL,
  `delegated_by_erp_user_id` bigint(20) unsigned NOT NULL,
  `abilities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`abilities`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_delegation_unique` (`course_offering_id`,`delegated_to_erp_user_id`),
  CONSTRAINT `course_permission_delegations_course_offering_id_foreign` FOREIGN KEY (`course_offering_id`) REFERENCES `course_offerings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_permission_delegations`
--

LOCK TABLES `course_permission_delegations` WRITE;
/*!40000 ALTER TABLE `course_permission_delegations` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_permission_delegations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_portfolios`
--

DROP TABLE IF EXISTS `course_portfolios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_portfolios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `owner_name` varchar(191) DEFAULT NULL,
  `status` enum('DRAFT','SUBMITTED','UNDER_REVIEW','APPROVED','PUBLISHED','REJECTED','SUPERSEDED') NOT NULL DEFAULT 'DRAFT',
  `version_number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `academic_year` varchar(9) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `parent_version_id` bigint(20) unsigned DEFAULT NULL,
  `synopsis` text DEFAULT NULL,
  `aims` text DEFAULT NULL,
  `objectives` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`objectives`)),
  `teaching_philosophy` text DEFAULT NULL,
  `assessment_strategy` text DEFAULT NULL,
  `resources` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`resources`)),
  `references` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`references`)),
  `hw_sw_requirements` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`hw_sw_requirements`)),
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `reviewed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `published_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `rejected_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_portfolios_erp_course_id_index` (`erp_course_id`),
  KEY `course_portfolios_parent_version_id_foreign` (`parent_version_id`),
  CONSTRAINT `course_portfolios_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `course_portfolios_parent_version_id_foreign` FOREIGN KEY (`parent_version_id`) REFERENCES `course_portfolios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_portfolios`
--

LOCK TABLES `course_portfolios` WRITE;
/*!40000 ALTER TABLE `course_portfolios` DISABLE KEYS */;
INSERT INTO `course_portfolios` VALUES
(1,1,'Paul','PUBLISHED',1,NULL,NULL,NULL,'Demo portfolio for teaching workspace preview.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-14 08:29:05',NULL,NULL,'2026-07-14 08:29:05','2026-07-17 13:21:37',NULL);
/*!40000 ALTER TABLE `course_portfolios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_subtopic_pages`
--

DROP TABLE IF EXISTS `delivery_subtopic_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_subtopic_pages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_delivery_subtopic_id` bigint(20) unsigned NOT NULL,
  `page_type` enum('text','video','link','file','quiz') NOT NULL,
  `title` varchar(191) NOT NULL,
  `body` longtext DEFAULT NULL,
  `url` varchar(500) DEFAULT NULL,
  `content_item_id` bigint(20) unsigned DEFAULT NULL,
  `assessment_id` bigint(20) unsigned DEFAULT NULL,
  `completion_method` enum('on_open','manual','video_complete','quiz_pass') NOT NULL DEFAULT 'on_open',
  `pass_threshold` tinyint(3) unsigned DEFAULT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `status` enum('draft','published') NOT NULL DEFAULT 'published',
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delivery_subtopic_pages_content_item_id_foreign` (`content_item_id`),
  KEY `dsp_subtopic_sort_idx` (`course_delivery_subtopic_id`,`sort_order`),
  CONSTRAINT `delivery_subtopic_pages_content_item_id_foreign` FOREIGN KEY (`content_item_id`) REFERENCES `content_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `delivery_subtopic_pages_course_delivery_subtopic_id_foreign` FOREIGN KEY (`course_delivery_subtopic_id`) REFERENCES `course_delivery_subtopics` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_subtopic_pages`
--

LOCK TABLES `delivery_subtopic_pages` WRITE;
/*!40000 ALTER TABLE `delivery_subtopic_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_subtopic_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_calendar`
--

DROP TABLE IF EXISTS `erp_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_calendar` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `academic_year` varchar(16) NOT NULL,
  `semester` tinyint(3) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('upcoming','active','closed') NOT NULL DEFAULT 'upcoming',
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_semester` (`academic_year`,`semester`),
  UNIQUE KEY `erp_calendar_erp_id_unique` (`erp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_calendar`
--

LOCK TABLES `erp_calendar` WRITE;
/*!40000 ALTER TABLE `erp_calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `erp_calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_courses`
--

DROP TABLE IF EXISTS `erp_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_courses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `erp_programme_id` bigint(20) unsigned DEFAULT NULL,
  `erp_department_id` bigint(20) unsigned DEFAULT NULL,
  `code` varchar(32) NOT NULL,
  `name` varchar(191) NOT NULL,
  `credits` tinyint(3) unsigned DEFAULT NULL,
  `level` tinyint(3) unsigned DEFAULT NULL,
  `semester` tinyint(3) unsigned DEFAULT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_courses_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_courses_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_courses`
--

LOCK TABLES `erp_courses` WRITE;
/*!40000 ALTER TABLE `erp_courses` DISABLE KEYS */;
INSERT INTO `erp_courses` VALUES
(1,301,1,1,'CS101','Introduction to Programming',12,1,1,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(2,302,1,1,'CS102','Data Structures & Algorithms',12,1,2,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(3,303,1,1,'CS201','Database Systems',12,2,1,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(4,304,1,2,'EE101','Circuit Theory',12,1,1,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10');
/*!40000 ALTER TABLE `erp_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_departments`
--

DROP TABLE IF EXISTS `erp_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_departments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `erp_school_id` bigint(20) unsigned DEFAULT NULL,
  `code` varchar(16) NOT NULL,
  `name` varchar(191) NOT NULL,
  `hod_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_departments_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_departments_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_departments`
--

LOCK TABLES `erp_departments` WRITE;
/*!40000 ALTER TABLE `erp_departments` DISABLE KEYS */;
INSERT INTO `erp_departments` VALUES
(1,1,1,'CS','Computer Science',142,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(2,2,1,'EE','Electrical Engineering',NULL,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(3,3,1,'ME','Mechanical Engineering',NULL,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10');
/*!40000 ALTER TABLE `erp_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_enrolments`
--

DROP TABLE IF EXISTS `erp_enrolments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_enrolments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `erp_user_id` bigint(20) unsigned NOT NULL COMMENT 'Student ERP user ID',
  `academic_year` varchar(16) NOT NULL,
  `semester` tinyint(3) unsigned NOT NULL,
  `status` enum('enrolled','dropped','completed') NOT NULL DEFAULT 'enrolled',
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_enrolment` (`erp_course_id`,`erp_user_id`,`academic_year`,`semester`),
  UNIQUE KEY `erp_enrolments_erp_id_unique` (`erp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_enrolments`
--

LOCK TABLES `erp_enrolments` WRITE;
/*!40000 ALTER TABLE `erp_enrolments` DISABLE KEYS */;
INSERT INTO `erp_enrolments` VALUES
(1,5000,301,905001,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(2,5001,301,905002,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(3,5002,301,905003,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(4,5003,301,905004,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(5,5004,301,905005,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(6,5005,301,905006,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(7,5006,301,905007,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(8,5007,301,905008,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(9,5008,301,905009,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(10,5009,301,905010,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(11,5010,301,905011,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(12,5011,301,905012,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(13,5012,301,905013,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(14,5013,301,905014,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(15,5014,301,905015,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(16,5015,301,905016,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(17,5016,301,905017,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(18,5017,301,905018,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(19,5018,301,905019,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(20,5019,301,905020,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(21,5020,301,905021,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(22,5021,301,905022,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(23,5022,301,905023,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(24,5023,301,905024,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(25,5024,301,905025,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(26,5025,301,905026,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(27,5026,301,905027,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(28,5027,301,905028,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(29,5028,301,905029,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(30,5029,301,905030,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(31,5030,301,905031,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(32,5031,301,905032,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(33,5032,301,905033,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(34,5033,301,905034,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(35,5034,301,905035,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(36,5035,301,905036,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(37,5036,301,905037,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(38,5037,301,905038,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(39,5038,301,905039,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(40,5039,301,905040,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(41,5040,302,905041,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(42,5041,302,905042,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(43,5042,302,905043,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(44,5043,302,905044,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(45,5044,302,905045,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(46,5045,302,905046,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(47,5046,302,905047,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(48,5047,302,905048,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(49,5048,302,905049,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(50,5049,302,905050,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(51,5050,302,905051,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(52,5051,302,905052,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(53,5052,302,905053,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(54,5053,302,905054,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(55,5054,302,905055,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(56,5055,302,905056,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(57,5056,302,905057,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(58,5057,302,905058,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(59,5058,302,905059,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(60,5059,302,905060,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(61,5060,302,905061,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(62,5061,302,905062,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(63,5062,302,905063,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(64,5063,302,905064,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(65,5064,302,905065,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(66,5065,302,905066,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(67,5066,302,905067,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(68,5067,302,905068,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(69,5068,302,905069,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(70,5069,302,905070,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(71,5070,302,905071,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(72,5071,302,905072,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(73,5072,302,905073,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(74,5073,302,905074,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(75,5074,302,905075,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(76,5075,303,905076,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(77,5076,303,905077,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(78,5077,303,905078,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(79,5078,303,905079,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(80,5079,303,905080,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(81,5080,303,905081,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(82,5081,303,905082,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(83,5082,303,905083,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(84,5083,303,905084,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(85,5084,303,905085,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(86,5085,303,905086,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(87,5086,303,905087,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(88,5087,303,905088,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(89,5088,303,905089,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(90,5089,303,905090,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(91,5090,303,905091,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(92,5091,303,905092,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(93,5092,303,905093,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(94,5093,303,905094,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(95,5094,303,905095,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(96,5095,303,905096,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(97,5096,303,905097,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(98,5097,303,905098,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(99,5098,303,905099,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(100,5099,303,905100,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(101,5100,303,905101,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(102,5101,303,905102,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(103,5102,303,905103,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(104,5103,304,905104,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(105,5104,304,905105,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(106,5105,304,905106,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(107,5106,304,905107,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(108,5107,304,905108,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(109,5108,304,905109,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(110,5109,304,905110,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(111,5110,304,905111,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(112,5111,304,905112,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(113,5112,304,905113,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(114,5113,304,905114,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(115,5114,304,905115,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(116,5115,304,905116,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(117,5116,304,905117,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(118,5117,304,905118,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(119,5118,304,905119,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(120,5119,304,905120,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(121,5120,304,905121,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(122,5121,304,905122,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(123,5122,304,905123,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(124,5123,304,905124,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(125,5124,304,905125,'2026',1,'enrolled',NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10');
/*!40000 ALTER TABLE `erp_enrolments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_lecturer_allocations`
--

DROP TABLE IF EXISTS `erp_lecturer_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_lecturer_allocations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `erp_user_id` bigint(20) unsigned NOT NULL COMMENT 'Lecturer ERP user ID',
  `academic_year` varchar(16) NOT NULL,
  `semester` tinyint(3) unsigned NOT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_allocation` (`erp_course_id`,`erp_user_id`,`academic_year`,`semester`),
  UNIQUE KEY `erp_lecturer_allocations_erp_id_unique` (`erp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_lecturer_allocations`
--

LOCK TABLES `erp_lecturer_allocations` WRITE;
/*!40000 ALTER TABLE `erp_lecturer_allocations` DISABLE KEYS */;
/*!40000 ALTER TABLE `erp_lecturer_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_permissions`
--

DROP TABLE IF EXISTS `erp_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `erp_role_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to erp_roles.erp_id',
  `slug` varchar(64) NOT NULL,
  `name` varchar(191) NOT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_permissions_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_permissions_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_permissions`
--

LOCK TABLES `erp_permissions` WRITE;
/*!40000 ALTER TABLE `erp_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `erp_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_programmes`
--

DROP TABLE IF EXISTS `erp_programmes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_programmes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL,
  `type` varchar(32) DEFAULT NULL,
  `erp_department_id` bigint(20) unsigned DEFAULT NULL,
  `code` varchar(32) NOT NULL,
  `name` varchar(191) NOT NULL,
  `credits` tinyint(3) unsigned DEFAULT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_programmes_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_programmes_code_unique` (`code`),
  KEY `erp_programmes_type_index` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_programmes`
--

LOCK TABLES `erp_programmes` WRITE;
/*!40000 ALTER TABLE `erp_programmes` DISABLE KEYS */;
INSERT INTO `erp_programmes` VALUES
(1,201,NULL,1,'BSCCS','BSc Honours Computer Science',120,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10');
/*!40000 ALTER TABLE `erp_programmes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_roles`
--

DROP TABLE IF EXISTS `erp_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL COMMENT 'Auth service role PK',
  `slug` varchar(64) NOT NULL,
  `name` varchar(191) NOT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_roles_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_roles_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_roles`
--

LOCK TABLES `erp_roles` WRITE;
/*!40000 ALTER TABLE `erp_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `erp_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_schools`
--

DROP TABLE IF EXISTS `erp_schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_schools` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL COMMENT 'PK in ERP Academic service',
  `code` varchar(16) NOT NULL,
  `name` varchar(191) NOT NULL,
  `dean_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_schools_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_schools_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_schools`
--

LOCK TABLES `erp_schools` WRITE;
/*!40000 ALTER TABLE `erp_schools` DISABLE KEYS */;
INSERT INTO `erp_schools` VALUES
(1,1,'FET','Engineering and Technology',143,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10');
/*!40000 ALTER TABLE `erp_schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `erp_users`
--

DROP TABLE IF EXISTS `erp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `erp_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_id` bigint(20) unsigned NOT NULL COMMENT 'Auth service user PK',
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `student_id` varchar(32) DEFAULT NULL,
  `staff_id` varchar(32) DEFAULT NULL,
  `erp_department_id` bigint(20) unsigned DEFAULT NULL,
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `erp_users_erp_id_unique` (`erp_id`),
  UNIQUE KEY `erp_users_email_unique` (`email`),
  UNIQUE KEY `erp_users_student_id_unique` (`student_id`),
  UNIQUE KEY `erp_users_staff_id_unique` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `erp_users`
--

LOCK TABLES `erp_users` WRITE;
/*!40000 ALTER TABLE `erp_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `erp_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eval_ai_analyses`
--

DROP TABLE IF EXISTS `eval_ai_analyses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `eval_ai_analyses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eval_survey_id` bigint(20) unsigned NOT NULL,
  `eval_question_id` bigint(20) unsigned DEFAULT NULL,
  `context_type` enum('survey','question') NOT NULL,
  `summary` text NOT NULL,
  `themes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`themes`)),
  `sentiment` varchar(20) DEFAULT NULL,
  `provider` varchar(50) DEFAULT NULL,
  `generated_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eval_ai_analyses_eval_question_id_foreign` (`eval_question_id`),
  KEY `eval_ai_analyses_context_index` (`eval_survey_id`,`eval_question_id`,`context_type`),
  CONSTRAINT `eval_ai_analyses_eval_question_id_foreign` FOREIGN KEY (`eval_question_id`) REFERENCES `eval_questions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `eval_ai_analyses_eval_survey_id_foreign` FOREIGN KEY (`eval_survey_id`) REFERENCES `eval_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eval_ai_analyses`
--

LOCK TABLES `eval_ai_analyses` WRITE;
/*!40000 ALTER TABLE `eval_ai_analyses` DISABLE KEYS */;
/*!40000 ALTER TABLE `eval_ai_analyses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eval_questions`
--

DROP TABLE IF EXISTS `eval_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `eval_questions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eval_survey_id` bigint(20) unsigned NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('likert','text') NOT NULL DEFAULT 'likert',
  `likert_scale` tinyint(3) unsigned DEFAULT 5,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eval_questions_eval_survey_id_foreign` (`eval_survey_id`),
  CONSTRAINT `eval_questions_eval_survey_id_foreign` FOREIGN KEY (`eval_survey_id`) REFERENCES `eval_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eval_questions`
--

LOCK TABLES `eval_questions` WRITE;
/*!40000 ALTER TABLE `eval_questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `eval_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eval_responses`
--

DROP TABLE IF EXISTS `eval_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `eval_responses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eval_survey_id` bigint(20) unsigned NOT NULL,
  `eval_question_id` bigint(20) unsigned NOT NULL,
  `response_session` uuid NOT NULL,
  `respondent_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `anonymity_token` varchar(64) DEFAULT NULL,
  `likert_value` tinyint(3) unsigned DEFAULT NULL,
  `text_value` text DEFAULT NULL,
  `submitted_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eval_responses_eval_question_id_foreign` (`eval_question_id`),
  KEY `eval_responses_eval_survey_id_response_session_index` (`eval_survey_id`,`response_session`),
  KEY `eval_responses_eval_survey_id_anonymity_token_index` (`eval_survey_id`,`anonymity_token`),
  CONSTRAINT `eval_responses_eval_question_id_foreign` FOREIGN KEY (`eval_question_id`) REFERENCES `eval_questions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `eval_responses_eval_survey_id_foreign` FOREIGN KEY (`eval_survey_id`) REFERENCES `eval_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eval_responses`
--

LOCK TABLES `eval_responses` WRITE;
/*!40000 ALTER TABLE `eval_responses` DISABLE KEYS */;
/*!40000 ALTER TABLE `eval_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eval_survey_rosters`
--

DROP TABLE IF EXISTS `eval_survey_rosters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `eval_survey_rosters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `eval_survey_id` bigint(20) unsigned NOT NULL,
  `erp_enrolment_id` bigint(20) unsigned DEFAULT NULL,
  `erp_user_id` bigint(20) unsigned NOT NULL,
  `snapshotted_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `eval_survey_rosters_eval_survey_id_erp_user_id_unique` (`eval_survey_id`,`erp_user_id`),
  CONSTRAINT `eval_survey_rosters_eval_survey_id_foreign` FOREIGN KEY (`eval_survey_id`) REFERENCES `eval_surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eval_survey_rosters`
--

LOCK TABLES `eval_survey_rosters` WRITE;
/*!40000 ALTER TABLE `eval_survey_rosters` DISABLE KEYS */;
/*!40000 ALTER TABLE `eval_survey_rosters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eval_surveys`
--

DROP TABLE IF EXISTS `eval_surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `eval_surveys` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `target_type` enum('course','lecturer','programme') NOT NULL DEFAULT 'course',
  `erp_course_id` bigint(20) unsigned DEFAULT NULL,
  `erp_lecturer_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `erp_programme_id` bigint(20) unsigned DEFAULT NULL,
  `anonymity_mode` enum('anonymous','identified') NOT NULL DEFAULT 'anonymous',
  `status` enum('draft','open','closed') NOT NULL DEFAULT 'draft',
  `opens_at` timestamp NULL DEFAULT NULL,
  `closes_at` timestamp NULL DEFAULT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eval_surveys_erp_course_id_foreign` (`erp_course_id`),
  KEY `eval_surveys_erp_programme_id_foreign` (`erp_programme_id`),
  KEY `eval_surveys_status_target_type_index` (`status`,`target_type`),
  CONSTRAINT `eval_surveys_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `eval_surveys_erp_programme_id_foreign` FOREIGN KEY (`erp_programme_id`) REFERENCES `erp_programmes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eval_surveys`
--

LOCK TABLES `eval_surveys` WRITE;
/*!40000 ALTER TABLE `eval_surveys` DISABLE KEYS */;
/*!40000 ALTER TABLE `eval_surveys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `starts_at` timestamp NOT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `location` varchar(191) DEFAULT NULL,
  `target_type` enum('global','programme','course') NOT NULL DEFAULT 'global',
  `erp_programme_id` bigint(20) unsigned DEFAULT NULL,
  `erp_course_id` bigint(20) unsigned DEFAULT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `events_erp_programme_id_foreign` (`erp_programme_id`),
  KEY `events_erp_course_id_foreign` (`erp_course_id`),
  CONSTRAINT `events_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE SET NULL,
  CONSTRAINT `events_erp_programme_id_foreign` FOREIGN KEY (`erp_programme_id`) REFERENCES `erp_programmes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_platform_push_log`
--

DROP TABLE IF EXISTS `exam_platform_push_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_platform_push_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `final_mark_id` bigint(20) unsigned NOT NULL,
  `pushed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `status` enum('success','failed') NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `response` text DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `exam_platform_push_log_final_mark_id_foreign` (`final_mark_id`),
  CONSTRAINT `exam_platform_push_log_final_mark_id_foreign` FOREIGN KEY (`final_mark_id`) REFERENCES `final_marks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_platform_push_log`
--

LOCK TABLES `exam_platform_push_log` WRITE;
/*!40000 ALTER TABLE `exam_platform_push_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_platform_push_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `export_jobs`
--

DROP TABLE IF EXISTS `export_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `export_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `report_definition_id` bigint(20) unsigned NOT NULL,
  `requested_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `filters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`filters`)),
  `format` enum('pdf','excel','csv','api') NOT NULL,
  `status` enum('queued','processing','completed','failed') NOT NULL DEFAULT 'queued',
  `file_path` varchar(255) DEFAULT NULL,
  `error` text DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `export_jobs_report_definition_id_foreign` (`report_definition_id`),
  KEY `export_jobs_requested_by_erp_user_id_index` (`requested_by_erp_user_id`),
  CONSTRAINT `export_jobs_report_definition_id_foreign` FOREIGN KEY (`report_definition_id`) REFERENCES `report_definitions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_jobs`
--

LOCK TABLES `export_jobs` WRITE;
/*!40000 ALTER TABLE `export_jobs` DISABLE KEYS */;
INSERT INTO `export_jobs` VALUES
(1,1,143,'[]','pdf','completed','exports/report-1.pdf',NULL,'2026-07-10 12:20:14','2026-07-10 12:20:13','2026-07-10 12:20:14'),
(2,10,143,'[]','api','failed',NULL,'Missing required filter: erp_school_id',NULL,'2026-07-10 12:21:13','2026-07-10 12:21:13'),
(3,10,143,'[]','pdf','failed',NULL,'Missing required filter: erp_school_id',NULL,'2026-07-10 12:21:20','2026-07-10 12:21:20'),
(4,10,143,'{\"erp_department_id\":1,\"erp_school_id\":1,\"erp_programme_id\":1,\"erp_course_id\":1,\"erp_user_id\":1}','pdf','completed','exports/report-4.pdf',NULL,'2026-07-10 12:21:49','2026-07-10 12:21:48','2026-07-10 12:21:49'),
(5,13,143,'{\"erp_department_id\":1,\"erp_school_id\":1,\"erp_programme_id\":1,\"erp_course_id\":1,\"erp_user_id\":1}','pdf','completed','exports/report-5.pdf',NULL,'2026-07-10 12:22:40','2026-07-10 12:22:40','2026-07-10 12:22:40'),
(6,12,142,'[]','pdf','failed',NULL,'Missing required filter: erp_user_id',NULL,'2026-07-20 10:50:45','2026-07-20 10:50:45'),
(7,4,142,'[]','pdf','completed','exports/report-7.pdf',NULL,'2026-07-20 10:50:56','2026-07-20 10:50:55','2026-07-20 10:50:56');
/*!40000 ALTER TABLE `export_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `final_marks`
--

DROP TABLE IF EXISTS `final_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `final_marks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `total_mark` decimal(6,2) DEFAULT NULL,
  `grade_letter` varchar(5) DEFAULT NULL,
  `status` enum('DRAFT','APPROVED','PUSHED') NOT NULL DEFAULT 'DRAFT',
  `approved_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `pushed_at` timestamp NULL DEFAULT NULL,
  `push_error` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `final_marks_erp_enrolment_id_unique` (`erp_enrolment_id`),
  KEY `final_marks_erp_course_id_foreign` (`erp_course_id`),
  CONSTRAINT `final_marks_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `final_marks_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `final_marks`
--

LOCK TABLES `final_marks` WRITE;
/*!40000 ALTER TABLE `final_marks` DISABLE KEYS */;
/*!40000 ALTER TABLE `final_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradebook_categories`
--

DROP TABLE IF EXISTS `gradebook_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gradebook_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `weight_pct` decimal(5,2) NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gradebook_categories_erp_course_id_foreign` (`erp_course_id`),
  CONSTRAINT `gradebook_categories_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradebook_categories`
--

LOCK TABLES `gradebook_categories` WRITE;
/*!40000 ALTER TABLE `gradebook_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradebook_entries`
--

DROP TABLE IF EXISTS `gradebook_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gradebook_entries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `gradebook_category_id` bigint(20) unsigned NOT NULL,
  `assessment_id` bigint(20) unsigned DEFAULT NULL,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `raw_mark` decimal(6,2) DEFAULT NULL,
  `moderated_mark` decimal(6,2) DEFAULT NULL,
  `weighted_mark` decimal(6,2) DEFAULT NULL,
  `is_moderated` tinyint(1) NOT NULL DEFAULT 0,
  `moderated_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `moderated_at` timestamp NULL DEFAULT NULL,
  `moderation_notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gradebook_entries_cat_assessment_enrolment_unique` (`gradebook_category_id`,`assessment_id`,`erp_enrolment_id`),
  KEY `gradebook_entries_assessment_id_foreign` (`assessment_id`),
  KEY `gradebook_entries_erp_enrolment_id_foreign` (`erp_enrolment_id`),
  CONSTRAINT `gradebook_entries_assessment_id_foreign` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `gradebook_entries_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `gradebook_entries_gradebook_category_id_foreign` FOREIGN KEY (`gradebook_category_id`) REFERENCES `gradebook_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradebook_entries`
--

LOCK TABLES `gradebook_entries` WRITE;
/*!40000 ALTER TABLE `gradebook_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `integration_configs`
--

DROP TABLE IF EXISTS `integration_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `integration_configs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `provider` varchar(50) NOT NULL,
  `display_name` varchar(191) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `secret_ref` varchar(191) DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `updated_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `integration_configs_provider_unique` (`provider`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `integration_configs`
--

LOCK TABLES `integration_configs` WRITE;
/*!40000 ALTER TABLE `integration_configs` DISABLE KEYS */;
/*!40000 ALTER TABLE `integration_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learn_page_completions`
--

DROP TABLE IF EXISTS `learn_page_completions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `learn_page_completions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `delivery_subtopic_page_id` bigint(20) unsigned NOT NULL,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `learn_page_completion_unique` (`delivery_subtopic_page_id`,`erp_enrolment_id`),
  KEY `learn_page_completions_erp_enrolment_id_foreign` (`erp_enrolment_id`),
  CONSTRAINT `learn_page_completions_delivery_subtopic_page_id_foreign` FOREIGN KEY (`delivery_subtopic_page_id`) REFERENCES `delivery_subtopic_pages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `learn_page_completions_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learn_page_completions`
--

LOCK TABLES `learn_page_completions` WRITE;
/*!40000 ALTER TABLE `learn_page_completions` DISABLE KEYS */;
/*!40000 ALTER TABLE `learn_page_completions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_paths`
--

DROP TABLE IF EXISTS `learning_paths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_paths` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `ordered_item_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`ordered_item_ids`)),
  `is_sequential` tinyint(1) NOT NULL DEFAULT 1,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `learning_paths_erp_course_id_foreign` (`erp_course_id`),
  CONSTRAINT `learning_paths_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_paths`
--

LOCK TABLES `learning_paths` WRITE;
/*!40000 ALTER TABLE `learning_paths` DISABLE KEYS */;
/*!40000 ALTER TABLE `learning_paths` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_progress`
--

DROP TABLE IF EXISTS `lesson_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson_progress` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `workspace_item_id` bigint(20) unsigned NOT NULL,
  `progress_pct` decimal(5,2) NOT NULL DEFAULT 0.00,
  `is_complete` tinyint(1) NOT NULL DEFAULT 0,
  `completed_at` timestamp NULL DEFAULT NULL,
  `last_accessed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lesson_progress_erp_enrolment_id_workspace_item_id_unique` (`erp_enrolment_id`,`workspace_item_id`),
  KEY `lesson_progress_workspace_item_id_foreign` (`workspace_item_id`),
  CONSTRAINT `lesson_progress_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_progress_workspace_item_id_foreign` FOREIGN KEY (`workspace_item_id`) REFERENCES `workspace_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_progress`
--

LOCK TABLES `lesson_progress` WRITE;
/*!40000 ALTER TABLE `lesson_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lti_registrations`
--

DROP TABLE IF EXISTS `lti_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lti_registrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tool_name` varchar(191) NOT NULL,
  `client_id` varchar(191) NOT NULL,
  `deployment_id` varchar(191) NOT NULL,
  `oidc_login_initiation_url` varchar(255) NOT NULL,
  `redirect_uri` varchar(255) NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `lti_registrations_client_id_unique` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lti_registrations`
--

LOCK TABLES `lti_registrations` WRITE;
/*!40000 ALTER TABLE `lti_registrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `lti_registrations` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'2026_06_26_000001_create_users_table',1),
(2,'2026_06_26_000002_create_erp_schools_table',1),
(3,'2026_06_26_000003_create_erp_departments_table',1),
(4,'2026_06_26_000004_create_erp_programme_types_table',1),
(5,'2026_06_26_000005_create_erp_programmes_table',1),
(6,'2026_06_26_000006_create_erp_courses_table',1),
(7,'2026_06_26_000007_create_erp_users_table',1),
(8,'2026_06_26_000008_create_erp_roles_table',1),
(9,'2026_06_26_000009_create_erp_permissions_table',1),
(10,'2026_06_26_000010_create_erp_lecturer_allocations_table',1),
(11,'2026_06_26_000011_create_erp_enrolments_table',1),
(12,'2026_06_26_000012_create_erp_calendar_table',1),
(13,'2026_06_26_000013_create_sync_events_table',1),
(14,'2026_06_26_000014_create_sync_cursors_table',1),
(15,'2026_06_26_000015_create_audit_logs_table',1),
(16,'2026_06_30_000001_create_nqf_levels_table',1),
(17,'2026_06_30_000002_create_nqf_descriptors_table',1),
(18,'2026_06_30_000003_create_nqf_descriptor_versions_table',1),
(19,'2026_06_30_000004_create_programme_type_nqf_map_table',1),
(20,'2026_06_30_000005_create_plos_table',1),
(21,'2026_06_30_000006_create_plo_nqf_descriptor_map_table',1),
(22,'2026_06_30_000007_create_plo_comments_table',1),
(23,'2026_06_30_000008_create_plo_history_table',1),
(24,'2026_06_30_000009_create_course_portfolios_table',1),
(25,'2026_06_30_000010_create_portfolio_clos_table',1),
(26,'2026_06_30_000011_create_portfolio_history_table',1),
(27,'2026_06_30_000012_create_portfolio_comments_table',1),
(28,'2026_06_30_000013_create_course_outlines_table',1),
(29,'2026_06_30_000014_create_outline_weeks_table',1),
(30,'2026_06_30_000015_create_teaching_workspaces_table',1),
(31,'2026_06_30_000016_create_workspace_items_table',1),
(32,'2026_06_30_000017_create_content_items_table',1),
(33,'2026_06_30_000018_create_content_item_course_table',1),
(34,'2026_06_30_000019_add_content_item_id_to_workspace_items_table',1),
(35,'2026_06_30_000020_create_release_rules_table',1),
(36,'2026_06_30_000021_create_learning_paths_table',1),
(37,'2026_06_30_000022_create_lesson_progress_table',1),
(38,'2026_06_30_000023_create_attendance_table',1),
(39,'2026_06_30_000024_create_assessments_table',1),
(40,'2026_06_30_000025_create_questions_table',1),
(41,'2026_06_30_000026_create_assessment_questions_table',1),
(42,'2026_06_30_000027_create_rubrics_table',1),
(43,'2026_06_30_000028_create_submissions_table',1),
(44,'2026_06_30_000029_create_gradebook_categories_table',1),
(45,'2026_06_30_000030_create_gradebook_entries_table',1),
(46,'2026_06_30_000031_create_final_marks_table',1),
(47,'2026_07_01_000001_create_assessment_clo_map_table',2),
(48,'2026_07_01_000002_create_eval_surveys_table',2),
(49,'2026_07_01_000003_create_eval_questions_table',2),
(50,'2026_07_01_000004_create_eval_responses_table',2),
(51,'2026_07_02_000001_create_integration_configs_table',2),
(52,'2026_07_02_000002_create_lti_registrations_table',2),
(53,'2026_07_02_000003_create_virtual_class_sessions_table',2),
(54,'2026_07_02_000004_create_scorm_registrations_table',2),
(55,'2026_07_02_000005_create_xapi_statements_table',2),
(56,'2026_07_03_000001_create_report_definitions_table',2),
(57,'2026_07_03_000002_create_export_jobs_table',2),
(58,'2026_07_04_000001_add_sprint18_performance_indexes',2),
(59,'2026_07_05_000001_create_course_offerings_table',2),
(60,'2026_07_05_000002_create_course_permission_delegations_table',2),
(61,'2026_07_05_000003_add_plo_number_to_plos_table',2),
(62,'2026_07_05_000004_add_clo_number_to_portfolio_clos_table',2),
(63,'2026_07_05_000005_create_clo_plo_mappings_table',2),
(64,'2026_07_05_000006_create_programme_nqf_confirmations_table',2),
(65,'2026_07_05_000007_add_versioning_to_course_portfolios_table',2),
(66,'2026_07_06_000001_add_topic_uid_and_delivery_mode_to_outline_weeks_table',2),
(67,'2026_07_06_000002_create_course_delivery_topics_table',2),
(68,'2026_07_06_000003_create_course_delivery_subtopics_table',2),
(69,'2026_07_07_000001_add_shared_with_and_archived_to_content_items_table',2),
(70,'2026_07_07_000002_rework_content_item_workspace_to_delivery_subtopics',2),
(71,'2026_07_07_000003_create_content_item_completions_table',2),
(72,'2026_07_07_000004_add_course_delivery_topic_id_to_virtual_class_sessions_table',2),
(73,'2026_07_07_000005_add_course_delivery_topic_id_to_attendance_table',2),
(74,'2026_07_08_000001_add_safe_browsing_enabled_to_assessments_table',2),
(75,'2026_07_08_000002_add_source_video_id_to_content_items_table',2),
(76,'2026_07_08_000003_add_graded_status_override_to_submissions_table',2),
(77,'2026_07_08_000004_create_exam_platform_push_log_table',2),
(78,'2026_07_09_000001_create_eval_survey_rosters_table',2),
(79,'2026_07_09_000002_add_anonymity_token_to_eval_responses_table',2),
(80,'2026_07_09_000003_create_eval_ai_analyses_table',2),
(81,'2026_07_10_000001_add_visible_to_roles_to_portfolio_comments_table',2),
(82,'2026_07_11_000001_create_announcements_table',2),
(83,'2026_07_11_000002_create_events_table',2),
(84,'2026_07_11_000003_create_suggestions_table',2),
(85,'2026_07_11_000004_create_notifications_table',2),
(88,'2026_07_12_000001_refine_nqf_levels_parent',3),
(89,'2026_07_12_000002_add_sequence_number_to_nqf_descriptors',3),
(90,'2026_07_13_000001_recast_programme_type_as_code',4),
(91,'2026_07_14_000001_extend_portfolio_and_outline_for_lecturer_portfolio',5),
(92,'2026_07_14_000002_create_portfolio_section_tables',5),
(93,'2026_07_15_000001_portfolio_p1_enhancements',6),
(94,'2026_07_16_000001_create_learn_pages_tables',7);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `recipient_erp_user_id` bigint(20) unsigned NOT NULL,
  `title` varchar(191) NOT NULL,
  `body` text DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_recipient_erp_user_id_read_at_index` (`recipient_erp_user_id`,`read_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nqf_descriptor_versions`
--

DROP TABLE IF EXISTS `nqf_descriptor_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nqf_descriptor_versions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nqf_descriptor_id` bigint(20) unsigned NOT NULL,
  `version_number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `body` text NOT NULL,
  `status` enum('DRAFT','APPROVED','PUBLISHED','ARCHIVED') NOT NULL DEFAULT 'DRAFT',
  `notes` text DEFAULT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `published_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `archived_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `archived_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nqf_descriptor_versions_nqf_descriptor_id_version_number_unique` (`nqf_descriptor_id`,`version_number`),
  CONSTRAINT `nqf_descriptor_versions_nqf_descriptor_id_foreign` FOREIGN KEY (`nqf_descriptor_id`) REFERENCES `nqf_descriptors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nqf_descriptor_versions`
--

LOCK TABLES `nqf_descriptor_versions` WRITE;
/*!40000 ALTER TABLE `nqf_descriptor_versions` DISABLE KEYS */;
INSERT INTO `nqf_descriptor_versions` VALUES
(3,7,1,'Descriptor 3','DRAFT',NULL,143,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-10 13:52:32','2026-07-10 13:52:32');
/*!40000 ALTER TABLE `nqf_descriptor_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nqf_descriptors`
--

DROP TABLE IF EXISTS `nqf_descriptors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nqf_descriptors` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nqf_level_id` bigint(20) unsigned NOT NULL,
  `sequence_number` int(10) unsigned NOT NULL,
  `domain` varchar(191) DEFAULT NULL,
  `body` text NOT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `updated_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nqf_descriptors_level_sequence_unique` (`nqf_level_id`,`sequence_number`),
  KEY `nqf_descriptors_nqf_level_id_index` (`nqf_level_id`),
  CONSTRAINT `nqf_descriptors_nqf_level_id_foreign` FOREIGN KEY (`nqf_level_id`) REFERENCES `nqf_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nqf_descriptors`
--

LOCK TABLES `nqf_descriptors` WRITE;
/*!40000 ALTER TABLE `nqf_descriptors` DISABLE KEYS */;
INSERT INTO `nqf_descriptors` VALUES
(1,2,1,'knowledge','Demonstrates broad, integrated knowledge of the discipline.',NULL,143,'2026-07-10 07:24:10','2026-07-10 13:52:24'),
(2,2,2,'skills','Applies specialised technical and cognitive skills to complex problems.',NULL,NULL,'2026-07-10 07:24:10','2026-07-10 13:52:24'),
(3,3,1,'knowledge','Demonstrates broad, integrated knowledge of the discipline.',NULL,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(4,3,2,'skills','Applies specialised technical and cognitive skills to complex problems.',NULL,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10'),
(7,2,3,NULL,'Descriptor 3',143,NULL,'2026-07-10 13:52:32','2026-07-10 13:52:32');
/*!40000 ALTER TABLE `nqf_descriptors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nqf_levels`
--

DROP TABLE IF EXISTS `nqf_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `nqf_levels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `level` tinyint(3) unsigned DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `updated_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nqf_levels_level_unique` (`level`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nqf_levels`
--

LOCK TABLES `nqf_levels` WRITE;
/*!40000 ALTER TABLE `nqf_levels` DISABLE KEYS */;
INSERT INTO `nqf_levels` VALUES
(1,5,'NQF1','Basic',1,NULL,NULL,'2026-07-02 07:56:57','2026-07-02 07:57:32','2026-07-02 07:57:32'),
(2,6,'Bachelor Level','Advanced knowledge and skills',1,143,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10',NULL),
(3,8,'Honours Level','Specialised, research-informed competence',1,143,NULL,'2026-07-10 07:24:10','2026-07-10 07:24:10',NULL);
/*!40000 ALTER TABLE `nqf_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outline_weeks`
--

DROP TABLE IF EXISTS `outline_weeks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `outline_weeks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_outline_id` bigint(20) unsigned NOT NULL,
  `topic_uid` uuid NOT NULL,
  `week_number` tinyint(3) unsigned NOT NULL,
  `end_week` tinyint(3) unsigned DEFAULT NULL,
  `topic` varchar(191) NOT NULL,
  `subtopics` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`subtopics`)),
  `delivery_mode` enum('face_to_face','online','hybrid','paced') DEFAULT NULL,
  `teaching_hours` decimal(4,1) DEFAULT NULL,
  `topic_weight` decimal(5,2) DEFAULT NULL,
  `learning_outcomes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`learning_outcomes`)),
  `clo_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`clo_ids`)),
  `plo_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`plo_ids`)),
  `graduate_attributes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`graduate_attributes`)),
  `nqf_descriptor_version_id` bigint(20) unsigned DEFAULT NULL,
  `bloom_level` enum('remember','understand','apply','analyse','evaluate','create') DEFAULT NULL,
  `teaching_strategy` varchar(191) DEFAULT NULL,
  `assessment_strategy` varchar(191) DEFAULT NULL,
  `references` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`references`)),
  `resources` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`resources`)),
  `required_software` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`required_software`)),
  `practical_equipment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`practical_equipment`)),
  `remarks` text DEFAULT NULL,
  `delivered` tinyint(1) NOT NULL DEFAULT 0,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `outline_weeks_course_outline_id_week_number_unique` (`course_outline_id`,`week_number`),
  UNIQUE KEY `outline_weeks_course_outline_id_topic_uid_unique` (`course_outline_id`,`topic_uid`),
  KEY `outline_weeks_nqf_descriptor_version_id_foreign` (`nqf_descriptor_version_id`),
  CONSTRAINT `outline_weeks_course_outline_id_foreign` FOREIGN KEY (`course_outline_id`) REFERENCES `course_outlines` (`id`) ON DELETE CASCADE,
  CONSTRAINT `outline_weeks_nqf_descriptor_version_id_foreign` FOREIGN KEY (`nqf_descriptor_version_id`) REFERENCES `nqf_descriptor_versions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outline_weeks`
--

LOCK TABLES `outline_weeks` WRITE;
/*!40000 ALTER TABLE `outline_weeks` DISABLE KEYS */;
INSERT INTO `outline_weeks` VALUES
(1,1,'6fdd26d0-0dc9-41ff-b5a4-9dbb782d93dc',1,2,'Introduction & Environment Setup','[{\"uid\":\"568e69e6-09b3-4029-99c1-68a3a5f3dff1\",\"title\":\"[object Object]\"},{\"uid\":\"5612f618-0413-46f1-9292-d79745ff9332\",\"title\":\"[object Object]\"},{\"uid\":\"c2d29485-b9e1-4170-9250-b2672a45a4cd\",\"title\":\"[object Object]\"}]','face_to_face',25.0,10.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-17 13:22:15'),
(2,1,'3ac3d635-87fd-43ee-bd6a-100b29356f80',2,NULL,'Variables & Data Types','[{\"uid\":\"b0904a6f-e5d0-481f-9896-b4cb72679793\",\"title\":\"Primitive types\"},{\"uid\":\"fbe50af6-faa4-4406-839c-8cca60eb4914\",\"title\":\"Type conversion\"},{\"uid\":\"6bf40baf-60cf-4ff1-b7f3-1bb9623ed127\",\"title\":\"Constants\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(3,1,'e5f30c45-0069-4aff-adbc-36412298bb4c',3,NULL,'Control Flow','[{\"uid\":\"dbefdcc9-9da2-44c0-bf6c-63bf58449e21\",\"title\":\"Conditionals\"},{\"uid\":\"e29e0920-1970-43f7-af87-fcde879aaefe\",\"title\":\"Loops\"},{\"uid\":\"9a9ea467-ee92-43ef-bd10-3cedd0a41db2\",\"title\":\"Break & continue\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(4,1,'295eca79-0b08-42ff-9b03-7415b9d4fd36',4,NULL,'Functions','[{\"uid\":\"9e9f440d-bd22-4a93-9255-5db1882f0c78\",\"title\":\"Parameters & return values\"},{\"uid\":\"6937a3b1-b842-4214-8b62-b3dc40aceaa5\",\"title\":\"Scope\"},{\"uid\":\"e1697b99-0d31-405d-810f-73c1613175a5\",\"title\":\"Recursion basics\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(5,1,'16af1637-d9d2-4ae8-9d11-8472dc442a87',5,NULL,'Arrays & Collections','[{\"uid\":\"7e6bb6cb-8766-4b21-9ac0-a31f1eac4b29\",\"title\":\"Indexing\"},{\"uid\":\"3d51ba3b-63af-4913-aa30-087c9a419a07\",\"title\":\"Iteration\"},{\"uid\":\"d0970dd9-53d6-4f10-abdd-58b2bdeb1b28\",\"title\":\"Common operations\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(6,1,'1ff8c1c2-63b4-49dc-8e49-e7589b058313',6,NULL,'Strings & Text Processing','[{\"uid\":\"eb995f49-9f44-410e-b5af-81b30dfd830e\",\"title\":\"Manipulation\"},{\"uid\":\"12df135e-027a-4e2c-9210-e2a43a85808d\",\"title\":\"Formatting\"},{\"uid\":\"6412f121-8eb1-4e0b-a927-9f8c359ea1e0\",\"title\":\"Parsing\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(7,1,'99fd14a8-a7c6-4f75-b3e8-3caafe635034',7,NULL,'File Input & Output','[{\"uid\":\"cd3e9fac-8909-412b-89a6-ae96544d954b\",\"title\":\"Reading files\"},{\"uid\":\"6da46c2d-fe06-45f5-a6f8-0375205988bc\",\"title\":\"Writing files\"},{\"uid\":\"c17456c7-91e3-4c4b-8cfc-db43d4185e9f\",\"title\":\"Error handling\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(8,1,'aebb3df7-842c-47fd-95c9-0eb6690e7b56',8,NULL,'Putting It Together','[{\"uid\":\"fee93758-0ebf-42cb-8ecf-6634682a5f32\",\"title\":\"Mini project\"},{\"uid\":\"03150b58-ef49-4f92-85d3-44cb0ce3dc27\",\"title\":\"Debugging\"},{\"uid\":\"4547c3fb-b262-4bbb-9065-b63451564690\",\"title\":\"Code review\"}]','face_to_face',3.0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06');
/*!40000 ALTER TABLE `outline_weeks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plo_comments`
--

DROP TABLE IF EXISTS `plo_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plo_comments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `plo_id` bigint(20) unsigned NOT NULL,
  `body` text NOT NULL,
  `commenter_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `commenter_role` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plo_comments_plo_id_foreign` (`plo_id`),
  CONSTRAINT `plo_comments_plo_id_foreign` FOREIGN KEY (`plo_id`) REFERENCES `plos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plo_comments`
--

LOCK TABLES `plo_comments` WRITE;
/*!40000 ALTER TABLE `plo_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `plo_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plo_history`
--

DROP TABLE IF EXISTS `plo_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plo_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `plo_id` bigint(20) unsigned NOT NULL,
  `changed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `from_status` varchar(50) DEFAULT NULL,
  `to_status` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plo_history_plo_id_foreign` (`plo_id`),
  CONSTRAINT `plo_history_plo_id_foreign` FOREIGN KEY (`plo_id`) REFERENCES `plos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plo_history`
--

LOCK TABLES `plo_history` WRITE;
/*!40000 ALTER TABLE `plo_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `plo_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plo_nqf_descriptor_map`
--

DROP TABLE IF EXISTS `plo_nqf_descriptor_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plo_nqf_descriptor_map` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `plo_id` bigint(20) unsigned NOT NULL,
  `nqf_descriptor_version_id` bigint(20) unsigned NOT NULL,
  `rationale` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plo_nqf_descriptor_map_plo_id_nqf_descriptor_version_id_unique` (`plo_id`,`nqf_descriptor_version_id`),
  KEY `plo_nqf_descriptor_map_nqf_descriptor_version_id_foreign` (`nqf_descriptor_version_id`),
  CONSTRAINT `plo_nqf_descriptor_map_nqf_descriptor_version_id_foreign` FOREIGN KEY (`nqf_descriptor_version_id`) REFERENCES `nqf_descriptor_versions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `plo_nqf_descriptor_map_plo_id_foreign` FOREIGN KEY (`plo_id`) REFERENCES `plos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plo_nqf_descriptor_map`
--

LOCK TABLES `plo_nqf_descriptor_map` WRITE;
/*!40000 ALTER TABLE `plo_nqf_descriptor_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `plo_nqf_descriptor_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plos`
--

DROP TABLE IF EXISTS `plos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_programme_id` bigint(20) unsigned NOT NULL,
  `plo_number` smallint(5) unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text NOT NULL,
  `status` enum('DRAFT','SUBMITTED','REVIEW','APPROVED','PUBLISHED') NOT NULL DEFAULT 'DRAFT',
  `version_number` smallint(5) unsigned NOT NULL DEFAULT 1,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `reviewed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `published_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plos_erp_programme_id_foreign` (`erp_programme_id`),
  CONSTRAINT `plos_erp_programme_id_foreign` FOREIGN KEY (`erp_programme_id`) REFERENCES `erp_programmes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plos`
--

LOCK TABLES `plos` WRITE;
/*!40000 ALTER TABLE `plos` DISABLE KEYS */;
/*!40000 ALTER TABLE `plos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_assessment_strategies`
--

DROP TABLE IF EXISTS `portfolio_assessment_strategies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_assessment_strategies` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `assessment_tool` varchar(191) NOT NULL,
  `assessment_type` varchar(100) DEFAULT NULL,
  `category` enum('continuous','summative') DEFAULT NULL,
  `method` varchar(191) DEFAULT NULL,
  `rubric_ref` varchar(255) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `week_due` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `clo_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`clo_ids`)),
  `plo_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`plo_ids`)),
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_assessment_strategies_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_assessment_strategies_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_assessment_strategies`
--

LOCK TABLES `portfolio_assessment_strategies` WRITE;
/*!40000 ALTER TABLE `portfolio_assessment_strategies` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_assessment_strategies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_clos`
--

DROP TABLE IF EXISTS `portfolio_clos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_clos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `clo_number` smallint(5) unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `bloom_level` enum('remember','understand','apply','analyse','evaluate','create') NOT NULL,
  `graduate_attributes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`graduate_attributes`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `portfolio_clos_portfolio_number_unique` (`clo_number`,`course_portfolio_id`),
  KEY `portfolio_clos_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_clos_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_clos`
--

LOCK TABLES `portfolio_clos` WRITE;
/*!40000 ALTER TABLE `portfolio_clos` DISABLE KEYS */;
INSERT INTO `portfolio_clos` VALUES
(2,1,1,'CLO1','Testing','understand',NULL,'2026-07-17 08:09:51','2026-07-17 08:09:51'),
(3,1,2,'CLO2','Testing 2','understand',NULL,'2026-07-17 08:09:51','2026-07-17 08:09:51');
/*!40000 ALTER TABLE `portfolio_clos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_comments`
--

DROP TABLE IF EXISTS `portfolio_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_comments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `body` text NOT NULL,
  `commenter_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `commenter_role` varchar(50) DEFAULT NULL,
  `visible_to_roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`visible_to_roles`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_comments_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_comments_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_comments`
--

LOCK TABLES `portfolio_comments` WRITE;
/*!40000 ALTER TABLE `portfolio_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_contributions`
--

DROP TABLE IF EXISTS `portfolio_contributions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_contributions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `plo_id` bigint(20) unsigned NOT NULL,
  `course_emphasis` enum('high','medium','low') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `portfolio_contribution_unique` (`course_portfolio_id`,`plo_id`),
  KEY `portfolio_contributions_plo_id_foreign` (`plo_id`),
  CONSTRAINT `portfolio_contributions_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `portfolio_contributions_plo_id_foreign` FOREIGN KEY (`plo_id`) REFERENCES `plos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_contributions`
--

LOCK TABLES `portfolio_contributions` WRITE;
/*!40000 ALTER TABLE `portfolio_contributions` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_contributions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_history`
--

DROP TABLE IF EXISTS `portfolio_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `changed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `from_status` varchar(50) DEFAULT NULL,
  `to_status` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_history_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_history_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_history`
--

LOCK TABLES `portfolio_history` WRITE;
/*!40000 ALTER TABLE `portfolio_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_lab_work`
--

DROP TABLE IF EXISTS `portfolio_lab_work`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_lab_work` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `start_week` tinyint(3) unsigned DEFAULT NULL,
  `end_week` tinyint(3) unsigned DEFAULT NULL,
  `laboratory_work` text NOT NULL,
  `equipment` text DEFAULT NULL,
  `safety_notes` text DEFAULT NULL,
  `expected_outcomes` text DEFAULT NULL,
  `assessment` text DEFAULT NULL,
  `resources` text DEFAULT NULL,
  `hours` decimal(5,1) DEFAULT NULL,
  `clo_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`clo_ids`)),
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_lab_work_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_lab_work_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_lab_work`
--

LOCK TABLES `portfolio_lab_work` WRITE;
/*!40000 ALTER TABLE `portfolio_lab_work` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_lab_work` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_learning_activities`
--

DROP TABLE IF EXISTS `portfolio_learning_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_learning_activities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `activity` varchar(255) NOT NULL,
  `method` varchar(191) DEFAULT NULL,
  `clo_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`clo_ids`)),
  `hours` decimal(5,1) DEFAULT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_learning_activities_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_learning_activities_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_learning_activities`
--

LOCK TABLES `portfolio_learning_activities` WRITE;
/*!40000 ALTER TABLE `portfolio_learning_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_learning_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_policy_files`
--

DROP TABLE IF EXISTS `portfolio_policy_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_policy_files` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `file_path` varchar(255) NOT NULL,
  `original_filename` varchar(255) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_size` int(10) unsigned DEFAULT NULL,
  `uploaded_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_policy_files_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_policy_files_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_policy_files`
--

LOCK TABLES `portfolio_policy_files` WRITE;
/*!40000 ALTER TABLE `portfolio_policy_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_policy_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_references`
--

DROP TABLE IF EXISTS `portfolio_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_references` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `reference_type` varchar(60) DEFAULT NULL,
  `citation` text NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_references_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_references_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_references`
--

LOCK TABLES `portfolio_references` WRITE;
/*!40000 ALTER TABLE `portfolio_references` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_references` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portfolio_resources`
--

DROP TABLE IF EXISTS `portfolio_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio_resources` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_portfolio_id` bigint(20) unsigned NOT NULL,
  `resource_type` varchar(60) NOT NULL,
  `title` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `authors` varchar(255) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  `publisher` varchar(191) DEFAULT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portfolio_resources_course_portfolio_id_foreign` (`course_portfolio_id`),
  CONSTRAINT `portfolio_resources_course_portfolio_id_foreign` FOREIGN KEY (`course_portfolio_id`) REFERENCES `course_portfolios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portfolio_resources`
--

LOCK TABLES `portfolio_resources` WRITE;
/*!40000 ALTER TABLE `portfolio_resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio_resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programme_nqf_confirmations`
--

DROP TABLE IF EXISTS `programme_nqf_confirmations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme_nqf_confirmations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_programme_id` bigint(20) unsigned NOT NULL,
  `nqf_level_id` bigint(20) unsigned NOT NULL,
  `confirmed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programme_nqf_confirmations_erp_programme_id_unique` (`erp_programme_id`),
  KEY `programme_nqf_confirmations_nqf_level_id_foreign` (`nqf_level_id`),
  CONSTRAINT `programme_nqf_confirmations_erp_programme_id_foreign` FOREIGN KEY (`erp_programme_id`) REFERENCES `erp_programmes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `programme_nqf_confirmations_nqf_level_id_foreign` FOREIGN KEY (`nqf_level_id`) REFERENCES `nqf_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme_nqf_confirmations`
--

LOCK TABLES `programme_nqf_confirmations` WRITE;
/*!40000 ALTER TABLE `programme_nqf_confirmations` DISABLE KEYS */;
/*!40000 ALTER TABLE `programme_nqf_confirmations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programme_type_nqf_map`
--

DROP TABLE IF EXISTS `programme_type_nqf_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme_type_nqf_map` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `programme_type_code` varchar(32) NOT NULL,
  `nqf_level_id` bigint(20) unsigned NOT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `programme_type_nqf_map_programme_type_code_unique` (`programme_type_code`),
  KEY `programme_type_nqf_map_nqf_level_id_foreign` (`nqf_level_id`),
  CONSTRAINT `programme_type_nqf_map_nqf_level_id_foreign` FOREIGN KEY (`nqf_level_id`) REFERENCES `nqf_levels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme_type_nqf_map`
--

LOCK TABLES `programme_type_nqf_map` WRITE;
/*!40000 ALTER TABLE `programme_type_nqf_map` DISABLE KEYS */;
INSERT INTO `programme_type_nqf_map` VALUES
(3,'certificate',2,143,'2026-07-13 13:35:18','2026-07-13 13:35:18'),
(4,'diploma',2,143,'2026-07-13 13:35:24','2026-07-13 13:35:24'),
(5,'degree',3,143,'2026-07-13 13:35:29','2026-07-13 13:35:29');
/*!40000 ALTER TABLE `programme_type_nqf_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned DEFAULT NULL,
  `type` enum('mcq','multi_select','true_false','short_answer','essay','file_upload') NOT NULL DEFAULT 'mcq',
  `stem` text NOT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `correct_answer` text DEFAULT NULL,
  `explanation` text DEFAULT NULL,
  `marks` decimal(5,2) NOT NULL DEFAULT 1.00,
  `bloom_level` enum('remember','understand','apply','analyse','evaluate','create') DEFAULT NULL,
  `topic_tag` varchar(100) DEFAULT NULL,
  `is_global` tinyint(1) NOT NULL DEFAULT 0,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `questions_erp_course_id_foreign` (`erp_course_id`),
  CONSTRAINT `questions_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `release_rules`
--

DROP TABLE IF EXISTS `release_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `release_rules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_item_id` bigint(20) unsigned NOT NULL,
  `rule_type` enum('date','prerequisite','manual') NOT NULL DEFAULT 'manual',
  `release_at` timestamp NULL DEFAULT NULL,
  `prerequisite_item_id` bigint(20) unsigned DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `release_rules_workspace_item_id_foreign` (`workspace_item_id`),
  KEY `release_rules_prerequisite_item_id_foreign` (`prerequisite_item_id`),
  CONSTRAINT `release_rules_prerequisite_item_id_foreign` FOREIGN KEY (`prerequisite_item_id`) REFERENCES `workspace_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `release_rules_workspace_item_id_foreign` FOREIGN KEY (`workspace_item_id`) REFERENCES `workspace_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `release_rules`
--

LOCK TABLES `release_rules` WRITE;
/*!40000 ALTER TABLE `release_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `release_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_definitions`
--

DROP TABLE IF EXISTS `report_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_definitions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `name` varchar(191) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_definitions_key_unique` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_definitions`
--

LOCK TABLES `report_definitions` WRITE;
/*!40000 ALTER TABLE `report_definitions` DISABLE KEYS */;
INSERT INTO `report_definitions` VALUES
(1,'academic_summary','Academic Summary','academic','Enrolment, completion, and pass-rate summary across courses.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(2,'obe_compliance','OBE Compliance','obe','PLO publication status and NQF descriptor mapping coverage.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(3,'programme_summary','Programme Summary','programme','Delivery and compliance roll-up for a single programme.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(4,'portfolio_compliance','Portfolio Compliance','portfolio','Course portfolio submission and publication compliance.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(5,'teaching_summary','Teaching Summary','teaching','Lecturer workload, grading turnaround, and moderation rate.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(6,'assessment_summary','Assessment Summary','assessment','Assessment submission counts, average marks, and pass rates.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(7,'attendance_summary','Attendance Summary','attendance','Attendance rate per enrolment for a course.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(8,'completion_summary','Completion Summary','completion','Enrolment, completion, and pass counts for a course.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(9,'nqf_compliance','NQF Compliance','nqf_compliance','Programme-type to NQF descriptor mapping coverage gaps.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(10,'dean_summary','Dean\'s Report','dean','Faculty-level roll-up across all departments.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(11,'department_summary','Department Summary','department','Department-level roll-up across all courses.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(12,'lecturer_summary','Lecturer Summary','lecturer','Individual lecturer teaching load and performance.','2026-07-10 07:00:08','2026-07-10 07:00:08'),
(13,'student_summary','Student Summary','student','Individual student completion, marks, and attendance across enrolments.','2026-07-10 07:00:08','2026-07-10 07:00:08');
/*!40000 ALTER TABLE `report_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rubrics`
--

DROP TABLE IF EXISTS `rubrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rubrics` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` bigint(20) unsigned NOT NULL,
  `criterion` varchar(191) NOT NULL,
  `max_marks` decimal(5,2) NOT NULL,
  `levels` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`levels`)),
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rubrics_assessment_id_foreign` (`assessment_id`),
  CONSTRAINT `rubrics_assessment_id_foreign` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rubrics`
--

LOCK TABLES `rubrics` WRITE;
/*!40000 ALTER TABLE `rubrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `rubrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scorm_registrations`
--

DROP TABLE IF EXISTS `scorm_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `scorm_registrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content_item_id` bigint(20) unsigned NOT NULL,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `scorm_version` enum('1.2','2004') NOT NULL DEFAULT '1.2',
  `lesson_status` enum('not attempted','incomplete','completed','passed','failed','browsed') NOT NULL DEFAULT 'not attempted',
  `score_raw` decimal(6,2) DEFAULT NULL,
  `score_min` decimal(6,2) DEFAULT NULL,
  `score_max` decimal(6,2) DEFAULT NULL,
  `suspend_data` longtext DEFAULT NULL,
  `lesson_location` varchar(255) DEFAULT NULL,
  `total_time_seconds` int(10) unsigned NOT NULL DEFAULT 0,
  `last_committed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scorm_registrations_content_item_id_erp_enrolment_id_unique` (`content_item_id`,`erp_enrolment_id`),
  KEY `scorm_registrations_erp_enrolment_id_foreign` (`erp_enrolment_id`),
  CONSTRAINT `scorm_registrations_content_item_id_foreign` FOREIGN KEY (`content_item_id`) REFERENCES `content_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `scorm_registrations_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scorm_registrations`
--

LOCK TABLES `scorm_registrations` WRITE;
/*!40000 ALTER TABLE `scorm_registrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `scorm_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` bigint(20) unsigned NOT NULL,
  `erp_enrolment_id` bigint(20) unsigned NOT NULL,
  `attempt_number` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `status` enum('IN_PROGRESS','SUBMITTED','GRADED','RETURNED') NOT NULL DEFAULT 'IN_PROGRESS',
  `graded_status_override` enum('FORCE_GRADED','FORCE_UNGRADED') DEFAULT NULL,
  `override_reason` text DEFAULT NULL,
  `overridden_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `overridden_at` timestamp NULL DEFAULT NULL,
  `answers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`answers`)),
  `file_path` varchar(500) DEFAULT NULL,
  `turnitin_id` varchar(100) DEFAULT NULL,
  `similarity_score` decimal(5,2) DEFAULT NULL,
  `raw_mark` decimal(6,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `graded_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `graded_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `submissions_assessment_id_erp_enrolment_id_attempt_number_unique` (`assessment_id`,`erp_enrolment_id`,`attempt_number`),
  KEY `submissions_erp_enrolment_id_foreign` (`erp_enrolment_id`),
  CONSTRAINT `submissions_assessment_id_foreign` FOREIGN KEY (`assessment_id`) REFERENCES `assessments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submissions_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

LOCK TABLES `submissions` WRITE;
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suggestions`
--

DROP TABLE IF EXISTS `suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `suggestions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `body` text NOT NULL,
  `submitted_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `contact_email` varchar(191) DEFAULT NULL,
  `status` enum('new','reviewed','actioned','dismissed') NOT NULL DEFAULT 'new',
  `reviewed_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suggestions`
--

LOCK TABLES `suggestions` WRITE;
/*!40000 ALTER TABLE `suggestions` DISABLE KEYS */;
/*!40000 ALTER TABLE `suggestions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_cursors`
--

DROP TABLE IF EXISTS `sync_cursors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sync_cursors` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(64) NOT NULL COMMENT 'e.g. erp_schools',
  `last_synced_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `last_synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sync_cursors_entity_type_unique` (`entity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_cursors`
--

LOCK TABLES `sync_cursors` WRITE;
/*!40000 ALTER TABLE `sync_cursors` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_cursors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sync_events`
--

DROP TABLE IF EXISTS `sync_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sync_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_type` varchar(64) NOT NULL COMMENT 'e.g. ProgrammeCreated',
  `erp_entity_type` varchar(64) NOT NULL COMMENT 'e.g. programme',
  `erp_entity_id` bigint(20) unsigned NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `processed_at` timestamp NULL DEFAULT NULL,
  `error` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sync_events_event_type_processed_at_index` (`event_type`,`processed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sync_events`
--

LOCK TABLES `sync_events` WRITE;
/*!40000 ALTER TABLE `sync_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `sync_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teaching_workspaces`
--

DROP TABLE IF EXISTS `teaching_workspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teaching_workspaces` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_outline_id` bigint(20) unsigned NOT NULL,
  `generated_at` timestamp NULL DEFAULT NULL,
  `last_synced_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `teaching_workspaces_course_outline_id_unique` (`course_outline_id`),
  CONSTRAINT `teaching_workspaces_course_outline_id_foreign` FOREIGN KEY (`course_outline_id`) REFERENCES `course_outlines` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teaching_workspaces`
--

LOCK TABLES `teaching_workspaces` WRITE;
/*!40000 ALTER TABLE `teaching_workspaces` DISABLE KEYS */;
INSERT INTO `teaching_workspaces` VALUES
(1,1,'2026-07-14 08:29:06','2026-07-17 13:22:15','2026-07-14 08:29:06','2026-07-17 13:22:15');
/*!40000 ALTER TABLE `teaching_workspaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_user_id` bigint(20) unsigned NOT NULL COMMENT 'Auth service user ID',
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `roles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Roles array synced from ERP JWT claims' CHECK (json_valid(`roles`)),
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_erp_user_id_unique` (`erp_user_id`),
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
-- Table structure for table `virtual_class_sessions`
--

DROP TABLE IF EXISTS `virtual_class_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `virtual_class_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `erp_course_id` bigint(20) unsigned NOT NULL,
  `workspace_item_id` bigint(20) unsigned DEFAULT NULL,
  `course_delivery_topic_id` bigint(20) unsigned DEFAULT NULL,
  `provider` enum('bbb','zoom','teams','google_meet','opencast') NOT NULL,
  `title` varchar(191) NOT NULL,
  `external_meeting_id` varchar(191) DEFAULT NULL,
  `join_url` varchar(500) DEFAULT NULL,
  `host_url` varchar(500) DEFAULT NULL,
  `starts_at` timestamp NULL DEFAULT NULL,
  `ends_at` timestamp NULL DEFAULT NULL,
  `status` enum('scheduled','live','ended','failed') NOT NULL DEFAULT 'scheduled',
  `failure_reason` text DEFAULT NULL,
  `created_by_erp_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `virtual_class_sessions_erp_course_id_foreign` (`erp_course_id`),
  KEY `virtual_class_sessions_workspace_item_id_foreign` (`workspace_item_id`),
  KEY `virtual_class_sessions_starts_at_index` (`starts_at`),
  KEY `virtual_class_sessions_course_delivery_topic_id_foreign` (`course_delivery_topic_id`),
  CONSTRAINT `virtual_class_sessions_course_delivery_topic_id_foreign` FOREIGN KEY (`course_delivery_topic_id`) REFERENCES `course_delivery_topics` (`id`) ON DELETE SET NULL,
  CONSTRAINT `virtual_class_sessions_erp_course_id_foreign` FOREIGN KEY (`erp_course_id`) REFERENCES `erp_courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `virtual_class_sessions_workspace_item_id_foreign` FOREIGN KEY (`workspace_item_id`) REFERENCES `workspace_items` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_class_sessions`
--

LOCK TABLES `virtual_class_sessions` WRITE;
/*!40000 ALTER TABLE `virtual_class_sessions` DISABLE KEYS */;
INSERT INTO `virtual_class_sessions` VALUES
(1,1,NULL,NULL,'zoom','coming',NULL,NULL,NULL,'2026-07-14 11:01:00','2026-07-14 12:19:00','failed','Integration \'zoom\' is not enabled or is missing required credentials.',144,'2026-07-14 08:19:56','2026-07-14 08:19:56'),
(2,1,NULL,NULL,'bbb','coming',NULL,NULL,NULL,'2026-07-14 11:01:00','2026-07-14 12:19:00','failed','Integration \'bbb\' is not enabled or is missing required credentials.',144,'2026-07-14 08:20:10','2026-07-14 08:20:10'),
(3,1,NULL,NULL,'teams','coming',NULL,NULL,NULL,'2026-07-14 11:01:00','2026-07-14 12:19:00','failed','Integration \'teams\' is not enabled or is missing required credentials.',144,'2026-07-14 08:20:13','2026-07-14 08:20:13'),
(4,1,NULL,NULL,'opencast','coming',NULL,NULL,NULL,'2026-07-14 11:01:00','2026-07-14 12:19:00','failed','Integration \'opencast\' is not enabled or is missing required credentials.',144,'2026-07-14 08:20:17','2026-07-14 08:20:17'),
(5,1,NULL,NULL,'teams','Title',NULL,NULL,NULL,'2026-07-21 13:29:00','2026-07-21 15:29:00','failed','Integration \'teams\' is not enabled or is missing required credentials.',144,'2026-07-20 11:27:26','2026-07-20 11:27:26'),
(6,1,NULL,NULL,'zoom','Title',NULL,NULL,NULL,'2026-07-21 13:29:00','2026-07-21 15:29:00','failed','Integration \'zoom\' is not enabled or is missing required credentials.',144,'2026-07-20 11:27:34','2026-07-20 11:27:34'),
(7,1,NULL,NULL,'opencast','Title',NULL,NULL,NULL,'2026-07-21 13:29:00','2026-07-21 15:29:00','failed','Integration \'opencast\' is not enabled or is missing required credentials.',144,'2026-07-20 11:27:39','2026-07-20 11:27:39');
/*!40000 ALTER TABLE `virtual_class_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workspace_items`
--

DROP TABLE IF EXISTS `workspace_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `workspace_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `teaching_workspace_id` bigint(20) unsigned NOT NULL,
  `outline_week_id` bigint(20) unsigned DEFAULT NULL,
  `week_number` tinyint(3) unsigned NOT NULL,
  `item_type` enum('learning_material','activity','quiz','assignment','discussion','attendance','completion') NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `title` varchar(191) NOT NULL,
  `instructions` text DEFAULT NULL,
  `is_placeholder` tinyint(1) NOT NULL DEFAULT 1,
  `content_item_id` bigint(20) unsigned DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workspace_items_teaching_workspace_id_foreign` (`teaching_workspace_id`),
  KEY `workspace_items_outline_week_id_foreign` (`outline_week_id`),
  KEY `workspace_items_content_item_id_foreign` (`content_item_id`),
  CONSTRAINT `workspace_items_content_item_id_foreign` FOREIGN KEY (`content_item_id`) REFERENCES `content_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `workspace_items_outline_week_id_foreign` FOREIGN KEY (`outline_week_id`) REFERENCES `outline_weeks` (`id`) ON DELETE SET NULL,
  CONSTRAINT `workspace_items_teaching_workspace_id_foreign` FOREIGN KEY (`teaching_workspace_id`) REFERENCES `teaching_workspaces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workspace_items`
--

LOCK TABLES `workspace_items` WRITE;
/*!40000 ALTER TABLE `workspace_items` DISABLE KEYS */;
INSERT INTO `workspace_items` VALUES
(1,1,1,1,'learning_material',0,'Learning Material — Introduction & Environment Setup','Demo instructions for learning material.',0,3,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(2,1,1,1,'activity',1,'Activity — Introduction & Environment Setup','Demo instructions for activity.',0,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(3,1,1,1,'quiz',2,'Quiz — Introduction & Environment Setup','Demo instructions for quiz.',0,NULL,'2026-07-23','2026-07-14 08:29:06','2026-07-14 08:29:06'),
(4,1,1,1,'assignment',3,'Assignment — Introduction & Environment Setup','Demo instructions for assignment.',0,NULL,'2026-07-24','2026-07-14 08:29:06','2026-07-14 08:29:06'),
(5,1,1,1,'discussion',4,'Discussion — Introduction & Environment Setup','Demo instructions for discussion.',0,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(6,1,1,1,'attendance',5,'Attendance — Introduction & Environment Setup','Demo instructions for attendance.',0,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(7,1,1,1,'completion',6,'Completion — Introduction & Environment Setup','Demo instructions for completion.',0,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(8,1,2,2,'learning_material',0,'[Week 2] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(9,1,2,2,'activity',1,'[Week 2] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(10,1,2,2,'quiz',2,'[Week 2] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(11,1,2,2,'assignment',3,'[Week 2] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(12,1,2,2,'discussion',4,'[Week 2] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(13,1,2,2,'attendance',5,'[Week 2] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(14,1,2,2,'completion',6,'[Week 2] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(15,1,3,3,'learning_material',0,'[Week 3] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(16,1,3,3,'activity',1,'[Week 3] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(17,1,3,3,'quiz',2,'[Week 3] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(18,1,3,3,'assignment',3,'[Week 3] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(19,1,3,3,'discussion',4,'[Week 3] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(20,1,3,3,'attendance',5,'[Week 3] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(21,1,3,3,'completion',6,'[Week 3] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(22,1,4,4,'learning_material',0,'[Week 4] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(23,1,4,4,'activity',1,'[Week 4] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(24,1,4,4,'quiz',2,'[Week 4] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(25,1,4,4,'assignment',3,'[Week 4] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(26,1,4,4,'discussion',4,'[Week 4] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(27,1,4,4,'attendance',5,'[Week 4] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(28,1,4,4,'completion',6,'[Week 4] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(29,1,5,5,'learning_material',0,'[Week 5] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(30,1,5,5,'activity',1,'[Week 5] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(31,1,5,5,'quiz',2,'[Week 5] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(32,1,5,5,'assignment',3,'[Week 5] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(33,1,5,5,'discussion',4,'[Week 5] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(34,1,5,5,'attendance',5,'[Week 5] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(35,1,5,5,'completion',6,'[Week 5] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(36,1,6,6,'learning_material',0,'[Week 6] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(37,1,6,6,'activity',1,'[Week 6] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(38,1,6,6,'quiz',2,'[Week 6] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(39,1,6,6,'assignment',3,'[Week 6] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(40,1,6,6,'discussion',4,'[Week 6] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(41,1,6,6,'attendance',5,'[Week 6] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(42,1,6,6,'completion',6,'[Week 6] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(43,1,7,7,'learning_material',0,'[Week 7] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(44,1,7,7,'activity',1,'[Week 7] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(45,1,7,7,'quiz',2,'[Week 7] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(46,1,7,7,'assignment',3,'[Week 7] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(47,1,7,7,'discussion',4,'[Week 7] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(48,1,7,7,'attendance',5,'[Week 7] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(49,1,7,7,'completion',6,'[Week 7] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(50,1,8,8,'learning_material',0,'[Week 8] Learning Material',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(51,1,8,8,'activity',1,'[Week 8] Activity',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(52,1,8,8,'quiz',2,'[Week 8] Quiz',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(53,1,8,8,'assignment',3,'[Week 8] Assignment',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(54,1,8,8,'discussion',4,'[Week 8] Discussion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(55,1,8,8,'attendance',5,'[Week 8] Attendance',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06'),
(56,1,8,8,'completion',6,'[Week 8] Completion',NULL,1,NULL,NULL,'2026-07-14 08:29:06','2026-07-14 08:29:06');
/*!40000 ALTER TABLE `workspace_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xapi_statements`
--

DROP TABLE IF EXISTS `xapi_statements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `xapi_statements` (
  `id` uuid NOT NULL,
  `actor` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`actor`)),
  `verb` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`verb`)),
  `object` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`object`)),
  `result` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`result`)),
  `context` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context`)),
  `statement_timestamp` timestamp NOT NULL,
  `stored_at` timestamp NOT NULL,
  `erp_enrolment_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `xapi_statements_erp_enrolment_id_foreign` (`erp_enrolment_id`),
  KEY `xapi_statements_stored_at_index` (`stored_at`),
  CONSTRAINT `xapi_statements_erp_enrolment_id_foreign` FOREIGN KEY (`erp_enrolment_id`) REFERENCES `erp_enrolments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xapi_statements`
--

LOCK TABLES `xapi_statements` WRITE;
/*!40000 ALTER TABLE `xapi_statements` DISABLE KEYS */;
/*!40000 ALTER TABLE `xapi_statements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'mutupo_elearning'
--

--
-- Dumping routines for database 'mutupo_elearning'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-20 12:16:19
