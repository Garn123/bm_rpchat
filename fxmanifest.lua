fx_version("cerulean")

game("gta5")
lua54("yes")
version("1.0.0")

author("_garny")

description("BiggaMods RP Chat")

client_scripts({
    "client/*.lua",
})

server_scripts({
    "server/*.lua",
})

shared_scripts({
    "@ox_lib/init.lua",
    "shared/*.lua",
})

files({
    "nui/style.css",
})

chat_theme("gtao")({
    styleSheet = "nui/style.css",
    msgTemplates = {
        default = "<b>{0}</b><span>: {1}</span>",
    },
})

dependency("ox_lib")
