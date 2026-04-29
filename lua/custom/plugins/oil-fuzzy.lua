local M = {}

function M.fuzzy_folders()
    local actions = require("telescope.actions")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local make_entry = require("telescope.make_entry")
    local conf = require("telescope.config").values
    local action_set = require("telescope.actions.set")
    local action_state = require("telescope.actions.state")
    local utils = require("telescope.utils")

    local mini_loaded, mini = pcall(require, "mini.icons")
    local folder_icon = mini_loaded and mini.get("directory", ".") or ""

    local function entry_maker(entry)
        local is_dir = vim.fn.isdirectory(entry) == 1
        local cwd = vim.fn.expand("%:p:h")
        local rel_path = vim.fn.fnamemodify(entry, ":.")
        local icon, icon_hl

        if is_dir then
            icon = folder_icon
            icon_hl = "TelescopeDirectory"
        else
            local basename = vim.fn.fnamemodify(entry, ":t")
            icon, icon_hl = utils.transform_devicons(basename, "", false)
            icon_hl = icon_hl or "TelescopeNormal"
        end

        local display = icon .. " " .. rel_path
        local style = { { { 0, #icon + 1 }, icon_hl } }

        return {
            value = entry,
            display = display,
            ordinal = rel_path,
            path = entry,
            valid = true,
            __TelescopeDisplaySetup = { display = style },
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
                local path = selection.path
                if vim.fn.isdirectory(path) == 1 then
                    vim.cmd("Oil " .. path)
                else
                    vim.cmd("edit " .. path)
                end
            end)
            return true
        end,
    }):find()
end

return M
