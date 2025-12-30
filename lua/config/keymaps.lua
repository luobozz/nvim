-- ===
-- === map function
-- ===

local function mapkey(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end

local function mapcmd(key, cmd)
  vim.api.nvim_set_keymap("n", key, ":" .. cmd .. "<cr>", { noremap = true })
end

local function maplua(key, txt)
  vim.api.nvim_set_keymap("n", key, ":lua " .. txt .. "<cr>", { noremap = true })
end

-- ===
-- === Basic Mappings
-- ===
mapkey("i", "jj", "esc")
mapkey("n", "<A-l>", "$")
mapkey("n", "<A-h>", "^")
