import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics

local playTimer = nil
local playTime = 30 * 1000

local cranks = 0

local lastRev = 0
local fullRev = false

local coinSprite = nil

local function resetTimer()
    playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function initWheel()
    local coin = gfx.image.new("images/wheel")
    coinSprite = gfx.sprite.new(coin)
    coinSprite:moveTo(200, 120)
    coinSprite:setScale(5)
    coinSprite:add()
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
    math.randomseed(playdate.getSecondsSinceEpoch())
    initBK()
    initWheel()
    resetTimer()
end

init()

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
    PlayerInput()
    
    coinSprite:setRotation(playdate.getCrankPosition())

    gfx.sprite.update()

    gfx.drawText("Time: " .. math.ceil(playTimer.value / 1000), 5, 5)
    gfx.drawText("Cranks: " .. cranks, 320, 5)
end
