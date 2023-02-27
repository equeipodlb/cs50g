--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- ENEMY LASER CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	There will be 2 types of enemy laser. Even though they will travel at the same speed, 1 can only be shot from
    the boss' canons, is bigger and will deal more damage
]]

EnemyLaser = Class{}

function EnemyLaser:init(x, y, skin)
    self.x = x
    self.y = y
    self.skin = skin
    if self.skin == 1 then
        self.width = LASER_WIDTH
        self.height = LASER_HEIGHT
        self.dmg = 1
    else
        self.width = BIG_LASER_WIDTH
        self.height = BIG_LASER_HEIGHT
        self.dmg = 2
    end
    self.image = gFrames['lasers'][self.skin]
end

function EnemyLaser:update(dt)
    self.x = self.x - LASER_SPEED * dt
end

function EnemyLaser:render()
    if self.skin == 1 then
        love.graphics.draw(self.image, self.x, self.y,0,0.1,0.1)
    else
        love.graphics.draw(self.image,self.x,self.y,0,0.190476,0.18939393)
    end
end