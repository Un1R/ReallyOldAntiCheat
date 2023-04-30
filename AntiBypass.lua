local Check 
local Settings = require(script.Parent.Parent:WaitForChild("Settings"))
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
local function sendembed(Username,Reason)
	local HttpService = game:GetService("HttpService")

	local data = 
		{
			["embeds"] = {{
				["title"] = "Anti Exploit Detection"; -- The title of the message.
				["description"] = "FALSE-POSITIVES IS POSSIBLE."; -- Description of the message, under the title.
				["color"] = tonumber(0xFF0000); -- Hex color code, currently set to red.
				["author"] = { -- Separate table for many features
					["name"] = "Index Studios | BytTec Software"; -- the name of the author
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

game.Players.PlayerAdded:Connect(function(player)
	repeat wait() until game:GetService("ReplicatedStorage"):FindFirstChild("GameEssentials") and game:GetService("ReplicatedStorage"):FindFirstChild("GameEssentials"):FindFirstChild("Check") and game:GetService("ReplicatedStorage")
	Check = game:GetService("ReplicatedStorage"):FindFirstChild("GameEssentials"):FindFirstChild("Check")
	local Character = player.Character or player.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	
	while true do
		wait()
		local Response
		if Humanoid.Health > 0 and Character and player then
			local SUCCESS, MSG = pcall(function()
				Response = Check:InvokeClient(player)
			end)

			if MSG then
				if MSG == "Script that implemented this callback has been destroyed while calling async callback" then
					if Settings.Discord.Log == true then
						sendembed(player.Name,"Attempted to bypass anti exploit")
					end
					player:Kick("Attempted to bypass")
					break
				end

			end
			wait(3)
			if Response ~= 'EXIST' or Response == nil then
				sendembed(player.Name,"Attempted to bypass anti exploit")
				player:Kick("Bypass attempted")
			end
		end
	end
end)



