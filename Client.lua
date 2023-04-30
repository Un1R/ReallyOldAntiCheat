local GameEssentials = game:GetService("ReplicatedStorage"):FindFirstChild("GameEssentials")
local CheckValue = GameEssentials:FindFirstChild("CheckValue")
local SendValue = GameEssentials:FindFirstChild("SendValue")

repeat wait() until game.Players.LocalPlayer

local Ccharacter = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

local toolCount = 0

Ccharacter.ChildAdded:Connect(function(instance)
	if instance:IsA('Tool') then
		toolCount = toolCount + 1
	end
end)

GameEssentials:FindFirstChild("Check2").OnClientInvoke = function(Player,Character,Feature,IsEnabled,KickMessage)
	local log = 0
	
	if Feature == "MultiTool" and IsEnabled == true then
		if Character:IsDescendantOf(workspace) then
			if toolCount >= 2 and log == 0 then
				log = 1
				GameEssentials:FindFirstChild("SendLog"):FireServer(Player.Name,"Attempted to Tool Crash or equip more than 1 tool at once")
				Player:Kick(KickMessage)
			end
		end
	end
	
	if Feature == "BTools" and IsEnabled == true then
		local PossibleNames = {
			["Undo"] = true;
			["Delete"] = true;
			["Identify"] = true;
			["Move"] = true;
		}
		for _,x in ipairs(Player.Backpack:GetChildren()) do
			if x.Name == "HopperBin" or x.ClassName == "HopperBin" or PossibleNames[x.Name] then
				GameEssentials:FindFirstChild("SendLog"):FireServer(Player.Name,"BTools detected")
				x:Destroy()
			end
		end

		if Character:FindFirstChildWhichIsA("HopperBin") then
			GameEssentials:FindFirstChild("SendLog"):FireServer(Player.Name,"BTools detected")
			Character:FindFirstChildWhichIsA("HopperBin"):Destroy()
		end

		for _,kzq in ipairs(Character:GetChildren()) do
			if PossibleNames[kzq.Name] then
				GameEssentials:FindFirstChild("SendLog"):FireServer(Player.Name,"BTools detected")
				kzq:Destroy()
			end
		end
	end
	
end

SendValue.OnClientEvent:Connect(function(Player,Character,Humanoid,Max,Type,Action,Default,KickMsg)
	
	if Type == "Health" then
		if Humanoid then
			
			if Humanoid.Health > Max then
				
				if Action == "ResetToNormal" then
					GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Health Value is above the max, or god mode detected")
					Player:Kick("<<[BytTec]>> Health Value is above the max, or god mode detected.")
				end
				
				if Action == "Kick" then
					GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Health Value is above the max, or god mode detected")
					Player:Kick("<<[BytTec]>> Health Value is above the max, or god mode detected.")
				end
				
				
				if Action == "ServerBan" then

					GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Health Value is above the max, or god mode detected")
					GameEssentials:WaitForChild("InsertValue"):FireServer(Player.Name)

				end	
				
			end
			
		end	
	end
	
	if Type == "WalkSpeed" then
		
		if Character.Humanoid.WalkSpeed > Max then
			if Action == "ResetToNormal" then
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"WalkSpeed Value is above max")
				Humanoid.WalkSpeed = Default
				
			end
			
			if Action == "Kick" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"WalkSpeed Value is above max")
				Player:Kick(KickMsg)
				
			end
			
			if Action == "ServerBan" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"WalkSpeed Value is above max")
				GameEssentials:WaitForChild("InsertValue"):FireServer(Player.Name)
				
			end	
			
		end
		
	end
	
	if Type == "JumpPower" then

		if Character.Humanoid.JumpPower > Max then

			if Action == "ResetToNormal" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"JumpPower Value is above max")
				Humanoid.JumpPower = Default

			end

			if Action == "Kick" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"JumpPower Value is above max")
				Player:Kick(KickMsg)

			end

			if Action == "ServerBan" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"JumpPower Value is above max")
				GameEssentials:WaitForChild("InsertValue"):FireServer(Player.Name)

			end	

		end

	end
	
	if Type == "Sit" then
		
		if Character.Humanoid.Sit == true then
			
			if Action == "ResetToNormal" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Player attempted to sit")
				Humanoid.Sit = false
				Humanoid:ChangeState(3)
				Humanoid.Jump = true
				
			end
			
			if Action == "Kick" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Player attempted to sit")
				Player:Kick(KickMsg)
				
			end
			
			if Action == "ServerBan" then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Player attempted to sit")
				GameEssentials:WaitForChild("InsertValue"):FireServer(Player.Name)
				
			end			
			
		end
		
	end
	
end)

CheckValue.OnClientInvoke = function(Player,Character,Type,KickMsg,Default,Max)
	local Humanoid = Character:FindFirstChild("Humanoid")
	
	if Type == "Health" then
		
		if Humanoid then
			
			if Humanoid.Health > Max  then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"Health Value above max, or god mode detected")
				return 'HEALTH OVER MAX'
					
			end
			
		end
		
	end
	
	if Type == "WalkSpeed" then
		
		if Humanoid then
			if Humanoid.WalkSpeed > Max then
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"WalkSpeed Value is above max")
				Humanoid.WalkSpeed = Default
				return 'NOT EQUAL'
				
			end
			
		end
		
	end
	
	if Type == "JumpPower" then
		
		if Humanoid then
			
			if Humanoid.JumpPower > Max then
				
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"JumpPower Value is above max")
				Humanoid.JumpPower = Default
				return 'NOT EQUAL'
				
			end
			
		end
		
	end
	
	if Type == "WalkSpeed" then
		if Humanoid then
			if Humanoid.WalkSpeed > Max then
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"WalkSpeed Value is above max")
				Humanoid.WalkSpeed = Default
				return 'NOT EQUAL'
			end
		end	
	end
	
	if Type == "JumpPower" then
		if Humanoid then
			if Humanoid.JumpPower > Max then
				GameEssentials:WaitForChild("SendLog"):FireServer(Player.Name,"JumpPower Value is above max")
				Humanoid.JumpPower = Default
				return 'NOT EQUAL'
			end
		end	
	end
	
end

GameEssentials:FindFirstChild("Check").OnClientInvoke = function()
	return 'EXIST'
end

while true do
	wait()
	if Ccharacter:WaitForChild("Humanoid").Health > 0 and Ccharacter and game.Players.LocalPlayer then
		if not GameEssentials then
			game.Players.LocalPlayer:Kick("Attempted to bypass")
		end
		if not GameEssentials:FindFirstChild("Check") then
			GameEssentials:WaitForChild("SendLog"):FireServer(game.Players.LocalPlayer.Name,"Attempted to bypass anti exploit")
			game.Players.LocalPlayer:Kick("Attempted to bypass")
		end
		if not GameEssentials:FindFirstChild("SendLog") then
			--GameEssentials:WaitForChild("SendLog"):FireServer(game.Players.LocalPlayer.Name,"Attempted to bypass anti exploit")
			game.Players.LocalPlayer:Kick("Attempted to bypass")
		end
		if not GameEssentials:FindFirstChild("SendValue") then
			GameEssentials:WaitForChild("SendLog"):FireServer(game.Players.LocalPlayer.Name,"Attempted to bypass anti exploit")
			game.Players.LocalPlayer:Kick("Attempted to bypass")
		end
		if not GameEssentials:FindFirstChild("InsertValue") then
			GameEssentials:WaitForChild("SendLog"):FireServer(game.Players.LocalPlayer.Name,"Attempted to bypass anti exploit")
			game.Players.LocalPlayer:Kick("Attempted to bypass")
		end
	end
end
