--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- FRIENDLY LASER CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	Lasers that the player can shoot to defeat enemies
    We need to make a friendly and an enemy laser class so that later we can decide which ones hurt the player and which ones
    hurt the enemies. Also they travel in opposite directions
]]

FriendlyLaser = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local LASER_IMAGE = love.graphics.newImage('graphics/allied-laser.png')

function FriendlyLaser:init(x, y)
    self.x = x
    self.y = y

    self.width = LASER_WIDTH
    self.height = LASER_HEIGHT
end

function FriendlyLaser:update(dt)
    self.x = self.x + LASER_SPEED * dt
end

function FriendlyLaser:render()
    love.graphics.draw(LASER_IMAGE, self.x, self.y,0,0.1,0.1)
end