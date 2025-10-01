-- init.lua

-- Fix Lua's package.path so require('user.settings') works
local config_path = vim.fn.stdpath("config")
package.path = package.path .. ";" .. config_path .. "/?.lua;" .. config_path .. "/?/init.lua"

vim.g.mapleader = " "
require("user.settings")
require("user.keymaps")

-- Plugin manager setup
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(require("user.plugins"))

-- LSP
require("user.lsp")
