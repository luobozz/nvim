-- ===
-- === mini.nvim surround,各种对字符的包裹{} [] ''
-- ===

return {
  "nvim-mini/mini.surround",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    })
  end,
}
