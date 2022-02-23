# 🧙 Witch

Witch is a neovim colorscheme switcher. It makes switching colorschemes with
different variants easy, setting the matching lualine theme on the fly.

It provides a single way to load a colorscheme with a variant:

```lua
require('witch').set(<colorscheme>, <variant>)

-- examples:

require('witch').set('nightfox', 'nightfox')
require('witch').set('github', 'light')
```

It sets a neovim colorscheme and a matching lualine theme.

The code above has to be placed **after** loading the colorschemes and setting
the lualine config (using any theme, e.g. the "auto" one).

# Supported colorschemes

- ayu
- nightfox
- github
- tokyonight

# Requirements

- any neovim version supporting lua
- lualine installed from [shadmansaleh/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
  - this is required to allow switching lualine themes without losing existing config
- the supported colorschemes should be installed separately

# Todo

- [ ] add a telescope picker
- [ ] support additional configuration options (italics, integrations etc.)
- [ ] support more themes
- [ ] support more status line plugins

# How?

This plugin defines a couple of internal configurations, to decide how to set the colorscheme:

```lua
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
```

Here you can see that for each colorscheme we defined:

- a name;
- a list of variants;
- a `mode`, that is used to choose how to set the theme;
- eventually, a `global_variable` or `theme_variable`.

The same approach is used for the lualine config:

```lua
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
```

Here, we can choose if the theme has a single lualine theme (mode = `only_one`)
or a different one for each variant (mode = `per_variant`).
