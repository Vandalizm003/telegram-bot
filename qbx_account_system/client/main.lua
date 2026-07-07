local isUIOpen = false
local debugMode = true -- Увімкнути детальні логи

local function debugPrint(...)
    if debugMode then
        print('^3[ACCOUNT_CLIENT]^7', ...)
    end
end

-- Функція відкриття UI
local function OpenUI()
    if isUIOpen then 
        debugPrint('UI вже відкрито, ігноруємо запит.')
        return 
    end
    
    debugPrint('Відкриття UI...')
    isUIOpen = true
    
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()

    -- Агресивний фокус
    CreateThread(function()
        while isUIOpen do
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false, false)
            Wait(500) -- Кожні півсекунди нагадуємо FiveM, що фокус у нас
        end
    end)
    
    local config = lib.load('config')
    
    SendNUIMessage({
        action = 'open',
        serverName = config.ui.serverName or 'FiveM Server'
    })
    debugPrint('NUIMessage відправлено: open')
end

-- Функція закриття UI
local function CloseUI()
    if not isUIOpen then 
        debugPrint('UI вже закрито.')
        return 
    end
    
    debugPrint('Закриття UI...')
    isUIOpen = false
    
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    
    SendNUIMessage({ 
        action = 'close' 
    })
    debugPrint('NUIMessage відправлено: close')
end

-- Головна подія запуску системи логіну
RegisterNetEvent('qbx_account_system:client:showLoginUI', function()
    debugPrint('!!! ОТРИМАНО ПОДІЮ showLoginUI !!!')
    
    -- Невелика затримка, щоб уникнути конфліктів при спавні
    Wait(100)
    
    local success, hasAccount = pcall(function()
        return lib.callback.await('qbx_account_system:server:checkAccount', false)
    end)
    
    if not success then
        debugPrint('ПОМИЛКА перевірки акаунту:', hasAccount)
        return
    end
    
    debugPrint('Статус акаунту:', hasAccount and 'ІСНУЄ' or 'НЕ ІСНУЄ')
    
    -- Завжди відкриваємо UI для логіну/реєстрації
    debugPrint('Відкриваємо РЕЄСТРАЦІЮ/ВХІД')
    OpenUI()
end)

-- Подія успішного входу (після логіну/реєстрації)
AddEventHandler('qbx_account_system:client:accountLoggedIn', function()
    debugPrint('!!! ОТРИМАНО ПОДІЮ accountLoggedIn !!!')
    
    if isUIOpen then
        debugPrint('Закриваємо UI перед вибором персонажа...')
        CloseUI()
        Wait(500) -- Чекаємо поки NUI повністю зникне, щоб уникнути конфліктів фокусу
    end
    
    debugPrint('Спроба відкрити вибір персонажів (dd-characters)...')
    
    -- Плавно показуємо екран, якщо він був затемнений (від ShutdownLoadingScreen)
    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
    end
    
    -- Викликаємо ініціалізацію безпосередньо dd-characters
    TriggerEvent('dd-characters:client:open')
end)

-- NUI Callbacks
RegisterNUICallback('register', function(data, cb)
    debugPrint('Отримано запит на реєстрацію з UI')
    local success, message, accountId = lib.callback.await('qbx_account_system:server:register', false, data)
    
    cb({ success = success, message = message })
    
    if success then
        debugPrint('Реєстрація успішна, закриваємо UI')
        CloseUI()
        -- Не викликаємо одразу персонажів, чекаємо на серверну подію або робимо це тут
        Wait(200)
        TriggerEvent('qbx_account_system:client:accountLoggedIn')
    end
end)

RegisterNUICallback('login', function(data, cb)
    debugPrint('Отримано запит на вхід з UI')
    local success, message, accountId = lib.callback.await('qbx_account_system:server:login', false, data)
    
    cb({ success = success, message = message })
    
    if success then
        debugPrint('Вхід успішний, закриваємо UI')
        CloseUI()
        Wait(200)
        TriggerEvent('qbx_account_system:client:accountLoggedIn')
    end
end)

RegisterNUICallback('requestRecovery', function(data, cb)
    debugPrint('Запит на відновлення паролю')
    local success, message = lib.callback.await('qbx_account_system:server:requestRecovery', false, data.discordId)
    cb({ success = success, message = message })
end)

RegisterNUICallback('resetPassword', function(data, cb)
    debugPrint('Запит на скидання паролю')
    local success, message = lib.callback.await('qbx_account_system:server:resetPassword', false, data)
    cb({ success = success, message = message })
    if success then CloseUI() end
end)

RegisterNUICallback('close', function(data, cb)
    debugPrint('Користувач натиснув закрити в UI')
    CloseUI()
    cb({})
end)

-- Тестова команда для адміністраторів
RegisterCommand('test_account_ui', function(source, args, rawCommand)
    if source == 0 then return end -- Тільки з клієнта
    debugPrint('Команда тесту UI викликана вручну')
    OpenUI()
end, false)


-- Запускаємо UI при першому вході гравця на сервер (до вибору персонажа)
CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(100)
    end
    debugPrint('Сесія почалася. Запускаємо перевірку акаунту...')
    
    -- Затримка для стабілізації завантаження та перехоплення фокусу
    Wait(2000) 
    TriggerEvent('qbx_account_system:client:showLoginUI')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    -- Ця подія спрацьовує ПІСЛЯ вибору персонажа.
    -- Логін/реєстрація тут вже не потрібні, тому залишаємо порожньою або для інших цілей.
    debugPrint('QBCore повідомив про завантаження гравця (персонаж вже вибраний).')
end)