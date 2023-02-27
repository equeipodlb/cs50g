--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- BOSS CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The big enemy of the game. The boss will shoot different types of lasers and you and it is much tankier than the
    small aliens. Also it has a cool animation
]]

Boss = Class{}

function Boss:init(level)
    self.animation = Animation({
        frames = gFrames['boss'],
        interval = 0.2,
        looping = true,
    })
    
    self.width = BOSS_WIDTH / 2
    self.height = BOSS_HEIGHT / 2

    self.x = VIRTUAL_WIDTH - self.width
    self.y = (VIRTUAL_HEIGHT - self.height)/2 - 5

    self.health = 50 * level
    
end

--[[
    AABB collision
]]
function Boss:collides(laser)
    if (self.x + 2) + (self.width - 4) >= laser.x and self.x + 2 <= laser.x + LASER_WIDTH then
        if (self.y + 2) + (self.height - 4) >= laser.y and self.y + 2 <= laser.y + LASER_HEIGHT then
            return true
        end
    end
    return false
end


function Boss:update(dt)
    self.animation:update(dt)
end

function Boss:render()
    love.graphics.draw(self.animation:getCurrentFrame(), self.x, self.y,0,0.5,0.5)
end