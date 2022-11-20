import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local Wheel = import "wheel"

local gfx <const> = playdate.graphics

local cranks = 0

local lastRev = 0
local fullRev = false

local wheelSprite = nil

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

local function init()
    initBK()
    initWheel()
end

init()

--#endregion

local function PlayerInput()
    --[[rev will be 1 or -1 if it hits the top or bottom of the crank wheel]]
    local rev = playdate.getCrankTicks(2)
    --[[
        This if checks toi make sure that lastRev and rev are equal
        and double check that rev is none zero value.
    ]]--

    if lastRev == rev and (rev == 1 or rev == -1 )then
        if lastRev == 1 and rev == 1 then
            fullRev = true
        end
        if lastRev == -1 and rev == -1 then
            fullRev = true
        end
        print("Rev: ", rev)
    end
    --[[
        if a full revolution has been made then add a crank and reset the variables to defualt to start check for next revolution
        elsewe set lastRev to the current rev value if rev is none zero    
    ]]--
    if fullRev then
        cranks = cranks + 1
        fullRev = false
        lastRev = 0
    else
        if rev ~= 0 then
            lastRev = rev
            print("Last: ", lastRev)
        end
    end
end

function playdate.update()

    if playdate.isCrankDocked() then
        print("Open the shop")
        -- Reset the Wheels rotation
        wheelSprite:setRotation(0)
    else
        print("Game is running")
        PlayerInput()
        wheelSprite:setRotation(playdate.getCrankPosition())
    end
    gfx.sprite.update()
    gfx.drawText("Cranks: " .. cranks, 5, 5)
end
