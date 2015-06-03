-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               5.1.73-1 - (Debian)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.2.0.4961
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for testderby
CREATE DATABASE IF NOT EXISTS `testderby` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `testderby`;


-- Dumping structure for table testderby.derbys
CREATE TABLE IF NOT EXISTS `derbys` (
  `derby_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `unique_id` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `number_of_lanes` int(11) NOT NULL,
  `racer_list` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raceoff_id` int(11) DEFAULT NULL,
  `status` enum('P','R','D') COLLATE utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `last_modified_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`derby_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.generators
CREATE TABLE IF NOT EXISTS `generators` (
  `generator_id` int(11) NOT NULL AUTO_INCREMENT,
  `number_of_lanes` int(11) NOT NULL,
  `number_of_racers` int(11) NOT NULL,
  `offsets` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `rank` int(11) NOT NULL,
  PRIMARY KEY (`generator_id`),
  KEY `lanes_to_racers` (`number_of_lanes`,`number_of_racers`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for procedure testderby.gen_build
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `gen_build`(IN `lc` INT, IN `rc` INT, IN `offsets` VARCHAR(12), IN `segment` INT, IN `rsum` INT)
BEGIN
	DECLARE v INT;
	SET @@GLOBAL.max_sp_recursion_depth = 255;
	SET @@session.max_sp_recursion_depth = 255;
	SET v=lc-1;
	IF segment < v THEN
		BEGIN
			DECLARE i INT;
			SET i=0;
			segs: LOOP
			cseg: BEGIN
				SET i = i+1;
				IF NOT FIND_IN_SET(i,offsets) THEN
					CALL gen_build(lc,rc,CONCAT(offsets,i,','),segment+1,rsum+i);
				END IF;
				IF i < rc THEN
					ITERATE segs;
				ELSE
					LEAVE segs;
				END IF;
			END cseg;
			END LOOP segs;
		END;
	ELSE
		BEGIN
			DECLARE j INT;
			SET j=0;
			segend: LOOP
			sgend: BEGIN
				SET j = j+1;
				IF NOT FIND_IN_SET(j,offsets) THEN
					INSERT INTO generators (number_of_lanes,number_of_racers,offsets,rank) VALUES (lc,rc,CONCAT(offsets,j),rsum+j);
				END IF;
				IF j < rc THEN
					ITERATE segend;
				ELSE
					LEAVE segend;
				END IF;
			END sgend;
			END LOOP segend;
		END;
	END IF;
END//
DELIMITER ;


-- Dumping structure for function testderby.get_next_generator
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `get_next_generator`(`d_id` INT, `lane_cnt` INT) RETURNS int(11)
    COMMENT 'Gets a random available generator'
BEGIN
DECLARE gen INT;
SET @gen = 0;
SELECT g.generator_id INTO @gen FROM generators AS g WHERE g.number_of_lanes=@lane_cnt AND g.generator_id NOT IN
 (SELECT r.generator_id FROM rounds AS r WHERE r.derby_id = @d_id)
  ORDER BY RAND() LIMIT 1;
RETURN @gen;
END//
DELIMITER ;


-- Dumping structure for table testderby.heats
CREATE TABLE IF NOT EXISTS `heats` (
  `heat_id` int(11) NOT NULL AUTO_INCREMENT,
  `round_id` int(11) NOT NULL,
  PRIMARY KEY (`heat_id`),
  KEY `round_id` (`round_id`),
  CONSTRAINT `heats_ibfk_1` FOREIGN KEY (`round_id`) REFERENCES `rounds` (`round_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.heat_racers
CREATE TABLE IF NOT EXISTS `heat_racers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `heat_id` int(11) NOT NULL,
  `racer_id` int(11) NOT NULL,
  `lane` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.login_attempts
CREATE TABLE IF NOT EXISTS `login_attempts` (
  `user_id` int(11) NOT NULL,
  `time` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.racers
CREATE TABLE IF NOT EXISTS `racers` (
  `racer_id` int(11) NOT NULL AUTO_INCREMENT,
  `derby_id` int(11) NOT NULL,
  `first_name` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `car_photo` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `racer_photo` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  `last_modified_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`racer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.rounds
CREATE TABLE IF NOT EXISTS `rounds` (
  `round_id` int(11) NOT NULL AUTO_INCREMENT,
  `derby_id` int(11) NOT NULL,
  `generator_id` int(11) NOT NULL,
  PRIMARY KEY (`round_id`),
  UNIQUE KEY `generator_id` (`generator_id`),
  CONSTRAINT `rounds_ibfk_2` FOREIGN KEY (`generator_id`) REFERENCES `generators` (`generator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.scores
CREATE TABLE IF NOT EXISTS `scores` (
  `score_id` int(11) NOT NULL AUTO_INCREMENT,
  `heat_id` int(11) NOT NULL,
  `racer_id` int(11) NOT NULL,
  `lane` int(11) NOT NULL,
  `place` int(11) NOT NULL,
  `last_modified_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`score_id`),
  KEY `heat_id` (`heat_id`),
  KEY `racer_id` (`racer_id`),
  CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`heat_id`) REFERENCES `heats` (`heat_id`) ON UPDATE NO ACTION,
  CONSTRAINT `scores_ibfk_2` FOREIGN KEY (`racer_id`) REFERENCES `racers` (`racer_id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


-- Dumping structure for table testderby.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` char(128) NOT NULL,
  `salt` char(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
