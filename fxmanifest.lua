fx_version 'cerulean'
game 'gta5'

name 'Prodigy_DiceRoll'
description 'Standalone Dice Rolling Minigame'
author 'Prodigy Developments'
version '1.0'

client_scripts {
    'client/main.lua',
    'config.lua'
}
server_scripts {
    'server/main.lua',
    'config.lua'
}

ui_page 'client/ui/index.html'

files {
    'client/ui/index.html',
    'client/ui/script.js',
    'client/ui/style.css',
    'client/ui/dice_1.png',
    'client/ui/dice_2.png',
    'client/ui/dice_3.png',
    'client/ui/dice_4.png',
    'client/ui/dice_5.png',
    'client/ui/dice_6.png'
}
