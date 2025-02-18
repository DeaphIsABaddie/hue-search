local detect = 3
local near = false

local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for prop, _ in pairs(Config.Props) do
            local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 10.0, GetHashKey(prop), false, false, false)

            if DoesEntityExist(object) then
                local objcoords = GetEntityCoords(object)
                local distance = #(coords - objcoords)

                if distance < detect then
                    if not near then
                        near = true

                        exports['qb-target']:AddTargetEntity(object, {
                            options = {
                                {
                                    type = "client",
                                    event = "hue-search:client:trash",
                                    icon = "fa-solid fa-trash",
                                    label = "Search Bin"
                                }
                            },
                            distance = 2.0
                        })
                    end
                end
            end
        end

        if not near then
            near = false
            exports['qb-target']:RemoveTargetEntity(object)
        end
    end
end)

RegisterNetEvent('hue-search:client:trash', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local close = false
    local id = nil

    for prop, _ in pairs(Config.Props) do
        local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 10.0, GetHashKey(prop), false, false, false)

        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)
            local distance = #(coords - objCoords)

            if distance < 3.0 then
                close = true

                id = NetworkGetNetworkIdFromEntity(object)

                break
            end
        end
    end

    if close then
        if IsPedInAnyVehicle(ped, false) then
            QBCore.Functions.Notify("You cannot do this whilst in a vehicle", "error", 3000)
        else
            QBCore.Functions.Progressbar('search', 'Searching trash...', 5000, false, true, {
                disablemovement = true,
                disablecarmovement = true,
                disablemouse = false,
                disablecombat = true,
            }, {
                dict = "amb@prop_human_bum_bin@enter",
                anim = "enter",
                flags = 50,
            }, {}, {}, function()
                ClearPedTasks(ped)
                print(id)
                TriggerServerEvent("hue-search:server:loot", id)
            end, function()
                ClearPedTasks(ped)
                print("Search canceled!")
            end)
        end
    else
        QBCore.Functions.Notify("No bin nearby to search", "error")
    end
end)
