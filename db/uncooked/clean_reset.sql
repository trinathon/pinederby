DELETE s FROM scores AS s JOIN heats h ON s.heat_id=h.heat_id JOIN rounds r ON h.round_id=r.round_id WHERE r.derby_id = 2;
#DELETE s FROM scores AS s;
ALTER TABLE scores AUTO_INCREMENT = 1;

DELETE h FROM heats AS h JOIN rounds r ON h.round_id=r.round_id WHERE r.derby_id = 2;
#DELETE h FROM heats AS h;
ALTER TABLE heats AUTO_INCREMENT = 1;

DELETE r FROM rounds AS r WHERE r.derby_id = 2;
ALTER TABLE rounds AUTO_INCREMENT = 1;

#DELETE g FROM generators g WHERE g.number_of_lanes=4 AND g.number_of_racers=16;
DELETE g FROM generators AS g;
ALTER TABLE generators AUTO_INCREMENT = 1;

