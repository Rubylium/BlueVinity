ESX                             = nil
local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isDead                    = false
local CurrentTask               = {}
local menuOpen 				    = false
local wasOpen 				    = false
local pedIsTryingToChopVehicle  = false
local ChoppingInProgress        = false



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)


function IsDriver()
	return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end



function MaxSeats(vehicle)
	local vehpas = GetVehicleNumberOfPassengers(vehicle)
	return vehpas
end

local lastTested = 0
function ChopVehicle()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn( ped, false )
	local seats = MaxSeats(vehicle)
	if seats ~= 0 then
		TriggerEvent('chat:addMessage', { args = { '[^1RESELLER^0]: Tu ne peux pas vendre avec des passagers !' } })
	else
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn( ped, false )
		local plate = GetVehicleNumberPlateText(vehicle)
		if plate == 'RESELLER' then
			TriggerServerEvent('chopNotify')
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn( ped, false )
			ChoppingInProgress        = true
			VehiclePartsRemoval()
			--if not HasAlreadyEnteredMarker then
			--	HasAlreadyEnteredMarker =  true
			--	ChoppingInProgress        = false
			--	exports.pNotify:SendNotification({text = "Tu à quitté la zone, pas de récompense pour toi.", type = "error", timeout = 1000, layout = "centerRight", queue = "right", killer = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
			--	SetVehicleAlarmTimeLeft(vehicle, 60000)
			--end
		else
			ESX.ShowAdvancedNotification('RESELLER', 'Vente Reseller', 'C\'est quoi ça ? C\'est pas une voiture du reseller ?! Casse toi !', 'CHAR_CHEF', 1)
		end
	end
end



function VehiclePartsRemoval()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn( ped, false )
	SetVehicleEngineOn(vehicle, false, false, true)
	SetVehicleUndriveable(vehicle, false)
	if ChoppingInProgress == true then
	    exports['progressBars']:startUI(Config.DoorOpenFrontLeftTime, "Ouverture porte de gauche")
	    Citizen.Wait(Config.DoorOpenFrontLeftTime)
	SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 0, false, false)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
	    exports['progressBars']:startUI(Config.DoorBrokenFrontLeftTime, "Destruction porte de gauche")
	    Citizen.Wait(Config.DoorBrokenFrontLeftTime)
	SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
	    exports['progressBars']:startUI(Config.DoorOpenFrontRightTime, "Ouverture porte de droite")
	    Citizen.Wait(Config.DoorOpenFrontRightTime)
	SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 1, false, false)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
	    exports['progressBars']:startUI(Config.DoorBrokenFrontRightTime, "Destruction porte de droite")
	    Citizen.Wait(Config.DoorBrokenFrontRightTime)
	SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
		exports['progressBars']:startUI(Config.DoorOpenHoodTime, "Ouverture capot")
	    Citizen.Wait(Config.DoorOpenHoodTime)
	SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 4, false, false)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
		exports['progressBars']:startUI(Config.DoorBrokenHoodTime, "Destruction capot")
	    Citizen.Wait(Config.DoorBrokenHoodTime)
	SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),4, true)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
		exports['progressBars']:startUI(Config.DoorOpenTrunkTime, "ouveture du coffre")
	    Citizen.Wait(Config.DoorOpenTrunkTime)
	SetVehicleDoorOpen(GetVehiclePedIsIn(ped, false), 5, false, false)
	end
	Citizen.Wait(1000)
	if ChoppingInProgress == true then
		exports['progressBars']:startUI(Config.DoorBrokenTrunkTime, "Fermeture du coffre")
	    Citizen.Wait(Config.DoorBrokenTrunkTime)
	SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false),5, true)
	end
	Citizen.Wait(1000)
	exports['progressBars']:startUI(Config.DeletingVehicleTime, "Destruction du véhicule")
	Citizen.Wait(Config.DeletingVehicleTime)
	if ChoppingInProgress == true then
	    DeleteVehicle()
		exports.pNotify:SendNotification({text = "Vehicle détruit avec succès, récompense dans t'es poche...", type = "success", timeout = 1000, layout = "centerRight", queue = "right", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function DeleteVehicle()
	if IsDriver() then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local bonus = GetVehicleEngineHealth(vehicle)
			TriggerServerEvent("lenzh_chopshop:rewards", bonus)
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end


AddEventHandler('lenzh_chopshop:hasEnteredMarker', function(zone)
	if zone == 'Chopshop' and IsDriver() then
		CurrentAction     = 'Chopshop'
		CurrentActionMsg  = ('Appuyer sur E pour vendre votre véhicule reseller')
		CurrentActionData = {}
	elseif zone == 'Chopshop' and not IsDriver() then
		exports.pNotify:SendNotification({text = "Tu est bien sur la revente du reseller, mais tu n'a aucun véhicule du reseller. Dommage pour toi, avant de venir ici fallait aller sur l'autre point.", type = "error", timeout = 10000, layout = "centerRight", queue = "right", killer = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
	end
end)

AddEventHandler('lenzh_chopshop:hasExitedMarker', function(zone)
	if menuOpen then
		ESX.UI.Menu.CloseAll()
	end

	if zone == 'Chopshop' then

	if ChoppingInProgress == true then
		exports.pNotify:SendNotification({text = "You Left The Zone. Go Back In The Zone", type = "error", timeout = 1000, layout = "centerRight", queue = "right", killer = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
	end
end
	ChoppingInProgress        = false


	CurrentAction = nil
end)

function CreateBlipCircle(coords, text, radius, color, sprite)

	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, color)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	if Config.EnableBlips == true then
	  for k,zone in pairs(Config.Zones) do
	   CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	  end
   end
end)


-- Display markers
--Citizen.CreateThread(function()
--    while true do
--        Citizen.Wait(0)
--        local coords, letSleep = GetEntityCoords(PlayerPedId()), true
--        for k,v in pairs(Config.Zones) do
--            if Config.MarkerType ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
--                DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
--                letSleep = false
--            end
--        end
--        if letSleep then
--            Citizen.Wait(500)
--        end
--    end
--end)

-- Enter / Exit marker events
--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(0)
--		local coords      = GetEntityCoords(PlayerPedId())
--		local isInMarker  = false
--		local currentZone = nil
--		local letSleep = true
--		for k,v in pairs(Config.Zones) do
--			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
--				isInMarker  = true
--				currentZone = k
--			end
--		end
--		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
--			HasAlreadyEnteredMarker = true
--			LastZone                = currentZone
--			TriggerEvent('lenzh_chopshop:hasEnteredMarker', currentZone)
--		end
--
--		if not isInMarker and HasAlreadyEnteredMarker then
--			HasAlreadyEnteredMarker = false
--			TriggerEvent('lenzh_chopshop:hasExitedMarker', LastZone)
--		end
--	end
--end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
		if IsControlJustReleased(0, 38) then
			if IsDriver() then
				if CurrentAction == 'Chopshop' then
					ChopVehicle()
				end
			end
			CurrentAction = nil
		end
		else
			Citizen.Wait(500)
		end
	end
end)


AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)


GetPlayerName()


function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end


RegisterNetEvent('chopEnable')
AddEventHandler('chopEnable', function()
	pedIsTryingToChopVehicle = true
end)
