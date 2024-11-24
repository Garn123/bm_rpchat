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

        end
        --
        if msg.price then
            if not PayFee(source, msg.price) then return end
        end

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
    end)
end
