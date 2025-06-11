CREATE DATABASE IF NOT EXISTS artemis;
USE artemis;


# ************************************************************
# Sequel Ace SQL dump
# Version 20064
#
# https://sequel-ace.com/
# https://github.com/Sequel-Ace/Sequel-Ace
#
# Host: host (MySQL 8.0.40)
# Database: artemis
# Generation Time: 2025-04-11 12:17:18 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table action_type
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `action_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_type` varchar(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `action_type_UNIQUE` (`action_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table audit
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `audit` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'dataplatform',
  `pipeline_id` bigint DEFAULT '0',
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table catalog
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `catalog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `catalog_name` enum('BigQuery','Black Hole','Cassandra','ClickHouse','Delta Lake','Druid','Elasticsearch','Exasol','Faker','Google Sheets','Hive','Hudi','Iceberg','Ignite','JMX','Kafka','Kinesis','Kudu','MariaDB','Memory','MongoDB','MySQL','OpenSearch','Oracle','Phoenix','Pinot','PostgreSQL','Prometheus','Redis','Redshift','SingleStore','Snowflake','SQL Server','System','Thrift','TPC-DS','TPC-H','Vertica') NOT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `config` json NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `catalog_name` (`catalog_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table catalog_instance
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `catalog_instance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `catalog_id` int NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `name` varchar(100) NOT NULL,
  `config` json NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_catalog_instance_catalog_id_name` (`catalog_id`,`name`),
  CONSTRAINT `catalog_instance_ibfk_1` FOREIGN KEY (`catalog_id`) REFERENCES `catalog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table env_component
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `env_component` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `env_id` int DEFAULT NULL,
  `org_id` int unsigned NOT NULL,
  `source_id` int unsigned NOT NULL,
  `component_details` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table environment
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `environment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `env_name` varchar(128) DEFAULT NULL,
  `org_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table object
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `object` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int NOT NULL,
  `tenant_id` int NOT NULL,
  `namespace` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `object_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `org_id_2` (`org_id`,`tenant_id`,`namespace`,`object_name`),
  KEY `org_id` (`org_id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `namespace` (`namespace`),
  KEY `object_name` (`object_name`),
  KEY `is_active` (`is_active`),
  KEY `created_at` (`created_at`),
  KEY `modified_at` (`modified_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table pipeline
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pipeline` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int unsigned NOT NULL,
  `pipeline_name` varchar(128) DEFAULT NULL,
  `pipeline_id` bigint DEFAULT NULL,
  `sla` int DEFAULT NULL COMMENT 'Minutes',
  `objective` varchar(128) DEFAULT NULL,
  `tenant` varchar(128) DEFAULT NULL,
  `tenant_id` int unsigned DEFAULT NULL,
  `tag` varchar(128) DEFAULT NULL,
  `pipeline_type` varchar(128) DEFAULT NULL,
  `source_details_id` int unsigned DEFAULT NULL,
  `source_information` text,
  `schema_ids` text,
  `topics` text,
  `environment` varchar(128) DEFAULT NULL,
  `argo_details` text,
  `status` varchar(128) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '0',
  `is_deleted` tinyint DEFAULT '0',
  `dqaas_enabled` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_health` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table schema
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `schema` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int NOT NULL,
  `vertical_id` int NOT NULL,
  `schema_version` int NOT NULL DEFAULT '0',
  `columns` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `primary_key` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `source_db` varchar(45) NOT NULL,
  `schema_type` varchar(45) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_by` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` text,
  `namespace_description` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `dpt_partition_column` varchar(128) DEFAULT NULL,
  `dpt_merge_column` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `dpt_data_version` int NOT NULL DEFAULT '5',
  `dpt_date_format` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `object_id` (`object_id`),
  KEY `is_active` (`is_active`),
  KEY `created_at` (`created_at`),
  KEY `modified_at` (`modified_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;



# Dump of table schema_type
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `schema_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `schema_type` varchar(45) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `schema_type_UNIQUE` (`schema_type`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table source
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `source` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `source_name` varchar(128) DEFAULT NULL,
  `source_type` varchar(128) DEFAULT NULL,
  `environment` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table source_details
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `source_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `source_id` int unsigned NOT NULL,
  `connection_details` text,
  `pipeline_id` varchar(256) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni` (`source_id`,`pipeline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



# Dump of table vertical
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `vertical` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(15) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_unique` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT IGNORE INTO `environment` (`id`, `env_name`, `org_id`, `is_active`)
VALUES
    (1, 'prod', 1, 1);

INSERT IGNORE INTO `schema_type` (`id`, `schema_type`)
VALUES
    (1, 'EVENT'),
    (2, 'ENTITY'),
    (3, 'FACT'),
    (4, 'ALL');

INSERT IGNORE INTO `source` (`id`, `source_name`, `source_type`, `environment`, `is_active`)
VALUES
    (18, 'SEGMENT', 'SEGMENT', 'prod', 1),
    (12, 'SCYLLA', 'NOSQL', 'prod', 1),
    (5, 'S3', 'S3', 'prod', 1),
    (6, 'POSTGRES', 'RDBMS', 'prod', 1),
    (13, 'ORACLE', 'RDBMS', 'prod', 1),
    (19, 'MYSQL_RDS', 'RDBMS', 'prod', 1),
    (21, 'MYSQL_AURORA', 'RDBMS', 'prod', 0),
    (1, 'MYSQL', 'RDBMS', 'prod', 1),
    (14, 'MSSQL', 'RDBMS', 'prod', 1),
    (8, 'MONGO', 'NOSQL', 'prod', 1),
    (3, 'KAFKA', 'KAFKA', 'prod', 0),
    (10, 'GOOGLE_SHEET', 'GOOGLE_SHEET', 'prod', 1),
    (9, 'GCS', 'GCS', 'prod', 1),
    (11, 'BIGQUERY', 'BIGQUERY', 'prod', 1);


INSERT IGNORE INTO `vertical` (`id`, `type`)
VALUES
    (1, 'ALL');


INSERT IGNORE INTO `action_type` (`id`, `action_type`)
VALUES
    (1, 'NOOP'),
    (2, 'SNAPSHOT'),
    (3, 'JOURNAL'),
    (4, 'SNAPSHOT_AND_JOURNAL');


INSERT IGNORE INTO `catalog` (`id`, `catalog_name`, `description`, `is_active`, `config`)
VALUES
	(1, 'MySQL', 'MySQL connector properties for trino', 1, '[{\"id\": \"connection-url\", \"name\": \"MySQL Connection URL\", \"regex\": \"^jdbc:mysql://([\\\\w.-]+)(:\\\\d+)?(/([\\\\w_-]+)?)?(?:\\\\?([\\\\w%&=.-]+))?$\", \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}, {\"id\": \"connection-user\", \"name\": \"MySQL User\", \"regex\": null, \"value\": null, \"secret\": false, \"datatype\": \"string\", \"required\": true}, {\"id\": \"connection-password\", \"name\": \"MySQL Password\", \"regex\": null, \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}]'),
	(2, 'PostgreSQL', 'PostgreSQL connector properties for trino', 1, '[{\"id\": \"connection-url\", \"name\": \"PostgreSQL Connection URL\", \"regex\": \"^jdbc:postgresql://([\\\\w.-]+)(:\\\\d+)?(/([\\\\w_-]+)?)?(?:\\\\?([\\\\w%&=.-]+))?$\", \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}, {\"id\": \"connection-user\", \"name\": \"PostgreSQL User\", \"regex\": null, \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}, {\"id\": \"connection-password\", \"name\": \"PostgreSQL Password\", \"regex\": null, \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}]'),
	(3, 'MongoDB', 'MongoDB connector properties for trino', 1, '[{\"id\": \"mongodb.connection-url\", \"name\": \"MongoDB Connection URL\", \"regex\": \"^mongodb(?:\\\\+srv)?://(?:([^:]*):([^@]*)@)?([^/?]*)(?:/([^?]+))?(?:\\\\?(.+))?$\", \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}]'),
	(4, 'Kafka', 'Kafka connector properties for trino', 1, '[{\"id\": \"kafka.nodes\", \"name\": \"Kafka Nodes\", \"regex\": null, \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}, {\"id\": \"kafka.table-names\", \"name\": \"Kafka Table Names\", \"regex\": null, \"value\": null, \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"kafka.config.resources\", \"name\": \"Kafka Config Resources\", \"regex\": null, \"value\": \"/etc/kafka-configuration.properties\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"kafka.hide-internal-columns\", \"name\": \"Kafka Hide Internal Columns\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"kafka.table-description-dir\", \"name\": \"Kafka Table Description Directory\", \"regex\": null, \"value\": \"/mnt/data/repo/schemas/repo/schemas\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"kafka.table-description-supplier\", \"name\": \"Kafka Table Description Supplier\", \"regex\": null, \"value\": \"FILE\", \"secret\": false, \"datatype\": \"string\", \"required\": false}]'),
	(5, 'Hive', 'Hive connector properties for trino', 1, '[{\"id\": \"hive.metastore.uri\", \"name\": \"Hive Metastore URI\", \"regex\": null, \"value\": null, \"secret\": false, \"datatype\": \"string\", \"required\": true}, {\"id\": \"hive.metastore-cache-ttl\", \"name\": \"Hive Metastore Cache TTL\", \"regex\": null, \"value\": \"20m\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"hive.metastore-refresh-interval\", \"name\": \"Hive Metastore Refresh Interval\", \"regex\": null, \"value\": \"10m\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"hive.metastore.thrift.client.connect-timeout\", \"name\": \"Hive Metastore Thrift Client Connect Timeout\", \"regex\": null, \"value\": \"30m\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"hive.metastore.thrift.client.read-timeout\", \"name\": \"Hive Metastore Thrift Client Read Timeout\", \"regex\": null, \"value\": \"30m\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"hive.orc.use-column-names\", \"name\": \"Hive ORC Use Column Names\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.parquet.use-column-names\", \"name\": \"Hive Parquet Use Column Names\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.non-managed-table-writes-enabled\", \"name\": \"Hive Non-Managed Table Writes Enabled\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.non-managed-table-creates-enabled\", \"name\": \"Hive Non-Managed Table Creates Enabled\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.recursive-directories\", \"name\": \"Hive Recursive Directories\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.ignore-absent-partitions\", \"name\": \"Hive Ignore Absent Partitions\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.metastore.thrift.delete-files-on-drop\", \"name\": \"Hive Metastore Thrift Delete Files on Drop\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.compression-codec\", \"name\": \"Hive Compression Codec\", \"regex\": null, \"value\": \"ZSTD\", \"secret\": false, \"datatype\": \"string\", \"required\": false}, {\"id\": \"hive.s3.streaming.enabled\", \"name\": \"Hive S3 Streaming Enabled\", \"regex\": null, \"value\": \"true\", \"secret\": false, \"datatype\": \"boolean\", \"required\": false}, {\"id\": \"hive.s3.aws-access-key\", \"name\": \"Hive S3 AWS Access Key\", \"regex\": null, \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}, {\"id\": \"hive.s3.aws-secret-key\", \"name\": \"Hive S3 AWS Secret Key\", \"regex\": null, \"value\": null, \"secret\": true, \"datatype\": \"string\", \"required\": true}, {\"id\": \"hive.s3.region\", \"name\": \"Hive S3 Region\", \"regex\": null, \"value\": null, \"secret\": false, \"datatype\": \"string\", \"required\": false}]');


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;