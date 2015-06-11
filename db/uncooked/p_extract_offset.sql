CREATE DEFINER=`root`@`localhost` FUNCTION `p_extract_offset`(`offsets` VARCHAR(50), `idx` INT, `idx_max` INT)
	RETURNS int(11)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
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
END