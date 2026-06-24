local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim", commit = "6afb67460283f0e990d35d229fd38fdc04063e0a" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim", commit = "74b06c6c75e4eeb3108ec01852001636d85a932b" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs", commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim", commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67" }
  use { "JoosepAlviste/nvim-ts-context-commentstring", commit = "6141a40173c6efa98242dc951ed4b6f892c97027" }
  use { "kyazdani42/nvim-web-devicons", commit = "c72328a5494b4502947a022fe69c0c47e53b6aa6" }
  use { "kyazdani42/nvim-tree.lua", commit = "edd4e25fd4f8923f9e2816e27b5d1b1b5fff7a85" }
  use { "akinsho/bufferline.nvim", dependencies = 'nvim-tree/nvim-web-devicons', commit = "73540cb95f8d95aa1af3ed57713c6720c78af915" }
  use { "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" }
  use { "nvim-lualine/lualine.nvim", commit = "0a5a66803c7407767b799067986b4dc3036e1983" }
  use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
  use { "jedrzejboczar/possession.nvim", requires = { "nvim-lua/plenary.nvim" }, commit = "fbea95b16c284727bc8deff2c3780a73efcdaca6" }
  use { "lewis6991/impatient.nvim", commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6" }
  use { "lukas-reineke/indent-blankline.nvim", commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6" }
  use { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" }
  use { "ggandor/lightspeed.nvim", commit = "299eefa6a9e2d881f1194587c573dad619fdb96f" }
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96", }
  use { "stevearc/gkeep.nvim", run = ':UpdateRemotePlugins', commit = "eeb4f0e94bc10c3031f417c9d6adddfb2f104117" }
  use { "fgheng/winbar.nvim", commit = "13739fdb31be51a1000486189662596f07a59a31" }
  use { "rcarriga/nvim-notify", commit = "22f29093eae7785773ee9d543f8750348b1a195c" }
  use { "folke/which-key.nvim", commit = "b4301f50ff79a1801b8a8bdc463fe15bde26b37b" }
  use { "sindrets/diffview.nvim", commit = "6ca4cce071d527fa16c27781f98b843774ae84a7" }
  use { "ThePrimeagen/harpoon", branch = "harpoon2", requires = { {"nvim-lua/plenary.nvim"} }, commit = "0378a6c428a0bed6a2781d459d7943843f374bce" }
  use { "mbbill/undotree", commit = "56c684a805fe948936cda0d1b19505b84ad7e065"}
  use { "folke/todo-comments.nvim", commit = "a7e39ae9e74f2c8c6dc4eea6d40c3971ae84752d" }
  use { "kylechui/nvim-surround", commit = "9f0cb495f25bff32c936062d85046fbda0c43517" }
  use { "luckasRanarison/tailwind-tools.nvim", commit = "fbe982901d4508b0dcd80e07addf0fcb6dab6c49" }
  use { "onsails/lspkind-nvim" }

  -- ruby on rails
  use { "stevearc/dressing.nvim", commit = "2d7c2db2507fa3c4956142ee607431ddb2828639"}
  -- use { "weizheheng/ror.nvim", commit = "9d31ad3953be83ac8dd542725ca4881c861f64a5"}
  use { "~/Development/neovim/ror.nvim" }

  -- Colorschemes
  use { "TobiasBuchholz/darkplus.nvim", commit = "0a6887ea54000204faa4a000f09ffdfa58dd7914" }
  -- use { "~/.config/nvim/colorschemes/darkplus.nvim" } -- use this for local colorscheme development

  -- github copilot
  use { "copilotlsp-nvim/copilot-lsp", commit = "1b6d8273594643f51bb4c0c1d819bdb21b42159d" }
  use {
    "zbirenbaum/copilot.lua",
    commit = "ad7e729e9a6348f7da482be0271d452dbc4c8e2c",
    requires = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    cmd = "Copilot",
    event = "InsertEnter"
  }

  use {
    "zbirenbaum/copilot-cmp",
    commit = "15fc12af3d0109fa76b60b5cffa1373697e261d1",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }

  -- markdown preview
  use({
    'MeanderingProgrammer/render-markdown.nvim',
    after = { 'nvim-treesitter' },
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    commit = "8debb17aab2fbbf3b341e46ac032d0a6f937d8c3",
    config = function()
        require('render-markdown').setup({})
    end,
  })

  -- Claude Code
  use { "folke/snacks.nvim", commit = "ad9ede6a9cddf16cedbd31b8932d6dcdee9b716e" }
  use { "coder/claudecode.nvim", commit = "432121f0f5b9bda041030d1e9e83b7ba3a93dd8f" }

  -- Amp
  use { "sourcegraph/amp.nvim",
    commit = "621f1ca375fc2887d30a4ac32a8b6c582d28f9c0",
    lazy = false,
    opts = { auto_start = true, log_level = "info" }
  }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp", commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc" } -- The completion plugin
  use { "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" } -- buffer completions
  use { "hrsh7th/cmp-path", commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" } -- path completions
  use { "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" } -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" }
  use { "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" }
  use { "rambhosale/cmp-bootstrap.nvim", after = "nvim-cmp", event = "InsertEnter", commit = "42ecec1c27f5d5fe3915bc103a2ef649eac1073c" }

  -- snippets
  use { "L3MON4D3/LuaSnip", commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84" } --snippet engine
  use { "rafamadriz/friendly-snippets", commit = "2be79d8a9b03d4175ba6b3d14b082680de1b31b1" } -- a bunch of snippets to use

  -- LSP
  -- use { "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" } -- simple to use language server installer
  use { "neovim/nvim-lspconfig", commit = "4b7fbaa239c5db6b36f424a4521ca9f1a401be33" } -- enable LSP
  use { "williamboman/mason.nvim", commit = "b03fb0f20bc1d43daf558cda981a2be22e73ac42" }
  use { "williamboman/mason-lspconfig.nvim", commit = "0a3b42c3e503df87aef6d6513e13148381495c3a" }
  use { "nvimtools/none-ls.nvim", commit = "e135361b9c11755ef6c48f54a2c970c509b56239" } -- for formatters and linters
  use { "RRethy/vim-illuminate", commit = "e522e0dd742a83506db0a72e1ced68c9c130f185" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", commit = "028d9a0695a0cc4cfa893889f8c408ed7ccc8adc" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", commit = "cf12346a3414fa1b06af75c79faebe7f76df080a", run = ":TSUpdate" }

  -- Git
  use { "lewis6991/gitsigns.nvim", commit = "6d808f99bd63303646794406e270bd553ad7792e" }

  -- DAP
  use { "mfussenegger/nvim-dap", commit = "6b12294a57001d994022df8acbe2ef7327d30587" }
  use { "rcarriga/nvim-dap-ui", commit = "1cd4764221c91686dcf4d6b62d7a7b2d112e0b13" }
  use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }
  use { "Cliffback/netcoredbg-macOS-arm64.nvim", commit = "f071c23dde59a3e65984e4d8b3921726b63e0775", requires = { "mfussenegger/nvim-dap" } }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
