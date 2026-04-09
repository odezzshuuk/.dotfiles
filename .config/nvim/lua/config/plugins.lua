vim.pack.add({
  -- useful module packer
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },

  -- ai completion
  { src = "https://github.com/github/copilot.vim" },

  -- extension api
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- Useful lua functions used ny lots of plugins

  -- appearance
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim", },

  -- theme
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/scottmckendry/cyberdream.nvim" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/Shatur/neovim-ayu", },

  "https://github.com/HiPhish/rainbow-delimiters.nvim",

  -- which key
  { src = "https://github.com/folke/which-key.nvim", },

  -- cmp
  { src = "https://github.com/hrsh7th/nvim-cmp", },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-cmdline" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lua" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" }, -- snippet completions
  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
  },
  { src = "https://github.com/rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
  { src = "https://github.com/folke/lazydev.nvim", },

  -- telescope
  { src = "https://github.com/nvim-telescope/telescope.nvim", },
  { src = "https://github.com/nvim-telescope/telescope-media-files.nvim" },
  { src = "https://github.com/benfowler/telescope-luasnip.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua", },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  -- lsp
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },                   -- simple to use language server installer
  {
    src = "https://github.com/mason-org/mason-lspconfig.nvim", -- simple to use language server installer
    -- version = "v1.32.0",  -- for working with require("lspconfig")[lang].setup({})
  },
  { src = "https://github.com/nvimtools/none-ls.nvim", },
  { src = 'https://github.com/Issafalcon/lsp-overloads.nvim' },
  { src = 'https://github.com/onsails/lspkind.nvim' },

  -- treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", },

  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },

  -- git
  {src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons"},
  {
    src = "https://github.com/sindrets/diffview.nvim",
  },

  -- file info
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/hedyhli/outline.nvim" },

  -- edit
  {
    src = "https://github.com/kylechui/nvim-surround",
    version = vim.version.range("4.x"), -- Use for stability; omit to use `main` branch for the latest features
  },
  {
    src = 'https://github.com/smoka7/hop.nvim',
  },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = "https://github.com/windwp/nvim-ts-autotag" },

  -- Debugger
  { src = "https://github.com/mfussenegger/nvim-dap", },

  -- tmux seamless
  { src = "https://github.com/christoomey/vim-tmux-navigator", },

  -- my plugin
  {
    src = "https://github.com/odezzshuuk/mini-functions.nvim",
    version = "dev",
  },
})

require("nvim-surround").setup()
