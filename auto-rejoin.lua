local NetworkClient = cloneref(game:GetService("NetworkClient"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local Players = cloneref(game:GetService("Players"))
local args = {
	[1] = game.PlaceId,
	[2] = game.JobId,
	[3] = Players.LocalPlayer
}
NetworkClient.ChildRemoved:Connect(function()
   TeleportService:TeleportToPlaceInstance(unpack(args));
end)
