local status_ok, tree = pcall(require, "nvim-surround")
if not status_ok then
    return
end

local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")


local function collapse_all()
    require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function edit_or_open()
    -- open as vsplit on current node
    local action = "edit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
        view.close() -- Close the tree if file was opened

    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)

    else
        require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
        view.close() -- Close the tree if file was opened
    end

end

local function vsplit_preview()
    -- open as vsplit on current node
    local action = "vsplit"
    local node = lib.get_node_at_cursor()

    -- Just copy what's done normally with vsplit
    if node.link_to and not node.nodes then
        require('nvim-tree.actions.node.open-file').fn(action, node.link_to)

    elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)

    else
        require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)

    end

    -- Finally refocus on tree if it was lost
    view.focus()
end

local git_add = function()
    local node = lib.get_node_at_cursor()
    local gs = node.git_status.file

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
        vim.cmd("silent !git add " .. node.absolute_path)

        -- If the file is staged, we unstage
    elseif gs == "M " or gs == "A " then
        vim.cmd("silent !git restore --staged " .. node.absolute_path)
    end

    lib.refresh_tree()
end

local tree_actions = {
    {
        name = "Create node",
        handler = require("nvim-tree.api").fs.create,
    },
    {
        name = "Remove node",
        handler = require("nvim-tree.api").fs.remove,
    },
    {
        name = "Trash node",
        handler = require("nvim-tree.api").fs.trash,
    },
    {
        name = "Rename node",
        handler = require("nvim-tree.api").fs.rename,
    },
    {
        name = "Fully rename node",
        handler = require("nvim-tree.api").fs.rename_sub,
    },
    {
        name = "Copy",
        handler = require("nvim-tree.api").fs.copy.node,
    },

    -- ... other custom actions you may want to display in the menu
}

local function tree_actions_menu(node)
	local entry_maker = function(menu_item)
		return {
			value = menu_item,
			ordinal = menu_item.name,
			display = menu_item.name,
		}
	end

	local finder = require("telescope.finders").new_table({
		results = tree_actions,
		entry_maker = entry_maker,
	})

	local sorter = require("telescope.sorters").get_generic_fuzzy_sorter()

	local default_options = {
		finder = finder,
		sorter = sorter,
		attach_mappings = function(prompt_buffer_number)
			local actions = require("telescope.actions")

			-- On item select
			actions.select_default:replace(function()
				local state = require("telescope.actions.state")
				local selection = state.get_selected_entry()
				-- Closing the picker
				actions.close(prompt_buffer_number)
				-- Executing the callback
				selection.value.handler(node)
			end)

			-- The following actions are disabled in this example
			-- You may want to map them too depending on your needs though
			actions.add_selection:replace(function() end)
			actions.remove_selection:replace(function() end)
			actions.toggle_selection:replace(function() end)
			actions.select_all:replace(function() end)
			actions.drop_all:replace(function() end)
			actions.toggle_all:replace(function() end)

			return true
		end,
	}

	-- Opening the menu
	require("telescope.pickers").new({ prompt_title = "Tree menu" }, default_options):find()
end

tree.setup({
    config = {
        view = {
            mappings = {
                custom_only = false,
                list = {
                    { key = "l", action = "edit", action_cb = edit_or_open },
                    { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
                    { key = "h", action = "close_node" },
                    { key = "H", action = "collapse_all", action_cb = collapse_all },
                    { key = "ga", action = "git_add", action_cb = git_add },
                }
            },
        },
        actions = {
            open_file = {
                quit_on_open = false
            }
        }
    }
})
