---Player entered other player's scope
  ---@param players { for: string, player: string }
AddEventHandler('playerEnteredScope', function(players)
  local greetingPlayer<const> = tonumber(players['for'])--[[@as integer]]
  local enteringPlayer<const> = players.player

  local greetingPlayerScope<const> = Player(greetingPlayer).state.scope
  greetingPlayerScope[enteringPlayer] = true

  Player(greetingPlayer).state.scope = greetingPlayerScope

  -- Load clothing textures
  TriggerClientEvent(
    'benite-apparel:client:loadTextures',
    tonumber(enteringPlayer)--[[@as integer]],
    Player(greetingPlayer).state.clothing,
    Player(greetingPlayer).state.clothingProperties,
    tostring(greetingPlayer)
  )
end)

---Player left other player's scope
  ---@param players { for: string, player: string }
AddEventHandler('playerLeftScope', function(players)
  local abandonedPlayer<const> = tonumber(players['for'])--[[@as integer]]
  local leavingPlayer<const> = players.player

  local abandonedPlayerScope<const> = Player(abandonedPlayer).state.scope
  abandonedPlayerScope[leavingPlayer] = nil

  Player(abandonedPlayer).state.scope = abandonedPlayerScope

  -- Unload clothing textures
  TriggerClientEvent(
    'benite-apparel:client:unloadTextures',
    tonumber(leavingPlayer)--[[@as integer]],
    Player(abandonedPlayer).state.clothing,
    tostring(abandonedPlayer)
  )
end)

---Player dropped from server
AddEventHandler('playerDropped', function()
  local droppedPlayer<const> = tostring(source)

  -- Check if dropped player is in any player's scope
  for _, src in ipairs(GetPlayers()) do
    local playerScope<const> = Player(src).state.scope
    if playerScope[droppedPlayer] then
      playerScope[droppedPlayer] = nil
      Player(src).state.scope = playerScope
    end
  end
end)

---Trigger client event for all people in the owner's scope
  ---@param eventName string
  ---@param scopeOwner integer
function TriggerScopeEvent(eventName, scopeOwner, ...)
  local targets<const> = Player(scopeOwner).state.scope
  for target, _ in pairs(targets) do
    TriggerClientEvent(eventName, tonumber(target)--[[@as integer]], ...)
  end

  TriggerClientEvent(eventName, scopeOwner, ...)
end