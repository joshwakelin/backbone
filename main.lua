local Backbone = {}


Backbone.Dependants = {
	["Folder"] = nil,
	["Path1"] = nil,
	["Path2"] = nil
}

Backbone.Funcs = {
	["system"] = function(...)
		return false 
	end,
}

Backbone.Pointers = {
	["system"] = {
		["id"] = 0,
		["description"] = "System information logging.",
		["task-location"] = "system",
		["blocked"] = {}
	}
} 


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

function Backbone.__GetPointerByName(name)
	if Backbone.Pointers[name] then return {true, Backbone.Pointers[name]} else return {false, nil} end
end


function Backbone.__StoreFunction(func)
	local ID = Backbone.__GenerateID()
	Backbone.Funcs[ID] = func	
end

function Backbone.Fire(player, name)
	assert(Backbone.__GetPointerByName(name)[1], "Path does not exist.")
	
end


function Backbone.Add(name, data)
	assert(not Backbone.__GetPointerByName(name)[1], "A path with this name already exists.")
	Backbone.__StoreFunction(data["function"])
	Backbone.Pointers[name] = data
end


return Backbone
