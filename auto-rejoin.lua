local NetworkClient = cloneref(game:GetService("NetworkClient"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local Players = cloneref(game:GetService("Players"))
local args = {
	[1] = game.PlaceId,
	[2] = game.JobId,
	[3] = Players.LocalPlayer
}
queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/xanyboyo/private/refs/heads/main/auto-rejoin.lua?token=GHSAT0AAAAAADPMWF5YWW4EGCTAKE7FNDZM2I6DQJA'))()")
NetworkClient.ChildRemoved:Connect(function()
   TeleportService:TeleportToPlaceInstance(unpack(args));
end)
