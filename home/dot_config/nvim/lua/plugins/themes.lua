-- lua/plugins/themes.lua

-- [[ SET YOUR THEME HERE ]]
-- Just change the name in the quotes to any installed theme (e.g., "gruvbox", "jellybeans", "kanso").
local chosen_theme = "flexoki-dark"

---

return {
  -- NOTE: kanso
  {
    "webhooked/kanso.nvim",
    name = "kanso", -- It's good practice to set a name to use with :colorscheme
    lazy = false,
    priority = 1000,
    opts = {
      theme = "zen", -- Default theme to load
      transparent = false,
      italics = true,
      keywordStyle = { italic = true },
      -- You can add other kanso options here if needed
    },
  },
  -- NOTE: vague
  {
    "vague2k/vague.nvim",
    name = "vague", -- It's good practice to set a name to use with :colorscheme
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      bold = true,
      italic = true,
      style = {
        comments = "italic",
        strings = "italic",
        keywords = "none",
        functions = "none",
        -- you can keep your other style customizations here
      },
      -- you can keep your plugin customizations here
    },
  },
  -- NOTE: jellybeans
  {
    "wtfox/jellybeans.nvim",
    name = "jellybeans",
    lazy = false,
    priority = 1000,
    opts = {
      -- This MUST be false to see your custom background color
      transparent = false,
      italics = true,
      bold = true,
      flat_ui = true,
      background = {
        dark = "jellybeans",
        light = "jellybeans_light",
      },
      plugins = {
        all = false,
        auto = true,
      },
      on_highlights = function(highlights, colors)
      end,
      -- This function now overrides the background color
      on_colors = function(c)
        local light_bg = "#ffffff"
        local dark_bg = "#121212" -- True black for OLED
        c.background = vim.o.background == "light" and light_bg or dark_bg
      end,
    },
  },
-- Note: catppuccin m4xsheen
  {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
         flavour = "mocha",
         custom_highlights = function(colors)
            return {
               WinSeparator = {
                  fg = colors.surface0,
               },
            }
         end,
         color_overrides = {
            mocha = {
               base = "#000000",
               mantle = "#000000",
            },
         },
         integrations = {
            notify = true,
            mason = true,
            fzf = true,
            aerial = true,
         },
      },
      init = function()
         vim.cmd.colorscheme("catppuccin")
      end,
   },
  -- NOTE: onedark
  {
    "navarasu/onedark.nvim",
    lazy = false,
    name = "onedark",
    opts = {
      -- Main options --
      style = "darker", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false, -- Show/hide background
      term_colors = true, -- Change terminal color as per the selected theme style
      ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      -- toggle theme style ---
      toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
      toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

      -- Change code style ---
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Lualine options --
      lualine = {
        transparent = false, -- lualine center bar transparency
      },

      -- Custom Highlights --
      colors = {}, -- Override default colors
      highlights = {}, -- Override highlight groups

      -- Plugins Config --
      diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = true, -- use background color for virtual text
      },
    },
  },

  -- NOTE: moonfly
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
  },
  -- NOTE: flexoki
  -- A warm, readable theme by Steph Ango (creator of Obsidian)
  -- Use :colorscheme flexoki-dark or flexoki-light
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    config = function()
      local bg = "#100F0F" -- flexoki main background
      require("flexoki").setup({
        highlight_groups = {
          -- Make file tree match main background
          NormalFloat = { bg = bg },
          FloatBorder = { bg = bg },
          -- Make which-key match main background
          WhichKeyFloat = { bg = bg },
          WhichKeyBorder = { bg = bg },
        },
      })
    end,
  },

  -- [[ APPLY THE CHOSEN THEME ON STARTUP ]]
  -- This special plugin definition will run after all other plugins have been loaded.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = chosen_theme,
    },
  },
}
