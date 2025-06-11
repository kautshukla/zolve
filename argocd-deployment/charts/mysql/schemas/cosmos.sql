CREATE DATABASE IF NOT EXISTS cosmos;

USE cosmos;



# ************************************************************
# Sequel Ace SQL dump
# Version 20064
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: dsense.cjab8ksmggyx.ap-south-1.rds.amazonaws.com (MySQL 8.0.40)
# Database: cosmos
# Generation Time: 2025-04-11 12:17:54 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table states
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `states` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `request_id` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `state_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table subscription
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `subscription` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `features` text,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table subscription_seq
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `subscription_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table transitions
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `transitions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `request_id` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `event` varchar(255) DEFAULT NULL,
  `source_state` varchar(255) DEFAULT NULL,
  `target_state` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table user_subscription
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_subscription` (
  `id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `status` varchar(255) NOT NULL,
  `subscription_id` bigint NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table user_subscription_seq
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_subscription_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;