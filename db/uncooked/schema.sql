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


-- Dumping structure for table testderby.debug
CREATE TABLE IF NOT EXISTS `debug` (
  `intgr1` int(11) DEFAULT NULL,
  `intgr2` int(11) DEFAULT NULL,
  `intgr3` int(11) DEFAULT NULL,
  `intgr4` int(11) DEFAULT NULL,
  `intgr5` int(11) DEFAULT NULL,
  `string1` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `flot1` float(7,4) DEFAULT NULL,
  `flot2` float(7,4) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.


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
CREATE DEFINER=`root`@`localhost` PROCEDURE `gen_build`(IN `derby` INT, IN `offsets` VARCHAR(12), IN `segment` INT, IN `rsum` INT)
BEGIN
#
# Sample call; CALL gen_build(2,'',1,0);
#
	DECLARE i,v,rc,lc INT;
	SET @@GLOBAL.max_sp_recursion_depth = 255;
	SET @@session.max_sp_recursion_depth = 255;
	SELECT d.number_of_lanes INTO lc FROM derbys AS d WHERE d.derby_id = derby;
	SELECT COUNT(*) INTO rc FROM racers AS r WHERE r.derby_id = derby;
	SET v=lc-1;
#	IF segment < v THEN
		BEGIN
#			DECLARE i INT;
			SET i=0;
			segs: LOOP
			cseg: BEGIN
				SET i = i+1;
				IF NOT FIND_IN_SET(i,offsets) THEN
					IF (((rsum+i) % rc) != 0) THEN
	#	INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,string1) VALUES (i,rc,rsum+i,dump_flag,offsets);
	#					LEAVE segs;
						IF segment < v THEN
							CALL gen_build(derby,CONCAT(offsets,i,','),segment+1,rsum+i);
						ELSE
							INSERT INTO generators (number_of_lanes,number_of_racers,offsets,rank) VALUES (lc,rc,CONCAT(offsets,i),rsum+i);
						END IF;
					END IF;
				END IF;
				IF (i < rc) THEN
					ITERATE segs;
				ELSE
					LEAVE segs;
				END IF;
			END cseg;
			END LOOP segs;
		END;
/*
	ELSE
		BEGIN
			DECLARE j INT;
			SET j=0;
			segend: LOOP
			sgend: BEGIN
				IF dump_flag THEN
					SET dump_flag = 0;
					LEAVE segend;
				END IF;
				SET j = j+1;
				IF NOT FIND_IN_SET(j,offsets) THEN
					IF (((rsum+j) % rc) != 0) THEN
						INSERT INTO generators (number_of_lanes,number_of_racers,offsets,rank) VALUES (lc,rc,CONCAT(offsets,j),rsum+j);
					END IF;
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
*/
END//
DELIMITER ;


-- Dumping structure for function testderby.get_next_generator
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `get_next_generator`(`derby` INT) RETURNS int(11)
    COMMENT 'Gets a random available generator'
BEGIN
# Get stdev of gen ranks
	DECLARE next_gen,lane_count,racer_count,range_gap,range_idx,range_full_low,range_full_high,range_mid_low,range_mid_high INT(11);
	DECLARE rank_avg,rank_stdev FLOAT(7,4);

	SELECT d.number_of_lanes INTO lane_count FROM derbys AS d WHERE d.derby_id=derby;
	SELECT COUNT(*) INTO racer_count FROM racers AS r WHERE r.derby_id = derby;
	
	IF NOT (SELECT COUNT(*) FROM generators AS g WHERE g.number_of_lanes = lane_count AND g.number_of_racers = racer_count) THEN
	 CALL gen_build(derby,'',1,0);
	END IF;
	SELECT AVG(g.rank),STD(g.rank) INTO rank_avg,rank_stdev FROM generators AS g WHERE g.number_of_lanes = lane_count AND g.number_of_racers = racer_count;
	SET range_gap = ROUND(rank_avg-3*rank_stdev);
# force range_idx to not repeat twice in a row?	
	SET range_idx = ROUND(RAND()*rank_stdev);
	
	SET range_full_low = ROUND(rank_avg-((range_idx-1)*range_gap));
	SET range_mid_low = ROUND(rank_avg-(range_idx*range_gap));
	SET range_full_high = ROUND(rank_avg+(range_idx*range_gap));
	SET range_mid_high = ROUND(rank_avg+((range_idx-1)*range_gap));

#	INSERT INTO debug (lane_count,racer_count,range_gap,range_idx,range_full_low,range_full_high,rank_avg,rank_stdev,range_mid_low,range_mid_high) VALUES (lane_count,racer_count,range_gap,range_idx,range_full_low,range_full_high,rank_avg,rank_stdev,range_mid_low,range_mid_high);
	
	SELECT g.generator_id INTO next_gen FROM generators AS g
	 WHERE (g.number_of_lanes = lane_count AND g.number_of_racers = racer_count)
	  AND ((range_full_low < g.rank AND range_mid_low > g.rank) OR (range_mid_high < g.rank AND range_full_high > g.rank))
	  AND g.generator_id NOT IN
	   (SELECT r.generator_id FROM rounds AS r WHERE r.derby_id = derby) 
	ORDER BY RAND() LIMIT 1;

	RETURN next_gen;
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


-- Dumping structure for function testderby.p_extract_offset
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `p_extract_offset`(`offsets` VARCHAR(50), `idx` INT, `idx_max` INT) RETURNS int(11)
BEGIN
	DECLARE vector INT;
	DECLARE L,R VARCHAR(12);
	
	SET vector =
		CASE
			WHEN idx=1 THEN CONVERT(SUBSTRING_INDEX(offsets,',',idx),UNSIGNED INTEGER)
 			WHEN idx=idx_max THEN CONVERT(SUBSTRING_INDEX(offsets,',',-1),UNSIGNED INTEGER)
			ELSE CONVERT(SUBSTRING_INDEX(SUBSTRING_INDEX(offsets,',',idx),',',-1),UNSIGNED INTEGER)
		END;
	RETURN vector;
END//
DELIMITER ;


-- Dumping structure for function testderby.p_idx_wrap
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `p_idx_wrap`(`idx` INT, `off_set` INT, `max_idx` INT) RETURNS int(11)
BEGIN
	RETURN IF((idx+off_set<=max_idx),(idx+off_set),((idx+off_set)%max_idx));
END//
DELIMITER ;


-- Dumping structure for table testderby.racers
CREATE TABLE IF NOT EXISTS `racers` (
  `racer_id` int(11) NOT NULL AUTO_INCREMENT,
  `derby_id` int(11) NOT NULL,
  `first_name` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `car_photo` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `racer_photo` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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


-- Dumping structure for procedure testderby.round_build
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `round_build`(IN `derby` INT)
BEGIN
#
### Get a generator
### Get list of racers
# loop
#	assign racers to lanes using generator offsets
#	insert heat and score objects
# insert round object
# repeat for inverted round
#
	DECLARE round_gen,lane_count,racer_count,this_round INT;
	DECLARE offsets VARCHAR(12);
	SELECT d.number_of_lanes INTO lane_count FROM derbys AS d WHERE d.derby_id=derby;
	
	SET round_gen = get_next_generator(derby);
	SELECT g.offsets INTO offsets FROM generators AS g WHERE g.generator_id = round_gen;
	DROP TEMPORARY TABLE IF EXISTS racerIds;
	CREATE TEMPORARY TABLE IF NOT EXISTS racerIds (row_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT) (SELECT r.racer_id FROM racers r WHERE r.derby_id = derby AND r.active = 1 ORDER BY r.last_name);
	SELECT COUNT(*) INTO racer_count FROM racerIds;

	INSERT INTO rounds (derby_id,generator_id) VALUES (derby,round_gen);
	SELECT LAST_INSERT_ID() INTO this_round;
	
	BEGIN
	DECLARE i INT;
	SET i=0;
	lanes: LOOP
	BEGIN
		DECLARE j INT;
		SET i = i+1;
# i is the lane 1 assignment and increments through racer list
#	for each i assign lane 2..n using offsets from generator
#		handle wrap around when offset+lane1 > racer_count
#	insert heat in heats and heat/lane/racer in scores
		
#		SELECT racer_id FROM racerIds WHERE row_id =i;
		INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,string1)
		 VALUES (racer_count,this_round,j,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,0,racer_count)),offsets);

		SET j=0;
		vectors: LOOP
		BEGIN
			DECLARE v INT;
			SET j=j+1;
			SET v = p_extract_offset(offsets,j,lane_count-1);

		INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,intgr5,string1)
		 VALUES (racer_count,this_round,j,v,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,v,racer_count)),offsets);

			IF j < lane_count-1 THEN
				ITERATE vectors;
			ELSE
				LEAVE vectors;
			END IF;
		END;
		END LOOP vectors;
 		
		IF i < racer_count THEN
			ITERATE lanes;
		ELSE
			LEAVE lanes;
		END IF;
		
	END;
	END LOOP lanes;
	END;

END//
DELIMITER ;


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
