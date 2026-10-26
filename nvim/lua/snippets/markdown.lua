local ls = require("luasnip")

-- The first row is the header, matching the TeX table snippet's row count.
local function tab(_, snip)
	local rows = tonumber(snip.captures[1])
	local cols = tonumber(snip.captures[2])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, t("|"))
		for k = 1, cols do
			table.insert(nodes, t(" "))
			table.insert(nodes, r(ins_indx, j .. "x" .. k, i(1)))
			table.insert(nodes, t(" |"))
			ins_indx = ins_indx + 1
		end
		if j == 1 then
			table.insert(nodes, t({ "", "|" .. string.rep(" --- |", cols) }))
		end
		if j < rows then
			table.insert(nodes, t({ "", "" }))
		end
	end
	return sn(nil, nodes)
end

local function tr(_, snip)
	local cols = tonumber(snip.captures[1])
	local nodes = { t("|") }
	for k = 1, cols do
		table.insert(nodes, t(" "))
		table.insert(nodes, r(k, tostring(k), i(1)))
		table.insert(nodes, t(" |"))
	end
	return sn(nil, nodes)
end

return {
	s({
		trig = "tab([1-9]%d*)x([1-9]%d*)",
		trigEngine = "pattern",
		name = "Markdown table",
		dscr = "Table with rows (including the header) x columns",
		hidden = true,
	}, { d(1, tab), t({ "", "" }), i(0) }),
	s({
		trig = "tr([1-9]%d*)",
		trigEngine = "pattern",
		name = "Markdown table row",
		dscr = "Table row with the given number of columns",
		hidden = true,
	}, { d(1, tr), t({ "", "" }), i(0) }),
}
