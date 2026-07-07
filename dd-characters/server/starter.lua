---@param source number
function DdGiveStarterItems(source)
    local starterItems = DdStarterConfig.items
    if not starterItems or #starterItems == 0 or GetResourceState('ox_inventory') == 'missing' then
        return
    end

    while not exports.ox_inventory:GetInventory(source) do
        Wait(100)
    end

    for i = 1, #starterItems do
        local item = starterItems[i]
        if item.metadata and type(item.metadata) == 'function' then
            exports.ox_inventory:AddItem(source, item.name, item.amount, item.metadata(source))
        else
            exports.ox_inventory:AddItem(source, item.name, item.amount, item.metadata)
        end
    end
end
