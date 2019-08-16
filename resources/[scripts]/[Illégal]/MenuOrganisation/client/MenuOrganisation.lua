ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0) 
	end
end)

-- Menu principal
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("", "~b~MENU ORGANISATION", 5, 100)
_menuPool:Add(mainMenu)
-- Menu joueurs
JoueurMenu = NativeUI.CreateMenu("", "~b~INTERACTION JOUEURS", 5, 100)
_menuPool:Add(JoueurMenu)

-- Notification sans ESX pour plus d'opti
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    SetNotificationBackgroundColor(6)
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Intéraction joueurs
function AddMenuKetchup(menu)
    local Description = "Ouvrir le menu d'intéraction joueur"
    local Item = NativeUI.CreateItem("intéraction joueur", Description)
    menu:AddItem(Item)
    menu.OnItemSelect = function(menu, item)
        if item == Item then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                mainMenu:Visible(not mainMenu:Visible())
                JoueurMenu:Visible(not JoueurMenu:Visible())
            else
				ShowNotification('Aucun joueurs proche . . .')
			end
        end
    end
end

-- Menu intéraction joueur ouvert
function AddJoueurMenu(menu)
    local Description = "Ouvrir le menu d'intéraction joueur"
    local Item = NativeUI.CreateItem("intéraction joueur", Description)
    menu:AddItem(Item)
    menu.OnItemSelect = function(menu, item)
        if item == Item then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then

                else
					ShowNotification('Aucun joueurs proche . . .')
				end
        end
    end
end


function AddMenuFoods(menu)
    local foods = {
        "Banana",
        "Apple",
        "Pizza",
        "Quartilicious",
        "Steak",
        0xF00D,
    }
    local newitem = NativeUI.CreateListItem("Food", foods, 1)
    menu:AddItem(newitem)
    menu.OnListChange = function(sender, item, index)
        if item == newitem then
            dish = item:IndexToItem(index)
            ShowNotification("Preparing ~b~" .. dish .. "~w~...")
        end
    end
end

function AddMenuFoodCount(menu)
    local amount = {}
    for i = 1, 100 do amount[i] = i end
    local newitem = NativeUI.CreateSliderItem("Quantity", amount, 1, false)
    menu:AddItem(newitem)
    menu.OnSliderChange = function(sender, item, index)
        if item == newitem then
            quantity = item:IndexToItem(index)
            ShowNotification("Preparing ~r~" .. quantity .. " ~b~" .. dish .. "(s)~w~...")
        end
    end
end

function AddMenuCook(menu)
    local newitem = NativeUI.CreateItem("Cook!", "Cook the dish with the appropriate ingredients and ketchup.")
    newitem:SetLeftBadge(BadgeStyle.Star)
    newitem:SetRightBadge(BadgeStyle.Tick)
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, index)
        if item == newitem then
            local string = "You have ordered ~r~" .. quantity .. " ~b~"..dish.."(s)~w~ ~r~with~w~ ketchup."
            if not ketchup then
                string = "You have ordered ~r~" .. quantity .. " ~b~"..dish.."(s)~w~ ~r~without~w~ ketchup."
            end
            ShowNotification(string)
        end
    end
    menu.OnIndexChange = function(sender, index)
        if sender.Items[index] == newitem then
            newitem:SetLeftBadge(BadgeStyle.None)
        end
    end
end

function AddMenuAnotherMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Another Menu")
    for i = 1, 20, 1 do
        submenu.SubMenu:AddItem(NativeUI.CreateItem("MRV le plus beau x)", ""))
    end
end

AddMenuKetchup(mainMenu)
AddMenuFoods(mainMenu)
AddMenuFoodCount(mainMenu)
AddMenuCook(mainMenu)
AddMenuAnotherMenu(mainMenu)
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