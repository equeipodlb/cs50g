--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- BossState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    The BossState class is where we will fight the boss of the game.
]]

BossState = Class{__includes = BaseState}

local pause = false
local bossCanonLocationsY = {245,279,88,150,373,436}
function BossState:init()
    self.friendlyShots = {}
    self.enemyShots = {}
    self.explosions = {}
    self.objects = {}
    self.timer = 0
    self.shootingTimer = 0
    self.fireRatePowerUp = false
    self.fireRatePowerUpTimer = 0
    self.multiShotPowerUp = false
    self.multiShotPowerUpTimer = 0
    self.level = 1
end
--[[
    Called when this state is transitioned to from another state.
]]
function BossState:enter(params)
    -- if we're coming from death, restart scrolling
    self.score = params.score
    self.ship = params.ship
    self.level = params.level
    self.boss = params.boss or Boss(self.level)
    self.highScores = params.highScores
    if (pause == true) then
        self.friendlyShots = params.friendlyShots
        self.enemyShots = params.enemyShots
        self.explosions = params.explosions
        self.objects = params.objects
        self.timer = params.timer
        self.shootingTimer = params.shootingTimer
        self.multiShotPowerUp = params.multiShotPowerUp
        self.multiShotPowerUpTimer = params.multiShotPowerUpTimer
        self.fireRatePowerUp = params.fireRatePowerUp
        self.fireRatePowerUpTimer = params.fireRatePowerUpTimer
    end
    Scrolling = true
    pause = false
end

local function getExplosion()
    local psystem = love.graphics.newParticleSystem(love.graphics.newImage('graphics/particle.png'), 64)
    psystem:setParticleLifetime(0.5, 1)
    psystem:setLinearAcceleration(-15, 0, 15, 80)
    psystem:setEmissionArea('normal', 10, 10)
    psystem:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    return psystem
end

local function getBossExplosion(boss)
    local psystem = love.graphics.newParticleSystem(love.graphics.newImage('graphics/particle.png'),10000)
    psystem:setParticleLifetime(1, 1.5)
    psystem:setLinearAcceleration(-50, -80, 50, 80)
    psystem:setEmissionArea('normal', 50, 50)
    psystem:setColors(1, 0, 0, 1, 1, 153/255, 51/255, 1, 64/255, 64/255, 64/255, 0)
    psystem:setPosition(boss.x + boss.width / 2,boss.y + boss.height/2)
    return psystem
end

function BossState:update(dt)
    
    self.timer = self.timer + dt
    self.score = self.score + 10 * dt
    if math.random(1000/(self.level)) == 1 then
        table.insert(self.objects, PickUp(VIRTUAL_WIDTH-POWERUP_WIDTH,math.random(0,VIRTUAL_HEIGHT- 12),math.random(3)))
    end
    if math.random(1,math.max(15,35-5*self.level)) == 1 then
        table.insert(self.enemyShots,EnemyLaser(self.boss.x - LASER_WIDTH, math.random(self.boss.y, self.boss.y + BOSS_HEIGHT),1))
    end
    if math.random(1,math.max(15,45-5*self.level)) == 1 then
        table.insert(self.enemyShots, EnemyLaser(self.boss.x - BIG_LASER_WIDTH, self.boss.y + bossCanonLocationsY[math.random(#bossCanonLocationsY)]/2 - BIG_LASER_HEIGHT/2,2))
    end
    for k,object in pairs(self.objects) do
        if object:collides(self.ship) then
            if object.skin == 1 then
                self.ship.health = math.min(MAX_HEALTH, self.ship.health+1)
                sounds['1up']:play()
            elseif object.skin == 2 then
                sounds['power-up']:play()
                self.fireRatePowerUp = true
                self.fireRatePowerUpTimer = 0
            else
                sounds['power-up']:play()
                self.multiShotPowerUp = true
                self.multiShotPowerUpTimer = 0   
            end
            self.score = self.score + 50
            table.remove(self.objects,k)
        end
        object:update(dt)
    end
    for k, laser in pairs(self.friendlyShots) do
        if self.boss:collides(laser) then
            self.boss.health = self.boss.health - 1
            local explosion = getExplosion()
            explosion:setPosition(laser.x + laser.width,laser.y + laser.height/2)
            explosion:emit(64)
            table.insert(self.explosions,explosion)
            sounds['explosion']:play()
            table.remove(self.friendlyShots,k)
        end
        laser:update(dt)
        if laser.x + LASER_WIDTH > VIRTUAL_WIDTH then
            table.remove(self.friendlyShots, k)
        end
    end
    for k, laser in pairs(self.enemyShots) do
        laser:update(dt)
        if laser.x < 0 then
            table.remove(self.enemyShots, k)
        end
    end
    
    -- simple collision between ship and all enemy shots
    for k, laser in pairs(self.enemyShots) do
        if self.ship:collides(laser) and not self.ship.invulnerable then
            self.ship.health = self.ship.health - laser.dmg
            self.ship:goInvulnerable(1.5)
            table.remove(self.enemyShots,k)
            sounds['hurt']:play()
        end
        
    end
    
    if self.ship.health <= 0 then
        sounds['explosion']:play()
        gStateMachine:change('score', {
            score = self.score,
            highScores = self.highScores
        })
    end
    -- update ship based on input
    self.ship:update(dt)
    self.boss:update(dt)
    self.shootingTimer = self.shootingTimer + dt
    self.multiShotPowerUpTimer = self.multiShotPowerUpTimer + dt
    if self.multiShotPowerUpTimer > MULTI_SHOT_DURATION then
        self.multiShotPowerUpTimer = 0
        self.multiShotPowerUp = false
    end
    self.fireRatePowerUpTimer = self.fireRatePowerUpTimer + dt
    if self.fireRatePowerUpTimer > FIRE_RATE_DURATION then
        self.fireRatePowerUpTimer = 0
        self.fireRatePowerUp = false
    end
    for k,explosion in pairs(self.explosions) do
        explosion:update(dt)
        if explosion:getCount() == 0 then
          table.remove(self.explosions, k)
        end
    end


    if love.keyboard.wasPressed('space') then
        if not self.fireRatePowerUp then
            if self.shootingTimer > SHOOTING_COOLDOWN then
                sounds['fire']:play()
                table.insert(self.friendlyShots, FriendlyLaser(self.ship.x + self.ship.width, self.ship.y + (self.ship.height - LASER_HEIGHT) / 2))
                self.shootingTimer = 0
                if self.multiShotPowerUp then
                    table.insert(self.friendlyShots,FriendlyLaser(self.ship.x + self.ship.width, self.ship.y + self.ship.height/5 - LASER_HEIGHT/2))
                    table.insert(self.friendlyShots,FriendlyLaser(self.ship.x + self.ship.width, self.ship.y + 4*self.ship.height/5 - LASER_HEIGHT/2))
                end
            end
        else
            if self.shootingTimer > SHOOTING_COULDOWN_POWERUP then
                sounds['fire']:play()
                table.insert(self.friendlyShots, FriendlyLaser(self.ship.x + self.ship.width, self.ship.y + (self.ship.height - LASER_HEIGHT) / 2))
                self.shootingTimer = 0
                if self.multiShotPowerUp then
                    table.insert(self.friendlyShots,FriendlyLaser(self.ship.x + self.ship.width, self.ship.y + self.ship.height/5 - LASER_HEIGHT/2))
                    table.insert(self.friendlyShots,FriendlyLaser(self.ship.x + self.ship.width, self.ship.y + 4*self.ship.height/5 - LASER_HEIGHT/2))
                end
            end
        end
    end

    if self.boss.health <= 0 then
        self.score = self.score + 1000 * self.level
        local explosion = getBossExplosion(self.boss)
        explosion:emit(10000)
        table.insert(self.explosions,explosion)
        sounds['large-explosion']:play()
        gStateMachine:change('play', {
            score = self.score,
            ship = self.ship,
            friendlyShots = self.friendlyShots,
            enemyShots = self.enemyShots,
            explosions = self.explosions,
            objects = self.objects,
            timer = self.timer,
            shootingTimer = self.shootingTimer,
            multiShotPowerUp = self.multiShotPowerUp,
            multiShotPowerUpTimer = self.multiShotPowerUpTimer,
            fireRatePowerUp = self.fireRatePowerUp,
            fireRatePowerUpTimer = self.fireRatePowerUpTimer,
            level = self.level + 1,
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('p') then
        pause = true
        gStateMachine:change('pause', {
            score = self.score,
            ship = self.ship,
            boss = self.boss,
            alliedLasers = self.friendlyShots,
            enemyLasers = self.enemyShots,
            explosions = self.explosions,
            objects = self.objects,
            timer = self.timer,
            highScores = self.highScores,
            shootingTimer = self.shootingTimer,
            fireRatePowerUp = self.fireRatePowerUp,
            fireRatePowerUpTimer = self.fireRatePowerUpTimer,
            multiShotPowerUp = self.multiShotPowerUp,
            multiShotPowerUpTimer = self.multiShotPowerUpTimer,
            level = self.level,
        })
    end
end

function BossState:render()
    for k,explosion in pairs(self.explosions) do
        love.graphics.draw(explosion, explosion.x, explosion.y)
    end
    for k,object in pairs(self.objects) do
        object:render()
    end
    for k, laser in pairs(self.friendlyShots) do
        laser:render()
    end
    for k,laser in pairs(self.enemyShots) do
        laser:render()
    end
    love.graphics.setFont(gFonts['spaceFont'])
    love.graphics.print('Score: ' .. tostring(math.floor(self.score)), 8, 8)
    for i = 0,self.ship.health - 1,1 do
        love.graphics.draw(love.graphics.newImage('graphics/heart.png'),8 + i*24, 48)
    end
    self.ship:render()
    self.boss:render()
end

