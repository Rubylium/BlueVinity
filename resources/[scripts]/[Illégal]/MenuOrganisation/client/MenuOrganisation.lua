ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0) 
	end
end)


local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
blip = nil
blips = {}
local attente = 0



-- Menu principal
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("", "~b~MENU ORGANISATION", 5, 50)
_menuPool:Add(mainMenu)
-- Menu joueurs
JoueurMenu = NativeUI.CreateMenu("", "~b~INTERACTION JOUEURS", 5, 50)
_menuPool:Add(JoueurMenu)

-- Notification sans ESX pour plus d'opti
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(184)
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function ShowNotificationReussi(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(210)
    AddTextComponentString(text)
    DrawNotification(false, false)
end


function ShowNotificationErreur(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(6)
    AddTextComponentString(text)
    DrawNotification(false, false)
end

--[[


                    MENU PRINCIPAL


]]--


function OpenJoueurMenu(menu)
    local Description = "Ouvrir le menu d'intéraction joueur"
    local Item = NativeUI.CreateItem("intéraction joueur", Description)
    menu:AddItem(Item)
    menu.OnItemSelect = function(menu, item)
        if item == Item then
            mainMenu:Visible(not mainMenu:Visible())
            JoueurMenu:Visible(not JoueurMenu:Visible())
        end
    end
end

--[[


                    MENU INTERACTION JOUEURS


]]--

function AddJoueurMenu(menu)
    -- Attaché le joueur
    local Description = "Attacher la personne devant vous"
    local Attacher = NativeUI.CreateItem("Attacher la personne", Description)
    menu:AddItem(Attacher)
    -- Libérer le joueur
    local Description = "Détacher la personne"
    local Detacher = NativeUI.CreateItem("Détacher la personne devant vous", Description)
    menu:AddItem(Detacher)
-- Attacher 


    menu.OnItemSelect = function(menu, Attacher)
        if Attacher == Attacher then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            print(closestPlayer)
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                local target, distance = ESX.Game.GetClosestPlayer()
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                local target_id = GetPlayerServerId(target)
                if distance <= 2.0 then
                    TriggerServerEvent('Organisation:requestarrest', target_id, playerheading, playerCoords, playerlocation)
                    ShowNotificationReussi("Le joueurs a été attaché")
                else
                    ShowNotificationErreur('Pas de joueur proche')
                end
            else
                ShowNotificationErreur('Pas de joueur proche')
            end
        end
    end


    menu.OnItemSelect = function(menu, Detacher)
        if Detacher == Detacher then
            local target, distance = ESX.Game.GetClosestPlayer()
            playerheading = GetEntityHeading(GetPlayerPed(-1))
            playerlocation = GetEntityForwardVector(PlayerPedId())
            playerCoords = GetEntityCoords(GetPlayerPed(-1))
            local target_id = GetPlayerServerId(target)
            TriggerServerEvent('Organisation:requestrelease', target_id, playerheading, playerCoords, playerlocation)
            Wait(5000)
            TriggerServerEvent('Organisation:handcuff', target_id)
        end
    end
end


OpenJoueurMenu(mainMenu)
AddJoueurMenu(JoueurMenu)
_menuPool:MouseEdgeEnabled (false);
_menuPool:MouseControlsEnabled (false);
_menuPool:ControlDisablingEnabled (false);
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 344) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)


-- Function menotte 

-- Nouvelle menotte 

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end


RegisterNetEvent('Organisation:getarrested')
AddEventHandler('Organisation:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	cuffed = true
	loadanimdict('mp_arresting')
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    TriggerServerEvent('Organisation:handcuff', playerPed)
end)

RegisterNetEvent('Organisation:doarrested')
AddEventHandler('Organisation:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 

RegisterNetEvent('Organisation:douncuffing')
AddEventHandler('Organisation:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('Organisation:getuncuffed')
AddEventHandler('Organisation:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	z = z - 1.0
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	cuffed = false
	ClearPedTasks(GetPlayerPed(-1))
end)


RegisterNetEvent('Organisation:Menotte')
AddEventHandler('Organisation:Menotte', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then

				if handcuffTimer then
					ESX.ClearTimeout(HandcuffTimer)
				end

				StartHandcuffTimer()
			end

		else

			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end

			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)

end)