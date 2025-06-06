RegisterCommand('rolldice', function(source, args, _)
    local num = tonumber(args[1]) or 1
    if num < 1 then num = 1 end
    if num > Config.MaxDice then num = Config.MaxDice end
    local results = {}
    for i = 1, num do
        table.insert(results, math.random(1, 6))
    end
    TriggerClientEvent('Prodigy_DiceRoll:ShowDice', -1, source, results)
end, false)

RegisterNetEvent('Prodigy_DiceRoll:RollDice', function(num)
    local src = source
    if num < 1 then num = 1 end
    if num > Config.MaxDice then num = Config.MaxDice end
    local results = {}
    for i = 1, num do
        table.insert(results, math.random(1, 6))
    end
    TriggerClientEvent('Prodigy_DiceRoll:ShowDice', -1, src, results)
end)
