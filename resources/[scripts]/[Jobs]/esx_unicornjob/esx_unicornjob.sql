INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_unicorn', 'unicorn', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_unicorn', 'unicorn', 1),
  ('society_unicorn_fridge', 'Unicorn (frigo)', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    ('society_unicorn', 'unicorn', 1)
;

INSERT INTO `jobs` (name, label, whitelisted) VALUES
  ('unicorn', 'unicorn', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('unicorn', 0, 'barman', 'Barman', 300, '{}', '{}'),
  ('unicorn', 1, 'dancer', 'Danseur', 300, '{}', '{}'),
  ('unicorn', 2, 'viceboss', 'Co-gérant', 500, '{}', '{}'),
  ('unicorn', 3, 'boss', 'Gérant', 600, '{}', '{}')


INSERT INTO `items` (name, label, `limit`) VALUES
	('jager', 'Jägermeister', -1), 
	('vodka', 'Vodkaa', -1),
	-('rhum', 'Rhum', -1), 
	('whisky', 'Whisky', -1), 
	-('tequila', 'Tequila', -1),
	-('martini', 'Martini Blanc', -1), 
	('cocacola', 'Coca-Cola', -1),
	-('caprisun', 'Capri-Sun', -1), 
	('fanta', 'Fanta', -1),
	-('jusfruit', 'Jus de Fruit', -1), 
	('icetea', 'Ice-Tea', -1), 
	-('redbull', 'Red-Bull', -1),
	-('drpepper', 'DrPepper', -1), 
	-('limonade', 'Limonade', -1),
	-('bolcacahuetes', 'Bol de Cacahuètes', -1), 
	-('bolnoixcajou', 'Bol de Noix de Cajoux', -1), 
	-('bolpistache', 'Bol de Pistache', -1), 
	-('bolchips', 'Bol de Chips', -1), 
	-('saucisson', 'Saucission', -1), 
	-('grapperaisin', 'Grappe de Raisin', -1), 
	('ice', 'Glaçons', -1), 
	('menthe', 'Menthe', -1)
;
