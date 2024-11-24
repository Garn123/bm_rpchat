if Config.AutoAnnounces.enable then
    CreateThread(function()
        while true do
            local random = math.random(1, #Config.AutoAnnounces.texts)
            exports.chat:addMessage(-1, {
                template =
                '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = { Config.AutoAnnounces.color, Config.AutoAnnounces.title, Config.AutoAnnounces.texts[random] }
            })
            Wait((Config.AutoAnnounces.intervals * 60) * 1000)
        end
    end)
end

for _, msg in pairs(Config.Messages) do
    RegisterCommand(msg.command, function(source, args, rawCommand)
        local message = rawCommand:sub(string.len(msg.command) + 1)
        if string.len(message) < 1 then return end
        --
        local muted = IsPlayerMuted(source)
        if muted then return end
        --
        if msg.admin then
            if not IsAdmin(source) then return end
        end
        --
        if msg.cooldown then
            if IsCooldownActive(source) then
                return Notification(source, Lang.cooldown, 'error', 3000)
            else
                SetCooldown(msg.cooldown, source)
            end
        end
        --
        if msg.price then
            if not PayFee(source, msg.price) then return end
        end
        --
        local targets = {}
        local sCoords = GetEntityCoords(GetPlayerPed(source))

        if msg.jobs then
            local targets = TargetPlayers(sCoords, msg.distance, msg.jobs)
        else
            local targets = TargetPlayers(sCoords, msg.distance)
        end

        if #targets == 0 then
            targets[#targets + 1] = source
        end
        --
        for _, id in pairs(targets) do
            exports.chat:addMessage(id, {
                template =
                '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">[ {1} ] {2}:</span><span class="mensajes-texto">{3}</span></div>',
                args = { msg.color, source, msg.title, message }
            })
            --
            if msg.sound then
                TriggerClientEvent('bm_rpchat:PlaySound', id)
            end
        end
    end, false)
end

RegisterCommand(Config.MuteCommand, function(source, args, rawCommand)
    if not IsAdmin(source) then return end
    local target = tonumber(args[1])
    if not target then
        return Notification(source, Lang.noId, 'error', 3000)
    end
    --
    if IsAdmin(target) then
        return Notification(source, Lang.cantMuteAdmin, 'error', 3000)
    end
    --
    if mutedPlayers[target] then
        return Notification(source, Lang.alreadyMuted, 'error', 3000)
    end
    --
    if not DoesPlayerExist(target) then
        return Notification(source, Lang.idNoExist, 'error', 3000)
    end
    --
    mutedPlayers[#mutedPlayers + 1] = target
    --
    Notification(source, GetPlayerName(source) .. ' ' .. Lang.mutedPlayer, 'success', 6000)
    Notification(target, Lang.muted, 'info', 6000)
end, false)

RegisterCommand(Config.UnmuteCommand, function(source, args, rawCommand)
    if not IsAdmin(source) then return end
    local target = tonumber(args[1])
    if not target then
        return Notification(source, Lang.noId, 'error', 3000)
    end
    --
    if IsAdmin(target) then
        return Notification(source, Lang.cantMuteAdmin, 'error', 3000)
    end
    --
    if not mutedPlayers[target] then
        return Notification(source, Lang.alreadyUnmuted, 'error', 3000)
    end
    --
    if not DoesPlayerExist(target) then
        return Notification(source, Lang.idNoExist, 'error', 3000)
    end
    --
    mutedPlayers[target] = nil
    --
    Notification(source, GetPlayerName(source) .. ' ' .. Lang.unmutedPlayer, 'success', 6000)
    Notification(target, Lang.unmuted, 'info', 6000)
end, false)

RegisterCommand(Config.PMCommand, function(source, args, rawCommand)
    local muted = IsPlayerMuted(source)
    if muted then return end
    local target = tonumber(args[1])
    --
    if not DoesPlayerExist(target) then
        return Notification(source, Lang.plydisconnected, 'error', 3000)
    end

    local message = rawCommand:sub(string.len(Config.PMCommand) + 3 + string.len(tostring(source)))
    if string.len(message) < 1 then return end
    --
    exports.chat:addMessage(target, {
        template =
        '<div class="mensajes"><span class="mensajes-titulo" style="color:{0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
        args = { Config.PMColor.received, Lang.pmFrom .. '[ ' .. source .. ' ]', message }
    })
    TriggerClientEvent('bm_rpchat:PlaySound', target)
    --
    exports.chat:addMessage(source, {
        template =
        '<div class="mensajes"><span class="mensajes-titulo" style="color:{0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
        args = { Config.PMColor.send, Lang.pmTo .. '[ ' .. source .. ' ]', message }
    })
end, false)

if Config.DiceCommand.enable then
    RegisterCommand(Config.DiceCommand.command, function(source, args)
        local amount = tonumber(args[1]) or 1
        if type(amount) ~= 'number' then return end
        if not amount or amount < 1 then amount = 1 end
        if amount > Config.DiceCommand.maxDices then amount = Config.DiceCommand.maxDices end
        --
        local sides = {
            [1] = 'fas fa-dice-one',
            [2] = 'fas fa-dice-two',
            [3] = 'fas fa-dice-three',
            [4] = 'fas fa-dice-four',
            [5] = 'fas fa-dice-five',
            [6] = 'fas fa-dice-six',
        }

        local dices = ''
        for i = 1, amount, 1 do
            local text = '<i class="' .. sides[math.random(1, 6)] .. ' dice"></i>'
            dices = dices .. text
        end
        --
        local coords = GetEntityCoords(GetPlayerPed(source))
        local targets = GetPlayersInRange(coords, Config.DiceCommand.distance)
        for _, target in pairs(targets) do
            TriggerClientEvent('chat:addMessage', target, {
                template =
                    '<div class="dados"><div class="mensajes-titulo" style="color:' ..
                    Config.DiceCommand.color ..
                    ';> </div><div class="mensajes-texto dices">' ..
                    '[ ' .. source .. ' ]' .. Lang.dicesTitle .. ':' .. dices .. '</div></div>',
                args = {}
            })
        end
    end, false)
end

if Config.StaffChat.enable then
    RegisterCommand(Config.StaffChat.command, function(source, args, rawCommand)
        local message = rawCommand:sub(string.len(Config.StaffChat.command) + 1)
        if string.len(message) <= 1 then return end
        local senderName = GetPlayerName(source)

        for _, id in pairs(GetPlayers()) do
            if IsAdmin(id) then
                exports.chat:addMessage(id, {
                    template =
                    '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                    args = { Config.StaffChat.color, '[ ' .. senderName .. ' ]' .. ' ' .. Lang.staffChat, message }
                })
                TriggerClientEvent('gny_rpchat:PlaySound', id)
            end
        end
    end)
end

if Config.TryCommand.enable then
    RegisterCommand(Config.TryCommand.command, function(source)
        local options = {
            [1] = Lang.trySuccess,
            [2] = Lang.tryFailure
        }

        local coords = GetEntityCoords(GetPlayerPed(source))
        local targets = GetPlayersInRange(coords, Config.TryCommand.distance)
        local result = options[math.random(1, 2)]
        for _, target in pairs(targets) do
            exports.chat:addMessage(target, {
                template =
                '<div class="mensajes"><span class="mensajes-titulo" style="color:{0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = { Config.TryCommand.color, '[' .. source .. ']' .. ' ' .. Lang.tryCommand, result }
            })
        end
    end, false)
end

if Config.ClearCommand.enable then
    RegisterCommand(Config.ClearCommand.clearChat, function(source)
        TriggerClientEvent('chat:clear', source)
    end)

    RegisterCommand(Config.ClearCommand.clearChatAll, function(source)
        if not IsAdmin(source) then return end
        local players = GetPlayers()
        for _, id in pairs(players) do
            TriggerClientEvent('chat:clear', id)
            exports.chat:addMessage(id, {
                template =
                '<div class="mensajes"><span class="mensajes-titulo"></span><span class="mensajes-texto">{0}</span></div>',
                args = { Lang.allChatCleared }
            })
        end
    end)
end
