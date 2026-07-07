fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Обов'язкові залежності
dependencies {
    'ox_lib',
    'oxmysql',
    'qbx_core'
}

-- Спільні файли (Завантажуються і сервером, і клієнтом)
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

-- Клієнтські файли
client_scripts {
    'client/main.lua'
}

-- Серверні файли
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/bcrypt.lua',
    'server/main.lua'
}

-- Налаштування інтерфейсу (UI)
ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/content.png' -- Якщо у вас є картинки в цій папці
}