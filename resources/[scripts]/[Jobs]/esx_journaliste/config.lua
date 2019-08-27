Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 102, g = 0, b = 102 }
Config.EnablePlayerManagement     = true
Config.EnableVaultManagement      = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableHelicopters          = false
Config.EnableMoneyWash            = true
Config.MaxInService               = -1
Config.Locale                     = 'fr'

Config.AuthorizedVehicles = {
	{ name = 'newsheli',  label = 'Weazel Helicoptere 1' },
	{ name = 'newsheli2',  label = 'Weazel Helicoptere 2' },
	{ name = 'newsvan',  label = 'Weazel Van' },

}

Config.Blip = {
	Pos     = { x = -1087.048, y = -249.330, z = 36.947},
	Sprite  = 184,
	Display = 3,
	Scale   = 0.85,
	Colour  = 0,
}

Config.Zones = {

    BossActions = {
        Pos   = { x = -1053.683, y = -230.554, z = 43.020 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 20,
    },
	
	Cloakrooms = {
		Pos = { x = -1068.600, y = -241.440, z = 38.833},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },
		Type = 20,
	},

    Vehicles = {
        Pos          = { x = -1095.294, y = -255.858, z = 36.812 },
        SpawnPoint   = { x = -1099.061, y = -265.882, z = 37.692},
        Size         = { x = 1.8, y = 1.8, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 20,
        Heading      = 207.43,
    },	

	VehicleDeleters = {
		Pos  = { x = -1102.436, y = -255.600, z = 36.292},
		Size = { x = 4.0, y = 4.0, z = 2.0 },
        Color = { r = 0, g = 255, b = 128 },		
		Type = 20,
	},	

    Vaults = {
        Pos   = { x = -1051.591, y = -232.954, z = 43.050 },
        Size  = { x = 1.3, y = 1.3, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type  = 20,
    },	
}

Config.Uniforms = {
	journaliste_outfit = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		}
	},
  journaliste_outfit_1 = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		}	
	},
  journaliste_outfit_2 = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		}	
	},
  journaliste_outfit_3 = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 13,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 0,
			['chain_1'] = 0,  ['chain_2'] = 0
		}	
	}
}