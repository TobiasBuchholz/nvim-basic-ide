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
  use { "nvim-lua/plenary.nvim", commit = "08e301982b9a057110ede7a735dd1b5285eb341f" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs", commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim", commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67" }
  use { "JoosepAlviste/nvim-ts-context-commentstring", commit = "32d9627123321db65a4f158b72b757bcaef1a3f4" }
  use { "kyazdani42/nvim-web-devicons", commit = "5b9067899ee6a2538891573500e8fd6ff008440f" }
  use { "kyazdani42/nvim-tree.lua", commit = "edd4e25fd4f8923f9e2816e27b5d1b1b5fff7a85" }
  use { "akinsho/bufferline.nvim", dependencies = 'nvim-tree/nvim-web-devicons', commit = "73540cb95f8d95aa1af3ed57713c6720c78af915" }
  use { "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" }
  use { "nvim-lualine/lualine.nvim", commit = "0a5a66803c7407767b799067986b4dc3036e1983" }
  use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
  use { "jedrzejboczar/possession.nvim", requires = { "nvim-lua/plenary.nvim" }, commit = "d4a071e26ba49d147c6ceaa7fe209d6c6e5d10fd" }
  use { "lewis6991/impatient.nvim", commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6" }
  use { "lukas-reineke/indent-blankline.nvim", commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6" }
  use { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" }
  use { "ggandor/lightspeed.nvim", commit = "299eefa6a9e2d881f1194587c573dad619fdb96f" }
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96", }
  use { "stevearc/gkeep.nvim", run = ':UpdateRemotePlugins', commit = "eeb4f0e94bc10c3031f417c9d6adddfb2f104117" }
  use { "fgheng/winbar.nvim", commit = "13739fdb31be51a1000486189662596f07a59a31" }
  use { "rcarriga/nvim-notify", commit = "50d037041ada0895aeba4c0215cde6d11b7729c4" }
  use { "folke/which-key.nvim", commit = "b4301f50ff79a1801b8a8bdc463fe15bde26b37b" }
  use { "sindrets/diffview.nvim", commit = "6ca4cce071d527fa16c27781f98b843774ae84a7" }
  use { "ThePrimeagen/harpoon", branch = "harpoon2", requires = { {"nvim-lua/plenary.nvim"} }, commit = "0378a6c428a0bed6a2781d459d7943843f374bce" }
  use { "mbbill/undotree", commit = "56c684a805fe948936cda0d1b19505b84ad7e065"}
  use { "folke/todo-comments.nvim", commit = "a7e39ae9e74f2c8c6dc4eea6d40c3971ae84752d" }
  use { "kylechui/nvim-surround", tag = "*" }

  -- ruby on rails
  use { "stevearc/dressing.nvim", commit = "5162edb1442a729a885c45455a07e9a89058be2f"}
  use { "weizheheng/ror.nvim", commit = "9d31ad3953be83ac8dd542725ca4881c861f64a5"}

  -- Colorschemes
  use { "TobiasBuchholz/darkplus.nvim", commit = "eb1be7900867c97b7056b885268eccfa8bb390c0" }
  -- use { "~/.config/nvim/colorschemes/darkplus.nvim" } -- use this for local colorscheme development

  -- github copilot
  use {
    "zbirenbaum/copilot.lua",
    commit = "f7612f5af4a7d7615babf43ab1e67a2d790c13a6",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({ suggestion = {enabled = false}, panel = {enabled = false} })
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    commit = "72fbaa03695779f8349be3ac54fa8bd77eed3ee3",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }

  -- ChatGPT
  use({
    "frankroeder/parrot.nvim",
    commit = "048a77d00ff427ce01c32a381ecff7f94a455643",
    requires = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim'},
    cmd = 'PrtStatus',
    config = function()
      require "user.parrot"
    end
  })

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
  use { "neovim/nvim-lspconfig", commit = "97762065bf7e1ac617d0a8710eb7ec2d656287a9" } -- enable LSP
  use { "williamboman/mason.nvim", commit = "751b1fcbf3d3b783fcf8d48865264a9bcd8f9b10" }
  use { "williamboman/mason-lspconfig.nvim", commit = "05744f0f1967b5757bd05c08df4271ab8ec990aa" }
  use { "jose-elias-alvarez/null-ls.nvim", commit = "0010ea927ab7c09ef0ce9bf28c2b573fc302f5a7" } -- for formatters and linters
  use { "RRethy/vim-illuminate", commit = "e522e0dd742a83506db0a72e1ced68c9c130f185" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", commit = "fac83a556e7b710dc31433dec727361ca062dbe9" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", commit = "268611e3ece8463bfb5b09044dcd1b76a28ffbb6" }

  -- Git
  use { "lewis6991/gitsigns.nvim", commit = "805610a9393fa231f2c2b49cb521bfa413fadb3d" }

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
