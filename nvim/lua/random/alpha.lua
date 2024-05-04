local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
local fortune = require("alpha.fortune")

-- Set header
dashboard.section.header.val = {
    -- "                                                     ",
    -- "                                                     ",
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
    -- "                                                     ",
    -- "                                                     ",
    -- "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find file", ":Telescope find_files<CR>"),
    dashboard.button( "g", "  > Find file", ":Telescope live_grep<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}

-- Set footer
local options = {
    max_width = 69,
    quotes = { -- Your own list
        {"full of small trolls and rich in bungers", '', '- Catherine Yang'},
        {"What if we used ChatGPT to reply to my Hinge messages?", '', '- Catherine Yang'},
        {"IS RIGATONI A TYPE OF PIZZA?", '', '- Emma Lu'},
        {"Evelyn, are you Korean?", '', '- Emma Lu and Catherine Yang'},
        {"YAY! I HAVE HEADPHONES NOW!", 'NOW I CAN GO ON MY WALKS WITH MUSIC!', '- Dr. Pauline our #thiccqueen'},
    }
}
dashboard.section.footer.val = fortune(options)

-- Send config to alpha
alpha.setup(dashboard.opts)
