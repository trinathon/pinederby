CALL round_build(2);
SELECT * FROM rounds;
#CALL gen_build(2,'',1,0);

#SELECT get_next_generator(derby) INTO g_id,g_offsets;
#SELECT COUNT(*) FROM generators AS g WHERE g.number_of_lanes = 4 AND g.number_of_racers = 16;  # 3360 -> 1288
-- SELECT COUNT(*) FROM generators AS g WHERE
-- g.number_of_lanes = 4 AND g.number_of_racers = 16
-- AND ((14 < g.rank AND 16 > g.rank) OR (34 < g.rank AND 38 > g.rank));
-- 
-- SELECT g.offsets FROM generators g WHERE g.number_of_lanes=4 AND g.number_of_racers=15 LIMIT 1;
-- SELECT g.offsets FROM generators g WHERE g.number_of_lanes=4 AND g.number_of_racers=15 ORDER BY g.generator_id DESC LIMIT 1;
-- SELECT g.rank,g.generator_id,g.offsets FROM generators g WHERE g.number_of_lanes=4 AND g.number_of_racers=15 ORDER BY g.rank DESC;
-- 
-- BEGIN
-- DECLARE oStr VARCHAR(12);
-- SELECT g.offsets INTO oStr FROM generators g WHERE g.number_of_lanes=4 AND g.number_of_racers=15 LIMIT 1;
-- END
-- 
#SET @@GLOBAL.max_sp_recursion_depth = 255;
#SET @@session.max_sp_recursion_depth = 255;
-- --  
-- SET @lane_cnt=3;
-- SET @d_id=1;
-- SELECT r.generator_id FROM rounds AS r WHERE r.derby_id = @d_id;
-- 
-- SELECT g.generator_id INTO @gen FROM generators AS g WHERE g.number_of_lanes=@lane_cnt AND g.generator_id NOT IN
-- (SELECT r.generator_id FROM rounds AS r WHERE r.derby_id = @d_id)
-- ORDER BY RAND() LIMIT 1;
-- 
-- SELECT @d_id,@lane_cnt,@gen;

-- CREATE PROCEDURE doiterate(p1 INT)
-- BEGIN
-- label1: LOOP
-- SET p1 = p1 + 1;
-- IF p1 < 10 THEN
-- ITERATE label1;
-- END IF;
-- LEAVE label1;
-- END LOOP label1;
-- SET @x = p1;
-- END;
-- 

-- CREATE PROCEDURE gen_test(lc INT, rc INT, offsets VARCHAR(12))
-- BEGIN
-- DECLARE zoffsets VARCHAR(12);
-- DECLARE i INT;
-- DECLARE j INT;
-- SET offsets = '';
-- SET i = 0;
-- lanelup: LOOP
-- SET j = 0;
-- SET i = i+1;
-- SET offsets = CONCAT(offsets,i,",");
-- IF i < @lc-1 THEN
-- ITERATE lanelup;
-- END IF;
-- drvlup: LOOP
-- SET j = j+1;
-- SET offsets = CONCAT(offsets,j);
-- INSERT INTO generators (number_of_lanes,number_of_racers,offsets) VALUES (@lc,@rc,@offsets);
-- IF j < @rc THEN
-- ITERATE drvlup;
-- ELSE
-- LEAVE drvlup;
-- END IF;
-- END LOOP drvlup;
-- END LOOP lanelup;
-- END;