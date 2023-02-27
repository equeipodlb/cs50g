--[[
    GD50
    Legend of Zelda
    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def, x, y, dir)
    self.x = x
    self.y = y
    self.direction = dir
    self.distanceTraveled = 0

    self.type = def.type
    self.width = def.width
    self.height = def.height

    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.texture = def.texture
    self.frame = def.frame

    self.whole = true

    if self.direction == 'left' then
    	self.dx = -100
    	self.dy = 0
    elseif self.direction == 'right' then
    	self.dx = 100
    	self.dy = 0
    elseif self.direction == 'up' then
    	self.dx = 0
    	self.dy = -100
    else
    	self.dx = 0
    	self.dy = 100
    end
end

function Projectile:update(dt)
	self.x = self.x + (self.dx * dt)
	self.y = self.y + (self.dy * dt)

	self.distanceTraveled = self.distanceTraveled + math.abs(self.dx * dt) + math.abs(self.dy * dt)
	self.y = self.y + (self.y  * dt)

	if self.whole then
		if self:wallCollision() or self.distanceTraveled >= 4 * TILE_SIZE then
			self.whole = false
		end
	end
end

function Projectile:render()
	love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame],
		math.floor(self.x - self.offsetX), math.floor(self.y - self.offsetY))
end

function Projectile:wallCollision()
	if self.x <= MAP_RENDER_OFFSET_X  or self.x >= MAP_WIDTH*TILE_SIZE
		or self.y <= MAP_RENDER_OFFSET_Y - 8 or self.y >= MAP_HEIGHT*TILE_SIZE then
		return true
	else
		return false
	end
end