ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0) 
	end
end)

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

-- Menu intéraction joueur ouvert
function AddJoueurMenu(menu)
    local Description = "Action random proche de joueurs"
    local Item = NativeUI.CreateItem("Action random proche de joueurs", Description)
    menu:AddItem(Item)
    menu.OnItemSelect = function(menu, item)
        if item == Item then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    ShowNotificationReussi("y'a un joueurs proche")
                else
					ShowNotificationErreur("Aucun joueurs proche . . .")
				end
        end
    end
end

-- Ouvrir l'intéraction joueurs
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