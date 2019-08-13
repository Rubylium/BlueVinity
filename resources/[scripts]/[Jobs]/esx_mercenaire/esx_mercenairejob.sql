

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_mercenaire', 'Mercenaire', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_mercenaire', 'Mercenaire', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_mercenaire', 'Mercenaire', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('mercenaire','Mercenaire')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('mercenaire',0,'recruit','Recru',200,'{}','{}'),
	('mercenaire',1,'officer','Experimente',400,'{}','{}'),
	('mercenaire',2,'sergeant','Sergent',600,'{}','{}'),
	('mercenaire',3,'lieutenant','Lieutenant',850,'{}','{}'),
	('mercenaire',4,'boss','Chef BAC',1000,'{}','{}')
;
