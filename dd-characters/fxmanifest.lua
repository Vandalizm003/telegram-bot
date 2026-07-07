fx_version 'cerulean'
game 'gta5'

name 'dd-characters'
author 'ddainusshaa'
description 'DD Characters — multicharacter system for Qbox'
version '1.0.0'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

ox_lib 'locale'

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**',
    'locales/*.json',
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'data/shared.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'data/client.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/server.lua',
    'data/starters.lua',
    'data/codex.lua',
    'data/pulse.lua',
    'server/characters.lua',
    'server/starter.lua',
    'server/validation.lua',
    'server/main.lua',
}

dependencies {
    'ox_lib',
    'oxmysql',
    'qbx_core',
}
