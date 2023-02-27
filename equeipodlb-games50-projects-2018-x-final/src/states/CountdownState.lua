--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- CountdownState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState or to the bossState as soon as the
    countdown is complete.
]]

CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
    self.highScores = {}
end
function CountdownState:enter(params)
    self.highScores = params.highScores
    self.message = params.message or ''
    self.boss = params.boss
    self.ship = params.ship
    self.score = params.score
    self.level = params.level or 1
end
--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            if not self.boss then
                gStateMachine:change('play', {
                    highScores = self.highScores
                })
            else
                gStateMachine:change('boss', {
                    ship = self.ship,
                    score = self.score,
                    level = self.level,
                    highScores = self.highScores
                })
            end
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(gFonts['hugeFont'])
    love.graphics.printf(self.message, 0, 50, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end