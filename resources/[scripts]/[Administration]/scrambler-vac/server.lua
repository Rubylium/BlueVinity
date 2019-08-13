local events = {
	'HCheat:TempDisableDetection',
	'BsCuff:Cuff696999',
	'police:cuffGranted',
	'_chat:messageEntered',
	'mellotrainer:adminTempBan',
	'esx_truckerjob:pay',
	'AdminMenu:giveCash',
	'AdminMenu:giveBank',
	--'esx:giveInventoryItem',
	'AdminMenu:giveDirtyMoney',
	'esx-qalle-jail:jailPlayer',
	'kickAllPlayer',
	'esx_gopostaljob:pay',
	'esx_banksecurity:pay',
	'esx_slotmachine:sv:2',
	'lscustoms:payGarage',
	'vrp_slotmachine:server:2',
	'dmv:success',
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
				local _source = source
				local xPlayer  = ESX.GetPlayerFromId(_source)  
				--print('Source: ',ESX.DumpTable(_source))
				--print('Arguments: ',ESX.DumpTable(args))
				--print ('period: '..args.period)
				--print ('reason: '..args.reason)
				local identifier
				local license
				local liveid    = ""
				local xblid     = ""
				local discord   = ""
				local playerip
				local duree = 5
				local reason = BanMessageHealthHack
				local targetplayername = xPlayer.name
				local sourceplayername = 'Ruby Anti Cheat Ban'
					
				if reason == "" then
					reason = ('no_reason')
				end
				
				for k,v in ipairs(GetPlayerIdentifiers(_source))do
					if string.sub(v, 1, string.len("steam:")) == "steam:" then
						identifier = v
					elseif string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
					elseif string.sub(v, 1, string.len("live:")) == "live:" then
						liveid = v
					elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
						xblid  = v
					elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
						discord = v
					elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
						playerip = v
					end
				end
				if duree > 0 then
					local permanent = 0
					ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
					DropPlayer(_source, reason)
				else
					local permanent = 1
					ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
					DropPlayer(_source, reason)
				end
			
				DropPlayer(source, BanMessageHealthHack)
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
		--Timeout(ssource)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)  
		--print('Source: ',ESX.DumpTable(_source))
		--print('Arguments: ',ESX.DumpTable(args))
		--print ('period: '..args.period)
		--print ('reason: '..args.reason)
		local identifier
		local license
		local liveid    = ""
		local xblid     = ""
		local discord   = ""
		local playerip
		local duree = 1
		local reason = BanMessageHealthHack
		local targetplayername = xPlayer.name
		local sourceplayername = 'Ruby Anti Cheat Ban'
			
		if reason == "" then
			reason = ('no_reason')
		end
		
		for k,v in ipairs(GetPlayerIdentifiers(_source))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				identifier = v
			elseif string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("live:")) == "live:" then
				liveid = v
			elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
				xblid  = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
				playerip = v
			end
		end
		if duree > 0 then
			local permanent = 0
			ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
			DropPlayer(_source, reason)
		else
			local permanent = 1
			ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
			DropPlayer(_source, reason)
		end
	
		DropPlayer(source, BanMessageHealthHack)
	
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
	--Timeout(ssource)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	--print('Source: ',ESX.DumpTable(_source))
	--print('Arguments: ',ESX.DumpTable(args))
	--print ('period: '..args.period)
	--print ('reason: '..args.reason)
	local identifier
	local license
	local liveid    = ""
	local xblid     = ""
	local discord   = ""
	local playerip
	local duree = 0
	local reason = BanMessageLuaInjection
	local targetplayername = xPlayer.name
	local sourceplayername = 'Ruby Anti Cheat Ban'
		
	if reason == "" then
		reason = ('no_reason')
	end
	
	for k,v in ipairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	if duree > 0 then
		local permanent = 0
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	else
		local permanent = 1
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	end

	DropPlayer(source, BanMessageLuaInjection)
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
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	local identifier
	local license
	local liveid    = ""
	local xblid     = ""
	local discord   = ""
	local playerip
	local duree = 0
	local reason = BanMessageLuaInjection
	local targetplayername = xPlayer.name
	local sourceplayername = 'Ruby Anti Cheat Ban'
		
	if reason == "" then
		reason = ('no_reason')
	end
	
	for k,v in ipairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	if duree > 0 then
		local permanent = 0
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	else
		local permanent = 1
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	end

	DropPlayer(source, BanMessageLuaInjection)
end)

RegisterServerEvent('scrambler:CheatDetected')
AddEventHandler('scrambler:CheatDetected', function(source, avert)

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
	SendWebhookMessage(webhook,"**Mod Menu detected!** \n```diff\nJoueurs: "..name.."\nID du joueurs: "..source.."\n\n+ Anticheat Flags: ( la personne à été kick du serveur après ".. avert .." detection . )```")
	--Timeout(ssource)


	DropPlayer(source, kickMessage)

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
	--Timeout(ssource)


	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	--print('Source: ',ESX.DumpTable(_source))
	--print('Arguments: ',ESX.DumpTable(args))
	--print ('period: '..args.period)
	--print ('reason: '..args.reason)
	local identifier
	local license
	local liveid    = ""
	local xblid     = ""
	local discord   = ""
	local playerip
	local duree = 1
	local reason = BanMessageHealthHack
	local targetplayername = xPlayer.name
	local sourceplayername = 'Ruby Anti Cheat Ban'
		
	if reason == "" then
		reason = ('no_reason')
	end
	
	for k,v in ipairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	if duree > 0 then
		local permanent = 0
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	else
		local permanent = 1
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	end

	DropPlayer(source, BanMessageHealthHack)
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
	--Timeout(ssource)


	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)  
	--print('Source: ',ESX.DumpTable(_source))
	--print('Arguments: ',ESX.DumpTable(args))
	--print ('period: '..args.period)
	--print ('reason: '..args.reason)
	local identifier
	local license
	local liveid    = ""
	local xblid     = ""
	local discord   = ""
	local playerip
	local duree = 1
	local reason = BanMessageLuaInjection
	local targetplayername = xPlayer.name
	local sourceplayername = 'Ruby Anti Cheat Ban'
		
	if reason == "" then
		reason = ('no_reason')
	end
	
	for k,v in ipairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	if duree > 0 then
		local permanent = 0
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	else
		local permanent = 1
		ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
		DropPlayer(_source, reason)
	end

	DropPlayer(source, BanMessageHealthHack)
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
				local _source = source
				local xPlayer  = ESX.GetPlayerFromId(_source)  
				--print('Source: ',ESX.DumpTable(_source))
				--print('Arguments: ',ESX.DumpTable(args))
				--print ('period: '..args.period)
				--print ('reason: '..args.reason)
				local identifier
				local license
				local liveid    = ""
				local xblid     = ""
				local discord   = ""
				local playerip
				local duree = 1
				local reason = BanMessageHealthHack
				local targetplayername = xPlayer.name
				local sourceplayername = 'Ruby Anti Cheat Ban'

				if reason == "" then
					reason = ('no_reason')
				end

				for k,v in ipairs(GetPlayerIdentifiers(_source))do
					if string.sub(v, 1, string.len("steam:")) == "steam:" then
						identifier = v
					elseif string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
					elseif string.sub(v, 1, string.len("live:")) == "live:" then
						liveid = v
					elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
						xblid  = v
					elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
						discord = v
					elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
						playerip = v
					end
				end
				if duree > 0 then
					local permanent = 0
					ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
					DropPlayer(_source, reason)
				else
					local permanent = 1
					ban(_source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
					DropPlayer(_source, reason)
				end

				DropPlayer(source, BanMessageHealthHack)
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

function ban(source,identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)

	local expiration = duree * 86400
	local timeat     = os.time()
	local message
	
	if expiration < os.time() then
		expiration = os.time()+expiration
	end
	
		table.insert(BanList, {
			identifier = identifier,
			license    = license,
			liveid     = liveid,
			xblid      = xblid,
			discord    = discord,
			playerip   = playerip,
			reason     = reason,
			expiration = expiration,
			permanent  = permanent
          })




		MySQL.Async.execute(
                'INSERT INTO banlist (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				['@permanent']        = permanent,
				},
				function ()
		end)

		--if permanent == 0 then
		--	TriggerEvent('bansql:sendMessage', source, (targetplayername .. _U('banned_for') .. duree .. _U('days_for') .. reason))
		--	message = (targetplayername .. identifier .." | ".. license .." | ".. liveid .." | ".. xblid .." | ".. discord .." | ".. playerip .." " .. _U('banned_for') .. duree .. _U('days_for') .. reason.." ".. _U('by') .." ".. sourceplayername)
		--else
		--	TriggerEvent('bansql:sendMessage', source, (targetplayername .. _U('permabanned_for') .. reason))
		--	message = (targetplayername .. identifier .. " | " .. license .. " | " .. liveid .. " | " .. xblid .. " | " .. discord .. " | " .. playerip .." " .. _U('permabanned_for') .. reason .. " " .. _U('by') .. " " .. sourceplayername)
		--end
		--if Config.EnableDiscordLink then
		--	sendToDiscord(Config.webhookban, "BanSql", message, Config.red)
		--end

		MySQL.Async.execute(
                'INSERT INTO banlisthistory (identifier,license,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)',
                { 
				['@identifier']       = identifier,
				['@license']          = license,
				['@liveid']           = liveid,
				['@xblid']            = xblid,
				['@discord']          = discord,
				['@playerip']         = playerip,
				['@targetplayername'] = targetplayername,
				['@sourceplayername'] = sourceplayername,
				['@reason']           = reason,
				['@expiration']       = expiration,
				['@timeat']           = os.time(),
				['@permanent']        = permanent,
				},
				function ()
		end)
		
		BanListHistoryLoad = false
end

function loadBanList()
	MySQL.Async.fetchAll(
	  'SELECT * FROM banlist',
	  {},
	  function (data)
	    BanList = {}
   
	    for i=1, #data, 1 do
		 table.insert(BanList, {
			   identifier = data[i].identifier,
			   license    = data[i].license,
			   liveid     = data[i].liveid,
			   xblid      = data[i].xblid,
			   discord    = data[i].discord,
			   playerip   = data[i].playerip,
			   reason     = data[i].reason,
			   expiration = data[i].expiration,
			   permanent  = data[i].permanent
		   })
	    end
	  end
	)
   end
   
   function loadBanListHistory()
	MySQL.Async.fetchAll(
	  'SELECT * FROM banlisthistory',
	  {},
	  function (data)
	    BanListHistory = {}
   
	    for i=1, #data, 1 do
		 table.insert(BanListHistory, {
			   identifier       = data[i].identifier,
			   license          = data[i].license,
			   liveid           = data[i].liveid,
			   xblid            = data[i].xblid,
			   discord          = data[i].discord,
			   playerip         = data[i].playerip,
			   targetplayername = data[i].targetplayername,
			   sourceplayername = data[i].sourceplayername,
			   reason           = data[i].reason,
			   expiration       = data[i].expiration,
			   permanent        = data[i].permanent,
			   timeat           = data[i].timeat
		   })
	    end
	  end
	)
   end
   
   
   function deletebanned(identifier) 
   
   MySQL.Async.execute(
			'DELETE FROM banlist WHERE identifier=@identifier',
			{
			  ['@identifier']  = identifier
			},
			    function ()
			    loadBanList()
			end)
   end
   
   
   
   AddEventHandler('playerConnecting', function (playerName,setKickReason)
	   local steamID  = "empty"
	   local license  = "empty"
	   local liveid   = "empty"
	   local xblid    = "empty"
	   local discord  = "empty"
	   local playerip = "empty"
   
	   for k,v in ipairs(GetPlayerIdentifiers(source))do
		   if string.sub(v, 1, string.len("steam:")) == "steam:" then
			   steamID = v
		   elseif string.sub(v, 1, string.len("license:")) == "license:" then
			   license = v
		   elseif string.sub(v, 1, string.len("live:")) == "live:" then
			   liveid = v
		   elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			   xblid  = v
		   elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			   discord = v
		   elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			   playerip = v
		   end
	   end
   
	   --Si Banlist pas chargée
	   if (Banlist == {}) then
		   Citizen.Wait(1000)
	   end
   
	  if steamID == false then
		   setKickReason(_U('invalid_steam'))
		   CancelEvent()
	  end
   
	   for i = 1, #BanList, 1 do
		   if 
			   ((tostring(BanList[i].identifier)) == tostring(steamID) 
			   or (tostring(BanList[i].license)) == tostring(license) 
			   or (tostring(BanList[i].liveid)) == tostring(liveid) 
			   or (tostring(BanList[i].xblid)) == tostring(xblid) 
			   or (tostring(BanList[i].discord)) == tostring(discord) 
			   or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		   then
   
			   if (tonumber(BanList[i].permanent)) == 1 then
   
				   setKickReason(BanMessageHealthHack .. BanList[i].reason)
				   CancelEvent()
				   break
   
			   elseif (tonumber(BanList[i].expiration)) > os.time() then
   
				   local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
				   if tempsrestant >= 1440 then
					   local day        = (tempsrestant / 60) / 24
					   local hrs        = (day - math.floor(day)) * 24
					   local minutes    = (hrs - math.floor(hrs)) * 60
					   local txtday     = math.floor(day)
					   local txthrs     = math.floor(hrs)
					   local txtminutes = math.ceil(minutes)
						   setKickReason(_U('you_have_been_banned') .. BanList[i].reason .. _U('time_left') .. txtday .. _U('days') ..txthrs .. _U('hours') ..txtminutes .. _U('minutes'))
						   CancelEvent()
						   break
				   elseif tempsrestant >= 60 and tempsrestant < 1440 then
					   local day        = (tempsrestant / 60) / 24
					   local hrs        = tempsrestant / 60
					   local minutes    = (hrs - math.floor(hrs)) * 60
					   local txtday     = math.floor(day)
					   local txthrs     = math.floor(hrs)
					   local txtminutes = math.ceil(minutes)
						   setKickReason(_U('you_have_been_banned') .. BanList[i].reason .. _U('time_left') .. txtday .. _U('days') .. txthrs .. _U('hours') .. txtminutes .. _U('minutes'))
						   CancelEvent()
						   break
				   elseif tempsrestant < 60 then
					   local txtday     = 0
					   local txthrs     = 0
					   local txtminutes = math.ceil(tempsrestant)
						   setKickReason(_U('you_have_been_banned') .. BanList[i].reason .. _U('time_left') .. txtday .. _U('days') .. txthrs .. _U('hours') .. txtminutes .. _U('minutes'))
						   CancelEvent()
						   break
				   end
   
			   elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then
   
				   deletebanned(steamID)
				   break
   
			   end
		   end
   
	   end
   
   end)
   
   AddEventHandler('es:playerLoaded',function(source)
	CreateThread(function()
	Wait(5000)
	   local steamID  = "no info"
	   local license  = "no info"
	   local liveid   = "no info"
	   local xblid    = "no info"
	   local discord  = "no info"
	   local playerip = "no info"
	   local playername = GetPlayerName(source)
   
	   for k,v in ipairs(GetPlayerIdentifiers(source))do
		   if string.sub(v, 1, string.len("steam:")) == "steam:" then
			   steamID = v
		   elseif string.sub(v, 1, string.len("license:")) == "license:" then
			   license = v
		   elseif string.sub(v, 1, string.len("live:")) == "live:" then
			   liveid = v
		   elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			   xblid  = v
		   elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			   discord = v
		   elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			   playerip = v
		   end
	   end
   
		   MySQL.Async.fetchAll('SELECT * FROM `baninfo` WHERE `identifier` = @identifier', {
			   ['@identifier'] = steamID
		   }, function(data)
		   local found = false
			   for i=1, #data, 1 do
				   if data[i].identifier == steamID then
					   found = true
				   end
			   end
			   if not found then
				   MySQL.Async.execute('INSERT INTO baninfo (identifier,license,liveid,xblid,discord,playerip,playername) VALUES (@identifier,@license,@liveid,@xblid,@discord,@playerip,@playername)', 
					   { 
					   ['@identifier'] = steamID,
					   ['@license']    = license,
					   ['@liveid']     = liveid,
					   ['@xblid']      = xblid,
					   ['@discord']    = discord,
					   ['@playerip']   = playerip,
					   ['@playername'] = playername
					   },
					   function ()
				   end)
			   else
				   MySQL.Async.execute('UPDATE `baninfo` SET `license` = @license, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername WHERE `identifier` = @identifier', 
					   { 
					   ['@identifier'] = steamID,
					   ['@license']    = license,
					   ['@liveid']     = liveid,
					   ['@xblid']      = xblid,
					   ['@discord']    = discord,
					   ['@playerip']   = playerip,
					   ['@playername'] = playername
					   },
					   function ()
				   end)
			   end
		   end)
	end)
   end)
   
   function getIdentity(source)
	   local identifier = GetPlayerIdentifiers(source)[1]
	   local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	   if result[1] ~= nil then
		   local identity = result[1]
   
		   return {
			   identifier = identity['identifier'],
			   name = identity['name'],
			   firstname = identity['firstname'],
			   lastname = identity['lastname'],
			   dateofbirth = identity['dateofbirth'],
			   sex = identity['sex'],
			   height = identity['height'],
			   job = identity['job'],
			   group = identity['group']
		   }
	   else
		   return nil
	   end
   end
   
   function inArray(value, array)
	   for _,v in pairs(array) do
		   if v == value then
			   return true
		   end
	   end
	   return false
   end
   
   CreateThread(function()
	   while true do
		   Wait(1000)
		   if BanListLoad == false then
			   loadBanList()
			   if BanList ~= {} then
				   --print(_U('banlist_loaded'))
				   BanListLoad = true
			   else
				  -- print(_U('banlist_starterror'))
			   end
		   end
		   if BanListHistoryLoad == false then
			   loadBanListHistory()
			   if BanListHistory ~= {} then
				   --print(_U('banhistory_loaded'))
				   BanListHistoryLoad = true
			   else
				   --print(_U('banlist_starterror'))
			   end
		   end
	   end
   end)





-- ANTI VPN




----------------
----  CONFIG  --
----------------
--local ownerEmail = 'alexisoko0@gmail.com'             -- Owner Email (Required) - No account needed (Used Incase of Issues)
--local kickThreshold = 1.01        -- Anything equal to or higher than this value will be kicked. (0.99 Recommended as Lowest)
--local kickReason = 'RUBY-ANTICHEAT | VPN Détécté, tu n\'est pas autorisé à rejoindre le serveur.\nSi c\'est une erreur, merci de contacter le résponsable dev sur discord'
--local flags = 'm'				  -- Quickest and most accurate check. Checks IP blacklist.
--local printFailed = true
--
--
--------- DO NOT EDIT BELOW THIS LINE -------
--function splitString(inputstr, sep)
--	local t= {}; i=1
--	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--		t[i] = str
--		i = i + 1
--	end
--	return t
--end
--
--AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
--	if GetNumPlayerIndices() < GetConvarInt('sv_maxclients', 32) then
--		deferrals.defer()
--		deferrals.update("Checking Player Information. Please Wait.")
--		playerIP = GetPlayerEP(source)
--		if string.match(playerIP, ":") then
--			playerIP = splitString(playerIP, ":")[1]
--		end
--		if IsPlayerAceAllowed(source, "blockVPN.bypass") then
--			deferrals.done()
--		else 
--			PerformHttpRequest('http://check.getipintel.net/check.php?ip=' .. playerIP .. '&contact=' .. ownerEmail .. '&flags=' .. flags, function(statusCode, response, headers)
--				if response then
--					if tonumber(response) == -5 then
--						print('[BlockVPN][ERROR] GetIPIntel seems to have blocked the connection with error code 5 (Either incorrect email, blocked email, or blocked IP. Try changing the contact email)')
--					elseif tonumber(response) == -6 then
--						print('[BlockVPN][ERROR] A valid contact email is required!')
--					elseif tonumber(response) == -4 then
--						print('[BlockVPN][ERROR] Unable to reach database. Most likely being updated.')
--					else
--						if tonumber(response) >= kickThreshold then
--							deferrals.done(kickReason)
--							if printFailed then
--								print('[BlockVPN][BLOCKED] ' .. playerName .. ' has been blocked from joining with a value of ' .. tonumber(response))
--							end
--						else 
--							deferrals.done()
--						end
--					end
--				end
--			end)
--		end
--	end
--end)