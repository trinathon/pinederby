DROP TABLE IF EXISTS debug;
CREATE TABLE debug (
	round_gen INT(11),
	racer_count INT(11),
	lane_count INT(11),
	offsets VARCHAR(12),
	round_id INT(11),
	racer_id INT(11),
	oCount INT(11),
	vector INT(11),
	gavg FLOAT(7,4),
	gstd FLOAT(7,4)
);

