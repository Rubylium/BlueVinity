------------------------------------------------------
------------------------------------------------------
------------------------------------------------------


--         MISSION VOITURE RESELLER !!!!!!!!


------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

local PlayerData = {}
ESX = nil

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
     PlayerData.job = job
end)

print('Ouais c\'est bien start')


local MissionReseller = false
local ResellerEnCours = false
local ResellerPris = false
local NombreParticipant = 0
local coordsX = {}
local coordsY = {}
local coordsZ = {}
local alpha = 8000
local alpha2 = 20000



RegisterNetEvent('ResellerVoiture')
AddEventHandler('ResellerVoiture', function()
	local ped = GetPlayerPed(PlayerId())
	local coords = GetEntityCoords(ped, false)
	local name = GetPlayerName(PlayerId())
     local x, y, z = table.unpack(GetEntityCoords(ped, true))
     
	
     TriggerServerEvent('Admin2Menu:MessageResellerVoiture2', x, y, z)
     --TriggerServerEvent('RessellerVoiture:Message')
     ResellerEnCours = true
end)

RegisterNetEvent('ResellerMissionVoiture')
AddEventHandler('ResellerMissionVoiture', function(x, y, z)
     coordsX = x
     coordsY = y
     coordsZ = z
     ESX.ShowAdvancedNotification(
          'RESELLER', 
          '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 
		'Mission livraison voiture Super Sportive\n~b~Livrer les voitures pour avoir une récompenses.', 'CHAR_CHAT_CALL', 8)
	ESX.ShowNotification('~g~Y ~w~pour accepter.\n~r~X ~w~pour refuser.')
     Citizen.Wait(1000)
     ResellerEnCours = true
	--PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
end)



Citizen.CreateThread(function()
     while true do
          Citizen.Wait(1)
          if IsControlJustPressed(1, 246) and ResellerEnCours then
               --NombreParticipant = NombreParticipant + 1
               TriggerServerEvent('PriseMissionResellerVoiture')
               TriggerEvent('ResellerVoitureBlipsCivil')
               ResellerPris = true
               --TriggerEvent('ResellerVoitureBlipsCivil')
			ResellerEnCours = false
			MissionReseller = true
          elseif IsControlJustPressed(1, 73) and ResellerEnCours then
               ResellerPris = false
               ResellerEnCours = false
               ESX.ShowNotification('~w~Vous avez refusé la mission.')
          end
     end
end)

--RegisterNetEvent('ResellerMissionVoitureCoords')
--AddEventHandler('ResellerMissionVoitureCoords', function(x, y, z)
--     coordsX = x
--     coordsY = y
--     coordsZ = z
--     TriggerEvent('ResellerVoitureBlipsCivil')
--end)


RegisterNetEvent('MissionResellerVoitureDebut')
AddEventHandler('MissionResellerVoitureDebut', function()
	if ResellerPris then
		NombreParticipant = NombreParticipant + 1
		if NombreParticipant > 15 then
			PlaySoundFrontend(-1, "On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
			PlaySoundFrontend(-1, "On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
			PlaySoundFrontend(-1, "On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
			TriggerEvent("pNotify:SetQueueMax", "right", 1)
			exports.pNotify:SendNotification({text = "✅ <b style='color:green'>+1<b style='color:white'> participant à l'event reseller.<br />Event Reseller avec: <b style='color:green'>"..NombreParticipant.."<b style='color:white'> participant(s) anonyme(s)", type = "succes", timeout = 100, layout = "centerRight", queue = "right"})
		end
	end
end)



RegisterNetEvent('ResellerVoitureBlipsCivil')
AddEventHandler('ResellerVoitureBlipsCivil', function()
	MissionReseller = true
	PlaySoundFrontend(-1, "10s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	PlaySoundFrontend(-1, "10s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	Citizen.Wait(10000)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	PlaySoundFrontend(-1, "CLOSE_WINDOW", "LESTER1A_SOUNDS", 0)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('RESELLER', '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 'De l\'argent facile avec des Super Sportive sa te tente ? Viens les chercher.', 'CHAR_LESTER_DEATHWISH', 1)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowNotification('~y~~h~Insutruction~s~\n- Se rendre sur les lieux (Logo de voiture)\n- Prendre la voiture')
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowNotification('-~h~La vendre sur le point (Logo dollar rouge)\n- Bonne chance !')
	exports.pNotify:SendNotification({text = "Attention, les événements reseller sont des évenements illégaux. Vous pouvez à tout moment vous faire tirer dessus, ou arreté par la LSPD.<br />Votre but est d'aller récupérer les véhicules et d'aller ensuite les vendres.", type = "info", timeout = 10000, layout = "centerRight", queue = "right"})

	Citizen.Wait(3000)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
     ESX.ShowAdvancedNotification('RESELLER', '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 'Bonne chance', 'CHAR_LESTER_DEATHWISH', 1)
     ESX.ShowNotification('✅ ~g~'..NombreParticipant..'~w~ participant(s) anonyme(s)')

	alpha = 8000
	alpha2 = 20000
	local blipsRenfort = AddBlipForCoord(coordsX, coordsY, coordsZ)
	local blipsRenfort2 = AddBlipForCoord(coordsX, coordsY, coordsZ)
	SetBlipSprite(blipsRenfort2, 225)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)

	SetBlipRoute(blipsRenfort,  true)

	-- revente des véhicules
	
	local blipsRenfort3 = AddBlipForCoord(15.75, 6505.57, 31.49)
	SetBlipSprite(blipsRenfort3, 500)
	SetBlipColour(blipsRenfort3, 6)
	SetBlipScale(blipsRenfort3, 0.8)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Revente véhicule Reseller')
	EndTextCommandSetBlipName(blipsRenfort3)

	local blipsRenfort4 = AddBlipForCoord(15.75, 6505.57, 31.49)
	SetBlipSprite(blipsRenfort4, 161)
	SetBlipScale(blipsRenfort4, 2.0) -- set scale
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Revente véhicule Reseller')
	SetBlipColour(blipsRenfort4, 1)
	SetBlipAlpha(blipsRenfort4, alpha)
	PulseBlip(blipsRenfort4)

	
	while alpha2 ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		alpha2 = alpha2 - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)
		SetBlipAlpha(blipsRenfort3, alpha2)
		SetBlipAlpha(blipsRenfort4, alpha2)

		if blips then
			if alpha == 0 then
				RemoveBlip(blipsRenfort)
				RemoveBlip(blipsRenfort2)
				PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
			end

			if alpha2 <= 0 then
				RemoveBlip(blipsRenfort3)
				RemoveBlip(blipsRenfort4)
                    MissionReseller = false
                    ResellerEnCours = false
                    ResellerPris = false
                    NombreParticipant = 0
                    coordsX = {}
                    coordsY = {}
                    coordsZ = {}
				PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
				return
			end
		else
			alpha = 0
			RemoveBlip(blipsRenfort)
               RemoveBlip(blipsRenfort2)
               
			PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
               blips = true	
               ResellerEnCours = false
               ResellerPris = false
               coordsX = {}
               coordsY = {}
               coordsZ = {}
		end
	end

end)

RegisterNetEvent('Admin2Menu:MessageResellerVoiture2Police2')
AddEventHandler('Admin2Menu:MessageResellerVoiture2Police2', function(x, y, z)
	MissionReseller = true
	Citizen.Wait(5000)
	PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('Indic LSPD', 'Message indic LSPD', 'J\'ai beaucoup d\'activité du coté reseller! je crois qu\'un évenement arrive !.', 'CHAR_WADE', 1)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
	Citizen.Wait(10000)
	PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('Indic LSPD', 'Message indic LSPD', 'Je confirme! C\'est une vente de véhicule illégal, j\'essaye de choper les positions!', 'CHAR_WADE', 1)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
	Citizen.Wait(6000)
	PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('Indic LSPD', 'Message indic LSPD', 'Merde, le cryptage est vraiment compliquer, ça vas me prendre encore du temps!', 'CHAR_WADE', 1)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
	Citizen.Wait(8000)
	PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('Indic LSPD', 'Message indic LSPD', 'C\'est bon, j\'ai trouvé une faille, je vous envoie ça sur vos GPS!', 'CHAR_WADE', 1)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 0)
	
	PlaySoundFrontend(-1, "10s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	PlaySoundFrontend(-1, "10s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	Citizen.Wait(10000)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	PlaySoundFrontend(-1, "CLOSE_WINDOW", "LESTER1A_SOUNDS", 0)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('RESELLER', '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 'De l\'argent facile avec des Super Sportive sa te tente ? Viens les chercher.', 'CHAR_LESTER_DEATHWISH', 1)
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowNotification('~y~~h~Insutruction~s~\n- Indécriptable\n- Indécriptable')
	Citizen.Wait(1000)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	ESX.ShowNotification('-~h~ Indécriptable\n- Indécriptable')


	Citizen.Wait(3000)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	ESX.ShowAdvancedNotification('RESELLER', '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 'Bonne chance', 'CHAR_LESTER_DEATHWISH', 1)
	exports.pNotify:SendNotification({text = "Dispatch Insutruction: <br />Un événement illégal du reseller est en cours, votre but est en priorité d'arrêter les suspects et d'empecher la vente des véhicules, mais resté sur vos gardes.<br /><br />Dispatch, fin de transmission, bonne chance.", type = "info", timeout = 10000, layout = "centerRight", queue = "right"})


	alpha = 8000
	alpha2 = 20000
	local blipsRenfort = AddBlipForCoord(x, y, z)
	local blipsRenfort2 = AddBlipForCoord(x, y, z)
	SetBlipSprite(blipsRenfort2, 225)
	SetBlipScale(blipsRenfort2, 0.85) -- set scale
	SetBlipColour(blipsRenfort2, 1)
	SetBlipAlpha(blipsRenfort2, alpha)
	PulseBlip(blipsRenfort2)

	SetBlipSprite(blipsRenfort, 161)
	SetBlipScale(blipsRenfort, 2.0) -- set scale
	SetBlipColour(blipsRenfort, 1)
	SetBlipAlpha(blipsRenfort, alpha)
	PulseBlip(blipsRenfort)
	SetBlipRoute(blipsRenfort,  true)
	-- revente des véhicules
	
	local blipsRenfort3 = AddBlipForCoord(15.75, 6505.57, 31.49)
	SetBlipSprite(blipsRenfort3, 500)
	SetBlipColour(blipsRenfort3, 1)
	SetBlipScale(blipsRenfort3, 0.8)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Revente véhicule Reseller')
	EndTextCommandSetBlipName(blipsRenfort3)

	local blipsRenfort4 = AddBlipForCoord(15.75, 6505.57, 31.49)
	SetBlipSprite(blipsRenfort4, 161)
	SetBlipScale(blipsRenfort4, 2.0) -- set scale
	SetBlipColour(blipsRenfort4, 1)
	SetBlipAlpha(blipsRenfort4, alpha)
	PulseBlip(blipsRenfort4)

	while alpha2 ~= 0 do
		Citizen.Wait(10)
		alpha = alpha - 1
		alpha2 = alpha2 - 1
		SetBlipAlpha(blipsRenfort, alpha)
		SetBlipAlpha(blipsRenfort2, alpha)
		SetBlipAlpha(blipsRenfort3, alpha2)
		SetBlipAlpha(blipsRenfort4, alpha2)
		Citizen.Wait(0)

		if blips then
			if alpha == 0 then
				RemoveBlip(blipsRenfort)
				RemoveBlip(blipsRenfort2)
				PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
			end

			if alpha2 <= 0 then
				RemoveBlip(blipsRenfort3)
				RemoveBlip(blipsRenfort4)
                    MissionReseller = false
                    ResellerEnCours = false
                    ResellerPris = false
                    NombreParticipant = 0
                    coordsX = {}
                    coordsY = {}
                    coordsZ = {}
				PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
				return
			end
		else
			alpha = 0
			alpha2 = 0
			RemoveBlip(blipsRenfort)
			RemoveBlip(blipsRenfort2)
			PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
               blips = true	
               ResellerEnCours = false
               ResellerPris = false
               coordsX = {}
               coordsY = {}
               coordsZ = {}
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if MissionReseller then
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil
			local letSleep = true
			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('lenzh_chopshop:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('lenzh_chopshop:hasExitedMarker', LastZone)
			end
		end
	end
end)

--Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if MissionReseller then
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true
			for k,v in pairs(Config.Zones) do
				if Config.MarkerType ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
					DrawMarker(Config.MarkerType, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
				end
			end
			if letSleep then
				Citizen.Wait(500)
			end
		end
	end
end)



blips = true

RegisterNetEvent('Admin2Menu:MessageResellerFin22Voiture')
AddEventHandler('Admin2Menu:MessageResellerFin22Voiture', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	Citizen.Wait(5500)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	PlaySoundFrontend(-1, "CLOSE_WINDOW", "LESTER1A_SOUNDS", 0)
	ESX.ShowAdvancedNotification('RESELLER', '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 'Mmh, mission terminé, les voiture ont été livré.', 'CHAR_LESTER_DEATHWISH', 1)
	blips = false
	MissionReseller = false
	ResellerEnCours = false
	ResellerPris = false
	NombreParticipant = 0
	alpha = 0
	alpha2 = 0
	coordsX = {}
	coordsY = {}
	coordsZ = {}
	Citizen.Wait(2000)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	ESX.ShowNotification('Prochaine mission très bientot  ...\n~c~Reseller, fin de transmission.')
	blips = true
end)