NetworkStartSoloTutorialSession()

local previewCam = nil
local previewScene = DdClientConfig.previewScenes[1]
local isOpen = false
local selectedCharacters = {}

-- Forward declarations (used before definitions below).
local closeMultichar
local destroyPreviewCam
local chooseCharacter
local clearInsideMeta
local triggerPlayerLoaded
local defaultSpawn = DdSharedConfig.defaultSpawn

local PLACEHOLDER_PED_MODEL = `a_m_y_bevhills_01`

local randomPeds = {
    {
        model = `mp_m_freemode_01`,
        headOverlays = {
            beard = { color = 0, style = 0, secondColor = 0, opacity = 1 },
            complexion = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            bodyBlemishes = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            blush = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            lipstick = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            blemishes = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            eyebrows = { color = 0, style = 0, secondColor = 0, opacity = 1 },
            makeUp = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            sunDamage = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            moleAndFreckles = { color = 0, style = 0, secondColor = 0, opacity = 0 },
            chestHair = { color = 0, style = 0, secondColor = 0, opacity = 1 },
            ageing = { color = 0, style = 0, secondColor = 0, opacity = 1 },
        },
        components = {
            { texture = 0, drawable = 0, component_id = 0 },
            { texture = 0, drawable = 0, component_id = 1 },
            { texture = 0, drawable = 0, component_id = 2 },
            { texture = 0, drawable = 0, component_id = 5 },
            { texture = 0, drawable = 0, component_id = 7 },
            { texture = 0, drawable = 0, component_id = 9 },
            { texture = 0, drawable = 0, component_id = 10 },
            { texture = 0, drawable = 15, component_id = 11 },
            { texture = 0, drawable = 15, component_id = 8 },
            { texture = 0, drawable = 15, component_id = 3 },
            { texture = 0, drawable = 34, component_id = 6 },
            { texture = 0, drawable = 61, component_id = 4 },
        },
        props = {
            { prop_id = 0, drawable = -1, texture = -1 },
            { prop_id = 1, drawable = -1, texture = -1 },
            { prop_id = 2, drawable = -1, texture = -1 },
            { prop_id = 6, drawable = -1, texture = -1 },
            { prop_id = 7, drawable = -1, texture = -1 },
        },
    },
    {
        model = `mp_f_freemode_01`,
        headBlend = {
            shapeMix = 0.3,
            skinFirst = 0,
            shapeFirst = 31,
            skinSecond = 0,
            shapeSecond = 0,
            skinMix = 0,
            thirdMix = 0,
            shapeThird = 0,
            skinThird = 0,
        },
        hair = {
            color = 0,
            style = 15,
            texture = 0,
            highlight = 0,
        },
        headOverlays = {
            chestHair = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            bodyBlemishes = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            beard = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            lipstick = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            complexion = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            blemishes = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            moleAndFreckles = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            makeUp = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            ageing = { secondColor = 0, opacity = 1, color = 0, style = 0 },
            eyebrows = { secondColor = 0, opacity = 1, color = 0, style = 0 },
            blush = { secondColor = 0, opacity = 0, color = 0, style = 0 },
            sunDamage = { secondColor = 0, opacity = 0, color = 0, style = 0 },
        },
        components = {
            { drawable = 0, component_id = 0, texture = 0 },
            { drawable = 0, component_id = 1, texture = 0 },
            { drawable = 0, component_id = 2, texture = 0 },
            { drawable = 0, component_id = 5, texture = 0 },
            { drawable = 0, component_id = 7, texture = 0 },
            { drawable = 0, component_id = 9, texture = 0 },
            { drawable = 0, component_id = 10, texture = 0 },
            { drawable = 15, component_id = 3, texture = 0 },
            { drawable = 15, component_id = 11, texture = 3 },
            { drawable = 14, component_id = 8, texture = 0 },
            { drawable = 15, component_id = 4, texture = 3 },
            { drawable = 35, component_id = 6, texture = 0 },
        },
        props = {
            { prop_id = 0, drawable = -1, texture = -1 },
            { prop_id = 1, drawable = -1, texture = -1 },
            { prop_id = 2, drawable = -1, texture = -1 },
            { prop_id = 6, drawable = -1, texture = -1 },
            { prop_id = 7, drawable = -1, texture = -1 },
        },
    },
}

local function ensurePreviewPedVisible()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    SetEntityVisible(ped, true, false)
    ResetEntityAlpha(ped)
    SetEntityAlpha(ped, 255, false)
    SetPedAoBlobRendering(ped, true)
    FreezeEntityPosition(ped, true)
    SetPedCanRagdoll(ped, false)
    SetEntityCollision(ped, true, true)
end

local function releaseWorldFocus()
    ClearFocus()
    pcall(function()
        ClearHdArea()
    end)
end

local function resetPreviewCamToPed()
    if not previewScene or not previewCam or not DoesCamExist(previewCam) then return end

    releaseWorldFocus()

    SetCamCoord(
        previewCam,
        previewScene.camCoords.x,
        previewScene.camCoords.y,
        previewScene.camCoords.z
    )
    PointCamAtCoord(
        previewCam,
        previewScene.pedCoords.x,
        previewScene.pedCoords.y,
        previewScene.pedCoords.z + 0.5
    )
end

clearInsideMeta = function()
    TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
    TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
end

triggerPlayerLoaded = function()
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end

--- qbx_core spawnDefault — used when qbx_spawn is missing.
local function spawnDefault()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    destroyPreviewCam()

    pcall(function()
        exports.spawnmanager:spawnPlayer({
            x = defaultSpawn.x,
            y = defaultSpawn.y,
            z = defaultSpawn.z,
            heading = defaultSpawn.w,
        })
    end)

    triggerPlayerLoaded()
    clearInsideMeta()

    while not IsScreenFadedIn() do
        Wait(0)
    end

    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end

--- qbx_core spawnLastLocation — used when no apartment/spawn resource handles play.
local function spawnLastLocation()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    destroyPreviewCam()

    pcall(function()
        exports.spawnmanager:spawnPlayer({
            x = QBX.PlayerData.position.x,
            y = QBX.PlayerData.position.y,
            z = QBX.PlayerData.position.z,
            heading = QBX.PlayerData.position.w,
        })
    end)

    triggerPlayerLoaded()
    clearInsideMeta()

    while not IsScreenFadedIn() do
        Wait(0)
    end
end

--- qbx_core createCharacter routing (startingApartment + qbx_spawn checks).
---@param newData table
local function routeNewCharacter(newData)
    if GetResourceState('qbx_spawn') == 'missing' then
        spawnDefault()
    elseif DdSharedConfig.enableApartments then
        TriggerEvent('apartments:client:setupSpawnUI', newData)
    else
        TriggerEvent('qbx_core:client:spawnNoApartments')
    end

    destroyPreviewCam()
end

--- qbx_core play routing after loadCharacter.
---@param citizenid string
local function routeExistingCharacter(citizenid)
    if GetResourceState('qbx_apartments'):find('start') then
        TriggerEvent('apartments:client:setupSpawnUI', citizenid)
    elseif GetResourceState('qbx_spawn'):find('start') then
        TriggerEvent('qb-spawn:client:setupSpawns', citizenid)
        TriggerEvent('qb-spawn:client:openUI', true)
    else
        spawnLastLocation()
    end

    destroyPreviewCam()
end

---@param character table
local function enterWorld(character)
    DoScreenFadeOut(10)
    closeMultichar()

    lib.callback.await('dd-characters:server:loadCharacter', false, character.citizenid)
    lib.callback.await('dd-characters:server:setWorldBucket', false)

    routeExistingCharacter(character.citizenid)
end

---@param value string
---@return string
local function capString(value)
    return value:gsub("(%w)([%w']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

---@param entities table[]
---@return table[]
local function mapQbxCharacters(entities)
    local characters = {}

    for i = 1, #entities do
        local entity = entities[i]
        local charinfo = entity.charinfo
        local metadata = entity.metadata or {}
        local lastLoggedOut = tonumber(entity.lastLoggedOut) or 0

        characters[#characters + 1] = {
            id = charinfo.cid or entity.cid or i,
            citizenid = entity.citizenid,
            firstname = charinfo.firstname or '',
            lastname = charinfo.lastname or '',
            birthdate = charinfo.birthdate or '',
            phone = charinfo.phone or '',
            gender = tonumber(charinfo.gender) or 0,
            nationality = charinfo.nationality or '',
            height = tonumber(charinfo.height) or tonumber(metadata.height) or 175,
            job = {
                name = entity.job and entity.job.name or 'unemployed',
                label = entity.job and entity.job.label or 'Civilian',
            },
            money = {
                cash = tonumber(entity.money and entity.money.cash) or 0,
                bank = tonumber(entity.money and entity.money.bank) or 0,
            },
            backstory = metadata.backstory or charinfo.backstory,
            -- Unix seconds — formatted in NUI (os.* is not available on FiveM client).
            lastPlayed = lastLoggedOut > 0 and lastLoggedOut or nil,
            playtimeHours = math.floor((tonumber(metadata.playtime) or 0) / 3600),
        }
    end

    table.sort(characters, function(a, b)
        return a.id < b.id
    end)

    return characters
end

---@param entities table[]
---@param maxSlots number
---@return number?
local function getNextCharacterSlot(entities, maxSlots)
    local used = {}

    for i = 1, #entities do
        local cid = entities[i].charinfo.cid or entities[i].cid
        used[cid] = true
    end

    for slot = 1, maxSlots do
        if not used[slot] then
            return slot
        end
    end
end

local function shutdownLoadscreen()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end

local function showMulticharIntro()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'setVisible',
        data = { visible = true },
    })
    SendNUIMessage({ action = 'sessionIntro' })
end

local function finishMulticharOpen()
    SendNUIMessage({ action = 'previewReady' })
end

local function getRandomScene()
    local scenes = DdClientConfig.previewScenes
    previewScene = scenes[math.random(1, #scenes)]
    return previewScene
end

---@param scene table
local function preparePreviewScene(scene)
    if not scene or not scene.pedCoords then return end

    local coords = scene.pedCoords
    local x, y, z = coords.x, coords.y, coords.z

    if scene.ipls then
        for i = 1, #scene.ipls do
            RequestIpl(scene.ipls[i])
        end
    end

    RequestCollisionAtCoord(x, y, z)
    SetFocusPosAndVel(x, y, z, 0.0, 0.0, 0.0)

    local interior = GetInteriorAtCoords(x, y, z)
    if interior ~= 0 then
        LoadInterior(interior)
        local interiorTimeout = GetGameTimer() + 10000
        while not IsInteriorReady(interior) and GetGameTimer() < interiorTimeout do
            Wait(0)
        end
        PinInteriorInMemory(interior)
    end

    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 80.0, 0)
    local sceneTimeout = GetGameTimer() + 10000
    while IsNetworkLoadingScene() and GetGameTimer() < sceneTimeout do
        Wait(0)
    end
    NewLoadSceneStop()

    local ped = cache.ped
    local collisionTimeout = GetGameTimer() + 10000
    while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < collisionTimeout do
        RequestCollisionAtCoord(x, y, z)
        Wait(0)
    end

    ClearFocus()
end

---@param scene table
local function placePreviewPed(scene)
    if not scene or not scene.pedCoords then return end

    local coords = scene.pedCoords
    local x, y, z, heading = coords.x, coords.y, coords.z, coords.w
    local ped = PlayerPedId()

    RequestCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    SetEntityHeading(ped, heading)
    Wait(50)
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    SetEntityHeading(ped, heading)

    ensurePreviewPedVisible()
    ClearPedTasksImmediately(ped)
    TaskStandStill(ped, -1)
end

local function ensureScreenVisible()
    if IsScreenFadedOut() or IsScreenFadingOut() then
        DoScreenFadeIn(1000)
    end

    local timeout = GetGameTimer() + 5000
    while not IsScreenFadedIn() and GetGameTimer() < timeout do
        Wait(0)
    end

    if not IsScreenFadedIn() then
        DoScreenFadeIn(0)
    end
end

local function setupPreviewCam()
    if not previewScene then return end

    DoScreenFadeIn(1000)

    previewCam = CreateCamWithParams(
        'DEFAULT_SCRIPTED_CAMERA',
        previewScene.camCoords.x,
        previewScene.camCoords.y,
        previewScene.camCoords.z,
        -6.0,
        0.0,
        previewScene.camCoords.w,
        40.0,
        false,
        0
    )

    PointCamAtCoord(
        previewCam,
        previewScene.pedCoords.x,
        previewScene.pedCoords.y,
        previewScene.pedCoords.z + 0.5
    )

    SetCamActive(previewCam, true)
    SetCamUseShallowDofMode(previewCam, true)
    SetCamNearDof(previewCam, 0.5)
    SetCamFarDof(previewCam, 3.5)
    SetCamDofStrength(previewCam, 0.45)
    RenderScriptCams(true, false, 1, true, true)

    NetworkOverrideClockTime(12, 0, 0)
    NetworkOverrideClockMillisecondsPerGameMinute(2147483647)

    CreateThread(function()
        while previewCam and DoesCamExist(previewCam) do
            SetUseHiDof()
            Wait(0)
        end
    end)

    ensureScreenVisible()
end

local function bootstrapPlaceholderPed()
    local model = PLACEHOLDER_PED_MODEL
    lib.requestModel(model, DdClientConfig.loadingModelsTimeout)
    SetPlayerModel(cache.playerId, model)
    SetModelAsNoLongerNeeded(model)
    SetEntityVisible(cache.ped, true, false)
end

destroyPreviewCam = function()
    if not previewCam then return end

    releaseWorldFocus()

    SetTimecycleModifier('default')
    NetworkClearClockTimeOverride()
    SetCamActive(previewCam, false)
    DestroyCam(previewCam, true)
    previewCam = nil
    RenderScriptCams(false, false, 1, true, true)
    FreezeEntityPosition(cache.ped, false)
    SetPedCanRagdoll(cache.ped, true)
    DisplayRadar(true)
end

local function randomPed()
    local ped = randomPeds[math.random(1, #randomPeds)]
    lib.requestModel(ped.model, DdClientConfig.loadingModelsTimeout)
    SetPlayerModel(cache.playerId, ped.model)
    pcall(function()
        exports['illenium-appearance']:setPedAppearance(PlayerPedId(), ped)
    end)
    SetModelAsNoLongerNeeded(ped.model)
end

---@param citizenId? string
local function previewPed(citizenId)
    if not citizenId then
        randomPed()
    else
        local clothing, model = lib.callback.await('dd-characters:server:getPreviewPedData', false, citizenId)
        if model and clothing then
            lib.requestModel(model, DdClientConfig.loadingModelsTimeout)
            SetPlayerModel(cache.playerId, model)
            Wait(50)
            pcall(function()
                exports['illenium-appearance']:setPedAppearance(PlayerPedId(), json.decode(clothing))
            end)
            SetModelAsNoLongerNeeded(model)
        else
            randomPed()
        end
    end

    Wait(100)
    ensurePreviewPedVisible()
end

closeMultichar = function()
    if not isOpen then return end
    isOpen = false

    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'setVisible',
        data = { visible = false },
    })
end

local function openMultichar()
    if isOpen then return end
    isOpen = true

    shutdownLoadscreen()
    DoScreenFadeIn(0)
    showMulticharIntro()

    CreateThread(function()
        local entities = lib.callback.await('dd-characters:server:getCharacters', false)
        local firstCitizenId = entities[1] and entities[1].citizenid

        getRandomScene()
        SetFollowPedCamViewMode(2)
        DisplayRadar(false)

        preparePreviewScene(previewScene)

        NetworkStartSoloTutorialSession()

        while not NetworkIsInTutorialSession() do
            Wait(0)
        end

        lib.callback.await('dd-characters:server:setCharacterBucket', false)

        previewPed(firstCitizenId)
        placePreviewPed(previewScene)

        Wait(200)
        setupPreviewCam()
        SetTimecycleModifier('default')
        AnimpostfxStopAll()

        finishMulticharOpen()
    end)
end

chooseCharacter = function()
    isOpen = false
    pcall(openMultichar)
end

---@param cb fun(response: table)
---@param data table
local function respond(cb, data)
    cb(data or { success = true })
end

RegisterNUICallback('ui:ready', function(_, cb)
    respond(cb, {
        brand = {
            name = DdSharedConfig.brandName,
            logoUrl = DdSharedConfig.brandLogo,
        },
    })
end)

RegisterNUICallback('getCharacters', function(_, cb)
    local ok, payload = pcall(function()
        local entities, maxCharacters = lib.callback.await('dd-characters:server:getCharacters', false)

        if type(entities) ~= 'table' then
            error('invalid character list')
        end

        maxCharacters = tonumber(maxCharacters) or 1
        local characters = mapQbxCharacters(entities)

        selectedCharacters = {}
        for i = 1, #characters do
            local character = characters[i]
            selectedCharacters[character.id] = character
        end

        return {
            characters = characters,
            config = {
                maxCharacters = maxCharacters,
                enableCodex = DdSharedConfig.enableCodex,
                enablePulse = DdSharedConfig.enablePulse,
            },
            playerName = GetPlayerName(cache.playerId) or 'Player',
        }
    end)

    if not ok or type(payload) ~= 'table' then
        lib.print.error(('[dd-characters] getCharacters failed: %s'):format(tostring(payload)))
        respond(cb, {
            characters = {},
            config = {
                maxCharacters = 1,
                enableCodex = DdSharedConfig.enableCodex,
                enablePulse = DdSharedConfig.enablePulse,
            },
            playerName = GetPlayerName(cache.playerId) or 'Player',
        })
        return
    end

    respond(cb, payload)
end)

RegisterNUICallback('previewCharacter', function(data, cb)
    local character = selectedCharacters[data.id]
    if character then
        previewPed(character.citizenid)
    else
        previewPed()
    end

    if previewScene then
        placePreviewPed(previewScene)
    end

    resetPreviewCamToPed()
    respond(cb)
end)

RegisterNUICallback('createCharacter', function(data, cb)
    local entities, maxCharacters = lib.callback.await('dd-characters:server:getCharacters', false)

    if type(entities) ~= 'table' then
        entities = {}
    end

    maxCharacters = tonumber(maxCharacters) or 1

    if #entities >= maxCharacters then
        lib.notify({ description = locale('notify.character_limit'), type = 'error' })
        respond(cb, { success = false, message = locale('notify.character_limit') })
        return
    end

    local valid, message = lib.callback.await('dd-characters:server:validateCreate', false, data)
    if not valid then
        lib.notify({ description = message or locale('notify.create_failed'), type = 'error' })
        respond(cb, { success = false, message = message })
        return
    end

    local cid = getNextCharacterSlot(entities, maxCharacters)
    if not cid then
        lib.notify({ description = locale('notify.character_limit'), type = 'error' })
        respond(cb, { success = false, message = locale('notify.character_limit') })
        return
    end

    local newData = lib.callback.await('dd-characters:server:createCharacter', false, {
        firstname = capString(data.firstname),
        lastname = capString(data.lastname),
        nationality = capString(data.nationality),
        gender = data.gender,
        birthdate = data.birthdate,
        cid = cid,
        height = data.height,
    })

    if not newData then
        lib.notify({ description = locale('notify.create_failed'), type = 'error' })
        respond(cb, { success = false, message = locale('notify.create_failed') })
        return
    end

    lib.callback.await('dd-characters:server:afterCreate', false, {
        backstory = data.backstory,
        height = data.height,
    })

    selectedCharacters[cid] = {
        id = cid,
        citizenid = newData.citizenid,
        firstname = capString(data.firstname),
        lastname = capString(data.lastname),
    }

    respond(cb, {
        success = true,
        characterId = cid,
        citizenid = newData.citizenid,
    })

    CreateThread(function()
        DoScreenFadeOut(150)
        closeMultichar()
        lib.callback.await('dd-characters:server:setWorldBucket', false)
        routeNewCharacter(newData)
    end)
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    local character = selectedCharacters[data.id]
    if not character then
        respond(cb, { success = false, message = locale('notify.character_not_found') })
        return
    end

    if not DdSharedConfig.allowDeleteCharacter then
        lib.notify({ description = locale('notify.delete_disabled'), type = 'error' })
        respond(cb, { success = false, message = locale('notify.delete_disabled') })
        return
    end

    local success = lib.callback.await('dd-characters:server:deleteCharacter', false, character.citizenid)
    if not success then
        lib.notify({ description = locale('notify.delete_failed'), type = 'error' })
        respond(cb, { success = false, message = locale('notify.delete_failed') })
        return
    end

    respond(cb, { success = true })
end)

RegisterNUICallback('playGame', function(data, cb)
    local character = selectedCharacters[data.id]
    if not character then
        respond(cb, { success = false })
        return
    end

    enterWorld(character)
    respond(cb, { success = true })
end)

RegisterNUICallback('getCodex', function(_, cb)
    local ok, payload = pcall(function()
        return lib.callback.await('dd-characters:server:getCodex', false)
    end)

    if not ok or type(payload) ~= 'table' then
        lib.print.error('[dd-characters] getCodex failed')
        respond(cb, { sections = {} })
        return
    end

    respond(cb, payload)
end)

RegisterNUICallback('getPulse', function(_, cb)
    local ok, payload = pcall(function()
        return lib.callback.await('dd-characters:server:getPulse', false)
    end)

    if not ok or type(payload) ~= 'table' then
        lib.print.error('[dd-characters] getPulse failed')
        respond(cb, {
            station = 'DD Pulse',
            frequency = '104.2 FM',
            tagline = 'Live citywide feed',
            items = {},
        })
        return
    end

    respond(cb, payload)
end)

RegisterNUICallback('openCodex', function(_, cb)
    respond(cb)
end)

RegisterNUICallback('openPulse', function(_, cb)
    respond(cb)
end)

RegisterNUICallback('exitGame', function(_, cb)
    closeMultichar()
    destroyPreviewCam()

    if DdSharedConfig.exitAction == 'quit' then
        QuitGame()
    else
        TriggerServerEvent('dd-characters:server:disconnect')
    end

    respond(cb, { success = true })
end)

RegisterNetEvent('dd-characters:client:open', function()
    chooseCharacter()
end)

RegisterNetEvent('qbx_core:client:playerLoggedOut', function()
    if GetInvokingResource() then return end
    chooseCharacter()
end)

--- Required when qbx_core built-in multichar is disabled (useExternalCharacters).
RegisterNetEvent('qbx_core:client:spawnNoApartments', function()
    DoScreenFadeOut(500)
    Wait(2000)
    SetEntityCoords(cache.ped, defaultSpawn.x, defaultSpawn.y, defaultSpawn.z, false, false, false, false)
    SetEntityHeading(cache.ped, defaultSpawn.w)
    Wait(500)
    destroyPreviewCam()
    SetEntityVisible(cache.ped, true, false)
    Wait(500)
    DoScreenFadeIn(250)
    triggerPlayerLoaded()
    clearInsideMeta()

    pcall(function()
        if GetResourceState('qb-weathersync'):find('start') then
            TriggerEvent('qb-weathersync:client:EnableSync')
        end
    end)

    TriggerEvent('qb-clothes:client:CreateFirstCharacter')
end)

CreateThread(function()
    while true do
        Wait(100)
        -- Чекаємо поки сесія почнеться І гравець авторизується в qbx_account_system
        if NetworkIsSessionStarted() and LocalPlayer.state.isAccountLoggedIn then
            pcall(function() exports.spawnmanager:setAutoSpawn(false) end)
            Wait(250)
            chooseCharacter() -- Або функція відкриття dd-characters
            break
        end
    end
end)