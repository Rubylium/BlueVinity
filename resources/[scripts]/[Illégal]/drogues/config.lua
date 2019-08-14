Config              = {}
Config.MarkerType   = 27
Config.DrawDistance = 3.0
Config.ZoneSize     = {x = 4.0, y = 4.0, z = 0.4}
Config.MarkerColor  = {r = 0, g = 0, b = 0}
Config.ShowBlips   = false  --markers visible on the map? (false to hide the markers on the map)

Config.RequiredCopsCoke  = 2
Config.RequiredCopsMeth  = 2
Config.RequiredCopsWeed  = 1
Config.RequiredCopsOpium = 3
Config.RequiredCopsLsd   = 99 -- Pas actif donc pas touché 

Config.TimeToFarm    = 6 * 800
Config.TimeToProcess = 5 * 900
Config.TimeToSell    = 4 * 3000

Config.Locale = 'fr'

Config.Zones = {
	CokeField =		{x = 778.78,	y = 4184.14, z = 41.78, name = _U('coke_field'), sprite = 501, color = 40},
	CokeProcessing =	{x = 1093.211,	y = -3196.66, z = -38.993, name = _U('coke_processing'), sprite = 501, color = 40},
	CokeDealer =		{x = -1107.70, y = -1642.52, z = 4.64, name = _U('coke_dealer'), sprite = 501,	color = 40},
	MethField =	     {x = -35.71, y = 2871.61, z = 59.61, name = _U('meth_field'), sprite = 499, color = 26},
	MethProcessing =	{x = 1009.5425415039, y = -3194.9985351563, z = -38.993125915527, name = _U('meth_processing'), sprite = 499, color = 26},
	MethDealer =		{x = -1673.61, y = 372.40, z = 85.1189, name = _U('meth_dealer'), sprite = 499, color = 26},
	WeedField =		{x = 1056.05, y = -3189.97, z = -40.1224, name = _U('weed_field'), sprite = 496, color = 52},
	WeedField2 =		{x = 1063.17, y = -3198.19, z = -40.1224, name = _'Récolte Weed 2', sprite = 496, color = 52},
	WeedProcessing =	{x = 1039.24, y = -3205.38, z = -38.166, name = _U('weed_processing'), sprite = 496, color = 52},
	WeedDealer =		{x = -1262.56, y = -1138.90, z = 7.5339, name = _U('weed_dealer'), sprite = 496, color = 52},
	OpiumField =		{x = -218.61, y = 6368.24, z = 32.0886, name = _U('opium_field'), sprite = 51,	color = 60},
	OpiumProcessing =	{x = 1290.115, y = -1697.31, z = 55.36, name = _U('opium_processing'), sprite = 51, color = 60},
	OpiumDealer =		{x = 379.58, y = -885.67, z = 39.63, name = _U('opium_dealer'),	sprite = 51, color = 60},
	TenuWeed =		{x = 1060.09, y = -3183.28, z = -39.764, name = ('Tenu Weed'),	sprite = 496, color = 52},
	AmeWeed =		{x = 1044.54, y = -3194.72, z = -39.158, name = ('Amélioration Weed'), sprite = 496, color = 52},
	--LsdField =              {x = 2510.3913574219, y = 3786.1909179688, z = -50.848163604736, name = _U('lsd_field'), sprite = 51,	color = 60},
	--LsdProcessing =         {x = -1108.6887207031, y = -1643.3828125, z = -4.6405272483826, name = _U('lsd_processing'), sprite = 51, color = 60},
	--LsdDealer =             {x = 115.67532348633, y = 170.83714294434, z = -112.45166778564, name = _U('lsd_dealer'), sprite = 500, color = 75},
}
