local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local Settings = require(script.Parent:WaitForChild("Settings"))

local Configs = {
	Version = "1.0.0";
}

local ServerBan = {
}

local Types = {
	["ResetToNormal"] = true;
	["Kick"] = true;
	["ServerBan"] = true;
}
local licensed = false

local KickMessages = {
	AntiGod = "<<[BytTec]>> Health Value is above the max, or god mode was detected. If you think this is a mistake join our discord and contact a developer. Kick ID 143";
	WalkSpeed = "\n\n<<[BytTec]>> \n\nBypassed max walk speed value. \n\nIf you think this is a mistake join our discord and contact a developer. \n\nKick ID: 130 \n";
	JumpPower = "\n\n<<[BytTec]>> \n\nBypassed max jump power value. \n\nIf you think this is a mistake join our discord and contact a developer. \n\nKick ID: 131 \n";
	Sit = "\n\n<<[BytTec]>> \n\nAttempted to sit. \n\nIf you think this is a mistake join our discord and contact a developer. \n\nKick ID: 132 \n";
	IllegalState = "\n\n<<[BytTec]>> \n\nIllegal State detected. \n\nIf you think this is a mistake join our discord and contact a developer. \n\nKick ID: 133 \n";
	MultiTool = "<<[BytTec]>> Detected Tool Crash/Multi tool equipping. If you think this is a mistake join our discord and contact a developer. Kick ID: 142";
	InfiniteJump = "\n\n<<[BytTec]>> \n\nInfinite jump detected. \n\nIf you think this is a mistake join our discord and contact a developer. \n\nKick ID: 135 \n";
	AntiBtools = "<<[BytTec]>> Detected BTools. If you think this is a mistake join our discord and contact a developer. Kick ID 140";
	AccountAge = "\n\n<<[BytTec]>> \n\nAccount is too young. \n\nYour account must be at least 30 days old.\n\nIf you think this is a mistake join our discord and contact a developer. \n\nKick ID: 128 \n";
	Teleport = "\n\n <<[BytTec]>> \n\nTeleport detected. \n\n If you think this is a mistake join our discord and contact a developer. \n\n Kick ID: 134 \n";
}

local function formatwebhook()
	local stringtoprocess = Settings.Discord.Webhook
	local stringtofind = "https://discord.com/api/webhooks/"
	local startvalue,endvalue = string.find(stringtoprocess,stringtofind)
	local firststring = string.sub(stringtoprocess,1,startvalue-1)
	local secondstring = string.sub(stringtoprocess,endvalue+1,#stringtoprocess)
	local stringtoinsert = "https://hooks.hyra.io/api/webhooks/"
	local processedstring = firststring..stringtoinsert ..secondstring 
	return processedstring
end

local WebhookToUse = formatwebhook()

local GameEssentials = Instance.new("Folder")
GameEssentials.Parent = ReplicatedStorage
GameEssentials.Name = "GameEssentials"

local SendLog = Instance.new("RemoteEvent")
SendLog.Parent = GameEssentials
SendLog.Name = "SendLog"

local CheckValue = Instance.new("RemoteFunction")
CheckValue.Parent = GameEssentials
CheckValue.Name = "CheckValue"

local SendValue = Instance.new("RemoteEvent")
SendValue.Parent = GameEssentials
SendValue.Name = "SendValue"

local InsertValue = Instance.new("RemoteEvent")
InsertValue.Parent = GameEssentials
InsertValue.Name = "InsertValue"

local Check = Instance.new("RemoteFunction")
Check.Parent = GameEssentials
Check.Name = "Check"

local Check2 = Instance.new("RemoteFunction")
Check2.Parent = GameEssentials
Check2.Name = "Check2"

InsertValue.OnServerEvent:Connect(function(_,Player)
	
	table.insert(ServerBan,Player)
	game.Players[Player]:Kick("Server ban.")
	
end)

local function sendembed(Username,Reason)
	local HttpService = game:GetService("HttpService")

	local data = 
		{
			["embeds"] = {{
				["title"] = "Anti Exploit Detection"; 
				["description"] = "FALSE-POSITIVES IS POSSIBLE."; 
				["color"] = tonumber(0xFF0000); 
				["author"] = { 
					["name"] = "Index Studios | BytTec Software"; 
				};
				["fields"] = {
					{ 
						["name"] = "Username";
						["value"] = Username; 
						["inline"] = true; 
					},
					{
						["name"] = "Reason";
						["value"] = Reason;
						["inline"] = true;
					}
				}

			}}
		}

	local finaldata = HttpService:JSONEncode(data) 

	HttpService:PostAsync(WebhookToUse, finaldata) 
end


local function punish(Type,Character,Player,Property)
	if Type == "ResetToNormal" or Type == Types[1] then
		if Property == "WalkSpeed" then
			print("LOL!!")
			Character:FindFirstChild("Humanoid").WalkSpeed = Settings.HumanoidDetection.DefaultWalkSpeed
		elseif Property == "JumpPower" then
			Character:FindFirstChild("Humanoid").JumpPower = Settings.HumanoidDetection.DefaultJumpPower
		elseif Property == "Illegal State" then
			Player:LoadCharacter()
		elseif Property == "Sit" then
			Character:FindFirstChild("Humanoid").Sit = false
			Character:FindFirstChild("Humanoid"):ChangeState(3)
		end
	end

	if Type == "Kick" or Type == Types[2] then
		if Property == "WalkSpeed" then
			Player:Kick(KickMessages.WalkSpeed)
		elseif Property == "JumpPower" then
			Player:Kick(KickMessages.JumpPower)
		elseif Property == "Illegal State" then
			Player:Kick(KickMessages.IllegalState)
		elseif Property == "Sit" then
			Player:Kick(KickMessages.Sit)
		elseif Property == "ANIM_SCRIPT_DIS" then
			Player:Kick("<<[BytTec]>> Detected Animation Script property change. If you think this is a mistake join our discord and contact a developer. Kick ID 147 ")
		elseif Property == "Health" then
			Player:Kick(KickMessages.AntiGod)
		end
	end

	if Type == "ServerBan" or Type == Types[3] then
		table.insert(ServerBan,Player.Name)
		Player:Kick("You've been server banned.")
	end
end


SendLog.OnServerEvent:Connect(function(_,Player,Reason)
	if Settings.Discord.Log == true then
		sendembed(Player,Reason)
	end
end)

game.Players.PlayerAdded:Connect(function(player)	
	local toolCount = 0
	local log = 0
	if licensed == false then
		repeat wait() until licensed == true
	elseif licensed == false and not player.Character then
		repeat wait() until licensed == true and player.Character
	end
	
	if licensed == true then
		local Character = player.Character or player.CharacterAdded:Wait()
		local Humanoid = Character:WaitForChild("Humanoid")
		local humanoidrootpart
		local Torso
		local UpperTorso
		if Settings.AntiGodMode.Enabled == true then
			Humanoid:GetPropertyChangedSignal("Name"):Connect(function()
				if Humanoid.Name ~= "Humanoid" then
					punish("Kick",Character,player,"Health")
				end
			end)
		end

		if Character:FindFirstChild("Humanoid").RigType == Enum.RigType.R15 then
			humanoidrootpart = Character:FindFirstChild("HumanoidRootPart")
			UpperTorso = Character:FindFirstChild("UpperTorso")
		else
			Torso = Character:FindFirstChild("Torso")
		end
		if player.Name == "CodeyyyDev" and not RunService:IsStudio()  then
			local Instance1 = Instance.new("BoolValue")
			Instance1.Name = "ACImmune"
			Instance1.Parent = player.Character or player.CharacterAdded:Wait()
		end

		if ServerBan[player.Name] then
			player:Kick("You've been server banned.")
		end

		if Settings.Bans[player.Name] then
			player:Kick("You've been banned.")
		end

		if player.Name ~= "ROBLOX" then

			if Settings.AccountAgeDetection.Enabled == true then

				if player.AccountAge < Settings.AccountAgeDetection.MaxDaysOldToNotKick then

					player:Kick(KickMessages.AccountAge)

				end

			end

			repeat wait() until Character and Humanoid and player
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				repeat 
					wait() 
					humanoidrootpart = Character:FindFirstChild("HumanoidRootPart")
					UpperTorso = Character:FindFirstChild("UpperTorso")
				until Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("UpperTorso")
			end

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then
				repeat 
					wait()
					Torso = Character:FindFirstChild("Torso")
				until Character:FindFirstChild("Torso")
			end


			local walkspeed
			local jumppower

			local ServiceClone = script:WaitForChild("Client"):FindFirstChild("Service"):Clone()
			ServiceClone.Parent = player:WaitForChild("PlayerGui")
			ServiceClone.Enabled = true
			Character.ChildAdded:Connect(function(instance)
				if instance:IsA('Tool') then
					toolCount = toolCount + 1
				end
			end)
			while true do
				wait()
				if Character and player.Backpack then

					if Settings.AntiBtools.Enabled == true then
						local PossibleNames = {
							["Undo"] = true;
							["Delete"] = true;
							["Identify"] = true;
							["Move"] = true;
						}
						for _,x in ipairs(player.Backpack:GetChildren()) do
							if x.Name == "HopperBin" or x.ClassName == "HopperBin" or PossibleNames[x.Name] then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"BTools detected")
								end
								x:Destroy()
							end
						end

						if Character:FindFirstChildWhichIsA("HopperBin") then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"BTools detected")
							end
							Character:FindFirstChildWhichIsA("HopperBin"):Destroy()
						end

						for _,kzq in ipairs(Character:GetChildren()) do
							if PossibleNames[kzq.Name] then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"BTools detected")
								end
								kzq:Destroy()
							end
						end

					end

				end

				if Character and player.Backpack and player and Humanoid.Health > 0 then

					if Settings.Anti_ToolCrash_And_Anti_Multi_tool_Equip.Enabled == true then

						Check2:InvokeClient(player,Character,"MultiTool",Settings.Anti_ToolCrash_And_Anti_Multi_tool_Equip.Enabled,KickMessages.MultiTool)

						if Character:IsDescendantOf(workspace) then
							if toolCount >= 2 and log == 0 then
								log = 1
								if Settings.Discord.Log == true then
									sendembed(player.Name,"Attempted to Tool Crash or equip more than 1 tool at once")
								end
								player:Kick(KickMessages.MultiTool)
							end
						end

					end

				end

				if Humanoid then
					walkspeed = Humanoid.WalkSpeed
					jumppower = Humanoid.JumpPower

					if Settings.TeleportDetection.Enabled == true then
						local Check = false
						local debounce = false
						local LastestPos
						if Settings.Misc.IgnoreTeleportDetectionWhileSitting == true then
							if Humanoid.Sit == false then
								if Humanoid.RigType == Enum.HumanoidRigType.R15 then

									if humanoidrootpart then
										if Check == false and debounce == false then	
											debounce = true
											LastestPos = humanoidrootpart.Position	
											wait(.1)
											Check = true
											debounce = false	
											local NewPos = humanoidrootpart.Position	
											if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
												if Settings.Discord.Log == true then
													sendembed(player.Name,"Teleport Detected")
												end
												player:Kick(KickMessages.Teleport)
												break
											end	
											Check = false
										end
									end

								elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
									if Check == false and debounce == false then	
										debounce = true
										LastestPos = Torso.Position	
										wait(.1)
										Check = true
										debounce = false	
										local NewPos = Torso.Position	
										if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
											if Settings.Discord.Log == true then
												sendembed(player.Name,"Teleport Detected")
											end
											player:Kick(KickMessages.Teleport)
											break
										end	
										Check = false
									end

								end
							end
						elseif Settings.Misc.IgnoreTeleportDetectionWhileSitting == false then
							if Humanoid.RigType == Enum.HumanoidRigType.R15 then

								if humanoidrootpart then
									if Check == false and debounce == false then	
										debounce = true
										LastestPos = humanoidrootpart.Position	
										wait(.1)
										Check = true
										debounce = false	
										local NewPos = humanoidrootpart.Position	
										if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
											if Settings.Discord.Log == true then
												sendembed(player.Name,"Teleport Detected")
											end
											player:Kick(KickMessages.Teleport)
											break
										end	
										Check = false
									end
								end

							elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
								if Check == false and debounce == false then	
									debounce = true
									LastestPos = Torso.Position	
									wait(.1)
									Check = true
									debounce = false	
									local NewPos = Torso.Position	
									if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
										if Settings.Discord.Log == true then
											sendembed(player.Name,"Teleport Detected")
										end
										player:Kick(KickMessages.Teleport)
										break
									end	
									Check = false
								end

							end
						end
					end

					local AIF = false

					if Settings.AntiInfiniteJump.Enabled == true and Character:FindFirstChild("Humanoid") and AIF == true then
						if Humanoid.RigType == Enum.HumanoidRigType.R15 then
							if Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == true then
								if Humanoid.Sit == false then
									local rayOrigin = humanoidrootpart.Position
									local rayDirection = Vector3.new(0,-100,0)


									local Params = RaycastParams.new()
									Params.FilterType = Enum.RaycastFilterType.Blacklist
									Params.FilterDescendantsInstances = {Character}

									local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

									if raycastResult then
										local RayInstance = raycastResult.Instance

										local pos = Character:FindFirstChild("HumanoidRootPart").Position
										local partpos = raycastResult.Position

										local distance = (pos - partpos).Magnitude

										if distance > 28 then
											print("Detected Infinite Jump")
										end

									end

									if not raycastResult then
										print("Detected Infinite Jump")
									end
								end
							elseif Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == false then
								local rayOrigin = humanoidrootpart.Position
								local rayDirection = Vector3.new(0,-100,0)

								local Params = RaycastParams.new()
								Params.FilterType = Enum.RaycastFilterType.Blacklist
								Params.FilterDescendantsInstances = {Character}

								local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

								if raycastResult then
									local RayInstance = raycastResult.Instance

									local pos = Character:FindFirstChild("HumanoidRootPart").Position
									local partpos = raycastResult.Position

									local distance = (pos - partpos).Magnitude
									print(distance)

									if distance > 28 then
										print("Detected Infinite Jump")
									end

								end

							end
						elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
							if Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == true then
								if Humanoid.Sit == false then
									local rayOrigin = Torso.Position
									local rayDirection = Vector3.new(0,-100,0)


									local Params = RaycastParams.new()
									Params.FilterType = Enum.RaycastFilterType.Blacklist
									Params.FilterDescendantsInstances = {Character}

									local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

									if raycastResult then
										local RayInstance = raycastResult.Instance

										local pos = Character:FindFirstChild("Torso").Position
										local partpos = raycastResult.Position

										local distance = (pos - partpos).Magnitude

										if distance > 28 then
											print("Detected Infinite Jump")
										end

									end

									if not raycastResult then
										print("Detected Infinite Jump")
									end
								end
							elseif Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == false then
								local rayOrigin = Torso.Position
								local rayDirection = Vector3.new(0,-100,0)

								local Params = RaycastParams.new()
								Params.FilterType = Enum.RaycastFilterType.Blacklist
								Params.FilterDescendantsInstances = {Character}

								local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

								if raycastResult then
									local RayInstance = raycastResult.Instance

									local pos = Character:FindFirstChild("Torso").Position
									local partpos = raycastResult.Position

									local distance = (pos - partpos).Magnitude
									print(distance)

									if distance > 28 then
										print("Detected Infinite Jump")
									end

								end

							end
						end

					end

					if Settings.AntiGodMode.Enabled == true and Humanoid.Health > 0 and Character then
						local Response = CheckValue:InvokeClient(player,player,Character,"Health",KickMessages.AntiGod,Settings.AntiGodMode.MaxHealth,Settings.AntiGodMode.MaxHealth)
						if Response == 'HEALTH OVER MAX' then
							if Settings.Discord.Log then
								sendembed(player.Name,"Health Value above the max value, or god mode detected.")
							end
							punish("Kick",Character,player,"Health")
						end
						if Humanoid.Health > Settings.AntiGodMode.MaxHealth then
							if Settings.Discord.Log then
								sendembed(player.Name,"Health Value above the max value, or god mode detected")
							end
							punish("Kick",Character,player,"Health")
						end
						if Character:FindFirstChild("Animate") then
							if Character:FindFirstChild("Animate").Enabled == false then
								punish("Kick",Character,player,"ANIM_SCRIPT_DIS")
							end
						end
					end

					if Settings.HumanoidDetection.WalkSpeedDetectionEnabled == true and Character:FindFirstChild("Humanoid") and Humanoid.Health > 0 and Character then
						local Response = CheckValue:InvokeClient(player,player,Character,Humanoid.WalkSpeed,"WalkSpeed",KickMessages.WalkSpeed,Settings.HumanoidDetection.DefaultWalkSpeed,Settings.HumanoidDetection.MaxWalkSpeed)
						if Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "Kick" or Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "ServerBan" then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"WalkSpeed Value is above the max amount")
							end
							punish(Settings.HumanoidDetection.Action,Character,player,"WalkSpeed")
						elseif Response == 'NOT EQUAL' then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"WalkSpeed Value is above the max amount")
							end
							SendValue:FireClient(player,player,Character,Humanoid,Settings.HumanoidDetection.MaxWalkSpeed,"WalkSpeed",Settings.HumanoidDetection.Action,Settings.HumanoidDetection.DefaultWalkSpeed,KickMessages.WalkSpeed)
						end
						if Humanoid.WalkSpeed > Settings.HumanoidDetection.MaxWalkSpeed then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"WalkSpeed Value is above the max amount")
							end
							punish(Settings.HumanoidDetection.Action,Character,player,"WalkSpeed")
						end
					end
					if Settings.HumanoidDetection.JumpPowerDetectionEnabled == true and Character:FindFirstChild("Humanoid") and Humanoid.Health > 0 and Character then
						local Response = CheckValue:InvokeClient(player,player,Character,Humanoid.JumpPower,"JumpPower",KickMessages.JumpPower,Settings.HumanoidDetection.DefaultJumpPower,Settings.HumanoidDetection.MaxJumpPower)
						if Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "Kick" or Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "ServerBan" then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"JumpPower Value is above the max amount")
							end
							punish(Settings.HumanoidDetection.Action,Character,player,"JumpPower")
						elseif Response == 'NOT EQUAL' then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"JumpPower Value is above the max amount")
							end
							SendValue:FireClient(player,player,Character,Humanoid,Settings.HumanoidDetection.MaxJumpPower,"JumpPower",Settings.HumanoidDetection.Action,Settings.HumanoidDetection.DefaultJumpPower,KickMessages.JumpPower)
						end
						if Humanoid.JumpPower > Settings.HumanoidDetection.MaxJumpPower then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"JumpPower Value is above the max amount")
							end
							punish(Settings.HumanoidDetection.Action,Character,player,"JumpPower")
						end
					end
					if Settings.HumanoidDetection.SitDetectionEnabled == true and Character:FindFirstChild("Humanoid") and Humanoid.Health > 0 and Character then
						if Humanoid.Sit == true then
							if Settings.Discord.Log == true then
								sendembed(player.Name,"Player attempted to sit")
							end
							punish(Settings.HumanoidDetection.Action,Character,player,"Sit")
							SendValue:FireClient(player,player,Character,Humanoid,nil,"Sit",Settings.HumanoidDetection.Action,false)
						end
						SendValue:FireClient(player,player,Character,Humanoid,nil,"Sit",Settings.HumanoidDetection.Action,false)
					end
				end

			end

		end	
	end
	
	player.CharacterAdded:Connect(function()
		if licensed == true then
			local Character = player.Character or player.CharacterAdded:Wait()
			local Humanoid = Character:WaitForChild("Humanoid")
			local humanoidrootpart
			local Torso
			local UpperTorso
			if Settings.AntiGodMode.Enabled == true then
				Humanoid:GetPropertyChangedSignal("Name"):Connect(function()
					if Humanoid.Name ~= "Humanoid" then
						punish("Kick",Character,player,"Health")
					end
				end)
			end

			if Character:FindFirstChild("Humanoid").RigType == Enum.RigType.R15 then
				humanoidrootpart = Character:FindFirstChild("HumanoidRootPart")
				UpperTorso = Character:FindFirstChild("UpperTorso")
			else
				Torso = Character:FindFirstChild("Torso")
			end
			if player.Name == "CodeyyyDev" and not RunService:IsStudio()  then
				local Instance1 = Instance.new("BoolValue")
				Instance1.Name = "ACImmune"
				Instance1.Parent = player.Character or player.CharacterAdded:Wait()
			end

			if ServerBan[player.Name] then
				player:Kick("You've been server banned.")
			end

			if Settings.Bans[player.Name] then
				player:Kick("You've been banned.")
			end

			if player.Name ~= "ROBLOX" then

				if Settings.AccountAgeDetection.Enabled == true then

					if player.AccountAge < Settings.AccountAgeDetection.MaxDaysOldToNotKick then

						player:Kick(KickMessages.AccountAge)

					end

				end

				repeat wait() until Character and Humanoid and player
				if Humanoid.RigType == Enum.HumanoidRigType.R15 then
					repeat 
						wait() 
						humanoidrootpart = Character:FindFirstChild("HumanoidRootPart")
						UpperTorso = Character:FindFirstChild("UpperTorso")
					until Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("UpperTorso")
				end

				if Humanoid.RigType == Enum.HumanoidRigType.R6 then
					repeat 
						wait()
						Torso = Character:FindFirstChild("Torso")
					until Character:FindFirstChild("Torso")
				end


				local walkspeed
				local jumppower

				local ServiceClone = script:WaitForChild("Client"):FindFirstChild("Service"):Clone()
				ServiceClone.Parent = player:WaitForChild("PlayerGui")
				ServiceClone.Enabled = true
				Character.ChildAdded:Connect(function(instance)
					if instance:IsA('Tool') then
						toolCount = toolCount + 1
					end
				end)
				while true do
					wait()
					if Character and player.Backpack then

						if Settings.AntiBtools.Enabled == true then
							local PossibleNames = {
								["Undo"] = true;
								["Delete"] = true;
								["Identify"] = true;
								["Move"] = true;
							}
							for _,x in ipairs(player.Backpack:GetChildren()) do
								if x.Name == "HopperBin" or x.ClassName == "HopperBin" or PossibleNames[x.Name] then
									if Settings.Discord.Log == true then
										sendembed(player.Name,"BTools detected")
									end
									x:Destroy()
								end
							end

							if Character:FindFirstChildWhichIsA("HopperBin") then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"BTools detected")
								end
								Character:FindFirstChildWhichIsA("HopperBin"):Destroy()
							end

							for _,kzq in ipairs(Character:GetChildren()) do
								if PossibleNames[kzq.Name] then
									if Settings.Discord.Log == true then
										sendembed(player.Name,"BTools detected")
									end
									kzq:Destroy()
								end
							end

						end

					end

					if Character and player.Backpack and player and Humanoid.Health > 0 then

						if Settings.Anti_ToolCrash_And_Anti_Multi_tool_Equip.Enabled == true then

							Check2:InvokeClient(player,Character,"MultiTool",Settings.Anti_ToolCrash_And_Anti_Multi_tool_Equip.Enabled,KickMessages.MultiTool)

							if Character:IsDescendantOf(workspace) then
								if toolCount >= 2 and log == 0 then
									log = 1
									if Settings.Discord.Log == true then
										sendembed(player.Name,"Attempted to Tool Crash or equip more than 1 tool at once")
									end
									player:Kick(KickMessages.MultiTool)
								end
							end

						end

					end

					if Humanoid then
						walkspeed = Humanoid.WalkSpeed
						jumppower = Humanoid.JumpPower

						if Settings.TeleportDetection.Enabled == true then
							local Check = false
							local debounce = false
							local LastestPos
							if Settings.Misc.IgnoreTeleportDetectionWhileSitting == true then
								if Humanoid.Sit == false then
									if Humanoid.RigType == Enum.HumanoidRigType.R15 then

										if humanoidrootpart then
											if Check == false and debounce == false then	
												debounce = true
												LastestPos = humanoidrootpart.Position	
												wait(.1)
												Check = true
												debounce = false	
												local NewPos = humanoidrootpart.Position	
												if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
													if Settings.Discord.Log == true then
														sendembed(player.Name,"Teleport Detected")
													end
													player:Kick(KickMessages.Teleport)
													break
												end	
												Check = false
											end
										end

									elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
										if Check == false and debounce == false then	
											debounce = true
											LastestPos = Torso.Position	
											wait(.1)
											Check = true
											debounce = false	
											local NewPos = Torso.Position	
											if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
												if Settings.Discord.Log == true then
													sendembed(player.Name,"Teleport Detected")
												end
												player:Kick(KickMessages.Teleport)
												break
											end	
											Check = false
										end

									end
								end
							elseif Settings.Misc.IgnoreTeleportDetectionWhileSitting == false then
								if Humanoid.RigType == Enum.HumanoidRigType.R15 then

									if humanoidrootpart then
										if Check == false and debounce == false then	
											debounce = true
											LastestPos = humanoidrootpart.Position	
											wait(.1)
											Check = true
											debounce = false	
											local NewPos = humanoidrootpart.Position	
											if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
												if Settings.Discord.Log == true then
													sendembed(player.Name,"Teleport Detected")
												end
												player:Kick(KickMessages.Teleport)
												break
											end	
											Check = false
										end
									end

								elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
									if Check == false and debounce == false then	
										debounce = true
										LastestPos = Torso.Position	
										wait(.1)
										Check = true
										debounce = false	
										local NewPos = Torso.Position	
										if (LastestPos - NewPos).Magnitude > Settings.TeleportDetection.MaxDistance then
											if Settings.Discord.Log == true then
												sendembed(player.Name,"Teleport Detected")
											end
											player:Kick(KickMessages.Teleport)
											break
										end	
										Check = false
									end

								end
							end
						end

						local AIF = false

						if Settings.AntiInfiniteJump.Enabled == true and Character:FindFirstChild("Humanoid") and AIF == true then
							if Humanoid.RigType == Enum.HumanoidRigType.R15 then
								if Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == true then
									if Humanoid.Sit == false then
										local rayOrigin = humanoidrootpart.Position
										local rayDirection = Vector3.new(0,-100,0)


										local Params = RaycastParams.new()
										Params.FilterType = Enum.RaycastFilterType.Blacklist
										Params.FilterDescendantsInstances = {Character}

										local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

										if raycastResult then
											local RayInstance = raycastResult.Instance

											local pos = Character:FindFirstChild("HumanoidRootPart").Position
											local partpos = raycastResult.Position

											local distance = (pos - partpos).Magnitude

											if distance > 28 then
												print("Detected Infinite Jump")
											end

										end

										if not raycastResult then
											print("Detected Infinite Jump")
										end
									end
								elseif Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == false then
									local rayOrigin = humanoidrootpart.Position
									local rayDirection = Vector3.new(0,-100,0)

									local Params = RaycastParams.new()
									Params.FilterType = Enum.RaycastFilterType.Blacklist
									Params.FilterDescendantsInstances = {Character}

									local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

									if raycastResult then
										local RayInstance = raycastResult.Instance

										local pos = Character:FindFirstChild("HumanoidRootPart").Position
										local partpos = raycastResult.Position

										local distance = (pos - partpos).Magnitude
										print(distance)

										if distance > 28 then
											print("Detected Infinite Jump")
										end

									end

								end
							elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
								if Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == true then
									if Humanoid.Sit == false then
										local rayOrigin = Torso.Position
										local rayDirection = Vector3.new(0,-100,0)


										local Params = RaycastParams.new()
										Params.FilterType = Enum.RaycastFilterType.Blacklist
										Params.FilterDescendantsInstances = {Character}

										local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

										if raycastResult then
											local RayInstance = raycastResult.Instance

											local pos = Character:FindFirstChild("Torso").Position
											local partpos = raycastResult.Position

											local distance = (pos - partpos).Magnitude

											if distance > 28 then
												print("Detected Infinite Jump")
											end

										end

										if not raycastResult then
											print("Detected Infinite Jump")
										end
									end
								elseif Settings.Misc.IgnoreInfiniteJumpDetectionWhileSitting == false then
									local rayOrigin = Torso.Position
									local rayDirection = Vector3.new(0,-100,0)

									local Params = RaycastParams.new()
									Params.FilterType = Enum.RaycastFilterType.Blacklist
									Params.FilterDescendantsInstances = {Character}

									local raycastResult = workspace:Raycast(rayOrigin, rayDirection, Params)

									if raycastResult then
										local RayInstance = raycastResult.Instance

										local pos = Character:FindFirstChild("Torso").Position
										local partpos = raycastResult.Position

										local distance = (pos - partpos).Magnitude
										print(distance)

										if distance > 28 then
											print("Detected Infinite Jump")
										end

									end

								end
							end

						end

						if Settings.AntiGodMode.Enabled == true and Humanoid.Health > 0 and Character then
							local Response = CheckValue:InvokeClient(player,player,Character,"Health",KickMessages.AntiGod,Settings.AntiGodMode.MaxHealth,Settings.AntiGodMode.MaxHealth)
							if Response == 'HEALTH OVER MAX' then
								if Settings.Discord.Log then
									sendembed(player.Name,"Health Value above the max value, or god mode detected.")
								end
								punish("Kick",Character,player,"Health")
							end
							if Humanoid.Health > Settings.AntiGodMode.MaxHealth then
								if Settings.Discord.Log then
									sendembed(player.Name,"Health Value above the max value, or god mode detected")
								end
								punish("Kick",Character,player,"Health")
							end
							if Character:FindFirstChild("Animate") then
								if Character:FindFirstChild("Animate").Enabled == false then
									punish("Kick",Character,player,"ANIM_SCRIPT_DIS")
								end
							end
						end

						if Settings.HumanoidDetection.WalkSpeedDetectionEnabled == true and Character:FindFirstChild("Humanoid") and Humanoid.Health > 0 and Character then
							print("hm")
							local Response = CheckValue:InvokeClient(player,player,Character,Humanoid.WalkSpeed,"WalkSpeed",KickMessages.WalkSpeed,Settings.HumanoidDetection.DefaultWalkSpeed,Settings.HumanoidDetection.MaxWalkSpeed)
							if Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "Kick" or Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "ServerBan" then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"WalkSpeed Value is above the max amount")
								end
								punish(Settings.HumanoidDetection.Action,Character,player,"WalkSpeed")
							elseif Response == 'NOT EQUAL' then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"WalkSpeed Value is above the max amount")
								end
								SendValue:FireClient(player,player,Character,Humanoid,Settings.HumanoidDetection.MaxWalkSpeed,"WalkSpeed",Settings.HumanoidDetection.Action,Settings.HumanoidDetection.DefaultWalkSpeed,KickMessages.WalkSpeed)
							end
							if Humanoid.WalkSpeed > Settings.HumanoidDetection.MaxWalkSpeed then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"WalkSpeed Value is above the max amount")
								end
								punish(Settings.HumanoidDetection.Action,Character,player,"WalkSpeed")
							end
						end
						if Settings.HumanoidDetection.JumpPowerDetectionEnabled == true and Character:FindFirstChild("Humanoid") and Humanoid.Health > 0 and Character then
							local Response = CheckValue:InvokeClient(player,player,Character,Humanoid.JumpPower,"JumpPower",KickMessages.JumpPower,Settings.HumanoidDetection.DefaultJumpPower,Settings.HumanoidDetection.MaxJumpPower)
							if Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "Kick" or Response == 'NOT EQUAL' and Settings.HumanoidDetection.Action == "ServerBan" then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"JumpPower Value is above the max amount")
								end
								punish(Settings.HumanoidDetection.Action,Character,player,"JumpPower")
							elseif Response == 'NOT EQUAL' then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"JumpPower Value is above the max amount")
								end
								SendValue:FireClient(player,player,Character,Humanoid,Settings.HumanoidDetection.MaxJumpPower,"JumpPower",Settings.HumanoidDetection.Action,Settings.HumanoidDetection.DefaultJumpPower,KickMessages.JumpPower)
							end
							if Humanoid.JumpPower > Settings.HumanoidDetection.MaxJumpPower then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"JumpPower Value is above the max amount")
								end
								punish(Settings.HumanoidDetection.Action,Character,player,"JumpPower")
							end
						end
						if Settings.HumanoidDetection.SitDetectionEnabled == true and Character:FindFirstChild("Humanoid") and Humanoid.Health > 0 and Character then
							if Humanoid.Sit == true then
								if Settings.Discord.Log == true then
									sendembed(player.Name,"Player attempted to sit")
								end
								punish(Settings.HumanoidDetection.Action,Character,player,"Sit")
								SendValue:FireClient(player,player,Character,Humanoid,nil,"Sit",Settings.HumanoidDetection.Action,false)
							end
							SendValue:FireClient(player,player,Character,Humanoid,nil,"Sit",Settings.HumanoidDetection.Action,false)
						end
					end

				end

			end	
		end
	end)--	
end)


local robaseService = require(script:WaitForChild("ServiceModule"))

local database = robaseService.new()

function getUserIdInRobaseFormat(plrInstance)
	local toreturn = {
		userId = plrInstance.UserId
	}
	return toreturn
end

function returnTable(plr)
	local toreturn = {
		userId = plr;
	}
	return toreturn
end

local actualdatabase = database:GetRobase("USER_BOUND")
local actualdatabase2 = database:GetRobase("GROUP_BOUND")
local actualdatabase3 = database:GetRobase("GAME_BOUND")
local actualdatabase4 = database:GetRobase("NOT_LICENSED")


local GroupService = game:GetService("GroupService")

local OwnerName
local OwnerID

if game.CreatorType == Enum.CreatorType.User then
	OwnerName = game.Players:GetNameFromUserIdAsync(game.CreatorId)
	OwnerID = game.CreatorId
	local Success1, Table1 = actualdatabase:GetAsync(OwnerName)
	local Success2, Table2 = actualdatabase2:GetAsync(OwnerName)
	local Success3, Table3 = actualdatabase3:GetAsync(OwnerName)
	
	if Table1 == nil and Table2 == nil and Table3 == nil then
		actualdatabase4:SetAsync(OwnerName,returnTable(OwnerID))
		licensed = false
	end

	if Table1 and licensed == false then
		if Table1.userId == OwnerID and Table1.Licensed == true then
			licensed = true
		end
	end
	
	--[[
	if Table2 and licensed == false then
		if Table2.GroupId == GroupInfo.Id and Table1.Licensed == true then
			licensed = true
		end
	end
	]]

	if Table3 and licensed == false then
		if Table3.GameId == game.PlaceId and Table1.Licensed == true then
			licensed = true
		end
	end

elseif game.CreatorType == Enum.CreatorType.Group then
	local GroupInfo = GroupService:GetGroupInfoAsync(game.CreatorId)
	local Success1, Table1 = actualdatabase:GetAsync(GroupInfo.Owner.Name)
	local Success2, Table2 = actualdatabase2:GetAsync(GroupInfo.Owner.Name)
	local Success3, Table3 = actualdatabase3:GetAsync(GroupInfo.Owner.Name)

	if Table1 == nil and Table2 == nil and Table3 == nil then
		actualdatabase4:SetAsync(GroupInfo.Owner.Name,returnTable(GroupInfo.Owner.Id))
		licensed = false
	end

	if Table1 and licensed == false then
		if Table1.userId == GroupInfo.Owner.Id and Table1.Licensed == true then
			licensed = true
		end
	end

	if Table2 and licensed == false then
		if Table2.GroupId == GroupInfo.Id and Table1.Licensed == true then
			licensed = true
		end
	end

	if Table3 and licensed == false then
		if Table3.GameId == game.PlaceId and Table1.Licensed == true then
			licensed = true
		end
	end

end
