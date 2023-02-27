--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- ScoreState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    The PlayState class is the bulk of the game, where the player actually shoots the ship and
    avoids enemies. When the player collides with a laser, we should have 1 less health, When we die we should goo
    to the ScoreState, where we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}


function PlayState:init()
    self.ship = Ship()
    self.enemies = {}
    self.friendlyShots = {}
    self.enemyShots = {}
    self.explosions = {}
    self.objects = {}
    self.timer = 0
    self.score = 0
    self.shootingTimer = 0
    self.fireRatePowerUp = false
    self.fireRatePowerUpTimer = 0
    self.multiShotPowerUp = false
    self.multiShotPowerUpTimer = 0
    self.bossTimer = 0
    self.level = 1
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)
    -- if we're coming from death, restart scrolling
    self.highScores = params.highScores
    self.score = params.score or 0
    self.ship = params.ship or Ship()
    self.enemies = params.enemies or {}
    self.friendlyShots = params.friendlyShots or {}
    self.enemyShots = params.enemyShots or {}
    self.explosions = params.explosions or {}
    self.objects = params.objects or {}
    self.timer = params.timer or 0
    self.shootingTimer = params.shootingTimer or 0
    self.multiShotPowerUp = params.multiShotPowerUp or false
    self.multiShotPowerUpTimer = params.multiShotPowerUpTimer or 0
    self.fireRatePowerUp = params.fireRatePowerUp or false
    self.fireRatePowerUpTimer = params.fireRatePowerUpTimer or 0
    self.bossTimer = params.bossTimer or 0
    self.level = params.level or 1
    Scrolling = true
end

local function getExplosion()
    local psystem = love.graphics.newParticleSystem(love.graphics.newImage('graphics/particle.png'), 64)
    psystem:setParticleLifetime(0.5, 1)
    psystem:setLinearAcceleration(-15, 0, 15, 80)
    psystem:setEmissionArea('normal', 10, 10)
    psystem:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    return psystem
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt
    self.score = self.score + 10 * dt
    local timelapse = math.random(1,math.max(2,math.floor(15/self.level)))
    -- spawn a new pipe pair every second and a half
    if self.timer > timelapse then
        table.insert(self.enemies,Alien())
        -- reset timer
        self.timer = 0
    end
    if math.random(1000/(self.level)) == 1 then
        table.insert(self.objects, PickUp(VIRTUAL_WIDTH-POWERUP_WIDTH,math.random(0,VIRTUAL_HEIGHT- 12),math.random(3)))
    end
    -- for every enemy..
    for k, enemy in pairs(self.enemies) do
        for j, laser in pairs(self.friendlyShots) do
            if enemy:collides(laser) then
                local explosion = getExplosion()
                explosion:setPosition(enemy.x + enemy.width / 2,enemy.y + enemy.height/2)
                explosion:emit(64)
                table.insert(self.explosions,explosion)
                sounds['explosion']:play()
                table.remove(self.enemies,k)
                table.remove(self.friendlyShots,j)
                self.score = self.score + 50 + 50 * self.level
                break
            end
        end
        if enemy.x < 0 then
            self.ship.health = self.ship.health - 1
            sounds['hurt']:play()
            table.remove(self.enemies,k)
        end
        enemy:update(dt)
        if math.random(1,math.max(25,100 - 10*self.level)) == 1 then
            table.insert(self.enemyShots,EnemyLaser(enemy.x - LASER_WIDTH, enemy.y + (enemy.height - LASER_HEIGHT) / 2,1))
        end
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
        if object.x < 0 then 
            table.remove(self.objects,k)
        end
        object:update(dt)
    end
    for k, laser in pairs(self.friendlyShots) do
        laser:update(dt)
        if laser.x + LASER_WIDTH/2 > VIRTUAL_WIDTH then
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
    --simple collision between ship and all enemies
    for k, alien in pairs(self.enemies) do
        if self.ship:collides(alien) and not self.ship.invulnerable then
            self.ship.health = self.ship.health - 1
            sounds['hurt']:play()
            self.ship:goInvulnerable(1.5)
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
    self.shootingTimer = self.shootingTimer + dt
    self.multiShotPowerUpTimer = self.multiShotPowerUpTimer + dt
    self.bossTimer = self.bossTimer + dt
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

    if self.bossTimer > BOSS_COOLDOWN + 10*self.level then
        self.bossTimer = 0
        for k,v in pairs(self.enemies) do self.enemies[k]=nil end
        for k,v in pairs(self.friendlyShots) do self.friendlyShots[k]=nil end
        for k,v in pairs(self.enemyShots) do self.enemyShots[k]=nil end
        for k,v in pairs(self.objects) do self.objects[k]=nil end
        for k,v in pairs(self.explosions) do self.explosions[k]=nil end
        gStateMachine:change('countdown', {
            boss = true,
            message = 'BOSS INCOMING',
            ship = self.ship,
            score = self.score,
            level = self.level,
            highScores = self.highScores
        })
        
    end

    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            score = self.score,
            ship = self.ship,
            enemies = self.enemies,
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
            bossTimer = self.bossTimer,
            level = self.level
        })
    end
end

function PlayState:render()
    for k, enemy in pairs(self.enemies) do
        enemy:render()
    end
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
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    Scrolling = false
end