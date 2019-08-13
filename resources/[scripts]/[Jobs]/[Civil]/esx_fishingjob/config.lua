Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'fr'

Config.Zones = {

	FishingFarm = {
		Pos   = {x = 4514.304, y = 4261.079, z = 0.80},
		Size  = {x = 100.0, y = 100.0, z = 20.0},
		Color = {r = 106, g = 219, b = 0},
		Name  = "Zone de pêche",
		Type  = 1
	},

	FishChips = {
		Pos   = {x = 2332.426, y = 4856.476, z = 40.50},
		Size  = {x = 4.0, y = 4.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Abattage du Poisson",
		Type  = 1
	},

	FishDead = {
		Pos   = {x = 1247.176, y = -349.969, z = 67.9},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Préparation des Fish And Chips",
		Type  = 1
	},
	
	SellFishChips = {
		Pos   = {x = -1110.420, y = -1453.921, z = 3.5},
		Size  = {x = 2.5, y = 2.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des Fish Ans Chips",
		Type  = 1
	},

	FishingActions = {
		Pos   = {x = 868.932, y =-1639.978, z = 28.5},
		Size  = {x = 2.0, y = 2.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Type  = 27
	 },
	  
	VehicleSpawner = {
		Pos   = {x = 869.219, y = -1653.744, z = 29.3},
		Size = {x = 2.0, y = 2.0, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage véhicule",
		Type  = 27
	},

	VehicleSpawnPoint = {
		Pos   = {x = 873.545, y = -1664.477, z = 29.3},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = {x = 876.117, y = -1670.564, z = 29.3},
		Size  = {x = 5.0, y = 5.0, z = 1.5},
		Color = {r = 255, g = 0, b = 0},
		Name  = "Ranger son véhicule",
		Type  = 27
	},
	  
	BoatSpawner = {
		Pos   = {x = 3829.858, y = 4458.429, z = 2.0},
		Size = {x = 2.0, y = 2.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage Bateau",
		Type  = 27
	},

	BoatSpawnPoint = {
		Pos   = {x = 3878.384, y = 4485.062, z = 00.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Spawn point",
		Type  = -1
	},

	BoatDeleter = {
		Pos   = {x = 3858.332, y = 4480.091, z = 02.0},
		Size  = {x = 5.0, y = 5.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Name  = "Ranger son Bateau",
		Type  = 27
	}

}

