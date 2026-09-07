--!strict

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local defaults = require(ReplicatedStorage.GameShared.Config.PlayerDataDefaults)

local PlayerDataService = {
	Name = "PlayerDataService",
	Order = 30,
}

local context: any
local profiles: { [Player]: any } = {}
local safeToSave: { [Player]: boolean } = {}
local store: GlobalDataStore?

local function deepCopy(value: any): any
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for k, v in value do
		copy[deepCopy(k)] = deepCopy(v)
	end
	return copy
end

local function reconcile(target: any, template: any)
	for key, value in template do
		if target[key] == nil then
			target[key] = deepCopy(value)
		elseif type(value) == "table" and type(target[key]) == "table" then
			reconcile(target[key], value)
		end
	end
end

function PlayerDataService:Init(ctx: any)
	context = ctx
	if context.Config.Persistence.Enabled then
		store = DataStoreService:GetDataStore(context.Config.Persistence.StoreName)
	end
end

function PlayerDataService:_load(player: Player)
	local profile = deepCopy(defaults)
	local canSave = not context.Config.Persistence.Enabled

	if store then
		local ok, result = pcall(function()
			return (store :: GlobalDataStore):GetAsync(string.format("player_%d", player.UserId))
		end)
		if ok then
			if type(result) == "table" then
				profile = result
				reconcile(profile, defaults)
			end
			canSave = true
		else
			context.Log:Warn("Player data load failed; this session will not save", player.UserId, result)
		end
	end

	profiles[player] = profile
	safeToSave[player] = canSave
end

function PlayerDataService:_save(player: Player)
	if not store or not safeToSave[player] then
		return
	end
	local profile = profiles[player]
	if not profile then
		return
	end
	local ok, err = pcall(function()
		(store :: GlobalDataStore):UpdateAsync(string.format("player_%d", player.UserId), function()
			return profile
		end)
	end)
	if not ok then
		context.Log:Warn("Player data save failed", player.UserId, err)
	end
end

function PlayerDataService:Start(_ctx: any)
	Players.PlayerAdded:Connect(function(player)
		self:_load(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self:_save(player)
		profiles[player] = nil
		safeToSave[player] = nil
	end)
	for _, player in Players:GetPlayers() do
		task.spawn(function()
			self:_load(player)
		end)
	end
	game:BindToClose(function()
		for player in profiles do
			self:_save(player)
		end
	end)
end

function PlayerDataService:Get(player: Player): any?
	return profiles[player]
end

function PlayerDataService:IsLoaded(player: Player): boolean
	return profiles[player] ~= nil
end

return PlayerDataService
