---@type string
BeniteDLCName = 'benite_apparel'

--
-- PLayermodels
--

---Benite Apparel playermodel
---@class Playermodel
  ---@field name string @ GTA5 model name
  ---@field label string @ GTA5 model name
  ---@field private new fun(name: string, label?: string): self
local Playermodel<const> = {}

---Creates new Benite Apparel playermodel
function Playermodel.new(name, label)
  local self<const> = setmetatable({}, Playermodel) --[[@as Playermodel]]

  self.name = name
  self.label = label or name

  return self
end

---@enum (key) PlayermodelHash
local playermodels<const> = {
  [`mp_m_freemode_01`] = Playermodel.new('mp_m_freemode_01', Locale.model_freemode_male),
  [`mp_f_freemode_01`] = Playermodel.new('mp_f_freemode_01', Locale.model_freemode_female)
}

---Gets playermodel from playermodel hash
  ---@param playermodelHash PlayermodelHash
  ---@return Playermodel
  function GetPlayermodel(playermodelHash)
    return playermodels[playermodelHash]
  end

--
-- Components
--

---@alias ComponentID
---| 0 # Head
---| 1 # Masks
---| 2 # Hair Styles
---| 3 # Torsos
---| 4 # Legs
---| 5 # Bags and Parachutes
---| 6 # Shoes
---| 7 # Accessories
---| 8 # Undershirts
---| 9 # Body Armors
---| 10 # Decals
---| 11 # Tops

---Benite Apparel playermodel component
---@class Component
  ---@field name string @ GTA5 component name
  ---@field label string @ Human readable name
  ---@field private new fun(name: string, label: string): self
local Component<const> = {}

---Creates new Benite Apparel playermodel component
function Component.new(name, label)
  local self<const> = setmetatable({}, Component) --[[@as Component]]

  self.name = name
  self.label = label

  return self
end

---@type table<ComponentID, Component>
local components<const> = {
  [11] = Component.new('jbib', Locale.components_jbib),
  [9]  = Component.new('task', Locale.components_task),
  [8]  = Component.new('accs', Locale.components_accs),
}

---Gets component from component ID
  ---@param componentId ComponentID
  ---@return Component
function GetComponent(componentId)
  return components[componentId]
end

---Gets all components
  ---@return table<ComponentID, Component>
function GetAllComponents()
  return components
end

DefaultComponents = {
  [`mp_m_freemode_01`] = {
    [11] = {
      [11] = 15,
      [8] = 15,
      [3] = 15
    },
    [9] = {
      [9] = 0
    },
    [8] = {
      [8] = 15
    }
  },

  [`mp_f_freemode_01`] = {
    
  }
}

--
-- Properties
--

---@alias PropertyID
---| 'rank' #	Rank
---| 'badgeNumber' #	Identifier
---| 'politiBack' #	POLITI logo on back
---| 'politiFront' #	POLITI logo on front
---| 'bookColor' #	Colour of notepad
---| 'penColor' #	Colour of pen
---| 'footballName' #	Football player name
---| 'footballNumber' #	Football player number
---| 'primaryColor' #	Primary colour
---| 'printFront' #	Front print
---| 'printBack' #	Back print


-- How many drawables each article of clothing uses
DrawablesEach = 8