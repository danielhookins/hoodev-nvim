-- Telescope configuration
local telescope_status, telescope = pcall(require, 'telescope')
if not telescope_status then
    return
end

telescope.setup({
  defaults = {
    -- Better file searching
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "%.lock",
      "__pycache__",
      "%.sqlite3",
      "%.ipynb",
      "vendor/*",
      "%.jpg",
      "%.jpeg",
      "%.png",
      "%.svg",
      "%.otf",
      "%.ttf",
    },
    -- Better sorting and matching
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    -- More flexible matching
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
  },
  pickers = {
    find_files = {
      -- Use fd if available (better than find), fallback to find
      find_command = function()
        if vim.fn.executable("fdfind") == 1 then
          return { "fdfind", "--type", "f", "--hidden", "--follow", "--exclude", ".git" }
        elseif vim.fn.executable("fd") == 1 then
          return { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" }
        elseif vim.fn.executable("rg") == 1 then
          return { "rg", "--files", "--hidden", "--glob", "!.git/*" }
        else
          return { "find", ".", "-type", "f" }
        end
      end,
    },
    live_grep = {
      -- Additional args for ripgrep
      additional_args = function()
        return {"--hidden", "--glob", "!.git/*"}
      end
    },
  },
})
