---@param payload table
---@return boolean success, string? errorKey
function DdValidateCreatePayload(payload)
    if type(payload) ~= 'table' then
        return false, 'notify.invalid_payload'
    end

    local validation = DdServerConfig.validation
    local pattern = validation.namePattern

    local function validateName(value)
        if type(value) ~= 'string' then
            return false
        end

        local len = #value
        if len < validation.minNameLength or len > validation.maxNameLength then
            return false
        end

        return value:match(pattern) ~= nil
    end

    if not validateName(payload.firstname) then
        return false, 'notify.invalid_firstname'
    end

    if not validateName(payload.lastname) then
        return false, 'notify.invalid_lastname'
    end

    local height = tonumber(payload.height) or 0
    if height < validation.minHeight or height > validation.maxHeight then
        return false, 'notify.invalid_height'
    end

    if payload.backstory and #payload.backstory > validation.maxBackstoryLength then
        return false, 'notify.invalid_backstory'
    end

    if type(payload.birthdate) ~= 'string' then
        return false, 'notify.invalid_birthdate'
    end

    local year = tonumber(payload.birthdate:sub(1, 4))
    if not year or year < validation.minBirthYear or year > validation.maxBirthYear then
        return false, 'notify.invalid_birthdate'
    end

    if payload.gender ~= 0 and payload.gender ~= 1 then
        return false, 'notify.invalid_gender'
    end

    return true
end
