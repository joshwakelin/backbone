local Backbone = {}



Backbone.Dependants = {
	["Folder"] = nil,
	["Path1"] = nil,
	["Path2"] = nil,
	["Client"] = require(game.ReplicatedStorage.BackboneClientBridge)
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
	
	if log == 1 then
		table.insert(Backbone.Logs, 1, "Created " ..Args[1].." with backend ID of "..Args[2]..". ")
	
	elseif log == 2 then
		table.insert(Backbone.Logs, 1, "Created " ..Args[1].." with backend ID of "..Args[2]..". Refrence is stored on the client.")
	end
	
	
	if log == 3 then
		table.insert(Backbone.Logs, 1, "Fired " ..Args[1].." with params: ".. ... ..". ")
	end
	
	if log == 4 then
		table.insert(Backbone.Logs, 1, "Blocked "..Args[1].." from firing as a matching block was found.")
	end
	
	if log == 5 then
		table.insert(Backbone.Logs, 1, "Added block list for "..Args[1].." when argument #"..tostring(Args[3]).." is set to "..tostring(Args[2]))
		
	end
	
end
function Backbone.__Network()
	local Folder = Instance.new("Folder")
	Folder.Name = "Backbone Depandants"
	Folder.Parent = game:GetService("ReplicatedStorage")

	local Path1 = Instance.new("BindableEvent")
	Path1.Name = "Path1"
	Path1.Parent = Folder
	
	local Path2 = Instance.new("RemoteEvent")
	Path2.Name = "Path2"
	Path2.Parent = Folder
	
	Backbone.Dependants["Folder"] = Folder
	Backbone.Dependants["Path1"] = Path1
	Backbone.Dependants["Path2"] = Path2
	
	
	
	
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
	if profile['disabled'] == true then return false end
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
	if Profile[2]['task-location'] ~= "server" then
		warn("Attempted to fire a non-server task under server, request for function fire was stopped of "..name)
		return
	end
	
	local Fireable = Backbone.__AssessBlocks(name, {...}, Profile[2])
	if Fireable then Backbone.Funcs[Profile[2]['id']]({...}) end
	
end

function Backbone.FireClient(name, whom, ...)
	local Profile = Backbone.__GetPointerByName(name)
	assert(Profile[1], "Path does not exist.")
	if Profile[2]['task-location'] ~= "client" then
		warn("Attempted to fire a server task under client, request for function fire was stopped of "..name)
		return
	end
	
	print(name)

	local Fireable = Backbone.__AssessBlocks(name, {...}, Profile[2])
	print(typeof(whom))
	print(typeof({game.Players:WaitForChild("backbone398383")}))
	if typeof(whom) == 'Instance' then
		if Fireable then Backbone.Dependants.Path2:FireClient(whom, name, {...}) end
	elseif typeof(whom) == 'table' then
		for _, player in pairs(whom) do
			Backbone.Dependants.Path2:FireClient(player, name, {...})
		end
	end 
	
end

function Backbone.Add(name, request)
	assert(not Backbone.__GetPointerByName(name)[1], "A path with this name already exists.")
	local ID = Backbone.__StoreFunction(request["function"])
	Backbone.Pointers[name] = request
	print(Backbone.Pointers)
	Backbone.Pointers[name]["id"] = ID
	Backbone.Pointers[name]["blocked"] = {}
	Backbone.Pointers[name]["task-location"] = "server"
	Backbone.__CreateLog(1, name, ID)
end

function Backbone.Block(name, value, parameterNumber, func)
	local Profile = Backbone.__GetPointerByName(name)
	assert(Profile[1], "Path does not exist.")
	table.insert(Profile[2]["blocked"], 1, {
		["data"] = value,
		["param"] = tonumber(parameterNumber)
		
	})
	
end

function Backbone.ClientAdd(name, request)
	assert(not Backbone.__GetPointerByName(name)[1], "A path with this name already exists.")
	local ID = Backbone.__StoreFunction(request["function"])
	Backbone.Pointers[name] = request
	print(Backbone.Pointers)
	Backbone.Pointers[name]["id"] = ID
	Backbone.Pointers[name]["blocked"] = {}
	Backbone.Pointers[name]["disabled"] = request["disabled"] or false
	Backbone.Pointers[name]["task-location"] = "client"
	Backbone.Dependants["Client"].AddRef(ID, request["function"])
	Backbone.__CreateLog(2, name, ID)
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

function Backbone.Disable(name)
	local Profile = Backbone.__GetPointerByName(name)
	assert(Profile[1], "Path does not exist.")
	
	
	Profile[2]['disabled'] = true
end

function Backbone.Enable(name)
	local Profile = Backbone.__GetPointerByName(name)
	assert(Profile[1], "Path does not exist.")


	Profile[2]['disabled'] = false
end

return Backbone
