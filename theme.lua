-- Theme configuration
local status_ok, tokyonight = pcall(require, "tokyonight")
if not status_ok then
    return
end

tokyonight.setup({
  style = "storm", -- Options: "storm", "moon", "night", "day"
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
  },
  sidebars = { "qf", "help" },
  dim_inactive = false,
  lualine_bold = false,
})
vim.cmd[[colorscheme tokyonight]]
