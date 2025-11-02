-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.29 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for audist
CREATE DATABASE IF NOT EXISTS `audist` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `audist`;

-- Dumping structure for table audist.cases
CREATE TABLE IF NOT EXISTS `cases` (
  `case_number` varchar(45) NOT NULL,
  `referee no` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(45) NOT NULL,
  `organization` varchar(45) NOT NULL,
  `value` varchar(45) NOT NULL,
  `case_date` date NOT NULL,
  `created_at` datetime NOT NULL,
  `image` varchar(255) NOT NULL,
  `nic` varchar(15) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `case_status_id` int NOT NULL,
  PRIMARY KEY (`case_number`),
  KEY `fk_cases_user1_idx` (`user_id`),
  KEY `fk_cases_case_status1_idx` (`case_status_id`),
  CONSTRAINT `fk_cases_case_status1` FOREIGN KEY (`case_status_id`) REFERENCES `case_status` (`id`),
  CONSTRAINT `fk_cases_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.cases: ~0 rows (approximately)
INSERT INTO `cases` (`case_number`, `referee no`, `name`, `organization`, `value`, `case_date`, `created_at`, `image`, `nic`, `user_id`, `case_status_id`) VALUES
	('1234', 'asdf', 'vihanga', 'qb', '500000', '2025-11-02', '2025-11-01 17:33:35', 'asd', '200206702833', 'g1L5lHDVSqa3T4E7IVI90zYjdKJ3', 1),
	('324r3', '12ed2', 'heshan', 'qb', '24000', '2025-11-01', '2025-11-01 17:34:14', '35df', '200206702833', 'g1L5lHDVSqa3T4E7IVI90zYjdKJ3', 1);

-- Dumping structure for table audist.case_information
CREATE TABLE IF NOT EXISTS `case_information` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phase` int NOT NULL,
  `initial_payment` double NOT NULL,
  `settlement_fee` double NOT NULL,
  `next_date` date NOT NULL,
  `withdraw` tinyint NOT NULL,
  `testimony` tinyint NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `case_person_id` int NOT NULL,
  `cases_case_number` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_case_information_case_person1_idx` (`case_person_id`),
  KEY `fk_case_information_cases1_idx` (`cases_case_number`),
  CONSTRAINT `fk_case_information_case_person1` FOREIGN KEY (`case_person_id`) REFERENCES `case_person` (`id`),
  CONSTRAINT `fk_case_information_cases1` FOREIGN KEY (`cases_case_number`) REFERENCES `cases` (`case_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.case_information: ~0 rows (approximately)

-- Dumping structure for table audist.case_person
CREATE TABLE IF NOT EXISTS `case_person` (
  `id` int NOT NULL AUTO_INCREMENT,
  `person_1` int NOT NULL,
  `person_2` int NOT NULL,
  `person_3` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_case_person_case_person_status1_idx` (`person_1`),
  KEY `fk_case_person_case_person_status2_idx` (`person_2`),
  KEY `fk_case_person_case_person_status3_idx` (`person_3`),
  CONSTRAINT `fk_case_person_case_person_status1` FOREIGN KEY (`person_1`) REFERENCES `case_person_status` (`id`),
  CONSTRAINT `fk_case_person_case_person_status2` FOREIGN KEY (`person_2`) REFERENCES `case_person_status` (`id`),
  CONSTRAINT `fk_case_person_case_person_status3` FOREIGN KEY (`person_3`) REFERENCES `case_person_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.case_person: ~0 rows (approximately)

-- Dumping structure for table audist.case_person_status
CREATE TABLE IF NOT EXISTS `case_person_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.case_person_status: ~0 rows (approximately)

-- Dumping structure for table audist.case_status
CREATE TABLE IF NOT EXISTS `case_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` varchar(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.case_status: ~0 rows (approximately)
INSERT INTO `case_status` (`id`, `status`) VALUES
	(1, 'Pending'),
	(2, 'Complete');

-- Dumping structure for table audist.division
CREATE TABLE IF NOT EXISTS `division` (
  `id` int NOT NULL AUTO_INCREMENT,
  `division` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.division: ~0 rows (approximately)
INSERT INTO `division` (`id`, `division`) VALUES
	(1, 'Ruwanwalla');

-- Dumping structure for table audist.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` varchar(255) NOT NULL,
  `name` varchar(45) NOT NULL,
  `division_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_division_idx` (`division_id`),
  CONSTRAINT `fk_user_division` FOREIGN KEY (`division_id`) REFERENCES `division` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table audist.user: ~0 rows (approximately)
INSERT INTO `user` (`id`, `name`, `division_id`) VALUES
	('g1L5lHDVSqa3T4E7IVI90zYjdKJ3', 'Vihanga Heshan', 1),
	('Y2cLmvg3EtRAwCFdywj3y90RtNw2', 'Supun Sulakshana', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
