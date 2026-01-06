-- ~/.config/nvim/lua/plugins/peek.lua
return {
  {
    "toppair/peek.nvim",
    ft = { "markdown" },
    build = "deno task --quiet build:fast",
    opts = {
      auto_load = true,
      close_on_bdelete = true,
      syntax = true,
      theme = "dark",
      update_on_change = true,
      app = "webview", -- or "browser", or { "chromium", "--new-window" }
      filetype = { "markdown" },
      throttle_at = 200000,
      throttle_time = "auto",
    },
    config = function(_, opts)
      local peek = require("peek")
      peek.setup(opts)

      vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
      vim.api.nvim_create_user_command("PeekClose", peek.close, {})
      vim.api.nvim_create_user_command("PeekToggle", function()
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end, {})
    end,
    keys = {
      { "<leader>mp", "<cmd>PeekToggle<cr>", desc = "Peek (Markdown Preview)" },
    },
  },
}