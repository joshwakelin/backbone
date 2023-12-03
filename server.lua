local whitelist = [] -- whitelisted for client usage, all others are set to only be set off via the server.




local function init()
  local connection, connection2, communicatior

  communicator = Instance.new("RemoteEvent", script)
  

  connection = communicator.OnServerEvent:Connect(function(client, intent)
      if not whitelist[intent] then
        client:Kick("")

    end
    

end
