backbone = {}

network = {}

pool = {}

backbone.__Error(fatal, message) 
   assert(fatal, message)
   return message
end

backbone.CreateProtected()

end


backbone.Create(id, data)
   if network[id] then
     return self.__Error(false, "Network ID already exists.")
   else
      network[id] = {
         ['protected'] = false,
         ['ref'] = data["name"] or nil,
         ['functions'] = {},
         ['blocks'] = data["blockType"] or false,
         ['logs'] = {},
         ['debounce'] = {},
      
      }
      network[id]['logs'][1] = "Network created at ".. tostring(os.time()) .." via module creation."

end

backbone.Fire()
   
end

backbone.ProtectedFire()

end


backbone.Sever(id)
   
end


backbone.Disable(id)


end


backbone.Enable(id)
   
end

backbone.EditFunction()

end 

backbone.Block()

end

backbone.GetLogs()

end

backbone.GetMostRecentFire()

end

backbone.BlockArgument()

end

backbone.GetFiresByName()

end



return backbone
