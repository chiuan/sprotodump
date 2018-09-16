--[[
	给leaf生成msg.go
	注册协议信息并按顺序产生协议id
	by chiuanwei 2017-01
--]]
local util = require "util"

local fmt_file_header = [[
-- Code generated
-- DO NOT EDIT!

]]

local fmt_start = [[local index = {]]
local fmt_end = [[
}
return index
]]

local fmt_item = [[
	%s = %d,]]


local test = {
	addmessage = 1,
	bb = 2,
}

local stream = {}
stream.__index = stream

function stream:write(str)
    table.insert(self.lines, str)
end

function stream:dump()
    return table.concat(self.lines, "\n")
end

local function new_stream()
    local obj = {
        lines = {}
    }
    return setmetatable(obj, stream)
end

local function main(trunk,build,param )

	local index = {count = 0,}

	

	-- 读取老的记录
	local path = param.outfile
	if util.check_file(path) then
		if _VERSION == "Lua 5.3" then
			index = assert(load(util.read_file(path)))()
		else
			index = assert(loadstring(util.read_file(path)))()
		end
	end

    -- 从现在的type中生成一系列序号记录起来
    local types = trunk[1].sort_types
    for i,v in ipairs(types) do
    	if index[v] == nil then
    		index[v] = index.count
    		index.count = index.count + 1
    	else
    		-- 已经存在了就不需要再次赋值index
    	end
    end

    -- 写入文件
    local f = new_stream()
	f:write(fmt_file_header)
	f:write(fmt_start)
	local items = {}
    for k,v in pairs(index) do
    	table.insert(items, fmt_item:format(k,v))
	end
	table.sort(items)
	for _,v in ipairs(items) do
		f:write(v)
	end
    f:write(fmt_end)
	local content = f:dump()
	if path ~= nil then
		util.write_file(path, content, "w")
	else
		print("没有输入index的文件路径.")
	end

end

return main
