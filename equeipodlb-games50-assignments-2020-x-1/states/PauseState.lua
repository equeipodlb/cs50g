PauseState = Class{__includes = BaseState}
local pauseImage = love.graphics.newImage('pauseImage.jpg')

function PauseState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
end

function PauseState:enter(params)
    self.bird.x = params.x
    self.bird.y = params.y
    self.score = params.score
    self.pipePairs = params.pipepairs
    self.timer = params.timer
    sounds['pause_sound']:play()
    sounds['music']:pause()
end

function PauseState:update(dt)
    -- go back to play if p is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            score = self.score,
            x = self.bird.x,
            y = self.bird.y,
            pipepairs = self.pipePairs,
            timer = self.timer
        })
    end
end

function PauseState:exit()
    sounds['music']:play()
end

function PauseState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.draw(pauseImage, VIRTUAL_WIDTH/2 - (180/5) , VIRTUAL_HEIGHT/2 - (180/5), 0, 0.2, 0.2)

    self.bird:render()
end