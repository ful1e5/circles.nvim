local M = {}

---Throw error with 'projekt0n/circles.nvim: ' prefix
---@param message string
M.error = function(message)
  error("projekt0n/circles.nvim: " .. message)
end

---override config.empty_icon to 'kyazdani42/nvim-web-devicons' plugin
---@param config circles.Config
local override_devicons = function(config)
  local installed, dev_icons = pcall(require, "nvim-web-devicons")
  if (installed) then
    local override_icons = dev_icons.get_icons()
    for _, icon in pairs(override_icons) do icon.icon = config.icons.empty end
    override_icons.default_icon = {icon = config.icons.empty}

    dev_icons.setup({override = override_icons, default = false})
  else
    M.error("plugin required 'kyazdani42/nvim-web-devicons'")
  end
end

---override config.empty_icon and config.filled_icon to 'kyazdani42/nvim-tree.lua' plugin
---@param config circles.Config
local override_nvimtree_icons = function(config)
  -- Make nvim-tree icons visible
  vim.g.nvim_tree_show_icons = {git = 0, folders = 1, files = 1, folder_arrows = 1}

  -- overriding nvim-tree icons
  local icons = config.icons
  vim.g.nvim_tree_icons = {
    default = icons.empty,
    symlink = icons.empty,
    folder = {
      default = icons.empty,
      open = icons.filled,
      empty = icons.empty,
      empty_open = icons.filled,
      symlink = icons.empty,
      symlink_open = icons.filled
    }
  }
end

---override lsp diagnostic prefix icon
---@param config circles.Config
local override_lsp_diagnostic_text = function(config)
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {prefix = config.icons.lsp_prefix},
    signs = true,
    update_in_insert = false
  })
end

---Load the circles.nvim plugin
---@param config circles.Config
M.load = function(config)
  override_devicons(config)
  override_nvimtree_icons(config)
  if (config.lsp) then override_lsp_diagnostic_text(config) end
end

return M
