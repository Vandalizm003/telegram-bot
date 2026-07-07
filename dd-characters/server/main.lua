lib.callback.register('dd-characters:server:getCharacters', function(source)
    local license2, license = DdCharacters.getLicenses(source)
    return DdCharacters.fetchAll(license2, license), DdCharacters.getMaxSlots(license2, license)
end)

lib.callback.register('dd-characters:server:getPreviewPedData', function(_, citizenId)
    local ped = MySQL.single.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = 1', { citizenId })
    if not ped then return end

    return ped.skin, ped.model and joaat(ped.model)
end)

lib.callback.register('dd-characters:server:loadCharacter', function(source, citizenId)
    local success = exports.qbx_core:Login(source, citizenId)
    if not success then return false end

    lib.print.info(('%s (Citizen ID: %s) has successfully loaded!'):format(GetPlayerName(source), citizenId))
    return true
end)

---@param data table
---@return table? newData
lib.callback.register('dd-characters:server:createCharacter', function(source, data)
    if type(data) ~= 'table' or DdCharacters.isAtLimit(source) then
        return
    end

    data.phone = nil
    data.account = nil

    local newData = { charinfo = data }
    local success = exports.qbx_core:Login(source, nil, newData)
    if not success then return end

    DdGiveStarterItems(source)

    local player = exports.qbx_core:GetPlayer(source)
    if player then
        newData.citizenid = player.PlayerData.citizenid
    end

    lib.print.info(('%s has created a character'):format(GetPlayerName(source)))
    return newData
end)

lib.callback.register('dd-characters:server:deleteCharacter', function(source, citizenId)
    if not DdCharacters.ownsCharacter(source, citizenId) then
        return false
    end

    exports.qbx_core:DeleteCharacter(citizenId)
    return true
end)

lib.callback.register('dd-characters:server:validateCreate', function(source, payload)
    if DdCharacters.isAtLimit(source) then
        return false, locale('notify.character_limit')
    end

    local valid, errorKey = DdValidateCreatePayload(payload)
    if not valid then
        return false, locale(errorKey)
    end

    return true
end)

lib.callback.register('dd-characters:server:afterCreate', function(source, payload)
    local player = exports.qbx_core:GetPlayer(source)

    if player and type(payload) == 'table' then
        if payload.backstory and player.Functions and player.Functions.SetMetaData then
            player.Functions.SetMetaData('backstory', payload.backstory)
        end

        if payload.height and player.Functions and player.Functions.SetMetaData then
            player.Functions.SetMetaData('height', payload.height)
        end
    end

    return true
end)

lib.callback.register('dd-characters:server:setCharacterBucket', function(source)
    pcall(function()
        exports.qbx_core:SetPlayerBucket(source, source)
    end)

    return true
end)

lib.callback.register('dd-characters:server:setWorldBucket', function(source)
    exports.qbx_core:SetPlayerBucket(source, 0)
    return true
end)

lib.callback.register('dd-characters:server:getCodex', function()
    if not DdSharedConfig.enableCodex then
        return { sections = {} }
    end

    return { sections = DdCodexConfig.sections }
end)

lib.callback.register('dd-characters:server:getPulse', function()
    if not DdSharedConfig.enablePulse then
        return {
            station = DdPulseConfig.station,
            frequency = DdPulseConfig.frequency,
            tagline = DdPulseConfig.tagline,
            items = {},
        }
    end

    local items = {}
    local now = os.date('!%Y-%m-%dT%H:%M:%S.000Z')

    for i = 1, #DdPulseConfig.items do
        local item = DdPulseConfig.items[i]
        items[#items + 1] = {
            id = item.id,
            type = item.type,
            headline = item.headline,
            body = item.body,
            timestamp = item.timestamp or now,
            source = item.source,
        }
    end

    return {
        station = DdPulseConfig.station,
        frequency = DdPulseConfig.frequency,
        tagline = DdPulseConfig.tagline,
        items = items,
    }
end)

RegisterNetEvent('dd-characters:server:disconnect', function()
    DropPlayer(source, locale('notify.player_exit'))
end)
