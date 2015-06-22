CREATE DEFINER=`root`@`localhost` FUNCTION `p_get_next_generator`(`derby` INT)
	RETURNS int(11)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT 'Gets a random available generator'
BEGIN
# Get stdev of gen ranks
	DECLARE next_gen,lane_count,racer_count,range_full_low,range_full_high,range_mid_low,range_mid_high INT(11);
	DECLARE rank_avg,range_gap,range_idx,rank_stdev FLOAT(7,4);

	SELECT d.number_of_lanes INTO lane_count FROM derbys AS d WHERE d.derby_id=derby;
	SELECT COUNT(*) INTO racer_count FROM racers AS r WHERE r.derby_id = derby;
	
	IF NOT (SELECT COUNT(*) FROM generators AS g WHERE g.number_of_lanes = lane_count AND g.number_of_racers = racer_count) THEN
	 CALL p_gen_build(derby,'',1,0);
	END IF;
	SELECT AVG(g.rank),STD(g.rank) INTO rank_avg,rank_stdev FROM generators AS g WHERE g.number_of_lanes = lane_count AND g.number_of_racers = racer_count;
# round only on the last step to get the range bounderies
#	SET range_gap = ROUND(rank_avg-3*rank_stdev);
	SET range_gap = rank_avg-3*rank_stdev;
# force range_idx to not repeat twice in a row?	
#	SET range_idx = ROUND(RAND()*rank_stdev);
	SET range_idx = RAND()*rank_stdev;
	
	SET range_full_low = ROUND(rank_avg-ABS((range_idx-1)*range_gap));
	SET range_mid_low = ROUND(rank_avg-ABS(range_idx*range_gap));
	SET range_full_high = ROUND(rank_avg+ABS(range_idx*range_gap));
	SET range_mid_high = ROUND(rank_avg+ABS((range_idx-1)*range_gap));

#	INSERT INTO debug (lane_count,racer_count,range_gap,range_idx,range_full_low,range_full_high,rank_avg,rank_stdev,range_mid_low,range_mid_high) VALUES (lane_count,racer_count,range_gap,range_idx,range_full_low,range_full_high,rank_avg,rank_stdev,range_mid_low,range_mid_high);
	
	SELECT g.generator_id INTO next_gen FROM generators AS g
	 WHERE (g.number_of_lanes = lane_count AND g.number_of_racers = racer_count)
	  AND ((range_full_low < g.rank AND range_mid_low > g.rank) OR (range_mid_high < g.rank AND range_full_high > g.rank))
	  AND g.generator_id NOT IN
	   (SELECT r.generator_id FROM rounds AS r WHERE r.derby_id = derby) 
	ORDER BY RAND() LIMIT 1;

	RETURN next_gen;
END