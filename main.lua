local Backbone = {}


Backbone.Dependants = {
	["Folder"] = nil,
	["Path1"] = nil,
	["Path2"] = nil
}

Backbone.Funcs = {
	["system"] = function(...)
		
	end,
}

Backbone.Logs = {
	
}
Backbone.Pointers = {
	["system"] = {
		["id"] = 0,
		["description"] = "System information logging.",
		["task-location"] = "system",
		["blocked"] = {},
		["disabled"] = true,
	}
} 


function Backbone.__CreateLog(log, ...)
	local Args = {...}
	local Length = #Backbone.Logs
	
	if Length > 99 then Backbone.Logs[100] = nil end
	
	if log == "Creation" then
		table.insert(Backbone.Logs, 1, "Created " ..Args[1].." with backend ID of "..Args[2]..". ")
	end
	
	if log == "Fire" then
		table.insert(Backbone.Logs, 1, "Fired " ..Args[1].." with params: ".. ... ..". ")
	end
	
	if log == "Blocked" then
		table.insert(Backbone.Logs, 1, "Blocked "..Args[1].." from firing as a matching block was found.")
	end
	
	if log == "Block" then
		table.insert(Backbone.Logs, 1, "Added block list for "..Args[1].." when argument #"..tostring(Args[3]).." is set to "..tostring(Args[2]))
		
	end
	
end
function Backbone.__Network()
	local Folder = Instance.new("Folder")
	Folder.Name = "Backbone Depandants"
	Folder.Parent = game:GetService("ReplicatedStorage")

	local Path1 = Instance.new("RemoteEvent")
	Path1.Name = "Path1"
	Path1.Parent = Folder
	
	local Path2 = Instance.new("RemoteEvent")
	Path2.Name = "Path2"
	Path2.Parent = Folder
	
	Backbone.Dependants["Folder"] = Folder
	Backbone.Dependants["Path1"] = Path1
	Backbone.Dependants["Path2"] = Path1
	
	return true
end






function Backbone.__GenerateID()
	local Final = ""

	for i = 1, 20 do
		Final ..= string.char(math.random(("a"):byte(), ("z"):byte()))
	end
	
	return Final
end

function Backbone.__AssessBlocks(name, parameters, profile)
	if #profile['blocked'] == 0 then return true end
	
	for i, v in ipairs(profile['blocked']) do
		if v["param"] == 0 then
				for j, k in pairs(parameters) do
					print(v, k)
					if v == k then 
						--check callback
						return false
						
					end
				end
			else
				if parameters[v["param"]] == v["data"] then
					return false
				end
			end
		end	
	return true	
end
function Backbone.__GetPointerByName(name)
	if Backbone.Pointers[name] then return {true, Backbone.Pointers[name]} else return {false, nil} end
end


function Backbone.__StoreFunction(func)
	local ID = Backbone.__GenerateID()
	Backbone.Funcs[ID] = func
	print(Backbone.Funcs)
	return ID	
end

function Backbone.Fire(name, ...)
	local Profile = Backbone.__GetPointerByName(name)
	assert(Profile[1], "Path does not exist.")
	local Fireable = Backbone.__AssessBlocks(name, {...}, Profile[2])
	if Fireable then Backbone.Funcs[Profile[2]['id']]({...}) end
	
end


function Backbone.Add(name, request)
	assert(not Backbone.__GetPointerByName(name)[1], "A path with this name already exists.")
	local ID = Backbone.__StoreFunction(request["function"])
	Backbone.Pointers[name] = request
	print(Backbone.Pointers)
	Backbone.Pointers[name]["id"] = ID
	Backbone.Pointers[name]["blocked"] = {}
	Backbone.Pointers[name]["task-location"] = "server"
	Backbone.__CreateLog("Creation", name, ID)
end

function Backbone.Block(name, value, parameterNumber, func)
	local Profile = Backbone.__GetPointerByName(name)
	assert(Profile[1], "Path does not exist.")
	table.insert(Profile[2]["blocked"], 1, {
		["data"] = value,
		["param"] = tonumber(parameterNumber)
		
	})
	
end

function Backbone.Unblock(name, value, loc)
	local Profile = Backbone.__GetPointerByName(name)
	
	assert(Profile[1], "Path does not exist.")
	local RemovalCount = 0;
	for i, v in ipairs(Profile[2]["blocked"]) do
		if value == v["data"] then
			if loc then 
				if v["param"] == tonumber(loc) then
					Profile[2]["blocked"][i] = nil
					RemovalCount += 1
				end
			else
				Profile[2]["blocked"][i] = nil
				RemovalCount += 1 
			end
		end
	end	
	return "Removed ".. RemovalCount.." instance(s) of blocks."
end

return Backbone
