local enabled = false

RegisterNetEvent('ps-adminmenu:client:raycast')
AddEventHandler('ps-adminmenu:client:raycast', function()
    if not enabled then
        enabled = true
        exports.qbx_core:Notify(locale('raycast_activated'), "success")
    else
        enabled = false
        exports.qbx_core:Notify(locale('raycast_deactivated'), "error")
    end
end)

local function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

local function CopyToClipboardRaycast(x, y, z)
    local x = qbx.math.round(x, 2)
    local y = qbx.math.round(y, 2)
    local z = qbx.math.round(z, 2)
    local data = string.format('vec3(%s, %s, %s)', x, y, z)
    lib.setClipboard(data)
    exports.qbx_core:Notify(locale('coords_copied'), "success")
end

CreateThread(function()
	while true do
        Wait(5)
        if enabled then
            local color = {r = 255, g = 255, b = 255, a = 200}
            local position = GetEntityCoords(PlayerPedId())
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            qbx.drawText2d({
                text = 'Raycast Coords: '..qbx.math.round(coords.x, 2)..' '..qbx.math.round(coords.y, 2)..' '..qbx.math.round(coords.z, 2),
                coords = vector2(1.0, 1.4),
                width = 1.0,
                height = 1.0,
                scale = 0.4,
                font = 4,
            })
            qbx.drawText2d({
                text = 'Press ~g~E ~w~to copy to clipboard',
                coords = vector2(1.0, 1.4 + 0.025),
                width = 1.0,
                height = 1.0,
                scale = 0.4,
                font = 4,
            })
            DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
            DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
            if IsControlJustReleased(0, 38) then
                CopyToClipboardRaycast(coords.x, coords.y, coords.z)
            end
        else
            Wait(500)
        end
	end
end)