lib.callback.register("bm_rpchat:server:callback:isMuted", function(source, id)
    local isMuted = Player(id).state.bm_rpchat_muted
    return isMuted or false
end)

local ToggleMute = function(target, toggle)
    if not target then
        return
    end
    if type(target) ~= "number" then
        target = tonumber(target)
    end
    --
    Player(target).state.bm_rpchat_muted = toggle or false
end

local IsAdmin = function(id)
    for _, group in pairs(Config.staffCommand.groups) do
        local IsAceAllowed = IsPlayerAceAllowed(id, "command")
        if IsAceAllowed then
            return true
        end
    end

    return false
end

lib.callback.register("bm_rpchat:server:callback:IsAdmin", function(source)
    return IsAdmin(source)
end)

lib.callback.register("bm_rpchat:server:callback:DoesPlayerExist", function(source, target)
    local exists = GetPlayerName(target) and true or false
    return exists or false
end)

exports.chat:registerMessageHook(function(source, outMessage, hookRef)
    local msg = outMessage.args[2]
    if string.sub(msg, 1, 1) ~= "/" then
        hookRef.cancel()
    end
end)

local adminGroups = {}
for _, group in pairs(Config.staffCommand.groups) do
    adminGroups[#adminGroups + 1] = "group." .. group
end

if Config.staffCommand.silence.enabled then
    lib.addCommand(Config.staffCommand.silence.command, {
        restricted = adminGroups,
    }, function(src, args, raw)
        local target = args[1]
        if not GetPlayerName(target) then
            return TriggerClientEvent("bm_rpchat:client:Notification", src, Config.language.noID, "error", 4000)
        end

        if src == target then
            return TriggerClientEvent(
                "bm_rpchat:client:Notification",
                src,
                Config.language.cantSilenceSelf,
                "error",
                4000
            )
        end

        if IsAdmin(target) then
            return TriggerClientEvent(
                "bm_rpchat:client:Notification",
                src,
                Config.language.cantSilenceAdmin,
                "error",
                4000
            )
        end

        if Player(target).state.bm_rpchat_muted then
            return TriggerClientEvent(
                "bm_rpchat:client:Notification",
                src,
                Config.language.silencedAlready,
                "error",
                4000
            )
        end

        TriggerClientEvent(
            "bm_rpchat:client:Notification",
            src,
            string.format(Config.language.playerSilenced, GetPlayerName(target)),
            "success",
            4000
        )

        TriggerClientEvent("chat:clear", target)

        exports.chat:addMessage(target, {
            template = '<div class="mensajes"><span class="mensajes-titulo"></span><span class="mensajes-texto">{0}</span></div>',
            args = { Config.language.silenced },
        })

        ToggleMute(target, true)
    end)
end

if Config.staffCommand.unsilence.enabled then
    lib.addCommand(Config.staffCommand.unsilence.command, {
        restricted = adminGroups,
    }, function(src, args, raw)
        local target = args[1]
        if not GetPlayerName(target) then
            return TriggerClientEvent("bm_rpchat:client:Notification", src, Config.language.noID, "error", 4000)
        end

        if not Player(target).state.bm_rpchat_muted then
            return TriggerClientEvent("bm_rpchat:client:Notification", src, Config.language.notSilenced, "error", 4000)
        end

        TriggerClientEvent(
            "bm_rpchat:client:Notification",
            src,
            string.format(Config.language.playerUnsilenced, GetPlayerName(target)),
            "error",
            4000
        )

        exports.chat:addMessage(target, {
            template = '<div class="mensajes"><span class="mensajes-titulo"></span><span class="mensajes-texto">{0}</span></div>',
            args = { Config.language.unsilenced },
        })

        ToggleMute(target, false)
    end)
end

if Config.clearAllCommand.enable then
    lib.addCommand(Config.clearAllCommand.command, {
        restricted = adminGroups,
    }, function(src, args, raw)
        TriggerClientEvent("chat:clear", -1)
        exports.chat:addMessage(-1, {
            template = '<div class="mensajes"><span class="mensajes-titulo"></span><span class="mensajes-texto">{0}</span></div>',
            args = { Config.language.clearAll },
        })
    end)
end
