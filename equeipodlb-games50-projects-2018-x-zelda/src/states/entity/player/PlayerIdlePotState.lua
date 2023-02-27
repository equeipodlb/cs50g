PlayerIdlePotState = Class{__includes = BaseState}

function PlayerIdlePotState:init(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)

end

--[[
    We can call this function if we want to use this state on an agent in our game; otherwise,
    we can use this same state in our Player class and have it not take action.
]]

function PlayerIdlePotState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk-pot')
    end

    if love.keyboard.wasPressed('a') then
        -- throw pot
        local projectile = self.entity.carrying:fire()
        table.insert(self.dungeon.currentRoom.projectiles, projectile)
        table.remove(self.dungeon.currentRoom.objects,2)
        self.entity:changeState('idle')
    end
end

function PlayerIdlePotState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end