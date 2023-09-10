Shop = {}
Shop.__index = Shop

local upgradeAmount = 10
local numPurchased = 0

function Shop.new()
    local instance = setmetatable({}, Shop)
    return instance
end

function Shop.CheckIfValidPurchase(amount)
    local canBuy = true
    if amount < upgradeAmount then
        print("Not enough money")
        canBuy = false
        numPurchased += 1
        IncreaseUpgradeAmount()
    end
    return canBuy
end

function Shop.GetUpgradeAmount()
    return upgradeAmount
end

function IncreaseUpgradeAmount()
    upgradeAmount = 4 * (2^numPurchased) + upgradeAmount
end

return Shop