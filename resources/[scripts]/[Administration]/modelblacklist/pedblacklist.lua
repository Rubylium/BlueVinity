-- CONFIG --

-- Blacklisted ped models
pedblacklist = {
	"CSB_BallasOG"
}

-- Defaults to this ped model if an error happened
defaultpedmodel = "a_m_y_skater_01"


pedblacklist2 = {
	"a_m_y_skater_01"
}

RegisterNetEvent('CheckPlayerPed')
AddEventHandler('CheckPlayerPed', function()
	Citizen.Wait(300*1000) -- Check de 5 minute
	playerPed = GetPlayerPed(-1)
	if playerPed then
		playerModel = GetEntityModel(playerPed)
		if isPedBlacklisted2(playerModel) then
			--SetPlayerModel(PlayerId(), prevPlayerModel)
			TriggerServerEvent('AntiPersoBug:Detected')
		end
	end
end)

function isPedBlacklisted2(model)
	for _, blacklistedPed in pairs(pedblacklist2) do
		if model == GetHashKey(blacklistedPed) then
			return true
		end
	end

	return false
end

function isPedBlacklisted(model)
	for _, blacklistedPed in pairs(pedblacklist) do
		if model == GetHashKey(blacklistedPed) then
			return true
		end
	end

	return false
end