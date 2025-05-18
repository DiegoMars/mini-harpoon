# mini-harpoon
Here is my version of [ThePrimeagen/harpoon](https://github.com/ThePrimeagen/harpoon)

## Dependencies
Currently, the only dependency is [telescope](https://github.com/nvim-telescope/telescope.nvim) 
to view the list of harpooned files.

## Installation
I am currently using [lazy.nvim](https://github.com/folke/lazy.nvim), so here 
is the installation that I have:
```lua
{
  "DiegoMars/mini-harpoon",
  dependencies = { "nvim-telescope/telescope.nvim" },
}
```

## My configuration
Here is currently how I have my stuff set up, change as you see fit!
```lua
local harpoon = require("mini-harpoon")

-- Add buffer to the list of harpooned buffers
vim.keymap.set("n", "<leader>ha", harpoon.add, { desc = "[h]arpoon [a]dd" })

-- Moves to that buffer
vim.keymap.set("n", "<leader>1", function() harpoon.goto(1) end, { desc = "Buffer [1]" })
vim.keymap.set("n", "<leader>2", function() harpoon.goto(2) end, { desc = "Buffer [2]" })
vim.keymap.set("n", "<leader>3", function() harpoon.goto(3) end, { desc = "Buffer [3]" })
vim.keymap.set("n", "<leader>4", function() harpoon.goto(4) end, { desc = "Buffer [4]" })

-- Remove active buffer from the list if it is in it
vim.keymap.set("n", "<leader>hr", function()
  local current = vim.api.nvim_buf_get_name(0)

  for i, path in ipairs(harpoon.list) do
    if path == current then
      table.remove(harpoon.list, i)
      print("Removed: " .. path)
      harpoon.save()
      return
    end
  end

  print("Current file not in Harpoon list")
end, { desc = "Remove current file from Harpoon" })

-- Show the current list of files
vim.keymap.set("n", "<leader>he", harpoon.telescope, { desc = "[h]arpoon [e]xplore" })
```

## To-do
 - [ ] Add some per project permanence rather than global
 - [ ] Work on geting that data error thing out
 - [ ] Add more functionality to the telescope menu
    - [ ] Number the buffers
    - [ ] Reorder buffers
    - [ ] Delete buffers
 - [ ] Add my own docs
