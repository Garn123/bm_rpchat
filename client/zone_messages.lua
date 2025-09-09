local cdTable = {}
local cdStarted = false

CooldownHandle = function()
    if cdStarted then
        return
    end
    cdStarted = true
    CreateThread(function()
        while #cdTable > 0 do
            for key, time in pairs(cdTable) do
                cdTable[key] = cdTable[key] - 1
                if cdTable[key] < 1 then
                    cdTable[key] = nil
                end
            end
            Wait(1000)
        end
        cdStarted = false
    end)
end

CreateThread(function()
    for key, data in pairs(Config.ZoneMessages) do
        local point = lib.points.new({
            coords = data.coords,
            distance = data.radius,
        })

        function point:onEnter()
            if cdTable[key] then
                return
            end
            --
            cdTable[key] = data.cooldown
            CooldownHandle()
            --
            exports.chat:addMessage({
                template = '<div class="mensajes"><span class="mensajes-titulo" style="color: {0};">{1}:</span><span class="mensajes-texto">{2}</span></div>',
                args = {
                    "#b22222",
                    Config.language.zoneMessage,
                    data.message,
                },
            })
        end
    end
end)
