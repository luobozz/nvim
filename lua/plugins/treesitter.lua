-- ===
-- === treesitter,语法高亮
-- ===

return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    local TS = require("nvim-treesitter")
    if not TS.get_installed then
      LazyVim.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
      return
    end
    -- make sure we're using the latest treesitter util
    package.loaded["lazyvim.util.treesitter"] = nil
    LazyVim.treesitter.build(function()
      TS.update(nil, { summary = true })
    end)
  end,
  event = { "LazyFile", "VeryLazy" },
  cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  opts_extend = { "ensure_installed" },
  opt = {
    -- 要安装高亮的语言直接加入括号即可，把sync_install设置为true下次进入vim自动安装，
    -- 或者手动执行:TSInstall <想要安装的语言>
    -- 语言列表查看https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
    ensure_installed = {
      "bash",
      "c",
      "html",
      "typescript",
      "vue",
      "css",
      "scss",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "python",
      "sql",
      "regex",
      "toml",
      "tsx",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    -- 设置为true后位于ensure_installed里面的语言会自动安装
    -- sync_install = true,
    -- 这里填写不想要自动安装的语言
    ignore_install = {},
    folds = { enable = true },
    indent = { enable = true },
    highlight = {
      -- 默认开启高亮
      enable = true,
      -- 想要禁用高亮的语言列表
      -- disable = {
      -- },
      -- 使用function以提高灵活性，禁用大型文件的高亮
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- 如果您依靠启用'语法'（例如，缩进），则将其设置为“ True”。
      -- 使用此选项可能会放慢编辑器，您可能会看到一些重复的高亮。
      -- 除了设置为true，它也可以设置成语言列表
      additional_vim_regex_highlighting = false,
    },
  },
  config = function(_, opts)
    local TS = require("nvim-treesitter")

    setmetatable(require("nvim-treesitter.install"), {
      __newindex = function(_, k)
        if k == "compilers" then
          vim.schedule(function()
            LazyVim.error({
              "Setting custom compilers for `nvim-treesitter` is no longer supported.",
              "",
              "For more info, see:",
              "- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
            })
          end)
        end
      end,
    })

    -- some quick sanity checks
    if not TS.get_installed then
      return LazyVim.error("Please use `:Lazy` and update `nvim-treesitter`")
    elseif type(opts.ensure_installed) ~= "table" then
      return LazyVim.error("`nvim-treesitter` opts.ensure_installed must be a table")
    end

    -- setup treesitter
    TS.setup(opts)
    LazyVim.treesitter.get_installed(true) -- initialize the installed langs

    -- install missing parsers
    local install = vim.tbl_filter(function(lang)
      return not LazyVim.treesitter.have(lang)
    end, opts.ensure_installed or {})
    if #install > 0 then
      LazyVim.treesitter.build(function()
        TS.install(install, { summary = true }):await(function()
          LazyVim.treesitter.get_installed(true) -- refresh the installed langs
        end)
      end)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
      callback = function(ev)
        local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
        if not LazyVim.treesitter.have(ft) then
          return
        end

        ---@param feat string
        ---@param query string
        local function enabled(feat, query)
          local f = opts[feat] or {} ---@type lazyvim.TSFeat
          return f.enable ~= false
            and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
            and LazyVim.treesitter.have(ft, query)
        end

        -- highlighting
        if enabled("highlight", "highlights") then
          pcall(vim.treesitter.start, ev.buf)
        end

        -- indents
        if enabled("indent", "indents") then
          LazyVim.set_default("indentexpr", "v:lua.LazyVim.treesitter.indentexpr()")
        end

        -- folds
        if enabled("folds", "folds") then
          if LazyVim.set_default("foldmethod", "expr") then
            LazyVim.set_default("foldexpr", "v:lua.LazyVim.treesitter.foldexpr()")
          end
        end
      end,
    })
  end,
}
