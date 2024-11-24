Config = {}

Config.framework = 'qb' -- 'esx', 'qb'
--
Config.PMCommand = 'msg'
Config.PMColor = {
    send = 'rgb(204, 59, 217)',
    received = 'rgb(51, 212, 49)'
}
--
Config.ClearChat = 'clear'
Config.ClearChatAll = 'clearall'
--
Config.MuteCommand = 'silenciar'
Config.MuteMSGColor = 'rgb(252, 198, 3)'
--
Config.UnmuteCommand = 'desilenciar'
--
Config.AdminGroups = { 'god', 'admin' }
--
Config.Messages = {
    {
        command = 'me',                                    --comando del chat
        admin = false,                                     -- Si es un comando de administrador
        jobs = nil,                                        --Que trabajos pueden usar el comando. se usa con los siguientes formatos:un solo trabajo -> 'police' | multiples trabajos -> {'police', 'ambulance'}
        cooldown = nil,                                    --Tiempo de enfriamento para volver a usar el mensaje en segundos. nil para inhabilitar
        distance = 10,                                     --Distancia a la que se lee el mensaje
        title = 'Me',                                      --Titulo que sale al principio del mensaje
        price = nil,                                       --Precio para usar mensaje. nil para inhabilitar
        sound = false,                                     --Habilitar sonido del mensaje
        color = 'rgb(247, 42, 27)',                        --Color del titulo. Acepta cualquier formato de CSS. hex, rgb, keyword
        webhook = true,                                    -- Falta por hacer
        suggestions = {
            title = 'ME - mensaje para expresar acciones', --Descripcion del comando al escribirlo
            helpTexts = {
                {
                    name = 'mensaje',          --titulo del primer argumento
                    help = 'Texto del mensaje' --explicacion del primer argumento
                }
            }
        }
    },
    {
        command = 'do',
        admin = false,
        distance = 10,
        title = 'Do',
        sound = false,
        color = 'rgb(51, 87, 232)',
        suggestions = {
            title = 'DO - mensaje para describir entorno',
            helpTexts = {
                {
                    name = 'mensaje',
                    help = 'Texto del mensaje'
                }
            }
        }
    },
    {
        command = 'id',
        admin = false,
        title = 'Pedir ID',
        sound = false,
        color = '#8B93FF',
        suggestions = {
            title = 'ID - canal para pedir la id de alguien',
            helpTexts = {
                {
                    name = 'mensaje',
                    help = 'Texto del mensaje'
                }
            }
        }
    },
    {
        command = 'ooc',
        admin = false,
        distance = 15,
        title = '[ OOC ]',
        sound = false,
        color = 'rgb(145, 145, 145)',
        suggestions = {
            title = 'OCC - canal para hablar fuera de rol',
            helpTexts = {
                {
                    name = 'mensaje',
                    help = 'Texto del mensaje'
                }
            }
        }
    },
}

--
Config.AutoAnnounces = {
    enable = true,
    intervals = 30,
    color = 'rgb(195, 139, 0)',
    title = '🦁Kings🦁',
    texts = {
        "Para cualquier duda, bug o reporte usar /report",
        "Si no encuentras algo mira bien con el ojito (Alt)",
        'No conocer las normas no te libra de las consecuencias',
        'Usa el chat adecuadamente',
        'Revisa el canal de comandos-ic para facilitarte el juego'
    }
}

--
Config.DiceCommand = {
    enable = true,
    maxDices = 5,
    command = 'dados',
    distance = 10,
    color = 'rgb(195, 139, 0)',
    suggestions = {
        title = 'Dados - Lanza de 1 a 5 dados',
        helpTexts = {
            {
                name = 'dados',
                help = 'Número de dados'
            }
        }
    }
}

--
Config.TryCommand = {
    enable = true,
    command = 'suerte',
    distance = 10,
    color = 'rgb(252, 3, 123)',
    suggestions = {
        title = 'Suerte - Tienta tu suerte a 50% de posibilidad de acierto'
    }
}

--
Config.StaffChat = {
    enable = true,
    command = 'rstaff',
    color = 'rgb(3, 252, 227)',
    suggestions = {
        title = 'Staff - Canal privado solo para staff del servidor.',
        helpTexts = {
            {
                name = 'mensaje',
                help = 'Texto del mensaje'
            }
        }
    }
}

--
Config.ClearCommand = {
    enable = true,
    clearChat = 'clear',
    clearChatAll = 'clearall'
}
