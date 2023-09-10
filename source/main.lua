import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local Wheel = import "wheel"
local Shop = import "shop"

local gfx <const> = playdate.graphics

local lastRev = 0
local fullRev = false

local wheelSprite = nil
local shopInstance = nil

local isShopOpen = false
--#region Init Functions 
local function initWheel()
    local wheel = gfx.image.new("images/wheel")
    WheelObject = Wheel.new(wheel, 200, 120)
    wheelSprite = WheelObject:initWheel()
end

local function initBK()
    local backgroundImage = gfx.image.new("images/background")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end)
end

local function initShop()
    shopInstance = Shop.new()
end

local function init()
    initBK()
    initWheel()
    initShop()
end

init()

--#endregion

local function PlayerInput()
    -- rev will be 1 or -1 if it hits the top or bottom of the crank wheel
    local rev = playdate.getCrankTicks(2)
    --[[
        This if checks toi make sure that lastRev and rev are equal
        and double check that rev is none zero value.
    ]]--

    if lastRev == rev and (rev == 1 or rev == -1 )then
        if lastRev == 1 and rev == 1 then
            fullRev = true
        elseif lastRev == -1 and rev == -1 then
            fullRev = true
        else
            lastRev = 0
        end
        print("Rev: ", rev)
    end
    --[[
        if a full revolution has been made then add a crank and reset the variables to defualt to start check for next revolution
        elsewe set lastRev to the current rev value if rev is none zero    
    ]]--
    if fullRev then
        Wheel.addCranks()
        fullRev = false
        lastRev = 0
    else
        if rev ~= 0 then
            lastRev = rev
            print("Last: ", lastRev)
        end
    end
end

local function OpenShop()
    if isShopOpen then
        if playdate.buttonJustPressed(playdate.kButtonA) then
            if shopInstance ~= nil then
                -- First check if there is enough cranks to purchase the updgrade
                if shopInstance.CheckIfValidPurchase(Wheel.getCranks()) then
                    -- Increasing Cranks and subtracking cost of upgrade
                    Wheel.UpgradeCranks(1)
                    Wheel.subCranks(shopInstance.GetUpgradeAmount())
                else
                    print("Not enough Money")
                end
            end
        elseif playdate.buttonIsPressed(playdate.kButtonB) then
            -- exit shop
            isShopOpen = false
        end
    end
end

function playdate.update()
    if wheelSprite == nil then
        return
    end
    if playdate.isCrankDocked() then
        isShopOpen = true
        OpenShop()
        -- Reset the Wheels rotation
        wheelSprite:setRotation(0)
    else
        -- print("Game is running")
        PlayerInput()
        wheelSprite:setRotation(playdate.getCrankPosition())
        
        --[[if playdate.buttonJustPressed(playdate.kButtonA) then
            Wheel.UpgradeCranks()
        end]]
    end
    gfx.sprite.update()
    gfx.drawText("Cranks: " .. Wheel.getCranks(), 5, 5)
end
