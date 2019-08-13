Config = {} -- DON'T TOUCH

Config.DrawDistance       = 100.0 -- Change the distance before you can see the marker. Less is better performance.
Config.EnableBlips        = false -- Set to false to disable blips.
Config.MarkerType         = 27    -- Change to -1 to disable marker.
Config.MarkerColor        = { r = 255, g = 0, b = 0 } -- Change the marker color.

Config.Locale             = 'en' -- Change the language. Currently available (en or fr).


Config.DoorOpenFrontLeftTime      = 4000
Config.DoorBrokenFrontLeftTime    = 4000
Config.DoorOpenFrontRightTime     = 4000
Config.DoorBrokenFrontRightTime   = 4000
Config.DoorOpenRearLeftTime       = 4000
Config.DoorBrokenRearLeftTime     = 4000
Config.DoorOpenRearRightTime      = 4000
Config.DoorBrokenRearRightTime    = 4000
Config.DoorOpenHoodTime           = 4000
Config.DoorBrokenHoodTime         = 4000
Config.DoorOpenTrunkTime          = 4000
Config.DoorBrokenTrunkTime        = 4000
Config.DeletingVehicleTime        = 4000

Config.Zones = {
    Chopshop = {coords = vector3(15.75, 6505.57, 31.49), name = _U('map_blip'), color = 49, sprite = 225, radius = 100.0, Pos = { x = 15.75, y = 6505.57, z = 31.49}, Size  = { x = 5.0, y = 5.0, z = 0.5 }, },
    --Shop = {coords = vector3(-55.42, 6392.8, 30.5), name = _U('map_blip_shop'), color = 50, sprite = 120, radius = 25.0, Pos = { x = -55.42, y = 6392.8, z = 30.5}, Size  = { x = 3.0, y = 3.0, z = 1.0 }, },
}
