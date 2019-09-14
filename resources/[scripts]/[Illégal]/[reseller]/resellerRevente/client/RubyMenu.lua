WarMenu = { }

WarMenu.debug = false

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = 0
	result.g = 242
	result.b = 255
	
	return result
end

ESX = nil
superadmin = nil
MissionReseller = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, true)
end


local menus = { }
local keys = { up = 172, down = 173, left = 174, right = 175, select = 176, back = 177 }
local optionCount = 0

local currentKey = nil
local currentMenu = nil

local menuWidth = 0.23
local titleHeight = 0.11
local titleYOffset = 0.045
local titleScale = 1.2

local buttonHeight = 0.038
local buttonFont = 4
local buttonScale = 0.365
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.002

local function debugPrint(text)
	if WarMenu.debug then
		Citizen.Trace('[WarMenu] '..tostring(text))
	end
end


local function setMenuProperty(id, property, value)
	if id and menus[id] then
		menus[id][property] = value
		debugPrint(id..' menu property changed: { '..tostring(property)..', '..tostring(value)..' }')
	end
end


local function isMenuVisible(id)
	if id and menus[id] then
		return menus[id].visible
	else
		return false
	end
end


local function setMenuVisible(id, visible, holdCurrent)
	if id and menus[id] then
		setMenuProperty(id, 'visible', visible)

		if not holdCurrent and menus[id] then
			setMenuProperty(id, 'currentOption', 1)
		end

		if visible then
			if id ~= currentMenu and isMenuVisible(currentMenu) then
				setMenuVisible(currentMenu, false)
			end

			currentMenu = id
		end
	end
end


local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow(2, 2, 0, 0, 0)
	end

	if menus[currentMenu] then
		if center then
			SetTextCentre(center)
		elseif alignRight then
			SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
			SetTextRightJustify(true)
		end
	end
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(x, y)
end


local function drawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end


local function drawTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight / 2

		if menus[currentMenu].titleBackgroundSprite then
			DrawSprite(menus[currentMenu].titleBackgroundSprite.dict, menus[currentMenu].titleBackgroundSprite.name, x, y, menuWidth, titleHeight, 0., 255, 255, 255, 255)
		else
			drawRect(x, y, 0, titleHeight, menus[currentMenu].titleBackgroundColor)
		end

		drawText(menus[currentMenu].title, x, y - titleHeight / 2 + titleYOffset, menus[currentMenu].titleFont, menus[currentMenu].titleColor, titleScale, true)
	end
end


local function drawSubTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

		local subTitleColor = { r = menus[currentMenu].titleBackgroundColor.r, g = menus[currentMenu].titleBackgroundColor.g, b = menus[currentMenu].titleBackgroundColor.b, a = 255 }

		drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
		drawText(menus[currentMenu].subTitle, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, 0.4, false)

		if optionCount > menus[currentMenu].maxOptionCount then
			drawText(tostring(menus[currentMenu].currentOption)..' / '..tostring(optionCount), menus[currentMenu].x + menuWidth, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, 0.4, false, false, true)
		end
	end
end


local function drawButton(text, subText)
	local x = menus[currentMenu].x + menuWidth / 2
	local multiplier = nil

	if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
		multiplier = optionCount
	elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
	end

	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end

		drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
		drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, 0.5, false, shadow)

		if subText then
			drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTextColor, 0.5, false, shadow, true)
		end
	end
end


function WarMenu.CreateMenu(id, title)
	-- Default settings
	menus[id] = { }
	menus[id].title = title
	menus[id].subTitle = 'INTERACTION MENU'

	menus[id].visible = false

	menus[id].previousMenu = nil

	menus[id].aboutToBeClosed = false

	menus[id].x = 0.75
	menus[id].y = 0.19

	menus[id].currentOption = 1
	menus[id].maxOptionCount = 10

	menus[id].titleFont = 4
	menus[id].titleColor = { r = 0, g = 0, b = 0, a = 255 }
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local ra = RGBRainbow(1.0)
			menus[id].titleBackgroundColor = { r = ra.r, g = ra.g, b = ra.b, a = 255 }
			menus[id].menuFocusBackgroundColor = { r = ra.r, g = ra.g, b = ra.b, a = 100 }
		end
	end)
	menus[id].titleBackgroundSprite = nil

	menus[id].menuTextColor = { r = 255, g = 255, b = 255, a = 255 }
	menus[id].menuSubTextColor = { r = 189, g = 189, b = 189, a = 255 }
	menus[id].menuFocusTextColor = { r = 255, g = 255, b = 255, a = 255 }
	menus[id].menuFocusBackgroundColor = { r = 245, g = 245, b = 245, a = 255 }
	menus[id].menuBackgroundColor = { r = 0, g = 0, b = 0, a = 70 }

	menus[id].subTitleBackgroundColor = { r = menus[id].menuBackgroundColor.r, g = menus[id].menuBackgroundColor.g, b = menus[id].menuBackgroundColor.b, a = 130 }

	menus[id].buttonPressedSound = { name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" } --https://pastebin.com/0neZdsZ5

	debugPrint(tostring(id)..' menu created')
end


function WarMenu.CreateSubMenu(id, parent, subTitle)
	if menus[parent] then
		WarMenu.CreateMenu(id, menus[parent].title)

		if subTitle then
			setMenuProperty(id, 'subTitle', string.upper(subTitle))
		else
			setMenuProperty(id, 'subTitle', string.upper(menus[parent].subTitle))
		end

		setMenuProperty(id, 'previousMenu', parent)

		setMenuProperty(id, 'x', menus[parent].x)
		setMenuProperty(id, 'y', menus[parent].y)
		setMenuProperty(id, 'maxOptionCount', menus[parent].maxOptionCount)
		setMenuProperty(id, 'titleFont', menus[parent].titleFont)
		setMenuProperty(id, 'titleColor', menus[parent].titleColor)
		setMenuProperty(id, 'titleBackgroundColor', menus[parent].titleBackgroundColor)
		setMenuProperty(id, 'titleBackgroundSprite', menus[parent].titleBackgroundSprite)
		setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)
		setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)
		setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)
		setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)
		setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)
		setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor)
	else
		debugPrint('Failed to create '..tostring(id)..' submenu: '..tostring(parent)..' parent menu doesn\'t exist')
	end
end


function WarMenu.CurrentMenu()
	return currentMenu
end


function WarMenu.OpenMenu(id)
	if id and menus[id] then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		setMenuVisible(id, true)

		if menus[id].titleBackgroundSprite then
			RequestStreamedTextureDict(menus[id].titleBackgroundSprite.dict, false)
			while not HasStreamedTextureDictLoaded(menus[id].titleBackgroundSprite.dict) do Citizen.Wait(0) end
		end

		debugPrint(tostring(id)..' menu opened')
	else
		debugPrint('Failed to open '..tostring(id)..' menu: it doesn\'t exist')
	end
end


function WarMenu.IsMenuOpened(id)
	return isMenuVisible(id)
end


function WarMenu.IsAnyMenuOpened()
	for id, _ in pairs(menus) do
		if isMenuVisible(id) then return true end
	end

	return false
end


function WarMenu.IsMenuAboutToBeClosed()
	if menus[currentMenu] then
		return menus[currentMenu].aboutToBeClosed
	else
		return false
	end
end


function WarMenu.CloseMenu()
	if menus[currentMenu] then
		if menus[currentMenu].aboutToBeClosed then
			menus[currentMenu].aboutToBeClosed = false
			setMenuVisible(currentMenu, false)
			debugPrint(tostring(currentMenu)..' menu closed')
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			optionCount = 0
			currentMenu = nil
			currentKey = nil
		else
			menus[currentMenu].aboutToBeClosed = true
			debugPrint(tostring(currentMenu)..' menu about to be closed')
		end
	end
end


function WarMenu.Button(text, subText)
	local buttonText = text
	if subText then
		buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
	end

	if menus[currentMenu] then
		optionCount = optionCount + 1

		local isCurrent = menus[currentMenu].currentOption == optionCount

		drawButton(text, subText)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText..' button pressed')
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint('Failed to create '..buttonText..' button: '..tostring(currentMenu)..' menu doesn\'t exist')

		return false
	end
end


function WarMenu.MenuButton(text, id)
	if menus[id] then
		if WarMenu.Button(text) then
			setMenuVisible(currentMenu, false)
			setMenuVisible(id, true, true)

			return true
		end
	else
		debugPrint('Failed to create '..tostring(text)..' menu button: '..tostring(id)..' submenu doesn\'t exist')
	end

	return false
end


function WarMenu.CheckBox(text, bool, callback)
	local checked = '~r~~h~Off'
	if bool then
		checked = '~g~~h~On'
	end

	if WarMenu.Button(text, checked) then
		bool = not bool
		debugPrint(tostring(text)..' checkbox changed to '..tostring(bool))
		callback(bool)

		return true
	end

	return false
end


function WarMenu.ComboBox(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	if WarMenu.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end
		end
	else
		currentIndex = selectedIndex
	end

	callback(currentIndex, selectedIndex)
	return false
end


function WarMenu.Display()
	if isMenuVisible(currentMenu) then
		if menus[currentMenu].aboutToBeClosed then
			WarMenu.CloseMenu()
		else
			ClearAllHelpMessages()

			drawTitle()
			drawSubTitle()

			currentKey = nil

			if IsDisabledControlJustPressed(0, keys.down) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption < optionCount then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
				else
					menus[currentMenu].currentOption = 1
				end
			elseif IsDisabledControlJustPressed(0, keys.up) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption > 1 then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
				else
					menus[currentMenu].currentOption = optionCount
				end
			elseif IsDisabledControlJustPressed(0, keys.left) then
				currentKey = keys.left
			elseif IsDisabledControlJustPressed(0, keys.right) then
				currentKey = keys.right
			elseif IsDisabledControlJustPressed(0, keys.select) then
				currentKey = keys.select
			elseif IsDisabledControlJustPressed(0, keys.back) then
				if menus[menus[currentMenu].previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					setMenuVisible(menus[currentMenu].previousMenu, true)
				else
					WarMenu.CloseMenu()
				end
			end

			optionCount = 0
		end
	end
end


function WarMenu.SetMenuWidth(id, width)
	setMenuProperty(id, 'width', width)
end


function WarMenu.SetMenuX(id, x)
	setMenuProperty(id, 'x', x)
end


function WarMenu.SetMenuY(id, y)
	setMenuProperty(id, 'y', y)
end


function WarMenu.SetMenuMaxOptionCountOnScreen(id, count)
	setMenuProperty(id, 'maxOptionCount', count)
end


function WarMenu.SetTitleColor(id, r, g, b, a)
	setMenuProperty(id, 'titleColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleColor.a })
end
 
 
function WarMenu.SetTitleBackgroundColor(id, r, g, b, a)
	setMenuProperty(id, 'titleBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleBackgroundColor.a })
end


function WarMenu.SetTitleBackgroundSprite(id, textureDict, textureName)
	setMenuProperty(id, 'titleBackgroundSprite', { dict = textureDict, name = textureName })
end


function WarMenu.SetSubTitle(id, text)
	setMenuProperty(id, 'subTitle', string.upper(text))
end


function WarMenu.SetMenuBackgroundColor(id, r, g, b, a)
	setMenuProperty(id, 'menuBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuBackgroundColor.a })
end


function WarMenu.SetMenuTextColor(id, r, g, b, a)
	setMenuProperty(id, 'menuTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuTextColor.a })
end

function WarMenu.SetMenuSubTextColor(id, r, g, b, a)
	setMenuProperty(id, 'menuSubTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuSubTextColor.a })
end

function WarMenu.SetMenuFocusColor(id, r, g, b, a)
	setMenuProperty(id, 'menuFocusColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuFocusColor.a })
end


function WarMenu.SetMenuButtonPressedSound(id, name, set)
	setMenuProperty(id, 'buttonPressedSound', { ['name'] = name, ['set'] = set })
end


function KeyboardInput(TextEntry, ExampleText, MaxStringLength)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true 

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function getPlayerIds()
	local players = {}
	for i = 0, GetNumberOfPlayers() do
		if NetworkIsPlayerActive(player) then
			players[#players + 1] = i
		end
	end
	return players
end

function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = 66
	result.g = 244
	result.b = 86
	
	return result
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

local allWeapons = {"WEAPON_KNIFE","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_PISTOL_MK2","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_FIREWORK","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}


local Enabled = true

local function TeleportToWaypoint()
	
	if DoesBlipExist(GetFirstBlipInfoId(8)) then
		local blipIterator = GetBlipInfoIdIterator(8)
		local blip = GetFirstBlipInfoId(8, blipIterator)
		WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector()) --Thanks To Briglair [forum.FiveM.net]
		wp = true
	else
		drawNotification("~r~No waypoint!")
	end
	
	local zHeigt = 0.0 height = 1000.0
	while true do
		Citizen.Wait(0)
		if wp then
			if IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
				entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
				entity = GetPlayerPed(-1)
			end

			SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
			FreezeEntityPosition(entity, true)
			local Pos = GetEntityCoords(entity, true)
			
			if zHeigt == 0.0 then
				height = height - 25.0
				SetEntityCoords(entity, Pos.x, Pos.y, height)
				bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
			else
				SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
				FreezeEntityPosition(entity, false)
				wp = false
				height = 1000.0
				zHeigt = 0.0
				drawNotification("~g~Teleported to waypoint!")
				break
			end
		end
	end
end


function RunningESX()
		local Attempt = 0
		local Found = false
	
	while Attempt <= 1 do
		print('Ruby menu : ON')
		Attempt = Attempt + 1
		
		if ESX ~= nil then Found = true break end
	end

	return Found
end

local Spectating = false

function SpectatePlayer(player)
	local playerPed = PlayerPedId()
	Spectating = not Spectating
	local targetPed = GetPlayerPed(player)

	if(Spectating)then

		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(true, targetPed)

		drawNotification('Spectating '..GetPlayerName(player))
	else

		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(false, targetPed)

		drawNotification('Stopped Spectating '..GetPlayerName(player))
	end
end


-- MAIN CODE --
function GetPlayers()
	local players = {}

	for _, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end


function reseller5()
	local repMoney = GetOnscreenKeyboardResult()
	local money = tonumber(repMoney)
	local ped = GetPlayerPed(PlayerId())
	local coords = GetEntityCoords(ped, false)
	local name = GetPlayerName(PlayerId())
	local x, y, z = table.unpack(GetEntityCoords(ped, true))
	
	TriggerServerEvent('Admin2Menu:MessageResellerFin2', money, x, y, z)
end

blips = true

RegisterNetEvent('Admin2Menu:MessageResellerFin22')
AddEventHandler('Admin2Menu:MessageResellerFin22', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	PlaySoundFrontend(-1, "5s", "MP_MISSION_COUNTDOWN_SOUNDSET", 0)
	Citizen.Wait(5500)
	PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
	PlaySoundFrontend(-1, "CLOSE_WINDOW", "LESTER1A_SOUNDS", 0)
	ESX.ShowAdvancedNotification('RESELLER', '~w~EVENEMENT ~h~~r~ILLEGAL ~w~RESELLER', 'Mmh, mission terminé, la cargaison à été récupéré.', 'CHAR_LESTER_DEATHWISH', 1)
	blips = false
	Citizen.Wait(2000)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	PlaySoundFrontend(-1, "ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET", 0)
	ESX.ShowNotification('Prochaine mission très bientot  ...\n~c~Reseller, fin de transmission.')
	blips = true
end)

RegisterNetEvent('Admin2Menu:MessageResellerFin22Police')
AddEventHandler('Admin2Menu:MessageResellerFin22Police', function(message, x, y, z)
	local message = message
	PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
	ESX.ShowAdvancedNotification('RESELLER', '~w~Message crypté', '43 61 72 67 61 69 73 6f 6e\n 20 72 c3 a9 63 75 70 c3 a9 72 c3 a9', 'CHAR_LESTER_DEATHWISH', 1)
	blips = false
	Citizen.Wait(2000)
	ESX.ShowNotification('Prochaine mission très bientot  ...\n~c~Reseller, fin de transmission.')
	blips = true
end)


function resellerVoiture()
	local repMoney = GetOnscreenKeyboardResult()
	local money = tonumber(repMoney)
	local ped = GetPlayerPed(PlayerId())
	local coords = GetEntityCoords(ped, false)
	local name = GetPlayerName(PlayerId())
	local x, y, z = table.unpack(GetEntityCoords(ped, true))
	
	TriggerServerEvent('Admin2Menu:MessageResellerFin2Voiture', money, x, y, z)
end




local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
	
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
	
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
	
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if Torque2 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 20.0)
		end
		if Torque4 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4.0 * 20.0)
		end
		if Torque8 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8.0 * 20.0)
		end
		if Torque16 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16.0 * 20.0)
		end
		if Torque32 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 32.0 * 20.0)
		end
		if Torque64 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 64.0 * 20.0)
		end
		if Torque128 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 128.0 * 20.0)
		end
		if Torque256 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 256.0 * 20.0)
		end
		if Torque512 then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 512.0 * 20.0)
		end
	end
end)

function KillAllPeds()
	local pedweapon
	local pedid
	for ped in EnumeratePeds() do 
	     if DoesEntityExist(ped) then
			pedid = GetEntityModel(ped)
			pedweapon = GetSelectedPedWeapon(ped)
			if (AntiCheat == true)then
			if pedweapon == -1312131151 or not IsPedHuman(ped) then 
				ApplyDamageToPed(ped, 1000, false)
				DeleteEntity(ped)
			else
				switch = function (choice)
				choice = choice and tonumber(choice) or choice
				
				case =
					{
					[451459928] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
				
					[1684083350] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
	
					[451459928] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
			
					[1096929346] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
	
					[880829941] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
			
					[-1404353274] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
	
					[2109968527] = function ( )
						ApplyDamageToPed(ped, 1000, false)
						DeleteEntity(ped)
					end,
	
					default = function ( )
					end,
				}
	
				if case[choice] then
					case[choice]()
				else
					case["default"]()
				end
				
				end
				switch(pedid) 
			end
		end
		end
	end
end

Citizen.CreateThread(function()
	FreezeEntityPosition(entity, false)
	local currentItemIndex = 1
	local selectedItemIndex = 1
		
	local IsESXPresent = RunningESX()
	local player = GetPlayerName(PlayerId())

	WarMenu.CreateMenu('MainMenu', '~w~STAFF MENU ~h~~r~2.9')
	WarMenu.SetSubTitle('MainMenu', 'Welcome to RESELLER '..player..'.')
	WarMenu.CreateSubMenu('SelfMenu', 'MainMenu', 'Self Options ~b~>~s~')
-- Vehicule mod
	WarMenu.CreateSubMenu('VehMenu', 'MainMenu', 'Vehicle Custom ~b~>~s~')
-- Vehicule boost
-- Vehicule boost
	WarMenu.CreateSubMenu('BoostMenu', 'MainMenu', 'Vehicle Boost ~b~>~s~')
	WarMenu.CreateSubMenu('PowerBoostMenu', 'BoostMenu', 'Power Boost ~b~>~s~')
	WarMenu.CreateSubMenu('TorqueBoostMenu', 'BoostMenu', 'Torque Boost ~b~>~s~')
-- Other	
	WarMenu.CreateSubMenu('PlayerMenu', 'MainMenu', 'Player Options ~b~>~s~')
	WarMenu.CreateSubMenu('OnlinePlayerMenu', 'PlayerMenu', 'Online Player Menu ~b~>~s~')
	WarMenu.CreateSubMenu('PlayerOptionsMenu', 'OnlinePlayerMenu', 'Player Options ~b~>~s~')
	WarMenu.CreateSubMenu('SingleWepPlayer', 'OnlinePlayerMenu', 'Single Weapon Menu ~b~>~s~')
	WarMenu.CreateSubMenu('SingleWepMenu', 'WepMenu', 'Single Weapon Menu ~b~>~s~')
-- Misc
	WarMenu.CreateSubMenu('ResellerMenu', 'MainMenu', 'Reseller options ~b~>~s~')
-- Spawn Véh reseller
	WarMenu.CreateSubMenu('ResellerVeh', 'MainMenu', 'Vehicle Reseller ~b~>~s~')
	WarMenu.CreateSubMenu('kickall', 'PlayerMenu', 'Tu Est Sur ?')


	local SelectedPlayer
	

	while Enabled do
		if WarMenu.IsMenuOpened('MainMenu') then
			scaleform = RequestScaleformMovie('mp_menu_glare')
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(1)
			end
			DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
			DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
			if WarMenu.MenuButton('Vehicle Boost ~b~>~s~', 'BoostMenu') then
			elseif WarMenu.MenuButton('~g~[PAS TOUCHER]~w~ Reseller options ~b~>~s~', 'ResellerMenu') then
			elseif WarMenu.MenuButton('~g~[PAS TOUCHER]~w~ Vehicle Reseller ~b~>~s~', 'ResellerVeh') then
		end
	
-- Misc Menu

			WarMenu.Display()
			DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
			DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
		elseif WarMenu.IsMenuOpened('ResellerMenu') then
		if WarMenu.Button('~g~Fin de mission voiture (Récolte)') then
			reseller5()
		elseif WarMenu.Button('~g~Fin de mission voiture (Vente)') then
			resellerVoiture()
		elseif WarMenu.Button('Reseller Police Vue') then
			reseller6()
		elseif WarMenu.Button('Reseller Livraison Voiture') then
			TriggerEvent('ResellerVoiture')
		elseif WarMenu.Button('Transformation Veh Reseller ~g~vert') then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleCustomPrimaryColour(playerVeh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(playerVeh, 8, 255, 37)
			--SetVehicleNumberPlateText(playerVeh, 'RESELLER')
		elseif WarMenu.Button('Transformation Veh Reseller ~u~noir') then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleCustomPrimaryColour(playerVeh, 0, 0, 0)
			SetVehicleCustomSecondaryColour(playerVeh, 0, 0, 0)
			--SetVehicleNumberPlateText(playerVeh, 'RESELLER')
		elseif WarMenu.Button('Transformation Veh Reseller ~r~rouge') then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleCustomPrimaryColour(playerVeh, 255, 0, 0)
			SetVehicleCustomSecondaryColour(playerVeh, 255, 0, 0)
			--SetVehicleNumberPlateText(playerVeh, 'RESELLER')
		elseif WarMenu.Button('Transformation Veh Reseller ~b~bleu') then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleCustomPrimaryColour(playerVeh, 0, 255, 229)
			SetVehicleCustomSecondaryColour(playerVeh, 0, 255, 229)
			--SetVehicleNumberPlateText(playerVeh, 'RESELLER')
		elseif WarMenu.Button('Transformation Veh Reseller ~p~violet') then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleCustomPrimaryColour(playerVeh, 191, 0, 255)
			SetVehicleCustomSecondaryColour(playerVeh, 191, 0, 255)
			--SetVehicleNumberPlateText(playerVeh, 'RESELLER')
		elseif WarMenu.Button('Transformation Veh Reseller ouvert') then
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleNumberPlateText(playerVeh, 'RESELLER')
			SetVehicleDoorOpen(playerVeh, 0, false)
			SetVehicleDoorOpen(playerVeh, 1, false)
			SetVehicleDoorOpen(playerVeh, 2, false)
			SetVehicleDoorOpen(playerVeh, 3, false)
		elseif WarMenu.Button('Transformation Veh cassé') then
			local ped = PlayerPedId()
			local playerPed = GetPlayerPed(-1)
			local playerVeh = GetVehiclePedIsIn(playerPed, true)
			SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 0, true)
			SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 1, true)
			SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 2, true)
			SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 3, true)
			SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 4, true)
			SetVehicleDoorBroken(GetVehiclePedIsIn(ped, false), 5, true)
		elseif WarMenu.Button('Spawn baller reseller') then
			local carid = GetHashKey('baller5')
			local playerPed = GetPlayerPed(-1)
			if playerPed and playerPed ~= -1 then
				RequestModel(carid)
				while not HasModelLoaded(carid) do
						Citizen.Wait(0)
				end
				local playerCoords = GetEntityCoords(playerPed)
		
				veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
				--SetVehicleAsNoLongerNeeded(veh)
				SetVehicleNumberPlateText(veh, 'RESELLER')
				TaskWarpPedIntoVehicle(playerPed, veh, -1)
			end
		elseif WarMenu.Button('Spawn kuruma2 reseller') then
			local carid = GetHashKey('kuruma2')
			local playerPed = GetPlayerPed(-1)
			if playerPed and playerPed ~= -1 then
				RequestModel(carid)
				while not HasModelLoaded(carid) do
						Citizen.Wait(0)
				end
				local playerCoords = GetEntityCoords(playerPed)
		
				veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
				--SetVehicleAsNoLongerNeeded(veh)
				SetVehicleNumberPlateText(veh, 'RESELLER')
				TaskWarpPedIntoVehicle(playerPed, veh, -1)
			end
		elseif WarMenu.Button('Get veh name') then
			local pPed = GetPlayerPed(-1)
			local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
			print(VehName)
		end



		WarMenu.Display()
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
	elseif WarMenu.IsMenuOpened("BoostMenu") then
		if WarMenu.MenuButton('Power Boost ~b~>~s~', 'PowerBoostMenu') then
		elseif WarMenu.MenuButton('Torque Boost ~b~>~s~', 'TorqueBoostMenu') then
		end


		WarMenu.Display()
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
	elseif WarMenu.IsMenuOpened('PowerBoostMenu') then 
		if WarMenu.Button('Engine Power boost reset') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1.0)
		elseif WarMenu.Button('Engine Power boost ~h~~g~x2') then
				SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x4') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x8') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x16') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x32') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 32.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x64') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 64.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x128') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 128.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x256') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 256.0 * 20.0)
		elseif WarMenu.Button('Engine Power boost  ~h~~g~x512') then
			SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 512.0 * 20.0)
		end

		WarMenu.Display()
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
	elseif WarMenu.IsMenuOpened('TorqueBoostMenu') then 
		if WarMenu.CheckBox('Engine Torque boost ~h~~g~x2', Torque2, function(enabled)
			Torque2 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x4', Torque4, function(enabled)
			Torque4 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x8', Torque8, function(enabled)
			Torque8 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x16', Torque16, function(enabled)
			Torque16 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x32', Torque32, function(enabled)
			Torque32 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x64', Torque64, function(enabled)
			Torque64 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x128', Torque128, function(enabled)
			Torque128 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x256', Torque256, function(enabled)
			Torque256 = enabled
		end) then
		elseif WarMenu.CheckBox('Engine Torque boost ~h~~g~x512', Torque512, function(enabled)
			Torque512 = enabled
		end) then
		end



		WarMenu.Display()
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
		DrawScaleformMovie(scaleform, 1.183, 0.6247, 0.9, 0.9, 255, 255, 255, 255, 0)
	elseif WarMenu.IsMenuOpened('ResellerVeh') then
	if WarMenu.Button('Spawn baller reseller') then
		local carid = GetHashKey('baller5')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn kuruma2 reseller') then
		local carid = GetHashKey('kuruma2')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn mule reseller') then
		local carid = GetHashKey('mule')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn benson reseller') then
		local carid = GetHashKey('benson')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn t20 reseller') then
		local carid = GetHashKey('t20')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn zentorno reseller') then
		local carid = GetHashKey('zentorno')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn xa21 reseller') then
		local carid = GetHashKey('xa21')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn tezeract reseller') then
		local carid = GetHashKey('tezeract')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn turismor reseller') then
		local carid = GetHashKey('turismor')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn vagner reseller') then
		local carid = GetHashKey('vagner')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn visione reseller') then
		local carid = GetHashKey('visione')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn vacca reseller') then
		local carid = GetHashKey('vacca')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn osiris reseller') then
		local carid = GetHashKey('osiris')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn nero reseller') then
		local carid = GetHashKey('nero')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn nero2 reseller') then
		local carid = GetHashKey('nero2')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn reaper reseller') then
		local carid = GetHashKey('reaper')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn fmj reseller') then
		local carid = GetHashKey('fmj')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn gp1 reseller') then
		local carid = GetHashKey('gp1')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn sc1 reseller') then
		local carid = GetHashKey('sc1')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
	
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			--SetVehicleAsNoLongerNeeded(veh)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			SetVehicleCustomSecondaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 30.0)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Spawn buzzard reseller') then
		local carid = GetHashKey('buzzard2')
		local playerPed = GetPlayerPed(-1)
		if playerPed and playerPed ~= -1 then
			RequestModel(carid)
			while not HasModelLoaded(carid) do
				Citizen.Wait(0)
			end
			local playerCoords = GetEntityCoords(playerPed)
			veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
			SetVehicleNumberPlateText(veh, 'RESELLER')
			--SetVehicleCustomPrimaryColour(veh, 8, 255, 37)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
			SetVehicleEnginePowerMultiplier(veh, 2.0 * 150.0)
			SetVehicleEngineTorqueMultiplier(veh, 2.0 * 150)
			SetModelAsNoLongerNeeded(carid)
		end
	elseif WarMenu.Button('Véhicule perso') then
		local ped = GetPlayerPed(-1)
		vehicle = GetVehiclePedIsIn(ped, false)
		SetVehicleNumberPlateText(vehicle, 'CNK 886')
		
	end


			WarMenu.Display()
		elseif IsDisabledControlPressed(0, 47) and IsDisabledControlPressed(0, 21) then
			ESX.TriggerServerCallback('RubyMenu:getUsergroup', function(group)
				playergroup = group
				if playergroup == 'superadmin' or playergroup == 'owner' then
					superadmin = true
					Citizen.Wait(10)
					WarMenu.OpenMenu('MainMenu')
					--PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1)
					ESX.ShowAdvancedNotification('STAFF INFO', 'RESSELLER MENU ~g~ON', 'Menu Reseller ouvert.\nTon grade:~g~ '..playergroup..'', 'CHAR_DEVIN', 8)
				end
			end)
		end

		Citizen.Wait(0)
	end
end)




RegisterCommand("killmenu", function(source,args,raw)
	Enabled = false
end, false)



