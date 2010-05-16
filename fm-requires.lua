#!/usr/bin/lua

local dir=table.remove(arg,1);
local project;
if dir:find("_") then
	project=dir:sub(1, dir:find("_")-1);
else
	project=dir;
end;
local env;
local dependencies={};
local files={};
local externalDependencies={};

local current={};
local CURRENT_ARG="";

local function orig_require(name)
	if not name:find("%.lua$") then
		name=name..".lua";
	end;
	if env._context[name] then
		return;
	end;
	env._context[name]=true;
	local f, err=loadfile(name);
	if not f then
		error(CURRENT_ARG..": "..err);
	end;
	setfenv(f,env);
	f();
end;

function watching_require(f)
	if not f:find("%.lua$") then
		f=f..".lua";
	end;
	if CURRENT_ARG==f then
		return;
	end;
	local required_dir=f:match("^([^/\\]*)[/\\]");
	assert(required_dir, f);
	if required_dir ~= dir then
		if required_dir ~= "wowbench" then
			externalDependencies[required_dir]=true;
		end;
	else
		table.insert(current, f);
	end;
	env.require=orig_require;
	orig_require(f);
	env.require=watching_require;
end;
require=watching_require;

local global=loadfile(project.."/global.lua");

local excludes={};
local exf=io.open(project.."/excludes");
if exf then
	for f in exf:lines() do
		excludes[project.."/"..f]=true;
	end
end

local function parse(f)
	if excludes[f] then
		return;
	end;
	env=setmetatable({
		_context={},
		require=watching_require,
		print=function()
			-- noop
		end
	},{ __index=_G});
	current={};
	table.insert(files, f);
	dependencies[f]=current;
	local f=assert(loadfile(f));
	setfenv(f, env);
	if global then 
		global();
	end;
	f()
end;

for i=1, #arg do
	CURRENT_ARG=arg[i];
	parse(arg[i]);
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
			s=s..join;
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

externalDependencies[project]=true;
print("## Dependencies: "..strjoin(", ", unpack(keys(externalDependencies))));

local parents=dependencies;
function IsChildOf(child, possibleParent, searched)
	if not searched then
		searched={};
	end;
	if searched[possibleParent] then
		return false;
	end;
	searched[possibleParent]=true;
	if contains(parents[child], possibleParent, searched) then
		return true;
	end;
	for i=1, #parents[child] do
		if IsChildOf(parents[child][i], possibleParent, searched) then
			return true;
		end;
	end;
	return false;
end;

local ordered={};
function Insert(file)
	for i=1,#ordered do
		if IsChildOf(ordered[i], file) then
			table.insert(ordered, i, file);
			return;
		end;
	end;
	table.insert(ordered, file);
end;

for i=1,#files do
	Insert(files[i]);
end;

for i=1, #ordered do
	local _,name=assert(ordered[i]:match("^(.*)[/\\](.*)$"));
	print(name);
end;
