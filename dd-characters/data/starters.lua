DdStarterConfig = {
    items = {
        { name = 'phone', amount = 1 },
        {
            name = 'id_card',
            amount = 1,
            metadata = function(source)
                assert(GetResourceState('qbx_idcard') == 'started', 'qbx_idcard is required for id_card starter item')
                return exports.qbx_idcard:GetMetaLicense(source, { 'id_card' })
            end,
        },
        {
            name = 'driver_license',
            amount = 1,
            metadata = function(source)
                assert(GetResourceState('qbx_idcard') == 'started', 'qbx_idcard is required for driver_license starter item')
                return exports.qbx_idcard:GetMetaLicense(source, { 'driver_license' })
            end,
        },
    },
}
