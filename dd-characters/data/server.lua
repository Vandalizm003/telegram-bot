DdServerConfig = {
    characters = {
        --- Max characters per player. Override per license below.
        defaultNumberOfCharacters = 1,

        ---@type table<string, number>
        playersNumberOfCharacters = {
            ['license2:b9f9f1bcd937e71e62ea31d977fb11085c214db4'] = 50,
        },
    },

    validation = {
        minNameLength = 2,
        maxNameLength = 16,
        minHeight = 140,
        maxHeight = 220,
        maxBackstoryLength = 300,
        minBirthYear = 1940,
        maxBirthYear = 2006,
        namePattern = "^[%a%s%-']+$",
    },
}
