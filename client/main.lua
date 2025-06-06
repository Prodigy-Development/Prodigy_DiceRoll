local diceDisplaying = {}

local function Draw3DText(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local activeDiceDisplays = {}

RegisterNetEvent("Prodigy_DiceRoll:ShowDice", function(playerId, diceResults)
    local src = PlayerId()
    local myPed = PlayerPedId()
    if GetPlayerFromServerId(playerId) == src then
        -- Play animation for self
        loadAnimDict(Config.DiceAnimDict)
        TaskPlayAnim(myPed, Config.DiceAnimDict, Config.DiceAnimName, 8.0, 1.0, Config.DiceAnimDuration, 49, 0, 0, 0, 0)
        Citizen.Wait(Config.DiceAnimDuration)
        ClearPedTasks(myPed)
    end
    -- Store dice display for all players
    table.insert(activeDiceDisplays, {
        serverId = playerId,
        dice = diceResults,
        time = GetGameTimer() + Config.DisplayTime
    })
end)

-- Create floating NUI element above player's head
Citizen.CreateThread(function()
    while true do
        local now = GetGameTimer()
        local myPed = PlayerPedId()
        local myPos = GetEntityCoords(myPed)
        local activeDisplayIds = {}
        
        for i = #activeDiceDisplays, 1, -1 do
            local display = activeDiceDisplays[i]
            if now > display.time then
                -- Send message to hide this specific player's dice
                SendNUIMessage({
                    type = 'hideSpecificFloating',
                    id = display.serverId
                })
                table.remove(activeDiceDisplays, i)
            else
                local target = GetPlayerFromServerId(display.serverId)
                if target ~= -1 then
                    local ped = GetPlayerPed(target)
                    local pos = GetEntityCoords(ped)
                    local distance = #(myPos - pos)
                    
                    -- Only show dice if within reasonable distance (Config.MaxViewDistance)
                    if distance <= Config.MaxViewDistance then
                        local _, screenX, screenY = World3dToScreen2d(pos.x, pos.y, pos.z + 1.0)
                        if _ then
                            -- Calculate scale based on distance (closer = bigger, further = smaller)
                            local scale = math.max(0.3, 1.0 - (distance / Config.MaxViewDistance) * 0.7)
                            
                            -- Show floating NUI element for this player
                            SendNUIMessage({
                                type = 'showFloating',
                                dice = display.dice,
                                x = screenX,
                                y = screenY,
                                id = display.serverId,
                                scale = scale
                            })
                            table.insert(activeDisplayIds, display.serverId)
                        end
                    else
                        -- Hide dice if player is too far away
                        SendNUIMessage({
                            type = 'hideSpecificFloating',
                            id = display.serverId
                        })
                    end
                end
            end
        end
        
        Citizen.Wait(0)
    end
end)

RegisterCommand('rolldice', function(_, args)
    local num = tonumber(args[1]) or 1
    if num < 1 then num = 1 end
    if num > Config.MaxDice then num = Config.MaxDice end
    TriggerServerEvent('Prodigy_DiceRoll:RollDice', num)
end)

RegisterNUICallback('hide', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end
