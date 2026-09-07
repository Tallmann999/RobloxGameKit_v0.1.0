--!strict

local CurrencyService = {
	Name = "CurrencyService",
	Order = 40,
}

local playerData: any

function CurrencyService:Init(context: any)
	playerData = context.Services.PlayerDataService
	assert(playerData, "CurrencyService requires PlayerDataService")
end

local function getCurrencies(player: Player): { [string]: number }?
	local profile = playerData:Get(player)
	if not profile then
		return nil
	end
	return profile.Currencies
end

function CurrencyService:GetBalance(player: Player, currency: string): number?
	local currencies = getCurrencies(player)
	return currencies and currencies[currency] or nil
end

function CurrencyService:Add(player: Player, currency: string, amount: number): boolean
	if amount <= 0 or amount ~= amount or amount == math.huge then
		return false
	end
	local currencies = getCurrencies(player)
	if not currencies then
		return false
	end
	local current = currencies[currency]
	if type(current) ~= "number" then
		return false
	end
	currencies[currency] = current + amount
	return true
end

function CurrencyService:Spend(player: Player, currency: string, amount: number): boolean
	if amount <= 0 or amount ~= amount or amount == math.huge then
		return false
	end
	local currencies = getCurrencies(player)
	if not currencies then
		return false
	end
	local current = currencies[currency]
	if type(current) ~= "number" or current < amount then
		return false
	end
	currencies[currency] = current - amount
	return true
end

return CurrencyService
