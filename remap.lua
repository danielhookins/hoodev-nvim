vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) 
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- Safely require telescope and set up keymaps only if available
local telescope_status, builtin = pcall(require, 'telescope.builtin')
if telescope_status then
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
else
    print("Telescope is not installed. Run :PackerInstall to install it.")
end
