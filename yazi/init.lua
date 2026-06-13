-- header: add hostname
Header:children_add(function()
  if ya.target_family() ~= "unix" then
    return ""
  end
  return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("green"):bold()
end, 500, Header.LEFT)

-- status
local size_nlink = function()
  local h = cx.active.current.hovered
  local size = h and (h:size() or h.cha.len) or 0

  return ui.Line({
    ui.Span(" " .. ya.readable_size(size) .. " "):bg("gray"):fg("blue"),
    ui.Span(""):bg("gray"):fg("blue"):bold(),
    ui.Span(" " .. tostring(h.cha.nlink) .. " "):bg("gray"):fg("blue"),
    ui.Span(th.status.sep_left.close):fg("gray"),
  })
end

-- symlink
local symlink = function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return " -> " .. tostring(h.link_to)
  else
    return ""
  end
end

-- user, group
local user_group = function()
  local h = cx.active.current.hovered
  if h == nil then
    return ""
  end

  return ui.Line({
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("gray"),
    ":",
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("gray"),
    " ",
  })
end

local mtime = function()
  local h = cx.active.current.hovered

  if not h or not h.cha.mtime then
    return ui.Span("")
  end

  return ui.Span(os.date("%Y-%m-%d %H:%M", h.cha.mtime // 1) .. " ")
end

-- unix specific
if ya.target_family() ~= "unix" then
  return
else
  Status:children_remove(2, Status.LEFT)
  Status:children_add(size_nlink, 2000, Status.LEFT)
  Status:children_add(mtime, 200, Status.RIGHT)
  Status:children_add(user_group, 500, Status.RIGHT)
end

Status:children_add(symlink, 3300, Status.LEFT)
