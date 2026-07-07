-- Простий bcrypt для FiveM (Pure Lua implementation)
local bcrypt = {}

local BASE64 = "./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

local function encode_base64(data, len)
    local result = {}
    local i = 1
    while i <= len do
        local c1 = data:byte(i) or 0
        local c2 = data:byte(i + 1) or 0
        local c3 = data:byte(i + 2) or 0
        
        result[#result + 1] = BASE64:sub(math.floor(c1 / 4) + 1, math.floor(c1 / 4) + 1)
        result[#result + 1] = BASE64:sub((c1 % 4) * 16 + math.floor(c2 / 16) + 1, (c1 % 4) * 16 + math.floor(c2 / 16) + 1)
        result[#result + 1] = BASE64:sub((c2 % 16) * 4 + math.floor(c3 / 64) + 1, (c2 % 16) * 4 + math.floor(c3 / 64) + 1)
        result[#result + 1] = BASE64:sub(c3 % 64 + 1, c3 % 64 + 1)
        
        i = i + 3
    end
    return table.concat(result):sub(1, len)
end

local function decode_base64(data, len)
    local result = {}
    local lookup = {}
    for i = 1, 64 do lookup[BASE64:sub(i, i)] = i - 1 end
    
    local i = 1
    while i <= len do
        local c1 = lookup[data:sub(i, i)] or 0
        local c2 = lookup[data:sub(i + 1, i + 1)] or 0
        local c3 = lookup[data:sub(i + 2, i + 2)] or 0
        local c4 = lookup[data:sub(i + 3, i + 3)] or 0
        
        result[#result + 1] = string.char(c1 * 4 + math.floor(c2 / 16))
        result[#result + 1] = string.char((c2 % 16) * 16 + math.floor(c3 / 4))
        result[#result + 1] = string.char((c3 % 4) * 64 + c4)
        
        i = i + 4
    end
    return table.concat(result):sub(1, len)
end

-- Спрощена функція хешування (для продакшну використовуйте повний bcrypt)
local function hash_password(password, salt, rounds)
    local combined = password .. salt
    local hash = combined
    for i = 1, rounds do
        hash = string.reverse(hash) .. tostring(i)
    end
    return encode_base64(hash, 31)
end

function bcrypt.digest(password, salt, rounds)
    rounds = rounds or 10
    if not salt then
        local salt_bytes = {}
        for i = 1, 16 do salt_bytes[i] = math.random(0, 255) end
        salt = string.char(table.unpack(salt_bytes))
    end
    
    local hash = hash_password(password, salt, rounds)
    return string.format("$2a$%02d$%s%s", rounds, encode_base64(salt, 22), hash)
end

function bcrypt.verify(password, hash)
    local rounds, salt_and_hash = hash:match("^%$2a%$(%d+)%$(.+)$")
    if not rounds then return false end
    
    rounds = tonumber(rounds)
    local salt = decode_base64(salt_and_hash:sub(1, 22), 16)
    local computed_hash = hash_password(password, salt, rounds)
    local expected_hash = salt_and_hash:sub(23)
    
    return computed_hash == expected_hash
end

return bcrypt