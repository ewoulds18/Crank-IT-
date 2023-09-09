Shop = {}
Shop.__index = Shop

local upgradeAmount = 10
local scaling = 1

function Shop.new()
    local instance = setmetatable({}, Shop)
    return instance
end

function Shop.CheckIfValidPurchase(amount)
    local canBuy = true
    if amount < upgradeAmount then
        print("Not enough money")
        canBuy = false
        IncreaseUpgradeAmount()
    end
    return canBuy
end

function Shop.GetUpgradeAmount()
    return upgradeAmount
end

function IncreaseUpgradeAmount()
    upgradeAmount = upgradeAmount + math.ceil(1*scaling)
end

return Shop