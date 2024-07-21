---All server callbacks
---@type table<integer, function>
local serverCallbacks<const> = {}

--- @type integer
local currentRequestId = 0

---Trigger registered server callback
	---@param name string
	---@param cb function
function TriggerServerCallback(name, cb, ...)
	serverCallbacks[currentRequestId] = cb

	TriggerServerEvent('benite-apparel:server:batscb', name, currentRequestId, ...)

	currentRequestId = currentRequestId < 65535 and currentRequestId + 1 or 0
end

---Net event for triggering server callback
	---@param requestId integer
RegisterNetEvent('benite-apparel:client:batscb', function(requestId, ...)
	serverCallbacks[requestId](...)
	serverCallbacks[requestId] = nil
end)