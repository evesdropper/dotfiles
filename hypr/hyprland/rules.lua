-- workspace rules

-- window rules

-- clipse float
hl.window_rule({
  name = "clipse",
  match = {
    class = "clipse",
  },
  float = true,
  size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
})

-- offloading screen.sh float window hellhole to hypr
hl.window_rule({
  name = "satty floating",
  match = {
    class = "com.gabm.satty",
  },
  float = true,
  min_size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
  max_size = { "(monitor_w*0.9)", "(monitor_h*0.9)" },
})

-- open windows in specific workspaces + added rules
hl.window_rule({
  name = "firefox",
  match = {
    class = "firefox",
  },
  group = "set",
  workspace = "2",
})

hl.window_rule({
  name = "bitwarden",
  match = {
    class = "bitwarden",
  },
  group = "set",
  workspace = "3",
})

hl.window_rule({
  name = "signal",
  match = {
    class = "signal",
  },
  group = "set",
  workspace = "4",
})

hl.window_rule({
  name = "beeper",
  match = {
    class = "beeper",
  },
  group = "set",
  workspace = "4",
})

hl.window_rule({
  name = "obsidian",
  match = {
    class = "obsidian",
  },
  group = "set",
  workspace = "5",
})
