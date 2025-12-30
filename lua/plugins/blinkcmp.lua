-- https://cmp.saghen.dev/configuration/keymap.html
return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  opts = {
    cmdline = {},
    keymap = {
      preset = "default",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "accept", "fallback" }, -- 更改成'select_and_accept'会选择第一项插入
      ["<Enter>"] = { "accept", "fallback" }, -- 更改成'select_and_accept'会选择第一项插入
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = { documentation = { auto_show = false } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
