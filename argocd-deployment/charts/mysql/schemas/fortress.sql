CREATE DATABASE IF NOT EXISTS fortress;

USE fortress;


# ************************************************************
# Sequel Ace SQL dump
# Version 20064
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: dsense.cjab8ksmggyx.ap-south-1.rds.amazonaws.com (MySQL 8.0.40)
# Database: fortress
# Generation Time: 2025-04-11 12:20:14 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table attribute
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `attribute` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_schema_id` int DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `attribute_type` varchar(40) DEFAULT NULL,
  `is_primary` tinyint DEFAULT '0',
  `default_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `ordinal_position` int DEFAULT NULL,
  `is_partition_key` tinyint(1) DEFAULT '0',
  `is_required` tinyint(1) DEFAULT '0',
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_schema_id` (`entity_schema_id`),
  KEY `attribute_type` (`attribute_type`),
  CONSTRAINT `attribute_ibfk_1` FOREIGN KEY (`entity_schema_id`) REFERENCES `entity_schema` (`id`) ON DELETE CASCADE,
  CONSTRAINT `attribute_ibfk_2` FOREIGN KEY (`attribute_type`) REFERENCES `attribute_type` (`datatype`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table attribute_type
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `attribute_type` (
  `datatype` varchar(40) NOT NULL,
  `metadata` json DEFAULT NULL,
  `default_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`datatype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table catalog
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `catalog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `namespace_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `namespace_id` (`namespace_id`),
  CONSTRAINT `catalog_ibfk_1` FOREIGN KEY (`namespace_id`) REFERENCES `namespace` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table cloud_provider
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `cloud_provider` (
  `name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `slib` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `permissions` json DEFAULT NULL,
  `region` varchar(40) DEFAULT NULL,
  `configs` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table document
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_id` int DEFAULT NULL,
  `segment_id` int DEFAULT NULL,
  `path` text,
  `file_name` text,
  `from_time` timestamp NULL DEFAULT NULL,
  `to_time` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partition_id` (`segment_id`),
  KEY `entity_id` (`entity_id`),
  CONSTRAINT `document_ibfk_1` FOREIGN KEY (`segment_id`) REFERENCES `segment` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_ibfk_2` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table entity
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `entity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `catalog_id` int DEFAULT NULL,
  `base_path` text,
  `is_hour_partitioned` tinyint(1) DEFAULT NULL,
  `description` text,
  `file_retain_count` smallint DEFAULT NULL,
  `storage_format` varchar(255) DEFAULT NULL,
  `cloud_provider` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `identity_keys` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `storage_format` (`storage_format`),
  KEY `cloud_provider` (`cloud_provider`),
  CONSTRAINT `entity_ibfk_2` FOREIGN KEY (`storage_format`) REFERENCES `storage_format` (`format`) ON DELETE CASCADE,
  CONSTRAINT `entity_ibfk_3` FOREIGN KEY (`cloud_provider`) REFERENCES `cloud_provider` (`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table entity_schema
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `entity_schema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_id` int DEFAULT NULL,
  `previous_schema` int DEFAULT NULL,
  `schema_version` int DEFAULT NULL,
  `is_latest` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_id` (`entity_id`),
  CONSTRAINT `entity_schema_ibfk_1` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table namespace
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `namespace` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `tenant_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name_tenant` (`name`,`tenant_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `namespace_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table segment
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `segment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entity_id` int DEFAULT NULL,
  `entity_schema_id` int DEFAULT NULL,
  `path` text,
  `date_value` date DEFAULT NULL,
  `time_value` time DEFAULT NULL,
  `date_time` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entity_schema_id` (`entity_schema_id`),
  KEY `entity_id` (`entity_id`),
  CONSTRAINT `segment_ibfk_1` FOREIGN KEY (`entity_schema_id`) REFERENCES `entity_schema` (`id`) ON DELETE CASCADE,
  CONSTRAINT `segment_ibfk_2` FOREIGN KEY (`entity_id`) REFERENCES `entity` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table storage_format
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `storage_format` (
  `format` varchar(255) NOT NULL,
  `slib` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `metadata` json DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table tenant
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tenant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `org` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;