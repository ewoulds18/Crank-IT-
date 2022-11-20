Wheel = {}
Wheel.__index = Wheel

import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics
cranksToAdd = 1
curCranks = 0

function Wheel.new(image, xPos, yPos)
    local instance = setmetatable({}, Wheel)
    instance.wheelImage = image
    instance.xPos = xPos
    instance.yPos = yPos
    return instance
end

function Wheel:getX()
    return self.xPos
end

function Wheel:getY()
    return self.yPos
end

function Wheel:initWheel()
    wheelSprite = gfx.sprite.new(self.wheelImage)
    wheelSprite:moveTo(self.xPos, self.yPos)
    wheelSprite:setScale(5)
    wheelSprite:add()
    return wheelSprite
end

function Wheel.addCranks()
    curCranks += cranksToAdd
end

function Wheel.getCranks()
    return curCranks
end

function Wheel.UpgradeCranks()
    cranksToAdd += 1
    print("Cranks to add: ", cranksToAdd)
end

return Wheel