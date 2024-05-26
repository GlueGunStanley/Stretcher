
     --[[ STANLEY DEVELOPMENT STUDIOS ]]--
--[[ https://discord.com/invite/uCKZJed3Gq ]]--

 
local MenuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu("Stretcher", "", 1250, 400)
MenuPool:Add(mainMenu)

local equipmentMenu = MenuPool:AddSubMenu(mainMenu, "Equipment", "Access various equipment", 1250, 400)
local seatMenu = MenuPool:AddSubMenu(mainMenu, "Use", "Use the stretcher", 1250, 400)

local background = Sprite.New('background', 'background', 0, 0, 0, 0)
mainMenu:SetBannerSprite(background, true)
equipmentMenu:SetBannerSprite(background, true)
seatMenu:SetBannerSprite(background, true)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if MenuPool:IsAnyMenuOpen() then
            MenuPool:ProcessMenus()
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Wait(100) -- This short delay is required for the state value to be returned properly

        if (mainMenu:Visible() or equipmentMenu:Visible() or seatMenu:Visible()) then
            local stretcherObject = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
            if stretcherObject then
                local movingState = CheckMovingState(GetVehicleNetId(stretcherObject))
                if movingState then
                    if Config.Debug.messages then
                    print("The stretcher has started moving! Closing menu.")
                    end
                    mainMenu:Visible(false)
                    equipmentMenu:Visible(false)
                    seatMenu:Visible(false)
                elseif #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(stretcherObject)) > 3.0 then
                    if Config.Debug.messages then
                    print("Player moved away from the stretcher! Closing menu.")
                    end
                    mainMenu:Visible(false)
                    equipmentMenu:Visible(false)
                    seatMenu:Visible(false)
                end
            end
        end
    end
end)

-- ADD ITEMS TO THE EQUIPMENT MENU
function AddEquipmentItems(menu)
    local item1a = NativeUI.CreateItem("Headrest", "Toggle the headrest up or down")
    item1a.Activated = function(parentMenu, selectedItem)
        TriggerEvent("ToggleHeadrest")
    end
    menu:AddItem(item1a)

    local item2a = NativeUI.CreateItem("Backboard", "Toggle backboard")
    item2a.Activated = function(parentMenu, selectedItem)
        TriggerEvent("ToggleBackboard")
    end
    menu:AddItem(item2a)

    local item3a = NativeUI.CreateItem("Monitor", "Toggle monitor")
    item3a.Activated = function(parentMenu, selectedItem)
        TriggerEvent("ToggleMonitor")
    end
    menu:AddItem(item3a)

    local item4a = NativeUI.CreateItem("Red Bag", "Toggle red bag")
    item4a.Activated = function(parentMenu, selectedItem)
        TriggerEvent("ToggleRedBag")
    end
    menu:AddItem(item4a)

    local item5a = NativeUI.CreateItem("Blue Bag", "Toggle blue bag")
    item5a.Activated = function(parentMenu, selectedItem)
        TriggerEvent("ToggleBlueBag")
    end
    menu:AddItem(item5a)
end
AddEquipmentItems(equipmentMenu)

-- ADD ITEMS TO THE SEAT MENU
function AddSeatItems(menu)
    local item11b = NativeUI.CreateItem("Get up", "Get up off of the stretcher")
    item11b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherGetUp")
    end
    menu:AddItem(item11b)

    local item0b = NativeUI.CreateItem("Recieve CPR", "Recieve CPR on the stretcher")
    item0b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherReceiveCPR")
    end
    menu:AddItem(item0b)
    
    local item1b = NativeUI.CreateItem("Sit Right", "Sit on the right side of the stretcher")
    item1b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherSitRight")
    end
    menu:AddItem(item1b)

    local item2b = NativeUI.CreateItem("Sit Left", "Sit on the right side of the stretcher")
    item2b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherSitLeft")
    end
    menu:AddItem(item2b)

    local item3b = NativeUI.CreateItem("Sit End", "Sit on the end of the stretcher")
    item3b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherSitEnd")
    end
    menu:AddItem(item3b)

    local item4b = NativeUI.CreateItem("Sit Upright", "Sit upright on the stretcher")
    item4b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherSitUpright")
    end
    menu:AddItem(item4b)

    local item8b = NativeUI.CreateItem("Sit Upright Legs Crossed", "Sit upright on the stretcher with legs crossed")
    item8b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherSitUprightLegsCrossed")
    end
    menu:AddItem(item8b)

    local item9b = NativeUI.CreateItem("Sit Upright Knees Tucked", "Sit upright on the stretcher with knees tucked")
    item9b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherSitUprightKneesTucked")
    end
    menu:AddItem(item9b)

    local item5b = NativeUI.CreateItem("Lie Left", "Lie left on the stretcher")
    item5b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherLieLeft")
    end
    menu:AddItem(item5b)

    local item6b = NativeUI.CreateItem("Lie Back", "Lie back on the stretcher")
    item6b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherLieBack")
    end
    menu:AddItem(item6b)

    local item12b = NativeUI.CreateItem("Lie Prone", "Lie prone on the stretcher")
    item12b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherLieProne")
    end
    menu:AddItem(item12b)

    local item7b = NativeUI.CreateItem("Lie Upright", "Lie upright on the stretcher")
    item7b.Activated = function(parentMenu, selectedItem)
        TriggerEvent("StretcherLieUpright")
    end
    menu:AddItem(item7b)
end
AddSeatItems(seatMenu)

Citizen.CreateThread(function()
while IsPedOnFoot(PlayerPedId()) do
    Wait(0)
    if IsControlJustReleased(0, Config.Keys.menu) then
        TriggerEvent("cl:OpenStretcherMenu")
        end
    end
end)

AddEventHandler("cl:OpenStretcherMenu", function()
    local stretcherObject = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(Config.Stretcher.modelHash), 70)
    
    if not DoesEntityExist(stretcherObject) then
        UTIL.Notify("~y~No stretcher nearby!")
        return 
    end

    local movingState = CheckMovingState(GetVehicleNetId(stretcherObject))
    if movingState then
        UTIL.Notify("~y~You can't open the menu while the stretcher is loaded or moving!")
        return
    else
        mainMenu:Visible(true)
    end
end)









