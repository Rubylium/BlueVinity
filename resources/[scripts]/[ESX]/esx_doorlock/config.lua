Config = {}
Config.Locale = 'fr'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -90.0,
		objCoords  = vector3(452.6, -982.7, 30.6),
		textCoords = vector3(453.0, -982.6, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police','admin' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police','admin' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police','admin' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police','admin' },
		locked = true
	},
	-- Cell 4
	{
     	objName = 'v_ilev_ph_cellgate',
     	objYaw = 90.0,
     	objCoords  = vector3(466.145, -1001.306, 25.06443),
     	textCoords = vector3(466.145, -1001.306, 25.06443),
     	authorizedJobs = { 'police','admin' },
     	locked = true
	},

	-- Cell 5
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(466.145, -997.6584, 25.06443),
		textCoords = vector3(466.145, -997.6584, 25.06443),
		authorizedJobs = { 'police','admin' },
		locked = true
	},

	-- Cell 6
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(482.737, -991.7142, 25.0654),
		textCoords = vector3(482.737, -991.7142, 25.0654),
		authorizedJobs = { 'police','admin' },
		locked = true
	},

	-- Cell 7
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(482.737, -988.2937, 25.0654),
		textCoords = vector3(482.737, -988.2937, 25.0654),
		authorizedJobs = { 'police','admin' },
		locked = true
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 14,
		size = 2
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police' },
		locked = false
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	-- Unicorn
	{
		objName = 'prop_strip_door_01',
		objCoords  = vector3(127.9552, 1298.503, 29.41962),
		textCoords = vector3(127.9552, 1298.503, 29.41962),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 12,
		size = 2
	},

	--
	-- Addons
	--


	-- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1


	-- BANQUE

	{ -- Entrer Principale (Double Portes)
		textCoords = vector3(231.9123, 215.0177, 106.6049),
		authorizedJobs = { 'banker' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'hei_prop_hei_bankdoor_new',
				objYaw = 115.0,
				objCoords = vector3(232.6054, 214.1584, 106.4049)
			},

			{
				objName = 'hei_prop_hei_bankdoor_new',
				objYaw = -65.0,
				objCoords = vector3(231.5123, 216.5177, 106.4049)
			}
		}
	},

	{ -- Entrer Secondaire (Double Portes)
		textCoords = vector3(259.306, 204.1005, 106.4049),
		authorizedJobs = { 'banker' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'hei_prop_hei_bankdoor_new',
				objYaw = 160.0,
				objCoords = vector3(260.6432, 203.2052, 106.4049)
			},

			{
				objName = 'hei_prop_hei_bankdoor_new',
				objYaw = -20.0,
				objCoords = vector3(258.2022, 204.1005, 106.4049)
			}
		}
	},

	{ -- Arrière Hall (Double Portes)
		textCoords = vector3(259.975, 214.2468, 107.4049),
		authorizedJobs = { 'banker' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'hei_prop_hei_bankdoor_new',
				objYaw = 250.0,
				objCoords = vector3(259.9831, 215.2468, 106.4049)
			},

			{
				objName = 'hei_prop_hei_bankdoor_new',
				objYaw = 70.0,
				objCoords = vector3(259.0879, 212.8062, 106.4049)
			}
		}
	},


{
	objName = 'v_ilev_bk_door',  -- Accès Escalier BAS
	objYaw = -20.0,
	objCoords  = vector3(237.7704, 227.87, 106.426),
	textCoords = vector3(237.7704, 227.87, 107.426),
	authorizedJobs = { 'banker' },
	locked = true
},

{
	objName = 'v_ilev_bk_door',  -- Accès Escalier HAUT
	objYaw = 160.0,
	objCoords  = vector3(236.5488, 228.3147, 110.4328),
	textCoords = vector3(236.5488, 228.3147, 110.4328),
	authorizedJobs = { 'banker' },
	locked = true
},

{
	objName = 'v_ilev_bk_door', -- Porte Accès Bureau Gauche
	objYaw = -20.0,
	objCoords  = vector3(266.3624, 217.5697, 110.4328),
	textCoords = vector3(266.3624, 217.5697, 111.4328),
	authorizedJobs = { 'banker' },
	locked = true
},

{
	objName = 'v_ilev_bk_door2', -- Gauche
	objYaw = 70.0,
	objCoords  = vector3(262.5366, 215.0576, 110.4328),
	textCoords = vector3(262.5366, 215.0576, 111.4328),
	authorizedJobs = { 'banker' },
	locked = true
},

{
	objName = 'v_ilev_bk_door2', -- Droite
	objYaw = 70.0,
	objCoords  = vector3(260.8579, 210.4453, 110.4328),
	textCoords = vector3(260.8579, 210.4453, 111.4328),
	authorizedJobs = { 'banker' },
	locked = true
},

{
	objName = 'v_ilev_bk_door', -- Porte Accès Bureau Droite
	objYaw = -110.0,
	objCoords  = vector3(256.6172, 206.1522, 110.4328),
	textCoords = vector3(256.6172, 206.1522, 111.4328),
	authorizedJobs = { 'banker' },
	locked = true
},


  -- Concesionnaire 

  { -- Principale (Double Portes)
  textCoords = vector3(-37.33113, -1108.873, 27.7198),
  authorizedJobs = { 'cardealer' },
  locked = true,
  distance = 2.5,
  doors = {
	  {
		  objName = 'v_ilev_csr_door_r',
		  objYaw = -20.0,
		  objCoords = vector3(-37.33113, -1108.873, 26.7198)
	  },

	  {
		  objName = 'v_ilev_csr_door_l',
		  objYaw = -20.0,
		  objCoords = vector3(-39.13366, -1108.218, 26.7198)
	  }
  }
},

{ -- Secondaire (Double Portes)
  textCoords = vector3(-60.54582, -1094.749, 26.88872),
  authorizedJobs = { 'cardealer' },
  locked = true,
  distance = 2.5,
  doors = {
	  {
		  objName = 'v_ilev_csr_door_r',
		  objYaw = -110.0,
		  objCoords = vector3(-60.54582, -1094.749, 26.88872)
	  },

	  {
		  objName = 'v_ilev_csr_door_l',
		  objYaw = -110.0,
		  objCoords = vector3(-59.89302, -1092.952, 26.88362)
	  }
  }
},

{
	objName = 'v_ilev_fib_door1', -- Porte Bureau Parking
	objYaw = 70.0,
	objCoords  = vector3(-33.80989, -1107.579, 26.57225),
	textCoords = vector3(-33.80989, -1107.579, 27.57225),
	authorizedJobs = { 'cardealer' },
	locked = true
},

{
	objName = 'v_ilev_fib_door1', -- Porte Bureau Expo
	objYaw = 70.0,
	objCoords  = vector3(-31.72353, -1101.846, 26.57225),
	textCoords = vector3(-31.72353, -1101.846, 26.57225),
	authorizedJobs = { 'cardealer' },
	locked = true
},

-- The Palace

{
	objName = 'ba_prop_door_club_generic_vip', -- VIP
	objYaw = -90.0,
	objCoords  = vector3(-1607.536, -3005.431, -75.05607),
	textCoords = vector3(-1607.536, -3005.431, -74.05607),
	authorizedJobs = { 'nightclub' },
	locked = true
},

{
	objName = 'ba_prop_door_club_edgy_generic', -- Barman 1
	objYaw = -90.0,
	objCoords  = vector3(-1583.465, -3004.96, -75.83991),
	textCoords = vector3(-1583.465, -3004.96, -75.83991),
	authorizedJobs = { 'nightclub' },
	locked = true
},

{
	objName = 'ba_prop_door_club_edgy_generic', -- Barman 1
	objYaw = 180.0,
	objCoords  = vector3(-1581.912, -3010.062, -75.83991),
	textCoords = vector3(-1581.912, -3010.062, -74.83991),
	authorizedJobs = { 'nightclub' },
	locked = true
},


-- Unicorn

{
	objName = 'prop_strip_door_01', -- Entrer
	objYaw = 30.0,
	objCoords  = vector3(127.9552, -1298.503, 29.41962),
	textCoords = vector3(127.9552, -1298.503, 30.41962),
	authorizedJobs = { 'unicorn' },
	locked = true
},

{
	objName = 'v_ilev_door_orangesolid', -- Bureau 1
	objYaw = -60.0,
	objCoords  = vector3(113.9822, -1297.43, 29.41868),
	textCoords = vector3(113.9822, -1297.43, 30.41868),
	authorizedJobs = { 'unicorn' },
	locked = true
},

{
	objName = 'v_ilev_roc_door2', -- Bureau 2
	objYaw = 30.0,
	objCoords  = vector3(99.08321, -1293.701, 29.41868),
	textCoords = vector3(99.08321, -1293.701, 30.41868),
	authorizedJobs = { 'unicorn' },
	locked = true
},

{
	objName = 'prop_magenta_door', -- Derrière
	objYaw = -150.0,
	objCoords  = vector3(96.09197, -1284.854, 29.43878),
	textCoords = vector3(96.09197, -1284.854, 30.43878),
	authorizedJobs = { 'unicorn' },
	locked = true
},

}