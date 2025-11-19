_G.scriptToLoad = math.abs(_G.scriptToLoad)
print("auto-rejoin Loaded!")
local NetworkClient = cloneref(game:GetService("NetworkClient"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local Players = cloneref(game:GetService("Players"))
local args = {
	[1] = game.PlaceId,
	[2] = game.JobId,
	[3] = Players.LocalPlayer
}
queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/xanyboyo/private/refs/heads/main/auto-rejoin.lua'))()")
-----------------------------------------------------------------------------------------------------------
if _G.scriptToLoad = 1 then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/TheRealAsu/BABFT/refs/heads/main/Loader.lua'))()
elseif _G.scriptToLoad = 2
	loadstring(game:HttpGet("https://raw.githubusercontent.com/ProBaconHub/ProBaconHubV2/refs/heads/main/LOADER.lua"))()
end
-----------------------------------------------------------------------------------------------------------
NetworkClient.ChildRemoved:Connect(function()
   TeleportService:TeleportToPlaceInstance(unpack(args));
end)
