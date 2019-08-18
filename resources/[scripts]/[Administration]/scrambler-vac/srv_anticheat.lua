local events = {
	'HCheat:TempDisableDetection',
	'BsCuff:Cuff696999',
	'police:cuffGranted',
	'_chat:messageEntered',
	'mellotrainer:adminTempBan',
	'esx_truckerjob:pay',
	'AdminMenu:giveCash',
	'AdminMenu:giveBank',
	'AdminMenu:giveDirtyMoney',
	'esx-qalle-jail:jailPlayer',
	'kickAllPlayer',
	'esx_gopostaljob:pay',
	'esx_banksecurity:pay',
	'esx_slotmachine:sv:2',
	'lscustoms:payGarage',
	'vrp_slotmachine:server:2',
	'dmv:success',
	'esx_drugs:startHarvestCoke',
	'esx_drugs:startHarvestMeth',
	'esx_drugs:startHarvestWeed',
	'esx_drugs:startHarvestOpium',
}

local eventsAdmin = {
	'Admin2Menu:giveCash',
	'Admin2Menu:giveBank',
	'Admin2Menu:giveDirtyMoney',
}

local Text               = {}
local lastduree          = ""
local lasttarget         = ""
local BanList            = {}
local BanListLoad        = false
local BanListHistory     = {}
local BanListHistoryLoad = false

Users = {}
violations = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('scrambler:GetGroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
   end)

platenum = math.random(00001, 99998)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local r = math.random(00001, 99998)
		platenum = r
	end
end)


GodModKickMessage = "RUBY ANTI-CHEAT | CHEAT DETECTED ! VOUS AVEZ ETE EXCLUS DU SERVEUR - [Cheat detection #".. platenum .."]."
kickMessage = "RUBY ANTI-CHEAT | CHEAT DETECTED ! YOU ARE NOT ALLOWED TO PLAY HERE! [Mod Menu detection #".. platenum .."]."
kickMessagePolice = "RUBY ANTI-RP | DETECTION VOLE DE VEHICULE! Voler des véhicule de service police/ems n'est pas autorisé! Merci de lire le réglement. [Detection #".. platenum .."]."
BanMessageLuaInjection = "RUBY ANTI-CHEAT | LUA MOD MENU / INJECTION DETECTED - YOU ARE GLOBALLY BANNED FROM THIS SERVER [Ban ID: #".. platenum .."]."
BanMessageHealthHack = "RUBY ANTI-CHEAT | CHEAT DETECTED - YOU ARE GLOBALLY BANNED FROM THIS SERVER [Ban ID: #".. platenum .."]."

function SendWebhookMessageStaff(webhook,message)
	webhook = "https://discordapp.com/api/webhooks/605077982830133248/HF-SUv2fHDEMwIFtmumlB-6P-iEJv42OdffTA9_G2OievG8TorZMRp5tPokBIs32bLFI"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

for i=1, #eventsAdmin, 1 do
	RegisterServerEvent(eventsAdmin[i])
	AddEventHandler(eventsAdmin[i], function()
		local _source = source
		TriggerEvent('scrambler:AdminDetected', eventsAdmin[i], _source, true)
	end)
end

RegisterServerEvent('scrambler:AdminDetected')
	AddEventHandler('scrambler:AdminDetected', function(name, source, isServerEvent)
		name = GetPlayerName(source)

		SendWebhookMessageStaff(webhook,"**Give D'argent détecté!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n\n- La personne c'est give de l'argents par le menu admin\n+ Anticheat Flags: [Detection #".. platenum .."].```")
	end)

function SendWebhookMessage(webhook,message)
	webhook = "https://discordapp.com/api/webhooks/605077772850823188/Tik19q1RpAWCnzD78H_kjRiCteK7_opYx7zgAoldshptJEHXTnZnsZ4ib-iTmfSNcBga"
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end


for i=1, #events, 1 do
	RegisterServerEvent(events[i])
	AddEventHandler(events[i], function()
		local _source = source
		TriggerEvent('scrambler:injectionDetected', events[i], _source, true)
	end)
end

RegisterServerEvent('scrambler:LittleDetection')
	AddEventHandler('scrambler:LittleDetection', function(invincible,oldHealth, newHealth, curWait, avert)
			name = GetPlayerName(source)
			avert = avert

			WarnPlayer(name)
			print('===========================================')
			print(' ')
			print(' ')
			print(' ')
			print(' ')
			print('^1Player id ^0[' .. source .. '] ^1à essayer d\'utiliser un cheat de health: ^0'..newHealth-oldHealth..'hp ( to reach '..newHealth..'hp ) in '..curWait..'ms! ^1 | nom de la personne : ^0[' .. name .. ']')
			print(' ')
			print(' ')
			print(' ')
			print(' ')
			print('===========================================')
			--SendWebhookMessage(webhook,"**Health Hack Detected!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n- Nombre(s) de détéction: "..avert.."\n\n- Régénération de :"..newHealth-oldHealth.."HP\n- HP après la régen: "..newHealth.."\n- Temps pour avoir "..newHealth..": "..curWait.."ms!\n+ Anticheat Flags: ( La régenération à été forcé )\n[Detection #".. platenum .."].```")

			if newHealth > 201 then
				TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, 0, BanMessageHealthHack)
				TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageHealthHack.."")
				SendWebhookMessage(webhook,"**Health Hack Detected!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n- Nombre(s) de détéction: "..avert.."\n\n- Régénération de :"..newHealth-oldHealth.."HP\n- HP après la régen: "..newHealth.."\n- Temps pour avoir "..newHealth..": "..curWait.."ms!\n+ Anticheat Flags: ( Le joueurs à été banni 5j )\n[Detection #".. platenum .."].```")
				SendWebhookMessageStaff(webhook,"**Mod Menu detected!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n- Nombre(s) de détéction: "..avert.."\n\n- Régénération de :"..newHealth-oldHealth.."HP\n- HP après la régen: "..newHealth.."\n- Temps pour avoir "..newHealth..": "..curWait.."ms!\n+ Anticheat Flags: ( Le joueur à été banni 5j après "..avert.." détéction du serveur. [Ban ID: #".. platenum .."]. )```")
			
			else
				SendWebhookMessage(webhook,"**Health Hack Detected!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n- Nombre(s) de détéction: "..avert.."\n\n- Régénération de :"..newHealth-oldHealth.."HP\n- HP après la régen: "..newHealth.."\n- Temps pour avoir "..newHealth..": "..curWait.."ms!\n+ Anticheat Flags: ( La régenération à été forcé )\n[Detection #".. platenum .."].```")
				
			end


	end)

RegisterServerEvent('scrambler:PoliceVehicule')
	AddEventHandler('scrambler:PoliceVehicule', function()
			name = GetPlayerName(source)
			DropPlayer(source, kickMessagePolice)
	end)

RegisterServerEvent('scrambler:GodModDetected')
	AddEventHandler('scrambler:GodModDetected', function(name, source, avert)

		local s = source
		nom = GetPlayerName(source)
	
	
		print('===========================================')
		print(' ')
		print(' ')
		print(' ')
		print(' ')
		print('^1Player id ^0[' .. source .. '] ^1à été banni 1j après 5 detection ^1 | nom de l\'event : ^0[' .. name .. ']')
		print(' ')
		print(' ')
		print(' ')
		print(' ')
		print('===========================================')
		SendWebhookMessageStaff(webhook,"**Mod Menu detected!** \n```diff\nJoueurs: "..nom.."\nID du joueurs: "..source.."\n\n- Nombre(s) de détéction: "..avert.."\n+ Anticheat Flags: ( Le joueur à été banni 1j après "..avert.." détéction du serveur. [Ban ID: #".. platenum .."]. )```")
		TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, BanMessageHealthHack)
		TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageHealthHack.."")
	
		--DropPlayer(source, BanMessageHealthHack)
	
	end)

RegisterServerEvent('scrambler:injectionDetected')
AddEventHandler('scrambler:injectionDetected', function(name, source, isServerEvent)

	local eventType = 'client'
	local s = source
	nom = GetPlayerName(source)

	if isServerEvent then
		eventType = 'server'
	end

	print('===========================================')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('^1Player id ^0[' .. source .. '] ^1à essayer d\'utiliser un event de type: ^0' .. eventType .. ' ^1 | nom de l\'event : ^0[' .. name .. ']')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('===========================================')
	SendWebhookMessageStaff(webhook,"**Mod Menu detected!** \n```diff\nJoueurs: "..nom.."\nID du joueurs: "..source.."\n\n- Type d'event utilisé : " .. eventType .. "\n- Nom de l'event utilisé : " .. name .. "\n+ Anticheat Flags: ( Le joueur à été définitivement banni du serveur. [Ban ID: #".. platenum .."]. )```")
	
	TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, 0, BanMessageLuaInjection)
	TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageLuaInjection.."")
	--DropPlayer(source, BanMessageLuaInjection)
end)


RegisterServerEvent('scrambler:ArmeDetect')
AddEventHandler('scrambler:ArmeDetect', function(source)

	local eventType = 'client'
	local s = source
	nom = GetPlayerName(source)

	if isServerEvent then
		eventType = 'server'
	end

	print('===========================================')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('^1Player id ^0[' .. source .. '] ^1à essayer d\'utiliser un event de type: ^0' .. eventType .. ' ^1 | nom de l\'event : ^0[' .. name .. ']')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('===========================================')
	SendWebhookMessageStaff(webhook,"**Arme black list** \n```diff\nJoueurs: "..nom.."\nID du joueurs: "..source.."\n\n+ Anticheat Flags: ( Le joueur à été définitivement banni du serveur. [Ban ID: #".. platenum .."]. )```")
	TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, 0, BanMessageHealthHack)
	TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageHealthHack.."")

	--DropPlayer(source, BanMessageLuaInjection)
end)


RegisterServerEvent('scrambler:CheatDetected2')
AddEventHandler('scrambler:CheatDetected2', function(source, avert)

	name = GetPlayerName(source)
	print('===========================================')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('^1Player id ^0[' .. source .. '] ^1à été kick, God Mod / cheat detected  '.. avert ..' detection !')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('===========================================')
	SendWebhookMessageStaff(webhook,"**HEALTH HACK DETECTED!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n\n+ Anticheat Flags: ( la personne à été définitivement banni du serveur.)```")

	TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, 0, BanMessageHealthHack)
	TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageHealthHack.."")

	--DropPlayer(source, BanMessageHealthHack)
end)


RegisterServerEvent('scrambler:GiveArgent')
AddEventHandler('scrambler:GiveArgent', function(source)

	name = GetPlayerName(source)
	print('===========================================')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('^1Player id ^0[' .. source .. '] ^1à été banni pour give argent cheat engine')
	print(' ')
	print(' ')
	print(' ')
	print(' ')
	print('===========================================')
	SendWebhookMessageStaff(webhook,"**GIVE ARGENT MODDEUR!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n\n+ Anticheat Flags: ( la personne à été définitivement banni du serveur.)```")
	TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, 0, BanMessageHealthHack)
	TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageHealthHack.."")


	--DropPlayer(source, BanMessageHealthHack)
end)

function WarnPlayer(playername)
	local isKnown = false
	local isKnownCount = 1
	for i,thePlayer in ipairs(violations) do
		if thePlayer.name == name then
			isKnown = true
			if violations[i].count == 5 then
				isKnownCount = violations[i].count
				print('===========================================')
				print(' ')
				print(' ')
				print(' ')
				print(' ')
				print('^1Player id ^0[' .. source .. '] ^1à été kick pour god mod !')
				print(' ')
				print(' ')
				print(' ')
				print(' ')
				print('===========================================')
				SendWebhookMessageStaff(webhook,"**CHEATER DETECTED!** \n```diff\nJoueurs: "..playername.."\nID du joueurs: "..source.."\n\n+ Anticheat Flags: ( La personne à été banni 1 jours après : "..isKnownCount.." detection. )```")
				table.remove(violations,i)
				TriggerEvent("RubyAntiCheat:Ban", 'Ruby_Anti_Cheat', source, 1, BanMessageHealthHack)
				TriggerClientEvent('chatMessage', -1, "ANTI CHEAT", {255, 0, 0}, "Le joueur" .. name .. "à été banni: "..BanMessageHealthHack.."")

				--DropPlayer(source, BanMessageHealthHack)
				--DropPlayer(source, kickMessage)
			else
				violations[i].count = violations[i].count+1
				isKnownCount = violations[i].count
			end
		end
	end

	if not isKnown then
		table.insert(violations, { name = name, count = 1 })
	end

	return isKnown, isKnownCount,isKnownExtraText
end


-- Kick session solo

RegisterServerEvent('sendSession:PlayerNumber')
AddEventHandler('sendSession:PlayerNumber', function(clientPlayerNumber)
	if source ~= nil then
		serverPlayerNumber = GetPlayers()
		if #serverPlayerNumber-clientPlayerNumber > 6 then 
			DropPlayer(source, '[Kick] Solo session.') -- Kick player
			print("sendSession:PlayerNumber clientPlayerNumber-"..clientPlayerNumber.." serverPlayerNumber-"..serverPlayerNumber) -- Debug
		end
	end
end)


-- Check for update
local CurrentVersion = [[4.0
]]
PerformHttpRequest('https://raw.githubusercontent.com/chaixshot/fivem/master/solokick/version', function(Error, NewestVersion, Header)
	if CurrentVersion ~= NewestVersion then
		print('\n')
		print('##')
		print('## Solo Kick')
		print('##')
		print('## Current Version: ' .. CurrentVersion)
		print('## Newest Version: ' .. NewestVersion)
		print('##')
		print('## Download')
		print('## https://github.com/chaixshot/fivem/tree/master/solokick')
		print('##')
		print('\n')
	end
end)
