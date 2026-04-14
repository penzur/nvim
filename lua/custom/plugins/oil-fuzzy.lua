local M = {}

function M.fuzzy_folders()
    local actions = require("telescope.actions")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local action_set = require("telescope.actions.set")
    local action_state = require("telescope.actions.state")

    local mini_loaded, mini = pcall(require, "mini.icons")
    local folder_icon = mini_loaded and mini.get("directory", ".") or ""

    local function entry_maker(entry)
        return {
            value = entry,
            display = folder_icon .. " " .. entry,
            ordinal = entry,
            path = entry,
        }
    end

    local fd_cmd = vim.fn.executable("fd") == 1
        and { "fd", "--type", "d", "--color", "never" }
        or { "find", ".", "-type", "d" }

    local results = vim.fn.systemlist(table.concat(fd_cmd, " "))
    if vim.v.shell_error ~= 0 then
        vim.notify("fuzzy_folders: failed to find directories", vim.log.levels.ERROR)
        return
    end

    pickers.new({}, {
        prompt_title = "Folders",
        finder = finders.new_table({
            results = results,
            entry_maker = entry_maker,
        }),
        sorter = conf.file_sorter(),
        attach_mappings = function(prompt_bufnr)
            action_set.select:replace(function()
                local selection = action_state.get_selected_entry()
                actions._close(prompt_bufnr)
                vim.cmd("Oil " .. selection.path)
            end)
            return true
        end,
    }):find()
end

return M
