CREATE DEFINER=`root`@`localhost` PROCEDURE `round_build`(IN `derby` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
#
### Get a generator
# Get list of racers
# loop
#	assign racers to lanes using generator offsets
#	insert heat and score objects
# insert round object
# repeat for inverted round
#
	DECLARE round_gen,lane_count,racer_count INT;
	SELECT d.number_of_lanes INTO lane_count FROM derbys AS d WHERE d.derby_id=derby;
	
	SET round_gen = get_next_generator(derby);
	CREATE TEMPORARY TABLE IF NOT EXISTS testderby.racherIds AS (SELECT r.racer_id FROM racers r WHERE r.derby_id = derby AND r.active = 1 ORDER BY r.last_name);
	SELECT COUNT(*) INTO racer_count FROM testderby.racherIds;
# insert round in rounds

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
		
		IF NOT FIND_IN_SET(i,offsets) THEN
			CALL gen_build(derby,CONCAT(offsets,i,','),segment+1,rsum+i);
		END IF;
		
		IF i < rc THEN
			ITERATE segs;
		ELSE
			LEAVE segs;
		END IF;
		
	END cseg;
	END LOOP segs;
	END;

	INSERT INTO debug (round_gen,racer_count,lane_count) VALUES (round_gen,racer_count,lane_count);
END