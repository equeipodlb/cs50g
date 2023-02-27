--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- PICKUP CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The pickup class will serve as the ship's powerups and upgrades so that it is easier for it to fight the enemies
]]

PickUp = Class{}


function PickUp:init(x, y,skin)
    self.x = x
    self.y = y

    self.width = POWERUP_WIDTH
    self.height = POWERUP_HEIGHT
    -- need a skin because there are 3 different ones
    self.skin = skin
    self.image = gFrames['powerups'][skin]
end



function PickUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function PickUp:update(dt)
    -- They move just like a laser in the x-axis
    self.x = self.x - LASER_SPEED * dt
end

function PickUp:render()
    love.graphics.draw(love.graphics.newImage('graphics/powerups.png'),self.image, self.x, self.y,0,0.5,0.5)
end