--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- ALIEN CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The basic enemies of the game. These alien ships will try to fly past you to attack Earth while shooting you
]]

Alien = Class{}
-- since we only want the image loaded once, not per instantation, define it externally
local ALIEN_IMAGE = love.graphics.newImage('graphics/alienship.png')

function Alien:init()
    self.width = ALIEN_WIDTH
    self.height = ALIEN_HEIGHT

    self.x = VIRTUAL_WIDTH - self.width
    self.y = math.random(0,VIRTUAL_HEIGHT- self.height)

    self.health = 1

    self.dx = ALIEN_SPEED
    self.dy = 0
    
    self.moveDuration = 0
    self.movementTimer = 0
end

--[[
    AABB collision with some leeway
]]
function Alien:collides(laser)
    if (self.x + 2) + (self.width - 4) >= laser.x and self.x + 2 <= laser.x + LASER_WIDTH then
        if (self.y + 2) + (self.height - 4) >= laser.y and self.y + 2 <= laser.y + LASER_HEIGHT then
            return true
        end
    end
    return false
end

function Alien:update(dt)
    self.x = self.x - self.dx * dt
    --Ensure it doesn't become 0
    if self.moveDuration == 0 then
        -- set an initial move duration and direction
        self.moveDuration = math.random()
        -- Randomly choose if it moves up or down
        if math.random(2) == 1 then
            self.dy = ALIEN_SPEEDY
        else
            self.dy = -ALIEN_SPEEDY
        end

    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0
        self.moveDuration = math.random()
        -- Randomly choose if it moves up or down
        if math.random(2) == 1 then
            self.dy = ALIEN_SPEEDY
        else
            self.dy = -ALIEN_SPEEDY
        end
    end

    self.movementTimer = self.movementTimer + dt
    self.y = math.max(0, self.y + self.dy * dt)
    self.y = math.min(VIRTUAL_HEIGHT - self.width, self.y + self.dy * dt)
end

function Alien:render()
    love.graphics.draw(ALIEN_IMAGE, self.x, self.y,0,0.026548,0.02784)
end