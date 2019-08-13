Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.PoliceStations = {

	LSPD = {

		Blip = {
			Pos     = { x = 2469.939, y = -387.361, z = 109.590 },
			Sprite  = 398,
			Display = 4,
			Scale   = 1.2,
			Colour  = 39,
		},

		-- https://wiki.rage.mp/index.php?title=Weapons
		AuthorizedWeapons = {
			{ name = 'WEAPON_NIGHTSTICK',       price = 200 },
			{ name = 'WEAPON_COMBATPISTOL',     price = 300 },
			{ name = 'WEAPON_ASSAULTSMG',       price = 2250 },
			{ name = 'WEAPON_ASSAULTRIFLE',     price = 2500 },
			{ name = 'WEAPON_PUMPSHOTGUN',      price = 1600 },
			{ name = 'WEAPON_STUNGUN',          price = 1400 },
			{ name = 'WEAPON_FLASHLIGHT',       price = 80 },
			{ name = 'WEAPON_FIREEXTINGUISHER', price = 120 },
			{ name = 'WEAPON_FLAREGUN',         price = 60 },
			--{ name = 'WEAPON_STICKYBOMB',       price = 250 },
			{ name = 'GADGET_PARACHUTE',        price = 300 },
		},

		Cloakrooms = {
			{ x = 2476.6855, y = -379.6019, z = 93.3964 },
		},

		Armories = {
			{ x = 2487.946, y = -403.916, z = 92.483 },
		},

		Vehicles = {
			{
				Spawner    = { x = 2533.096, y = -384.813, z = 92.042 },
				SpawnPoints = {
					{ x = 2545.9147, y = -384.8486, z = 92.992, heading = 8.555263, radius = 6.0 },
					{ x = 2545.9147, y = -384.8486, z = 92.992, heading = 8.555263, radius = 6.0 },
					{ x = 2545.9147, y = -384.8486, z = 92.992, heading = 8.555263, radius = 6.0 },
					{ x = 2545.9147, y = -384.8486, z = 92.992, heading = 8.555263, radius = 6.0 }
				}
			},

			{
				Spawner    = { x = 2533.096, y = -384.813, z = 92.042 },
				SpawnPoints = {
					{ x = 2545.9147, y = -384.8486, z = 92.992, heading = 8.555263, radius = 6.0 },
					{ x = 2545.9147, y = -384.8486, z = 92.992, heading = 8.555263, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner    = { x = 2544.977, y = -430.760, z = 94.120 },
				SpawnPoint = { x = 2559.952, y = -438.493, z = 92.992 },
				Heading    = 350.7301,
			}
		},

		VehicleDeleters = {
			{ x = 2521.077, y = -458.150, z = 91.992 },
			{ x = 2539.087, y = -363.360, z = 91.992 },
			{ x = 2521.077, y = -458.150, z = 91.992 }
		},

		BossActions = {
			{ x = 2476.8947, y = -384.2421, z = 93.4021 }
		},

	},

}

-- https://wiki.rage.mp/index.php?title=Vehicles
Config.AuthorizedVehicles = {
	Shared = {
		{
			model = 'gruppe1',
			label = 'Crown Victoria'
		},
		{
			model = 'gruppe2',
			label = 'Dodge Charger'
		},

		{
			model = 'gruppe3',
			label = 'Ford Explorer'
		}
	},

	recruit = {

	},

	officer = {
		{
			model = 'gruppe1',
			label = 'Crown Victoria'
		},
		{
			model = 'gruppe2',
			label = 'Dodge Charger'
		},

		{
			model = 'gruppe3',
			label = 'Ford Explorer'
		}
	},

	sergeant = {
		
			
	},

	intendent = {

	},

	lieutenant = {
		
	},
	chef = {

	},

	boss = {

	}
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.Uniforms = {
	recruit_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	officer_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	sergeant_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	intendent_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	lieutenant_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	chef_wear = {
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 9,   ['pants_2'] = 7,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 3
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['bags_1'] = 41,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}