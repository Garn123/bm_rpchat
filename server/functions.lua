--lang = require('shared.lang')

if Config.framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end
--
local mutedPlayers = {}
--
Notification = function(src, msg, type, time)
    TriggerClientEvent('bm_rpchat:Notification', src, msg, type, time)
end

IsPlayerMuted = function(id)
    for _, player in pairs(mutedPlayers) do
        if player == id then
            exports.chat:addMessage(playerId, {
                template =
                '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = { Config.MuteMSGColor, lang.muteMsg, lang.mutedText }
            })
            return true
        end
    end
    --
    return false
end

IsAdmin = function(id)
    if Config.framework == 'esx' then
        local player = ESX.GetPlayerFromId(id)
        local plyGroup = player.getGroup()
        for _, group in pairs(Config.AdminGroups) do
            if group == plyGroup then return true end
        end
    elseif Config.framework == 'qb' then
        for _, group in pairs(Config.AdminGroups) do
            local hasPerms = QBCore.Functions.HasPermission(id, group)
            local IsAceAllowed = IsPlayerAceAllowed(id, 'command')
            if hasPerms or IsAceAllowed then return true end
        end
    end
    --
    return false
end

GetPlayersInRange = function(coords, maxDistance)
    local inRangePlayers = {}
    --
    for _, id in pairs(GetPlayers()) do
        local pCoords = GetEntityCoords(GetPlayerPed(tonumber(id)))
        local distance = #(coords - pCoords)
        if not maxDistance or distance <= maxDistance then
            inRangePlayers[#inRangePlayers + 1] = id
        end
    end
    --
    return inRangePlayers
end

TargetPlayers = function(coords, maxDistance, jobs)
    local playerList = GetPlayersInRange(coords, maxDistance)
    if jobs then
        local targetList = {}
        --
        if Config.framework == 'esx' then
            if type(jobs) == 'table' then
                for _, id in pairs(playerList) do
                    local player = ESX.GetPlayerFromId(id)
                    for _, job in pairs(jobs) do
                        if player.job.name == job then
                            targetList[#targetList + 1] = id
                        end
                    end
                end
            elseif type(jobs) == 'string' then
                for _, id in pairs(playerList) do
                    local player = ESX.GetPlayerFromId(id)
                    if player.job.name == jobs then
                        targetList[#targetList + 1] = id
                    end
                end
            end
        elseif Config.framework == 'qb' then
            if type(jobs) == 'table' then
                for _, id in pairs(playerList) do
                    local player = QBCore.Functions.GetPlayer(id)
                    for _, job in pairs(jobs) do
                        if player.PlayerData.job.name == job then
                            targetList[#targetList + 1] = id
                        end
                    end
                end
            elseif type(jobs) == 'string' then
                for _, id in pairs(playerList) do
                    local player = QBCore.Functions.GetPlayer(id)
                    if player.PlayerData.job.name == jobs then
                        targetList[#targetList + 1] = id
                    end
                end
            end
        end
        --
        return targetList
    else
        return playerList
    end
end

PayFee = function(id, price)
    if Config.framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(id)
        local money = xPlayer.getAccount('bank')
        if money >= price then
            xPlayer.removeAccountMoney('bank', price)
            Notification(id, lang.paid, 'success', 3000)
            return true
        end
    elseif Config.framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(id)
        local money = Player.PlayerData.money.bank
        if money >= price then
            Player.Functions.RemoveMoney('bank', price)
            Notification(id, lang.paid, 'success', 3000)
            return true
        end
    end
    --
    Notification(id, lang.noMoney, 'error', 3000)
    return false
end
