local config = lib.load('config')
local loginAttempts = {}

local function debugPrint(...)
    print('^2[ACCOUNT_SERVER]^7', ...)
end

-- Очищення лічильників спроб
CreateThread(function()
    while true do
        Wait(600000)
        loginAttempts = {}
        debugPrint('Очищено лічильники спроб входу')
    end
end)

-- Реєстрація
lib.callback.register('qbx_account_system:server:register', function(source, data)
    debugPrint('Запит на реєстрацію від Source:', source)
    local license = GetPlayerIdentifierByType(source, 'license2')
    local discordId = GetPlayerIdentifierByType(source, 'discord')
    
    if not license then 
        debugPrint('ПОМИЛКА: Не вдалося отримати license2')
        return false, 'Не вдалося отримати ваш ідентифікатор.' 
    end
    
    -- Валідація
    if not data.username or #data.username < config.security.minUsernameLength then
        return false, ('Логін має бути не менше %d символів.'):format(config.security.minUsernameLength)
    end
    
    if not data.password or #data.password < config.security.minPasswordLength then
        return false, ('Пароль має бути не менше %d символів.'):format(config.security.minPasswordLength)
    end
    
    if not data.email or not data.email:match('.*@.*%..*') then
        return false, 'Невірний формат email.'
    end
    
    -- Перевірка унікальності
    local existingAccount = MySQL.single.await('SELECT id FROM accounts WHERE username = ? OR email = ?', {data.username, data.email})
    if existingAccount then
        return false, 'Акаунт з таким логіном або email вже існує.'
    end
    
    -- Хешування
    local bcrypt = require 'modules.bcrypt'
    local passwordHash = bcrypt.digest(data.password, nil, config.security.bcryptRounds)
    
    -- Збереження
    local accountId = MySQL.insert.await('INSERT INTO accounts (username, password_hash, email, discord_id) VALUES (?, ?, ?, ?)', {
        data.username, passwordHash, data.email, discordId
    })
    
    if not accountId then
        debugPrint('ПОМИЛКА БД: Не вдалося створити акаунт')
        return false, 'Помилка створення акаунту.'
    end
    
    debugPrint('Акаунт створено ID:', accountId)
    
    -- Прив'язка до гравця
    MySQL.update.await('UPDATE players SET account_id = ? WHERE license = ?', {accountId, license})
    
    return true, 'Акаунт успішно створено!', accountId
end)

-- Логін
lib.callback.register('qbx_account_system:server:login', function(source, data)
    debugPrint('Запит на вхід від Source:', source)
    local license = GetPlayerIdentifierByType(source, 'license2')
    if not license then return false, 'Не вдалося отримати ваш ідентифікатор.' end
    
    local attempts = loginAttempts[license] or 0
    if attempts >= config.security.maxLoginAttempts then
        return false, ('Забагато спроб. Спробуйте через %d хвилин.'):format(config.security.lockoutTime / 60)
    end
    
    local account = MySQL.single.await('SELECT id, password_hash FROM accounts WHERE username = ?', {data.username})
    if not account then
        loginAttempts[license] = attempts + 1
        debugPrint('Невірний логін (акаунт не знайдено). Спроба:', attempts + 1)
        return false, 'Невірний логін або пароль.'
    end
    
    local bcrypt = require 'modules.bcrypt'
    if not bcrypt.verify(data.password, account.password_hash) then
        loginAttempts[license] = attempts + 1
        debugPrint('Невірний пароль. Спроба:', attempts + 1)
        return false, 'Невірний логін або пароль.'
    end
    
    loginAttempts[license] = nil
    MySQL.update.await('UPDATE players SET account_id = ? WHERE license = ?', {account.id, license})
    
    debugPrint('Успішний вхід! Акаунт ID:', account.id)
    return true, 'Успішний вхід!', account.id
end)

-- Інші callback (recovery, reset) залишаються без змін, як у вашому коді...
-- (Для економії місця не дублюю, вони працюють, якщо БД вірна)

lib.callback.register('qbx_account_system:server:checkAccount', function(source)
    local license = GetPlayerIdentifierByType(source, 'license2')
    if not license then 
        debugPrint('checkAccount: Немає license')
        return false 
    end
    
    local account = MySQL.single.await('SELECT account_id FROM players WHERE license = ?', {license})
    local hasAccount = account and account.account_id ~= nil
    debugPrint('checkAccount Результат:', hasAccount)
    return hasAccount
end)

-- Подія для клієнта після успішної аутентифікації (якщо потрібно)
RegisterNetEvent('qbx_account_system:server:playerAuthenticated', function()
    local src = source
    debugPrint('Гравець авторизований на сервері, повідомляємо клієнта:', src)
    TriggerClientEvent('qbx_account_system:client:accountLoggedIn', src)
end)