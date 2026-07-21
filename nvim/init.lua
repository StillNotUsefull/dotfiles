-- ═══════════════════════════════════════════════════════════════
-- Colorscheme
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }

vim.cmd.colorscheme "catppuccin-mocha"

-- ═══════════════════════════════════════════════════════════════
-- Settings
-- ═══════════════════════════════════════════════════════════════

-- allow faster nvim startup by caching compiled lua modules
vim.loader.enable()

vim.g.have_nerd_font = true

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- ═══════════════════════════════════════════════════════════════
-- Keymaps
-- ═══════════════════════════════════════════════════════════════

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- enable mouse mode
vim.o.mouse = "a"

-- remove search highlighting after exiting search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- open nvim file explorer
vim.keymap.set("n", "<leader>pg", vim.cmd.Ex)

-- better indentation in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- move up or down a selection without overriding
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- scroll up or down with the cursor always in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- paste without adding the deleted selection to the register
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

-- create fancy code comment headings (aesthetic over function)
vim.keymap.set("n", "<leader>cs", function()
	local ft = vim.bo.filetype
	local title = vim.api.nvim_get_current_line():match("^%s*(.-)%s*$")

	-- Comment styles per filetype
	local styles = {
		lua = { prefix = "-- ", inline = nil },
		python = { prefix = "# ", inline = nil },
		sh = { prefix = "# ", inline = nil },
		bash = { prefix = "# ", inline = nil },
		zsh = { prefix = "# ", inline = nil },
		sql = { prefix = "-- ", inline = nil },
		javascript = { prefix = nil, inline = { "/* ", " */" } },
		typescript = { prefix = nil, inline = { "/* ", " */" } },
		javascriptreact = { prefix = nil, inline = { "/* ", " */" } },
		typescriptreact = { prefix = nil, inline = { "/* ", " */" } },
		c = { prefix = nil, inline = { "/* ", " */" } },
		cpp = { prefix = "// ", inline = nil },
		rust = { prefix = "// ", inline = nil },
		go = { prefix = "// ", inline = nil },
	}

	local style = styles[ft]
	if not style then
		vim.notify("No section comment style for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	local width = 63
	local bar = string.rep("═", width)
	local section

	if style.prefix then
		local p = style.prefix
		section = string.format("%s%s\n%s%s\n%s%s", p, bar, p, title, p, bar)
	else
		local open, close = style.inline[1], style.inline[2]
		section = string.format("%s%s%s\n%s %s %s\n%s%s%s", open, bar, close, open, title, close, open, bar, close)
	end

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	vim.api.nvim_buf_set_lines(0, row, row + 1, false, vim.split(section, "\n"))
end, { desc = "Create section comment from current line" })

-- ═══════════════════════════════════════════════════════════════
-- Language Server
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { { src = 'https://github.com/j-hui/fidget.nvim' } }
require('fidget').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end
  end,
})

---@type table<string, vim.lsp.Config>
local servers = {
  -- lsp
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },

  -- formatters
  stylua = {},
}

vim.pack.add {
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
}

-- Automatically install LSPs and related tools to stdpath for Neovim
require('mason').setup {}

-- Ensure the servers and tools above are installed
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  -- You can add other tools here that you want Mason to install
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- ═══════════════════════════════════════════════════════════════
-- Formatting
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { { src = 'https://github.com/stevearc/conform.nvim' } }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local enabled_filetypes = {
      -- lua = true,
      -- python = true,
    }
    if enabled_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    -- rust = { 'rustfmt' },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    -- You can use 'stop_after_first' to run the first available formatter from the list
    -- javascript = { "prettierd", "prettier", stop_after_first = true },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })

-- ═══════════════════════════════════════════════════════════════
-- Autocompletion
-- ══════════════════════════════════════════════════════════════

vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },

  signature = { enabled = true },
}

-- ═══════════════════════════════════════════════════════════════
-- Treesitter
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'rust', 'go' }
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  if not vim.treesitter.language.add(language) then return end
  vim.treesitter.start(buf, language)
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})

-- ═══════════════════════════════════════════════════════════════
-- Indent Blank Lines
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {}

-- ═══════════════════════════════════════════════════════════════
-- Git
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
require('gitsigns').setup {}

-- ═══════════════════════════════════════════════════════════════
-- Autopairs
-- ═══════════════════════════════════════════════════════════════

vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
require('nvim-autopairs').setup {}

vim.pack.add { 'https://github.com/windwp/nvim-ts-autotag' }
require('nvim-ts-autotag').setup {}
