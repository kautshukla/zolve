CREATE DATABASE IF NOT EXISTS apollo;
USE apollo;

# ************************************************************
# Sequel Ace SQL dump
# Version 20064
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: org mysql
# Database: apollo
# Generation Time: 2025-04-11 12:14:47 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE IF NOT EXISTS `api_keys` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `hashed_api_key` varchar(256) NOT NULL,
  `created_by` varchar(255) NOT NULL,
  `last_used` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_api_name` (`user_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `components` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `org` varchar(128) DEFAULT NULL,
  `unique_id` varchar(128) DEFAULT NULL,
  `component` varchar(128) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_2` (`org`,`component`),
  KEY `org` (`org`),
  KEY `unique_id` (`unique_id`),
  KEY `component` (`component`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `org` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_on_subscription` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `org_github_url` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'https://github.com/dview-io/k8-deployment',
  `modified_by` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `personas` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_persona_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `role_permissions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `permission` varchar(256) NOT NULL,
  `role_id` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `description` varchar(256) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permission` (`permission`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE IF NOT EXISTS `roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` enum('Admin','Auditor','User','alpha','beta','gamma') NOT NULL DEFAULT 'alpha',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `description` varchar(256) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_token` varchar(1000) NOT NULL,
  `access_token` varchar(1000) NOT NULL,
  `refresh_token` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `expires_in` varchar(30) NOT NULL,
  `token_type` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `at_expiry_time` mediumtext NOT NULL,
  `rt_expiry_time` mediumtext NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `login_idp` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'EXTERNAL',
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `id_token` (`id_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



CREATE TABLE IF NOT EXISTS `subscription_slots` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `org_name` varchar(128) NOT NULL,
  `requester_email` varchar(256) NOT NULL,
  `meet_scheduled` tinyint(1) DEFAULT '0',
  `meet_completed` tinyint(1) DEFAULT '0',
  `meet_notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`org_name`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `tenant` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int unsigned NOT NULL,
  `name` varchar(256) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `description` varchar(256) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id` (`org_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;




CREATE TABLE IF NOT EXISTS `user_tenants` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tenant_id` int unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `org_id` int unsigned NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`tenant_id`),
  KEY `org_id` (`org_id`),
  KEY `user_tenants_ibfk_4` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE IF NOT EXISTS `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT 'NA',
  `phone` varchar(100) NOT NULL DEFAULT 'NA',
  `designation` varchar(100) NOT NULL DEFAULT 'NA',
  `purpose` varchar(200) NOT NULL DEFAULT 'NA',
  `registered` tinyint(1) NOT NULL DEFAULT '0',
  `blacklisted` tinyint(1) NOT NULL DEFAULT '0',
  `phone_verified` tinyint(1) NOT NULL DEFAULT '0',
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'NA',
  `role_id` int unsigned DEFAULT '2',
  `org_id` int unsigned DEFAULT NULL,
  `on_trial` tinyint DEFAULT '1',
  `dinsights_enabled` tinyint(1) DEFAULT '0',
  `persona_id` int unsigned DEFAULT '1',
  PRIMARY KEY (`email`),
  UNIQUE KEY `UNIQUE_ID` (`id`),
  KEY `fk_user_org` (`org_id`),
  KEY `fk_user_role` (`role_id`),
  KEY `fk_user_persona` (`persona_id`),
  CONSTRAINT `fk_user_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table verification_token
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `verification_token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `token` varchar(100) NOT NULL,
  `method` varchar(50) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `expire_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


INSERT IGNORE INTO `roles` (`id`, `name`, `is_active`, `description`)
VALUES
    (1, 'Admin', 1, 'A role that has all the priveleges for Access modules.'),
    (2, 'Auditor', 1, 'A role that has all the priveleges for Access modules.'),
    (3, 'User', 1, 'A role with basic permissions.');


INSERT IGNORE INTO `personas` (`id`, `name`, `description`)
VALUES
    (1, 'NO_PERSONA', 'No Persona'),
    (2, 'CXO', 'The CXO is focused on high-level strategic insights and decision-making, impactful answers to support business goals.'),
    (3, 'BUSINESS_TEAM', 'The Business Team looks for insights to drive operations and growth. They want actionable data and clear trends.'),
    (4, 'PRODUCT_TEAM', 'The Product Team needs insights about user behavior, product performance, and market trends. Their questions are centered on improving product offerings.'),
    (5, 'ENGINEERING_TEAM', 'The Engineer Team focuses on technical details and operational efficiency. They seek precise data to optimize processes. Coolest'),
    (6, 'DATA_SCIENCE_TEAM', 'The Data Science Team is detail-oriented and interested in data models, patterns, and predictions. They require nuanced insights.'),
    (7, 'SALES_TEAM', 'The Sales Team is interested in customer trends, conversion rates, and pipeline insights. Their questions aim to improve sales performance.'),
    (8, 'MARKETING_TEAM', 'The Marketing Team seeks insights about customer engagement, campaign effectiveness, and ROI. They focus on reaching the right audience.'),
    (9, 'FINANCE_TEAM', 'The Finance Team focuses on budgets, forecasts, and financial health. They seek clarity on revenue, costs, and profitability.'),
    (10, 'SALES', 'The Sales Team is interested in customer trends, conversion rates, and pipeline insights. Their questions aim to improve sales performance.');



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;