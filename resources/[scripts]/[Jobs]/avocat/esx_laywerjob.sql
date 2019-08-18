INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('avocat',0,'recrue','Avocat Stagiaire',120,'{}','{}'),
('avocat',1,'novice','Avocat Débutant',140,'{}','{}'),
('avocat',2,'experimente','Avocat Experimente',150,'{}','{}'),
('avocat',3,'chief',"Avocat Gérant",160,'{}','{}'),
('avocat',4,'boss','Avocat Patron',180,'{}','{}');

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('avocat', 'avocat', 1);

INSERT INTO `addon_account` (name, label, shared) VALUES 
    ('society_avocat','Avocat',1);

INSERT INTO `datastore` (name, label, shared) VALUES 
    ('society_avocat','Avocat',1);

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
    ('society_avocat', 'Avocat', 1);
