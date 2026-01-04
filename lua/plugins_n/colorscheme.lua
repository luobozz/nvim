return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.sonokai_style = "atlantis" -- 可选: default, atlantis, andromeda, shusia, maia, espresso
      vim.g.sonokai_enable_italic = true
      vim.g.sonokai_disable_italic_comment = false
      vim.g.sonokai_transparent_background = false
      vim.g.sonokai_better_performance = true
      vim.g.sonokai_show_eob = true
      vim.g.sonokai_current_word = "bold"
      -- vim.cmd.colorscheme("sonokai")
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
