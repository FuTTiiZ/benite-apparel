---
--- GTA5 DLCs
---

local AllDLCDrawableVariations<const> = {
  [2060] = {
    label = 'Los Santos Summer Special',
    models = {
      [`mp_m_freemode_01`] = { 46, 185, 75, 184, 131, 85, 96, 136, 170, 56, 79, 347 }, 
      --[`mp_f_freemode_01`] = { 46, 185, 79, 229, 138, 85, 100, 105, 207, 56, 88, 370 }
    }
  },

  [2189] = {
    label = 'Cayo Perico Heist',
    models = {
      [`mp_m_freemode_01`] = { 46, 190, 75, 195, 133, 89, 98, 151, 178, 56, 80, 358 }, 
      --[`mp_f_freemode_01`] = { 46, 190, 79, 240, 140, 89, 102, 120, 216, 56, 89, 381 }
    }
  },

  [2372] = {
    label = 'Los Santos Tuners',
    models = {
      [`mp_m_freemode_01`] = { 46, 195, 76, 196, 138, 100, 102, 152, 184, 56, 120, 378 },
      --[`mp_f_freemode_01`] = { 46, 196, 80, 241, 145, 100, 106, 121, 222, 56, 128, 400 }
    }
  },

  [2545] = {
    label = 'The Contract',
    models = {
      [`mp_m_freemode_01`] = { 46, 198, 77, 197, 144, 100, 102, 152, 189, 57, 130, 389 }, 
      --[`mp_f_freemode_01`] = { 46, 199, 81, 242, 151, 100, 106, 121, 234, 57, 140, 415 }
    }
  },

  [2612] = {
    label = 'Gen 9 Patch',
    models = {
      [`mp_m_freemode_01`] = { 46, 198, 77, 197, 144, 100, 102, 152, 189, 57, 130, 389 }, 
      --[`mp_f_freemode_01`] = { 46, 199, 81, 242, 151, 100, 106, 121, 234, 57, 140, 415 }
    }
  },

  [2699] = {
    label = 'The Criminal Enterprises',
    models = {
      [`mp_m_freemode_01`] = { 46, 209, 79, 198, 148, 111, 109, 154, 191, 57, 134, 413 }, 
      --[`mp_f_freemode_01`] = { 46, 210, 83, 243, 156, 111, 113, 123, 236, 57, 144, 440 }
    }
  },

  [2802] = {
    label = 'Los Santos Drug Wars',
    models = {
      [`mp_m_freemode_01`] = { 46, 216, 79, 210, 160, 111, 126, 167, 193, 57, 146, 438 }, 
      --[`mp_f_freemode_01`] = { 46, 217, 84, 244, 169, 111, 130, 136, 238, 57, 158, 473 }
    }
  },

  [2944] = {
    label = 'San Andreas Mercenaries',
    models = {
      [`mp_m_freemode_01`] = { 46, 226, 81, 211, 177, 111, 135, 175, 199, 58, 174, 495 },
      --[`mp_f_freemode_01`] = { 46, 227, 85, 245, 191, 111, 142, 145, 245, 58, 191, 534 }
    }
  },

  [3095] = {
    label = 'The Chop Shop',
    models = {
      [`mp_m_freemode_01`] = { 46, 237, 82, 214, 193, 111, 145, 178, 207, 62, 193, 524 },
      --[`mp_f_freemode_01`] = { 46, 238, 86, 248, 207, 111, 154, 148, 253, 62, 209, 565 }
    }
  },

  [3258] = {
    label = 'Bottom Dollar Bounties',
    models = {
      [`mp_m_freemode_01`] = { 46, 244, 82, 214, 202, 111, 151, 192, 213, 62, 207, 544 },
      -- [`mp_f_freemode_01`] = { 46, 245, 86, 248, 217, 111, 159, 162, 259, 62, 223, 588 }
    }
  },

  [3407] = {
    label = 'Agents of Sabotage',
    models = {
      [`mp_m_freemode_01`] = { 46, 245, 83, 214, 216, 111, 156, 199, 215, 62, 245, 575 },
      -- [`mp_f_freemode_01`] = { 46, 246, 87, 248, 229, 111, 164, 169, 261, 62, 261, 618 }
    }
  }
}

---Lowers the array indexes of the drawable variations by 1.
---The native functions expect them to start at index 0,
---but Lua starts at index 1 by default
  ---@param indexes table
  ---@return table
local function shiftIndexes(indexes)
  local shiftedIndexes<const> = {}
  for i = 1, #indexes do shiftedIndexes[i - 1] = indexes[i] end
  return shiftedIndexes
end

local currentDLCVariations<const> = AllDLCDrawableVariations[GameBuild] or { models = {} }
for modelhash, variations in pairs(currentDLCVariations.models) do
  currentDLCVariations.models[modelhash] = shiftIndexes(variations)
end
DLCDrawableVariations = currentDLCVariations

---
--- BENITE DLCs
---

---@alias BeniteDLC
---| 'politi' #	Politi
---| 'superliga' # Superliga
---| 'custom' # Custom DLC

---@type table<BeniteDLC, string>
BeniteDLCHashes = {
  politi = 'd0df10ac050fb483ce354a0f4795114b1e221099d0e024657eab626e0ce0fe8e',
  superliga = '85be8c2872ffab21b9aa0bccdb72880eccf654ba00cde3ab161fb32a81da9a70',
  custom = '10442980a9ce7142a7247ee243e638c4235c46dfa546f547be17f5cb8d298fd7'
}