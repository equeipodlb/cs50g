--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- HowToPlayState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The how to play screen of our game.
]]

HowToPlayState = Class{__includes = BaseState}
function HowToPlayState:init()
    self.laser = FriendlyLaser(64 + SHIP_WIDTH,64 + SHIP_HEIGHT/2 - LASER_HEIGHT / 2)
    self.shipX = VIRTUAL_WIDTH/3 - SHIP_WIDTH/2
    self.shipY = VIRTUAL_HEIGHT/2 - SHIP_HEIGHT / 2
    self.shipDX = SHIP_SPEEDX
    self.shipDY = SHIP_SPEEDY
end
function HowToPlayState:enter(params)
    self.highScores = params.highScores
end

function HowToPlayState:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('title', {
            highScores = self.highScores
        })
    end
    self.laser:update(dt)
    if self.laser.x > VIRTUAL_WIDTH - 64 then
        self.laser.x = 88
    end
    -- revert direction when reached end
    if self.shipX > VIRTUAL_WIDTH / 2 then
        self.shipDX = -self.shipDX
    end
    if self.shipX < VIRTUAL_WIDTH / 4 then
        self.shipDX = -self.shipDX
    end
    if self.shipY < 120 then
        self.shipDY = -self.shipDY
    end
    if self.shipY > 200 - SHIP_HEIGHT then
        self.shipDY = -self.shipDY
    end
    self.shipX = self.shipX + self.shipDX * dt
    self.shipY = self.shipY + self.shipDY * dt

end

function HowToPlayState:render()
    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('Use spacebar to shoot!', 0, 15, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(love.graphics.newImage('graphics/ship.png'),64,64)
    self.laser:render()
    
    love.graphics.printf('Use arrows to move!',0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(love.graphics.newImage('graphics/ship.png'),self.shipX,VIRTUAL_HEIGHT/2)
    love.graphics.draw(love.graphics.newImage('graphics/ship.png'),3*VIRTUAL_WIDTH/4 - SHIP_WIDTH/2,self.shipY)
    love.graphics.printf('Survive, catch power-ups and do not let the enemies get past you!',0, 200, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.printf("Press Enter to return to the main menu!", 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')

end