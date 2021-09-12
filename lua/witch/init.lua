local Witch = {}

function Witch.set(colorscheme, variant)
  Witch.setColorscheme(colorscheme, variant)
  Witch.setLualineTheme(colorscheme, variant)
end

function Witch.mappings()
  return {
    ['ayu'] = {
      name = "ayu",
      variants = { "mirage", "dark", "light" },
      mode = "global_variable",
      variable = "ayucolor"
    },
    ['nightfox'] = {
      name = "nightfox",
      variants = { "nightfox", "nordfox", "palefox" },
      mode = "lua_load",
      variable = "fox"
    },
    ['github-theme'] = {
      name = "github-theme",
      variants = { "dark", "dimmed", "light" },
      mode = "lua_setup_only",
      variable = "themeStyle"
    },
    ['tokyonight'] = {
      name = "tokyonight",
      variants = { "night", "storm", "day" },
      mode = "global_variable",
      variable = "tokyonight_style"
    }
  }
end

function Witch.LualineMappings()
  return {
    ['ayu'] = {
      mode = "per_variant",
      variants = {
        ["mirage"] = "ayu_mirage",
        ["light"]  = "ayu_light",
        ["dark"]   = "ayu_dark"
      }
    },
    ["github"] = {
      mode = "only_one",
      name = "github"
    },
    ["nightfox"] = {
      mode = "only_one",
      name = "github"
    },
    ["tokyonight"] = {
      mode = "only_one",
      name = "tokyonight"
    }
  }
end

function Witch.setLualineTheme(theme, variant)
  local lualineExists, lualine = pcall(require, 'lualine')
  if not lualineExists then
    return
  end

  local themeFound = false
  for configuredTheme, _val in pairs(Witch.LualineMappings()) do
    if configuredTheme == theme then
      themeFound = true
    end
  end

  if not themeFound then
    print("Lualine theme not found")
    return nil
  end

  local lualineConfig = Witch.LualineMappings()[theme]

  local lualineTheme
  if (lualineConfig["mode"] == "only_one") then
    lualineTheme = lualineConfig["name"]
  elseif (lualineConfig["mode"] == "per_variant") then
    lualineTheme = lualineConfig["variants"][variant]
  end

  lualine.setup { options = { theme = lualineTheme }}
end


function Witch.setColorscheme(theme, variant)
  -- check theme is supported
  local themeFound = false
  for configuredTheme, _val in pairs(Witch.mappings()) do
    if configuredTheme == theme then
      themeFound = true
    end
  end

  if not themeFound then
    print("Theme not found")
    return nil
  end

  -- check variant is supported
  local variantFound = false
  for _i, configuredVariant in ipairs(Witch.mappings()[theme]["variants"]) do
    if configuredVariant == variant then
      variantFound = true
    end
  end

  if not variantFound then
    print("Variant not found")
    return nil
  end

  -- set colorscheme via lua
  local colorDefinition = Witch.mappings()[theme]
  for i, themeVariant in ipairs(colorDefinition['variants']) do
    if (variant == themeVariant) then
      if (colorDefinition['mode'] == "lua_setup_only") then
        local themeVariable = colorDefinition['variable']
        local loadedTheme = require(theme)
        local options = {}
        options[themeVariable] = variant
        loadedTheme.setup(options)
      elseif (colorDefinition['mode'] == "lua_load") then
        local themeVariable = colorDefinition['variable']
        require(theme).load(variant)
      elseif (colorDefinition['mode'] == "global_variable") then
        local variableName = colorDefinition["variable"]
        vim.cmd('let ' .. variableName .. ' = "' .. variant .. '"')
        vim.cmd('colorscheme ' .. theme)
      end
    end
  end
end

return Witch
