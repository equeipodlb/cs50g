--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- SHIP CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The ship class will serve as the playable ship for our game that the player will move and use to shoot
]]

Ship = Class{}

function Ship:init()
    self.image = love.graphics.newImage('graphics/ship.png')
    self.x = (VIRTUAL_WIDTH / 2) - 8
    self.y = (VIRTUAL_HEIGHT / 2) - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.health = 3

    self.dx = 0
    self.dy = 0

    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0
end

--[[
    AABB collision that expects a laser, which will have an X and Y and reference
    their own width and height with some leeway for the player
]]
function Ship:collides(laser)
    if (self.x + 2) + (self.width - 4) >= laser.x and self.x + 2 <= laser.x + laser.width then
        if (self.y + 2) + (self.height - 4) >= laser.y and self.y + 2 <= laser.y + laser.height then
            return true
        end
    end

    return false
end
-- If we get hit we go invulnerable
function Ship:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Ship:update(dt)
    -- keyboard input
    -- Doing it this way allows fluid movement in all axis and in both of them simultaneously
    if love.keyboard.isDown('left') then
        self.dx = -SHIP_SPEEDX
    elseif love.keyboard.isDown('right') then
        self.dx = SHIP_SPEEDX
    else
        self.dx = 0
    end
    if love.keyboard.isDown('up') then
        self.dy = -SHIP_SPEEDY
    elseif love.keyboard.isDown('down') then
        self.dy = SHIP_SPEEDY
    else
        self.dy = 0
    end
    
    --Invulnerability
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    
    --ensure boundaries
    self.x = math.max(0, self.x + self.dx * dt)
    self.y = math.max(0, self.y + self.dy * dt)

    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    self.y = math.min(VIRTUAL_HEIGHT - self.width, self.y + self.dy * dt)
end

function Ship:render()
    -- Flash if invulnerable
    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end
    love.graphics.draw(self.image, self.x, self.y)
    -- Reset Color
    love.graphics.setColor(1,1,1,1)
end