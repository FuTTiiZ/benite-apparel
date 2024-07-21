---@type table<string, function>
local serverCallbacks<const> = {}

---Trigger registered server callback
	---@param name string
	---@param requestId integer
	---@param source integer
	---@param cb function
local function triggerServerCallback(name, requestId, source, cb, ...)
  if serverCallbacks[name] ~= nil then
    serverCallbacks[name](source, cb, ...)
	else
		print('triggerServerCallback => [' .. name .. '] does not exist')
	end
end

---Register a server callback
	---@param name string
	---@param cb function
function RegisterServerCallback(name, cb)
  serverCallbacks[name] = cb
end

---Net event for triggering server callback
	---@param name string
	---@param requestId integer
RegisterNetEvent('benite-apparel:server:batscb', function(name, requestId, ...)
	local source<const> = source

	triggerServerCallback(name, requestId, source, function(...)
		TriggerClientEvent('benite-apparel:client:batscb', source, requestId, ...)
	end, ...)
end)