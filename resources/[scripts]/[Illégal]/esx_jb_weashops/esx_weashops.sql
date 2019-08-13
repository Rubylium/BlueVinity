USE `rework`;

CREATE TABLE `weashops` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,

  PRIMARY KEY (`id`)
);

INSERT INTO `licenses` (type, label) VALUES
  ('weapon', "Permis de port d'arme")
;

INSERT INTO `items` (`name`, `label`) VALUES 
('clip', 'Chargeur')
;


INSERT INTO `weashops` (name, item, price) VALUES
	('GunShop', 'WEAPON_FLASHLIGHT', 1000),
	('GunShop', 'WEAPON_MACHETE', 1500),
	('GunShop', 'WEAPON_BAT', 2000),
	('GunShop', 'WEAPON_STUNGUN', 10000),
	('GunShop', 'WEAPON_SNSPISTOL', 25000),
	('BlackWeashop', 'WEAPON_MICROSMG', 380000),
	('BlackWeashop', 'WEAPON_ASSAULTRIFLE', 500000),
	('BlackWeashop', 'WEAPON_SPECIALCARBINE', 800000),
	('BlackWeashop', 'WEAPON_MACHINEPISTOL', 300000),
	('BlackWeashop', 'WEAPON_COMBATPDW', 550000),
	('BlackWeashop', 'WEAPON_SAWNOFFSHOTGUN', 375000),
	('BlackWeashop', 'WEAPON_SWITCHBLADE', 15000),
	('BlackWeashop', 'WEAPON_VINTAGEPISTOL', 30000),
	('BlackWeashop', 'WEAPON_PISTOL50', 35000),
	('BlackWeashop', 'WEAPON_REVOLVER', 45000),
;
