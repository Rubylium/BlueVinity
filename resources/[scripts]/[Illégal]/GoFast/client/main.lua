
ESX = nil

PlayerData = {}


-- Coordonée pour le point de début de mission

local PosX = 471.153
local PosY = -3084.63
local PosZ = 6.07
local DebutMission = {coords = vector3(471.153, -3084.63, 6.07)}
local SpawnVehicule = {coords = vector3(454.90, -3052.006, 6.06)}
local SpawnVehiculeJoueur = {coords = vector3(452.64, -3050.59, 6.06)}
local GoFastVente = {coords = vector3(-229.74, 6261.69, 31.489)}

local GoFastEnCours = false
local BlipsGoFast = nil

local GoFastDejaFait = false



TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Affichage du points sur la map

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, PosX, PosY, PosZ, true)
		if dstCheck <= 20.0 then
			sleepThread = 5
			if dstCheck <= 4.2 then
				ESX.Game.Utils.DrawText3D(DebutMission.coords, "[E] Ouvrir le menu de ~g~GoFast\n~r~Activitée illégal", 1.0)
				if IsControlJustPressed(0, 38) then
					DebutMissionMenu()
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, GoFastVente.coords, true)
		if GoFastEnCours then
			if dstCheck <= 50.0 then
				sleepThread = 5
				if dstCheck <= 50.0 then
					ESX.Game.Utils.DrawText3D(GoFastVente.coords, "[E] Livrer le véhicule\n~r~Activitée illégal", 1.0)
					if IsControlJustPressed(0, 38) then
						FinDeGoFast()
					end
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)


-- Menu de début de mission 

function DebutMissionMenu()
	local elements = {}

	table.insert(elements, { ["label"] = "Commencer un GoFast", ["value"] = "start" })
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'GoFast',
		{
			title    = "Menu GoFast",
			align    = 'top-right',
			elements = elements
		},
		
	function(data, menu)
		local action = data.current.value

		if action == "start" then
			ESX.UI.Menu.CloseAll()
			AnimDebutMission()
		end
	end, function(data, menu)
		menu.close()
	end)
end





-- Animation de début de mission


local cloudOpacity = 0.10 -- (default: 0.01)
local muteSound = true -- (default: true)

function ToggleSound(state)
	if state then
		StartAudioScene("MP_LEADERBOARD_SCENE");
	else
		StopAudioScene("MP_LEADERBOARD_SCENE");
	end
end

-- Runs the initial setup whenever the script is loaded.
function InitialSetup()
	-- Stopping the loading screen from automatically being dismissed.
	SetManualShutdownLoadingScreenNui(true)
	-- Disable sound (if configured)
	ToggleSound(muteSound)
	-- Switch out the player if it isn't already in a switch state.
	if not IsPlayerSwitchInProgress() then
		SwitchOutPlayer(PlayerPedId(), 0, 1)
	end
end

-- Hide radar & HUD, set cloud opacity, and use a hacky way of removing third party resource HUD elements.
function ClearScreen()
	SetCloudHatOpacity(cloudOpacity)
	HideHudAndRadarThisFrame()
	
	-- nice hack to 'hide' HUD elements from other resources/scripts. kinda buggy though.
	SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function SpawnDuVehicule()
	local ped = PlayerPedId()
	print('Début animation')
	local veh = CreateVehicle(917809321, SpawnVehicule.coords, 335.26, true, true)
	print('Spawn du véhicule')
	--ESX.Game.Teleport(ped, SpawnVehiculeJoueur.coords, cb)
	print('Téléportation du joueur')
	TaskEnterVehicle(ped, veh, 0.0, -1, 1.0, p5, p6)
	print('Entré dans le véhicule')
end

function AnimDebutMission()
	InitialSetup()
	local ped = PlayerPedId()
	
	-- Wait for the switch cam to be in the sky in the 'waiting' state (5).
	while GetPlayerSwitchState() ~= 5 do
		Citizen.Wait(0)
		ClearScreen()
	end
	
	-- Shut down the game's loading screen (this is NOT the NUI loading screen).
	ShutdownLoadingScreen()
	
	ClearScreen()
	Citizen.Wait(0)
	--DoScreenFadeOut(0)
	ESX.Game.Teleport(ped, SpawnVehiculeJoueur.coords, cb)
	-- Shut down the NUI loading screen.
	ShutdownLoadingScreenNui()
	
	ClearScreen()
	Citizen.Wait(0)
	ClearScreen()
	--DoScreenFadeIn(500)
	while not IsScreenFadedIn() do
		Citizen.Wait(0)
		ClearScreen()
	end
	
	local timer = GetGameTimer()
	
	-- Re-enable the sound in case it was muted.
	ToggleSound(false)
	
	while true do
		ClearScreen()
		Citizen.Wait(0)
			
		-- wait 5 seconds before starting the switch to the player
		if GetGameTimer() - timer > 5000 then
		
			-- Switch to the player.
			SwitchInPlayer(PlayerPedId())
			ClearScreen()
			RequestModel(917809321)
			while not HasModelLoaded(917809321) do
				Citizen.Wait(0)
			end
			local veh = CreateVehicle(917809321, SpawnVehicule.coords, 335.26, true, true)
			SetVehicleNumberPlateText(veh, 'GOFAST')
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 20.0)
			-- Création du blips pour livrer le véhicule
			GoFastEnCours = true
			-- Wait for the player switch to be completed (state 12).
			while GetPlayerSwitchState() ~= 12 do
				Citizen.Wait(0)
				ClearScreen()
			end
			-- Stop the infinite loop.
			break
		end
	end
	
	-- Reset the draw origin, just in case (allowing HUD elements to re-appear correctly)
	ClearDrawOrigin()
	TriggerServerEvent("GoFast:MessagePolice")
	GoFastBlips()
	PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1)
	
end


function GoFastBlips()
	BlipsGoFast = AddBlipForCoord(GoFastVente.coords)
	SetBlipSprite(BlipsGoFast, 605)
	SetBlipScale(BlipsGoFast, 0.85) -- set scale
	SetBlipColour(BlipsGoFast, 1)
	SetBlipAlpha(BlipsGoFast, 200)
	PulseBlip(BlipsGoFast)

	SetBlipRoute(BlipsGoFast,  true)

	while GoFastEnCours do
		SetBlipAlpha(BlipsGoFast, 200)
		Wait(1000)
	end
end

function FinDeGoFast()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn( ped, false )
	local plate = GetVehicleNumberPlateText(vehicle)
	print(plate)
	if plate == ' GOFAST ' then
		RemoveBlip(BlipsGoFast)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local bonus = GetVehicleEngineHealth(vehicle)
		TriggerServerEvent("GoFast:VenteDuVehicule", bonus)
		ESX.Game.DeleteVehicle(vehicle)
		PlaySoundFrontend(-1, "MP_WAVE_COMPLETE", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		GoFastEnCours = false
	else
		ESX.ShowAdvancedNotification("GoFast", "~b~Livraison GoFast", "Hein ? C'est quoi ça ? C'est pas la voiture du GoFast !", "CHAR_LESTER_DEATHWISH", 8)
		PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
	end
end