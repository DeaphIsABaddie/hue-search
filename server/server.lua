local QBCore = exports['qb-core']:GetCoreObject()

local cooldowns = {}

RegisterNetEvent("hue-search:server:loot", function(binId)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if cooldowns[id] and cooldowns[id] > os.time() then
        local remaining = cooldowns[id] - os.time()
        QBCore.Functions.Notify(src, "This bin is empty!", "error")
        return
    end

    if player then
        player.Functions.AddItem('rolex', 1)

        TriggerClientEvent('QBCore:Notify', src, "You found something!", "success")

        cooldowns[id] = os.time() + 1500

        TriggerClientEvent("hue-search:client:cooldown", -1, id, cooldowns[id])
    end
end)

RegisterNetEvent("hue-search:client:cooldown", function(id, time)
    cooldowns[id] = time
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute to clean up expired cooldowns
        for id, cooldown in pairs(cooldowns) do
            if cooldown <= os.time() then
                cooldowns[id] = nil
            end
        end
    end
end)
