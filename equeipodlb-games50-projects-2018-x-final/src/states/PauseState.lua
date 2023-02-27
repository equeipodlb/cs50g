--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- PauseState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The pause screen of our game.
]]

PauseState = Class{__includes = BaseState}

function PauseState:init()
    self.enemies = {}
    self.alliedLasers = {}
    self.enemyLasers = {}
    self.timer = 0
end

function PauseState:enter(params)
    self.ship = params.ship
    self.enemies = params.enemies
    self.alliedLasers = params.alliedLasers
    self.enemyLasers = params.enemyLasers
    self.explosions = params.explosions
    self.objects = params.objects
    self.score = params.score
    self.timer = params.timer
    self.highScores = params.highScores
    self.shootingTimer = params.shootingTimer
    self.fireRatePowerUp = params.fireRatePowerUp
    self.fireRatePowerUpTimer = params.fireRatePowerUpTimer
    self.multiShotPowerUp = params.multiShotPowerUp
    self.multiShotPowerUpTimer = params.multiShotPowerUpTimer
    self.boss = params.boss
    self.bossTimer = params.bossTimer
    self.level = params.level
    sounds['pause_sound']:play()
    sounds['music']:pause()
    Scrolling = false
end

function PauseState:update(dt)
    -- go back to play if p is pressed
    if love.keyboard.wasPressed('p') then
        if not self.boss then
            gStateMachine:change('play', {
                score = self.score,
                ship = self.ship,
                enemies = self.enemies,
                friendlyShots = self.alliedLasers,
                enemyShots = self.enemyLasers,
                explosions = self.explosions,
                objects = self.objects,
                timer = self.timer,
                highScores = self.highScores,
                shootingTimer = self.shootingTimer,
                fireRatePowerUp = self.fireRatePowerUp,
                fireRatePowerUpTimer = self.fireRatePowerUpTimer,
                multiShotPowerUp = self.multiShotPowerUp,
                multiShotPowerUpTimer = self.multiShotPowerUpTimer,
                boss = self.boss,
                bossTimer = self.bossTimer,
                level = self.level
            })
        else
            gStateMachine:change('boss', {
                score = self.score,
                ship = self.ship,
                enemies = self.enemies,
                friendlyShots = self.alliedLasers,
                enemyShots = self.enemyLasers,
                explosions = self.explosions,
                objects = self.objects,
                timer = self.timer,
                highScores = self.highScores,
                shootingTimer = self.shootingTimer,
                fireRatePowerUp = self.fireRatePowerUp,
                fireRatePowerUpTimer = self.fireRatePowerUpTimer,
                multiShotPowerUp = self.multiShotPowerUp,
                multiShotPowerUpTimer = self.multiShotPowerUpTimer,
                boss = self.boss,
                level = self.level
            })
        end
    end
end

function PauseState:exit()
    sounds['music']:play()
    Scrolling = true
end

function PauseState:render()
    if not self.boss then
        for k, enemy in pairs(self.enemies) do
            enemy:render()
        end
    else
        self.boss:render()
    end
    for k,explosion in pairs(self.explosions) do
        love.graphics.draw(explosion, explosion.x, explosion.y)
    end
    for k,object in pairs(self.objects) do
        object:render()
    end
    for k, laser in pairs(self.enemyLasers) do
        laser:render()
    end
    for k, laser in pairs(self.alliedLasers) do
        laser:render()
    end
    love.graphics.setFont(gFonts['spaceFont'])
    love.graphics.print('Score: ' .. tostring(math.floor(self.score)), 8, 8)
    love.graphics.printf('PAUSE', VIRTUAL_WIDTH / 2 - 48, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'left')

    for i = 0,self.ship.health - 1,1 do
        love.graphics.draw(love.graphics.newImage('graphics/heart.png'),8 + i*24, 48)
    end

    self.ship:render()
end