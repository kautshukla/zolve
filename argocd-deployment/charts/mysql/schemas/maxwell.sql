CREATE DATABASE IF NOT EXISTS maxwell;

USE maxwell;


# ************************************************************
# Sequel Ace SQL dump
# Version 20064
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: dsense.cjab8ksmggyx.ap-south-1.rds.amazonaws.com (MySQL 8.0.40)
# Database: maxwell
# Generation Time: 2025-04-11 12:21:16 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bootstrap
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `bootstrap` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `database_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `table_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `where_clause` text,
  `is_complete` tinyint unsigned NOT NULL DEFAULT '0',
  `inserted_rows` bigint unsigned NOT NULL DEFAULT '0',
  `total_rows` bigint unsigned NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `binlog_file` varchar(255) DEFAULT NULL,
  `binlog_position` int unsigned DEFAULT '0',
  `client_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'maxwell',
  `comment` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table columns
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `columns` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `schema_id` bigint DEFAULT NULL,
  `table_id` bigint DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `charset` varchar(255) DEFAULT NULL,
  `coltype` varchar(255) DEFAULT NULL,
  `is_signed` tinyint unsigned DEFAULT NULL,
  `enum_values` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `column_length` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schema_id` (`schema_id`),
  KEY `table_id` (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table databases
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `databases` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `schema_id` bigint DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `charset` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schema_id` (`schema_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table heartbeats
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `heartbeats` (
  `server_id` int unsigned NOT NULL,
  `client_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'maxwell',
  `heartbeat` bigint NOT NULL,
  PRIMARY KEY (`server_id`,`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table positions
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `positions` (
  `server_id` int unsigned NOT NULL,
  `binlog_file` varchar(255) DEFAULT NULL,
  `binlog_position` int unsigned DEFAULT NULL,
  `gtid_set` varchar(4096) DEFAULT NULL,
  `client_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'maxwell',
  `heartbeat_at` bigint DEFAULT NULL,
  `last_heartbeat_read` bigint DEFAULT NULL,
  PRIMARY KEY (`server_id`,`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table schemas
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `schemas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `binlog_file` varchar(255) DEFAULT NULL,
  `binlog_position` int unsigned DEFAULT NULL,
  `last_heartbeat_read` bigint DEFAULT '0',
  `gtid_set` varchar(4096) DEFAULT NULL,
  `base_schema_id` bigint DEFAULT NULL,
  `deltas` mediumtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `server_id` int unsigned DEFAULT NULL,
  `position_sha` char(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `charset` varchar(255) DEFAULT NULL,
  `version` smallint unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `position_sha` (`position_sha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table tables
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `tables` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `schema_id` bigint DEFAULT NULL,
  `database_id` bigint DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `charset` varchar(255) DEFAULT NULL,
  `pk` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schema_id` (`schema_id`),
  KEY `database_id` (`database_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;