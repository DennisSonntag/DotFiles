local ls_status, ls = pcall(require, "luasnip")
if not ls_status then
	return
end

local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	{
		s("print", fmt('print!("{}");', { i(1, "") })),
	},
	{
		s("println", fmt('println!("{}");', { i(1, "") })),
	},
}
