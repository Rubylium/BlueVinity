Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale                     = 'fr'

Config.Zones = {

	PetrolFarm = {
		Pos   = {x = 696.413, y = 2889.107, z = 49.0},
		Size  = {x = 10.0, y = 10.0, z = 2.0},
		Color = {r = 0, g = 0, b = 0},
		Name  = "Récolte du pétroles",
		Type  = 1
	},


	TraitementPetrol = {
		Pos   = {x = 2746.750, y = 1653.339, z = 23.0},
		Size  = {x = 4.0, y = 4.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement du pétrole",
		Type  = 1
	},

	TraitementRaffin = {
		Pos   = {x = 2765.624, y = 1709.929, z = 23.0},
		Size  = {x = 4.0, y = 4.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Traitement du pétrole raffiné",
		Type  = 1
	},
	
	SellFarm = {
		Pos   = {x = 3532.0, y = 3672.900, z = 33.0},
		Size  = {x = 4.5, y = 4.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Vente des produits",
		Type  = 1
	},

	FuelerActions = {
		Pos   = {x = 2890.645, y = 4391.536, z = 49.4},
		Size  = {x = 2.0, y = 2.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Type  = 27
	 },
	  
	VehicleSpawner = {
		Pos   = {x = 2899.537, y = 4398.668, z = 49.4},
		Size = {x = 2.0, y = 2.0, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage véhicule",
		Type  = 27
	},

	VehicleSpawnPoint = {
		Pos   = {x = 2899.626, y = 4382.079, z = 49.5},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Spawn point",
		Type  = -1
	},

	VehicleDeleter = {
		Pos   = {x = 2909.202, y = 4365.562, z = 49.4},
		Size  = {x = 5.0, y = 5.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Name  = "Ranger son véhicule",
		Type  = 27
	}

}

