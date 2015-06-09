CREATE DEFINER=`root`@`localhost` PROCEDURE `round_build`(IN `derby` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
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
#	DROP TEMPORARY TABLE IF EXISTS racherIds;
	DROP TEMPORARY TABLE IF EXISTS racerIds;
#	CREATE TEMPORARY TABLE IF NOT EXISTS racerIds AS (SELECT r.racer_id FROM racers r WHERE r.derby_id = derby AND r.active = 1 ORDER BY r.last_name);
	CREATE TEMPORARY TABLE IF NOT EXISTS racerIds (row_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT) (SELECT r.racer_id FROM racers r WHERE r.derby_id = derby AND r.active = 1 ORDER BY r.last_name);
	SELECT COUNT(*) INTO racer_count FROM racerIds;

	INSERT INTO rounds (derby_id,generator_id) VALUES (derby,round_gen);
	SELECT LAST_INSERT_ID() INTO this_round;
	
	BEGIN
	DECLARE i INT;
	SET i=0;
	segs: LOOP
	cseg: BEGIN
		SET i = i+1;
# i is the lane 1 assignment and increments through racer list
#	for each i assign lane 2..n using offsets from generator
#		handle wrap around when offset+lane1 > racer_count
#	insert heat in heats and heat/lane/racer in scores
		
#		SELECT racer_id FROM racerIds WHERE row_id =i;
		INSERT INTO debug (round_gen,racer_count,lane_count,offsets,round_id,racer_id) VALUES (round_gen,racer_count,lane_count,offsets,this_round,(SELECT racer_id FROM racerIds WHERE row_id =i));
 		
		IF i < racer_count-1 THEN
			ITERATE segs;
		ELSE
			LEAVE segs;
		END IF;
		
	END cseg;
	END LOOP segs;
	END;

#	INSERT INTO debug (round_gen,racer_count,lane_count,offsets,round_id,racer_id) VALUES (round_gen,racer_count,lane_count,offsets,this_round,racer_id);
END