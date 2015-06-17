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
### insert round object
### loop
###	assign racers to lanes using generator offsets
###	insert heat and score objects
# repeat for inverted round
#
	DECLARE round_gen,lane_count,racer_count,this_round,this_heat INT;
	DECLARE offsets VARCHAR(12);
	SELECT d.number_of_lanes INTO lane_count FROM derbys AS d WHERE d.derby_id=derby;
	
	SET round_gen = get_next_generator(derby);
	SELECT g.offsets INTO offsets FROM generators AS g WHERE g.generator_id = round_gen;
	DROP TEMPORARY TABLE IF EXISTS racerIds;
	CREATE TEMPORARY TABLE IF NOT EXISTS racerIds (row_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT) (SELECT r.racer_id,r.last_name FROM racers r WHERE r.derby_id = derby AND r.active = 1 ORDER BY r.last_name ASC);
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
		
		INSERT INTO heats (round_id) VALUES (this_round);
		SELECT LAST_INSERT_ID() INTO this_heat;
		
		INSERT INTO scores (heat_id,racer_id,lane) VALUES (this_heat,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,0,racer_count)),1);
		
#		INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,string1)
#		 VALUES (racer_count,this_round,j,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,0,racer_count)),offsets);

		SET j=0;
		vectors: LOOP
		BEGIN
			DECLARE v INT;
			SET j=j+1;
			SET v = p_extract_offset(offsets,j,lane_count-1);

			INSERT INTO scores (heat_id,racer_id,lane) VALUES (this_heat,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,v,racer_count)),j+1);
			
#		INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,intgr5,string1)
#		 VALUES (racer_count,this_round,j,v,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,v,racer_count)),offsets);

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
# inverted
#ALTER
	DROP TEMPORARY TABLE IF EXISTS invRacerIds;
	CREATE TEMPORARY TABLE IF NOT EXISTS invRacerIds (row_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT) (SELECT r.racer_id FROM racers r WHERE r.derby_id = derby AND r.active = 1 ORDER BY r.last_name DESC);
#del	SELECT COUNT(*) INTO racer_count FROM racerIds;

	INSERT INTO rounds (derby_id,generator_id) VALUES (derby,0-round_gen);
	SELECT LAST_INSERT_ID() INTO this_round;
	
	BEGIN
	DECLARE i INT;
	SET i=0;
	lanes: LOOP
	BEGIN
		DECLARE j INT;
		SET i = i+1;
		
		INSERT INTO heats (round_id) VALUES (this_round);
		SELECT LAST_INSERT_ID() INTO this_heat;
		
		INSERT INTO scores (heat_id,racer_id,lane) VALUES (this_heat,(SELECT racer_id FROM invRacerIds WHERE row_id = p_idx_wrap(i,0,racer_count)),1);
		
#		INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,string1)
#		 VALUES (racer_count,this_round,j,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,0,racer_count)),offsets);

		SET j=0;
		vectors: LOOP
		BEGIN
			DECLARE v INT;
			SET j=j+1;
			SET v = p_extract_offset(offsets,j,lane_count-1);

			INSERT INTO scores (heat_id,racer_id,lane) VALUES (this_heat,(SELECT racer_id FROM invRacerIds WHERE row_id = p_idx_wrap(i,v,racer_count)),j+1);
			
#		INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,intgr5,string1)
#		 VALUES (racer_count,this_round,j,v,(SELECT racer_id FROM racerIds WHERE row_id = p_idx_wrap(i,v,racer_count)),offsets);

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

END