Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'fr'

Config.Zones = {

	FarmChicken = {
		Pos   = {x = -62.90, y = 6241.46, z = 30.09},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 0, g = 0, b = 0},
		Name  = "Achats de Poulets",
		Type  = 1
	},

	ConditChicken = {
		Pos   = {x = -101.97, y = 6208.79, z = 30.02},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Conditionnement des Poulets",
		Type  = 1
	},

	ChickenDead = {
		Pos   = {x = -77.99, y = 6229.06, z = 30.09},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Abattages des Poulets",
		Type  = 1
	},
	
	ChickenSell = {
		Pos   = {x = -596.15, y = -889.32, z = 24.50},
		Size  = {x = 5.0, y = 5.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits",
		Type  = 1
	},

	SlaughtererActions = {
		Pos   = {x = -1071.13, y = -2003.78, z = 14.80},
		Size  = {x = 2.0, y = 2.0, z = 1.5},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Type  = 27
	 },
	  
	VehicleSpawner = {
		Pos = {x = -1042.94, y = -2023.25, z = 12.16},
		Size = {x = 2.0, y = 2.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage véhicule",
		Type  = 27
	},

	VehicleSpawnPoint = {
		Pos = {x = -1048.85, y = -2025.32, z = 12.16},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos = {x = -1061.51, y = -2008.35, z = 12.16},
		Size  = {x = 5.0, y = 5.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Name  = "Ranger son véhicule",
		Type  = 27
	}

}

