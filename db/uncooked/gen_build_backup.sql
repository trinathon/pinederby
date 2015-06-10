CREATE DEFINER=`root`@`localhost` PROCEDURE `gen_build`(IN `derby` INT, IN `offsets` VARCHAR(12), IN `segment` INT, IN `rsum` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
#
# Sample call; CALL gen_build(2,'',1,0);
#
	DECLARE v,dump_flag INT;
	DECLARE rc,lc INT;
	SET dump_flag = 0;
	SET @@GLOBAL.max_sp_recursion_depth = 255;
	SET @@session.max_sp_recursion_depth = 255;
	SELECT d.number_of_lanes INTO lc FROM derbys AS d WHERE d.derby_id = derby;
	SELECT COUNT(*) INTO rc FROM racers AS r WHERE r.derby_id = derby;
	SET v=lc-1;
	IF segment < v THEN
		BEGIN
			DECLARE i INT;
			SET i=0;
			segs: LOOP
			cseg: BEGIN
				SET i = i+1;
				IF (((rsum+i) % rc) = 0) THEN
					SET dump_flag = 1;
	INSERT INTO debug (intgr1,intgr2,intgr3,intgr4,string1) VALUES (i,rc,rsum+i,dump_flag,offsets);
					LEAVE segs;
				END IF;
				IF NOT FIND_IN_SET(i,offsets) THEN
					CALL gen_build(derby,CONCAT(offsets,i,','),segment+1,rsum+i);
				END IF;
				IF (i < rc) THEN
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
END