#!/usr/bin/lua

local dir=table.remove(arg,1);
local env;
local dependencies={};
local externalDependencies={};

local current={};

local function orig_require(name)
	if env._context[name] then
		return;
	end;
	env._context[name]=true;
	local f=assert(loadfile(name));
	setfenv(f,env);
	f();
end;
function watching_require(f)
	if not f:find("%.lua$") then
		f=f..".lua";
	end;
	local required_dir=f:match("^(.*)[/\\]");
	if required_dir ~= dir then
		externalDependencies[required_dir]=true;
		orig_require(f);
		return;
	end;
	table.insert(current, f);
	if dependencies[f] then
		require=orig_require;
		orig_require(f);
		require=watching_require;
	else
		local old_current=current;
		current={};
		dependencies[f]=current;
		orig_require(f);
		current=old_current;
	end;
end;
require=watching_require;

for i=1, #arg do
	env=setmetatable({
		_context={},
		require=watching_require,
		print=function()
			-- noop
		end
	},{ __index=_G});
	current={};
	dependencies[arg[i]]=current;
	local f=assert(loadfile(arg[i]));
	setfenv(f, env);
	f()
end;

local function keys(t)
	local r={};
	for k,v in pairs(t) do
		table.insert(r,k);
	end;
	return r;
end;

local function strjoin(join, ...)
	local s="";
	for i=1,select("#",...) do
		local v=select(i,...);
		s=s..v;
		if i<select("#",...) then
			s=s..", ";
		end;
	end;
	return s;
end;

local function contains(t, v)
	for i=1, #t do
		if t[i]==v then
			return true;
		end;
	end;
	return false;
end;

print("## Dependencies: ".. strjoin(", ", unpack(keys(externalDependencies))));

local ordered={};
function Insert(file)
	for i=1,#ordered do
		if contains(dependencies[ordered[i]], file) then
			table.insert(ordered, i, file);
			return;
		end;
	end;
	table.insert(ordered, file);
end;

for k,v in pairs(dependencies) do
	Insert(k);
end;

for i=1, #ordered do
	local _,name=assert(ordered[i]:match("^(.*)[/\\](.*)$"));
	print(name);
end;
