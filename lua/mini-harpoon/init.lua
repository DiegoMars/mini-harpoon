local M = {}
local data_path = vim.fn.stdpath("data") .. "/mini-harpoon.json"
local encode = vim.fn.json_encode
local decode = vim.fn.json_decode

M.list = {}

-- Load saved list
function M.load()
  local f = io.open(data_path, "r")
  if f then
    local content = f:read("*a")
    M.list = decode(content) or {}
    f:close()
  end
end

-- Save list to file
function M.save()
  local f = io.open(data_path, "w")
  if f then
    f:write(encode(M.list))
    f:close()
  end
end

-- Add current buffer to list
function M.add()
  local buf = vim.api.nvim_buf_get_name(0)
  if buf == "" then return end
  for _, v in ipairs(M.list) do
    if v == buf then return end
  end
  table.insert(M.list, buf)
  print("Added: " .. buf)
  M.save()
end

-- Go to buffer at index
function M.goto(index)
  local path = M.list[index]
  if path and vim.fn.filereadable(path) == 1 then
    vim.cmd("edit " .. path)
  else
    print("Invalid or missing path")
  end
end

-- Remove buffer at index
function M.remove(index)
  if M.list[index] then
    print("Removed: " .. M.list[index])
    table.remove(M.list, index)
    M.save()
  else
    print("Invalid index")
  end
end

-- Telescope picker to show list
function M.telescope()
  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon List",
    finder = require("telescope.finders").new_table {
      results = M.list,
    },
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      map("i", "<CR>", function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("edit " .. entry[1])
      end)
      return true
    end,
  }):find()
end

-- Initialize on load
M.load()

return M
