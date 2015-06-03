CREATE DEFINER=`root`@`localhost` PROCEDURE `gen_build`(IN `lc` INT, IN `rc` INT, IN `offsets` VARCHAR(12), IN `segment` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
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
					CALL gen_build(lc,rc,CONCAT(offsets,i,','),segment+1);
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
					INSERT INTO generators (number_of_lanes,number_of_racers,offsets) VALUES (lc,rc,CONCAT(offsets,j));
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