CREATE FUNCTION `p_idx_wrap`(`idx` INT, `off_set` INT, `max_idx` INT)
	RETURNS INT
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
	RETURN IF((idx+off_set<=max_idx),(idx+off_set),(idx+off_set-max_idx));
END