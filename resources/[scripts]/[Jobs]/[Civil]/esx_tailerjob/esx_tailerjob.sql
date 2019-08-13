INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_tailer','Tailleur',1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_tailer','Tailleur', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_tailer', 'Tailleur', 1)
;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('tailer', 'Tailleur', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('tailer',0,'recrue','Intérimaire', 250, '{"tshirt_1":15,"tshirt_2":0,"torso_1":26,"torso_2":0,"shoes_1":51,"shoes_2":0,"pants_1":10, "pants_2":2, "arms":11}','{"tshirt_1":15,"tshirt_2":0,"torso_1":86,"torso_2":0,"shoes_1":52,"shoes_2":0,"pants_1":3, "pants_2":0, "arms":9}'),
	('tailer',1,'novice','Employer', 500, '{"tshirt_1":15,"tshirt_2":0,"torso_1":26,"torso_2":0,"shoes_1":51,"shoes_2":0,"pants_1":10, "pants_2":2, "arms":11}','{"tshirt_1":15,"tshirt_2":0,"torso_1":86,"torso_2":0,"shoes_1":52,"shoes_2":0,"pants_1":3, "pants_2":0, "arms":9}'),
	('tailer',2,'cequipe','Chef équipe', 750, '{"tshirt_1":15,"tshirt_2":0,"torso_1":26,"torso_2":0,"shoes_1":51,"shoes_2":0,"pants_1":10, "pants_2":2, "arms":11}','{"tshirt_1":15,"tshirt_2":0,"torso_1":86,"torso_2":0,"shoes_1":52,"shoes_2":0,"pants_1":3, "pants_2":0, "arms":9}'),
	('tailer',3,'cdisenior','Adjoint', 900, '{"tshirt_1":15,"tshirt_2":0,"torso_1":26,"torso_2":0,"shoes_1":51,"shoes_2":0,"pants_1":10, "pants_2":2, "arms":11}','{"tshirt_1":15,"tshirt_2":0,"torso_1":86,"torso_2":0,"shoes_1":52,"shoes_2":0,"pants_1":3, "pants_2":0, "arms":9}'),
	('tailer',4,'boss','Patron', 1000,'{"tshirt_1":15,"tshirt_2":0,"torso_1":26,"torso_2":0,"shoes_1":51,"shoes_2":0,"pants_1":10, "pants_2":2, "arms":11}','{"tshirt_1":15,"tshirt_2":0,"torso_1":86,"torso_2":0,"shoes_1":52,"shoes_2":0,"pants_1":3, "pants_2":0, "arms":9}')
;


INSERT INTO `items` (`name`, `label`) VALUES
	('wool', 'Laine'),
	('tissu', 'Tissu'),
	('clothe', 'Vêtement')
;

