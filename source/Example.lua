import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics

local playerSpeed = 4

local playTimer = nil
local playTime = 30*1000

local score = 0
local cranks = 0

local coinSprite = nil

local function spawnCoin()
	local x = math.random(40, 360)
	local y = math.random(40, 200)
	coinSprite:moveTo(x, y)
end

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function initPlayer()
	local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200, 120)
	playerSprite:setCollideRect(0,0, playerSprite:getSize())
	playerSprite:add()
end

local function initCoin()
	local coin = gfx.image.new("images/coin")
	coinSprite = gfx.sprite.new(coin)
	spawnCoin()
	coinSprite:setCollideRect(0,0, coinSprite:getSize())
	coinSprite:add()
end

local function initBK()
	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0,0)
			gfx.clearClipRect()
	end)
end

local function init()
	math.randomseed(playdate.getSecondsSinceEpoch())
	initPlayer()
	initBK()
	initCoin()
	resetTimer()
end

init()

local function PlayerInput()
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		playerSprite:moveBy(0, -playerSpeed)
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
		playerSprite:moveBy(0, playerSpeed)
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		playerSprite:moveBy(-playerSpeed, 0)
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		playerSprite:moveBy(playerSpeed, 0)
	end
	
end

local function checkCollisions()
	local collisions = coinSprite:overlappingSprites()
	if #collisions > 0 then
		spawnCoin()
		score += 1
	end
end

function playdate.update()
	if playTimer.value == 0 then
		if playdate.buttonIsPressed(playdate.kButtonA) then
			resetTimer()
			spawnCoin()
			score = 0
		end
	else 
		PlayerInput()
		checkCollisions()
	end

	playdate.timer.updateTimers()

	gfx.sprite.update()

	gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 5)
	gfx.drawText("Score: " .. score, 320, 5)
end