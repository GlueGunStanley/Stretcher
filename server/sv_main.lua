
     --[[ STANLEY DEVELOPMENT STUDIOS ]]--
--[[ https://discord.com/invite/uCKZJed3Gq ]]--

 
local stretchers = {}

RegisterNetEvent('sv:AddStretcherToTable')
AddEventHandler('sv:AddStretcherToTable', function(netId)
    if netId then
        stretchers[netId] = { moving = false, sitting = false}
        TriggerClientEvent('cl:SyncStretchers', -1, stretchers)
        if Config.Debug.messages then
            print("Stretcher added with network ID: " .. netId)
        end
    elseif Config.Debug.messages then
        print("Invalid network ID provided.")
    end
end)

RegisterNetEvent('sv:SetMovingState')
AddEventHandler('sv:SetMovingState', function(netId, bool)
    if netId and stretchers[netId] then
        stretchers[netId].moving = bool
        TriggerClientEvent('cl:SyncMovingState', -1, netId, bool)
        if Config.Debug.messages then
            print("Moving bool for stretcher with network ID " .. netId .. " set to " .. tostring(bool))
        end
    elseif Config.Debug.messages then
        print("Invalid network ID or stretcher not found.")
    end
end)

RegisterNetEvent('sv:SetSittingState')
AddEventHandler('sv:SetSittingState', function(netId, bool)
    if netId and stretchers[netId] then
        stretchers[netId].sitting = bool
        TriggerClientEvent('cl:SyncSittingState', -1, netId, bool)
        if Config.Debug.messages then
            print("Sitting bool for stretcher with network ID " .. netId .. " set to " .. tostring(bool))
        end
    elseif Config.Debug.messages then
        print("Invalid network ID or stretcher not found.")
    end
end)

RegisterNetEvent('sv:RemoveStretcherFromTable')
AddEventHandler('sv:RemoveStretcherFromTable', function(netId)
    if netId and stretchers[netId] then
        stretchers[netId] = nil
        TriggerClientEvent('cl:RemoveStretcherFromTable', -1, netId)
        if Config.Debug.messages then
            print("Stretcher with network ID " .. netId .. " removed")
        end
    elseif Config.Debug.messages then
        print("Invalid network ID or stretcher not found.")
    end
end)

RegisterServerEvent('sv:ToggleVehicleDoors')
AddEventHandler('sv:ToggleVehicleDoors', function(netId, fld, frd, bld, brd, hood, trunk, rld, rrd)
    TriggerClientEvent('cl:SyncVehicleDoors', -1, netId, fld, frd, bld, brd, hood, trunk, rld, rrd)
end)

AddEventHandler('playerConnecting', function()
    local playerId = source
    TriggerClientEvent('cl:SyncStretchers', playerId, stretchers)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerClientEvent('cl:StretcherCleanUp', -1)
        if Config.Debug.messages then
            print(resourceName .. " has started.")
        end
    end
end)













