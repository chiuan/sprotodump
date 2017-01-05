--[[
	给leaf生成msg.go
	注册协议信息并按顺序产生协议id
	by chiuanwei 2017-01
--]]
local util = require "util"

local fmt_file_header = [[
// Code generated
// DO NOT EDIT!

package msg

import (
	"server/sproto"
	"server/conf"
)

var Processor = sproto.NewProcessor(conf.MsgPack)
]]

local fmt_msg_name = [[       Processor.Register(&%s{})]]

local fmt_start = [[func init() {]]
local fmt_end = [[}]]

local fmt_cs_header = [[
// Code generated
// DO NOT EDIT!

using System;
using System.Collections.Generic;
using Sproto;
using UnityEngine;

namespace SprotoType
{
	public static class SprotoID
	{
		static Dictionary<short, Type> dictItoT = new Dictionary<short, Type>();

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
		static void Init()
		{
			foreach (var item in dictTtoI)
			{
				dictItoT[item.Value] = item.Key;
			}
		}

		public static short GetID(Type type)
		{
			short ret = -1;
			if (dictTtoI.TryGetValue(type, out ret))
			{
				return ret;
			}
			else
			{
				return -1;
			}
		}

		public static Type GetType(short id)
		{
			Type ret = null;
			if (dictItoT.TryGetValue(id, out ret))
			{
				return ret;
			}
			else
			{
				return null;
			}
		}
]]

local fmt_cs_id = [[			{typeof(%s),%d},]]
local fmt_cs_gen_if = [[			if (id == %d) { return new %s(content); }]]
local fmt_cs_gen_elseif = [[			else if (id == %d) { return new %s(content); }]]
local fmt_cs_gen_else = [[			else{ return null; }]]

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
	
	local names = {}
	-- 注意：顺序可能不一致的哦 
	for name, fields in pairs(trunk[1].type) do
		table.insert(names,name)
    end


	-- write msg.go
	local f = new_stream()
	f:write(fmt_file_header)
	f:write(fmt_start)
    for _,name in ipairs(names) do
    	f:write(fmt_msg_name:format(name))
    end
    f:write(fmt_end)

    -- write SprotoID.cs
    local f2 = new_stream()
    f2:write(fmt_cs_header)
    f2:write([[		static Dictionary<Type, short> dictTtoI = new Dictionary<Type, short>() {]])
    for i,name in ipairs(names) do
    	f2:write(fmt_cs_id:format(name,i-1))
    end
    f2:write([[		};]])

    f2:write([[		public static SprotoTypeBase Create(short id, ref byte[] content){]])
    for i,name in ipairs(names) do
    	if i == 1 then
    		f2:write(fmt_cs_gen_if:format(0,name))
    	else
    		f2:write(fmt_cs_gen_elseif:format(i-1,name))
    	end
    end
    f2:write(fmt_cs_gen_else)
    f2:write([[		}]]) --fuction
    f2:write([[	}]]) --class
    f2:write([[}]])

    local content = f:dump()
    local content2 = f2:dump()

    local goidfile = param.goidfile
    if not goidfile then
        print(content)
        return
    end
    local csidfile = param.csidfile
    if not csidfile then
    	print(content2)
    	return
    end

    util.write_file(goidfile, content, "w")
    util.write_file(csidfile, content2, "w")
end

return main
