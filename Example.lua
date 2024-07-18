local Backbone = require(script.Parent.Backbone)

--[[
  -- Usage  
  Backbone.Add(Name, InformationTable)
  
  Name = The name of the function.
  InformationTable = A table which consists of parameters. 
--]]

Backbone.Add("printStatement", {
	["function"] = function(argumentTable)
		local Argument1 = argumentTable[1]
		local Argument2 = argumentTable[2]
		print(Argument1)
		print(Argument2)
	end,
})

--[[
  -- Usage  
  Backbone.Fire(Name, ...)
  
  Name = The name of the function.
  ... = Any parameters you'd like to fire. 
--]]

Backbone.Fire("printStatement", "foo", "bar")

--[[
  -- Usage  
  Backbone.Block(Name, Value, ParameterNumber)
  
  Name = The name of the function.
  Value = The value to block out.
  ParameterNumber = The parameter number that must match to block. Set this to 0 for any parameter number.
--]]
Backbone.Block("printStatement", "evil", 2)
Backbone.Fire("printStatement", "evil", "evil") -- Won't fire, because firing is blocked.

--[[
  -- Usage  
  local Unblock = Backbone.Unblock(Name, Value, *ParameterNumber)
  
  Name = The name of the function you wish to edit. 
  Value = The value to unblock.
  ParameterNumber = (optional) parameter number to unblock. Leave blank to remove all instances.
  Unblock = Response message.
--]]
local Unblock = Backbone.Unblock("printStatement", "evil")
print(Unblock) --> 'Removed 1 instance(s) of blocks.'

--[[
  -- Usage  
  Backbone.Disable(Name)
  
  Name = The function you'd like to disable.
--]]
Backbone.Disable("printStatement")

--[[
  -- Usage  
  Backbone.Enable(Name)
  
  Name = The function you'd like to enable.
--]]
Backbone.Enable("printStatement")



-- Example codes


-- Kill all function, adds a password for showcasing usage of arguments.
Backbone.Add("killAll", {
	["function"] = function(argumentTable)
		local password = argumentTable[1]
		if password == "hey" then
			for i, v in pairs(game.Players:GetPlayers()) do
				v.Character:FindFirstChildOfClass("Humanoid").Health = 0
			end
		end
	end,
})

spawn(function()
	task.wait(6)
	Backbone.Fire("killAll", "hey")
end)



-- Backbone, create a function which changes a players points.
Backbone.Add("connectPointGain", {
	["function"] = function(argumentTable)
		local player = argumentTable[1]
		local points = player:WaitForChild("leaderstats"):WaitForChild("Points")
		points.Value += 1
	end,
})

-- Leaderstat addition, not related to code.
game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	local points = Instance.new("IntValue")
	points.Name = "Points"
	points.Value = 0 
	points.Parent = leaderstats
	leaderstats.Parent = player
	
	-- Every second, call the connectPointGain function we created above.

	local TaskSpawn = true
	 task.spawn(function()
		while task.wait(1) and TaskSpawn do
			Backbone.Fire("connectPointGain", player)
			
			-- Now, to spice it up, let's prevent the player from gaining points after 20 points with the Backbone block function.
			if player.leaderstats.Points.Value >= 20 then
				TaskSpawn = false -- Prevent loop from dataleaking and excessive running. 
				Backbone.Block("connectPointGain", player, 1)
			end
			
		end
	end)
	
end)


