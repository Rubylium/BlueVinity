-- CONFIG --

-- Ping Limit
pingLimit = 450

-- CODE --

RegisterServerEvent("checkMyPingBro")
AddEventHandler("checkMyPingBro", function()
	ping = GetPlayerPing(source)
	if ping >= pingLimit then
		DropPlayer(source, "RUBY ANTI-RP | Perte de connexion détecté\nAttention, vous avez 2m30 pour vous connecter à nouveau, vous serez prioritaire sur la file d'attente.")
	end
end)

RegisterServerEvent("kickForBeingAnAFKDouchebag")
AddEventHandler("kickForBeingAnAFKDouchebag", function()
	DropPlayer(source, "RUBY ANTI-RP | Tu à été kick car tu était AFK trop longtemps. Tu à 3 minutes pour te reconnecter et tu sera prioritaire sur la file d'attente.")
end)