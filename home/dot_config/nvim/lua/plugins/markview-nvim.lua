-- ~/.config/nvim/lua/plugins/markview.lua
return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- plugin recommends not lazy-loading it from lazy.nvim
    priority = 50, -- load after colorscheme (LazyVim colorschemes are usually very high priority)
    opts = {
      -- leave empty to use defaults; customize later if you want:
      -- preview = { icon_provider = "internal" }, -- "mini" or "devicons"
    },
    config = function(_, opts)
      require("markview").setup(opts)
    end,
    keys = {
      { "<leader>mv", "<cmd>Markview Toggle<cr>", desc = "Markview: Toggle preview" },
      { "<leader>mV", "<cmd>Markview splitToggle<cr>", desc = "Markview: Toggle splitview" },
      { "<leader>mh", "<cmd>Markview HybridToggle<cr>", desc = "Markview: Toggle hybrid mode" },
    },
  },
}