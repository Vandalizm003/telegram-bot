DdCharacters = {}

---@param license2 string?
---@param license? string
---@return number
function DdCharacters.getMaxSlots(license2, license)
    local cfg = DdServerConfig.characters
    return cfg.playersNumberOfCharacters[license2]
        or (license and cfg.playersNumberOfCharacters[license])
        or cfg.defaultNumberOfCharacters
end

---@param source number
---@return string?, string?
function DdCharacters.getLicenses(source)
    return GetPlayerIdentifierByType(source, 'license2'), GetPlayerIdentifierByType(source, 'license')
end

---@param source number
---@return number
function DdCharacters.getMaxSlotsForPlayer(source)
    local license2, license = DdCharacters.getLicenses(source)
    return DdCharacters.getMaxSlots(license2, license)
end

---@param position string
---@return vector4
local function convertPosition(position)
    local pos = json.decode(position)
    local fallback = DdSharedConfig.defaultSpawn
    local actualPos = (not pos.x or not pos.y or not pos.z) and fallback or pos
    return vec4(actualPos.x, actualPos.y, actualPos.z, actualPos.w or fallback.w)
end

---@param license2 string?
---@param license? string
---@return table[]
function DdCharacters.fetchAll(license2, license)
    local chars = {}
    local result = MySQL.query.await(
        'SELECT citizenid, charinfo, money, job, gang, position, metadata, UNIX_TIMESTAMP(last_logged_out) AS lastLoggedOutUnix FROM players WHERE license = ? OR license = ? ORDER BY cid',
        { license, license2 }
    )

    for i = 1, #result do
        local row = result[i]
        chars[i] = {
            citizenid = row.citizenid,
            charinfo = json.decode(row.charinfo),
            money = json.decode(row.money),
            job = row.job and json.decode(row.job),
            gang = row.gang and json.decode(row.gang),
            position = convertPosition(row.position),
            metadata = json.decode(row.metadata),
            lastLoggedOut = row.lastLoggedOutUnix,
        }
    end

    return chars
end

---@param source number
---@return number
function DdCharacters.getCount(source)
    local license2, license = DdCharacters.getLicenses(source)

    if not license2 and not license then
        return 0
    end

    return MySQL.scalar.await('SELECT COUNT(*) FROM players WHERE license = ? OR license = ?', {
        license or '',
        license2 or '',
    }) or 0
end

---@param source number
---@return boolean
function DdCharacters.isAtLimit(source)
    return DdCharacters.getCount(source) >= DdCharacters.getMaxSlotsForPlayer(source)
end

---@param source number
---@param citizenId string
---@return boolean
function DdCharacters.ownsCharacter(source, citizenId)
    local license2, license = DdCharacters.getLicenses(source)
    local characterLicense = MySQL.scalar.await('SELECT license FROM players WHERE citizenid = ?', { citizenId })

    return characterLicense ~= nil
        and (characterLicense == license or characterLicense == license2)
end
