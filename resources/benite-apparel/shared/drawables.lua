--
-- DRAWABLE CLASS
--

---Benite Apparel drawable
---@class Drawable
  ---@field dlc BeniteDLC
  ---@field label string
  ---@field modelHash PlayermodelHash
  ---@field componentId ComponentID
  ---@field idx integer
  ---@field offset integer
  ---@field textureName string
  ---@field resolution vector2
  ---@field properties PropertyID[]
  ---@field arms? integer
  ---@field private new fun(dlc: BeniteDLC, label: string, modelhash: PlayermodelHash, componentId: ComponentID, idx: integer, textureName: string, resolution: vector2, properties: PropertyID[], arms?: integer): self
local Drawable<const> = {}

---Creates new Benite Apparel drawable
function Drawable.new(dlc, label, modelHash, componentId, idx, textureName, resolution, properties, arms)
  -- Don't load if DLC isn't loaded
  if not GlobalState[BeniteDLCHashes[dlc]] then return {} end

  local self<const> = setmetatable({}, Drawable) --[[@as Drawable]]

  self.dlc = dlc
  self.label = label
  self.modelHash = modelHash
  self.componentId = componentId
  self.idx = idx

  self.offset = 
    DLCDrawableVariations.models[modelHash][componentId] -- Offset from server DLC
    + idx * DrawablesEach -- Offset in Benite DLC
    + 2

  self.textureName = textureName
  self.resolution = resolution

  self.properties = properties

  self.arms = arms or nil

  return self
end

--
-- SCRIPT
--

---@enum (key) DrawableID
local drawables<const> = {
-- mp_m_freemode_01
  -- [11] jbib (jacket)
    shirt = Drawable.new(
      'politi',
      Locale.drawable_shirt,
      `mp_m_freemode_01`,
      11,
      0,
      'jbib_diff_005_a_uni',
      vector2(1536, 1536),
      { 'rank' },
      11
    ),

    knit = Drawable.new(
      'politi',
      Locale.drawable_knit,
      `mp_m_freemode_01`,
      11,
      1,
      'jbib_diff_001_b_uni',
      vector2(768, 1536),
      { 'rank' },
      4
    ),

    bif = Drawable.new(
      'superliga',
      Locale.drawable_bif,
      `mp_m_freemode_01`,
      11,
      2,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    fck = Drawable.new(
      'superliga',
      Locale.drawable_fck,
      `mp_m_freemode_01`,
      11,
      3,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    ob = Drawable.new(
      'superliga',
      Locale.drawable_ob,
      `mp_m_freemode_01`,
      11,
      4,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    aab = Drawable.new(
      'superliga',
      Locale.drawable_aab,
      `mp_m_freemode_01`,
      11,
      5,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    fcm = Drawable.new(
      'superliga',
      Locale.drawable_fcm,
      `mp_m_freemode_01`,
      11,
      6,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    ach = Drawable.new(
      'superliga',
      Locale.drawable_ach,
      `mp_m_freemode_01`,
      11,
      7,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    vff = Drawable.new(
      'superliga',
      Locale.drawable_vff,
      `mp_m_freemode_01`,
      11,
      8,
      'jbib_diff_017_a_uni',
      vector2(5000, 5000),
      { 'footballName', 'footballNumber' },
      0
    ),

    customshirt = Drawable.new(
      'custom',
      Locale.drawable_customshirt,
      `mp_m_freemode_01`,
      11,
      9,
      'jbib_diff_002_a_uni',
      vector2(3000, 3000),
      { 'primaryColor', 'printFront', 'printBack' },
      0
    ),

  -- [9] task (armor)
    lvest = Drawable.new(
      'politi',
      Locale.drawable_lvest,
      `mp_m_freemode_01`,
      9,
      0,
      'Vest_Diffuse',
      vector2(4096, 2048),
      { 'badgeNumber', 'politiBack', 'politiFront' }
    ),

    lvestnote = Drawable.new(
      'politi',
      Locale.drawable_lvestnote,
      `mp_m_freemode_01`,
      9,
      1,
      'Vest_Diffuse2',
      vector2(4096, 2048),
      { 'badgeNumber', 'politiBack', 'politiFront', 'bookColor', 'penColor' }
    ),

  -- [8] accs (accessories/tshirts)
    customvest = Drawable.new(
      'custom',
      Locale.drawable_customvest,
      `mp_m_freemode_01`,
      8,
      0,
      'accs_diff_000_d_uni',
      vector2(1024, 1024),
      { 'primaryColor', 'printFront', 'printBack' }
    ),
}

for drawableId, drawable in pairs(drawables) do
  -- Delete if drawable has been marked as "missing" by DLC loader
  if not drawable.idx then drawables[drawableId] = nil end
end

---Gets drawable from drawable ID
  ---@param drawableId DrawableID
  ---@return Drawable
function GetDrawable(drawableId)
  return drawables[drawableId]
end

---Gets all drawables
function GetAllDrawables()
  return drawables
end