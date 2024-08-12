lib.addCommand('admin', {
    help = 'Open the admin menu',
    restricted = 'group.mod'
}, function(source)
    if not exports.qbx_core:IsOptin(source) then exports.qbx_core:Notify(source, 'You are not on admin duty', 'error'); return end
    TriggerClientEvent('ps-adminmenu:client:OpenUI', source)
end)

lib.addCommand("raycast", {
    help = "Enable raycast coords (God Only)",
    restricted = 'group.mod'
}, function(source)
    TriggerClientEvent('ps-adminmenu:client:raycast', source)
end)

-- Callbacks
