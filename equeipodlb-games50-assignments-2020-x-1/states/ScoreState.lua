--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}
local bronzeMedal = love.graphics.newImage('Bronze.png')
local silverMedal = love.graphics.newImage('Silver.png')
local GoldenMedal = love.graphics.newImage('Gold.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)

    if self.score == 0 then
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    elseif self.score >=1 and self.score <= 3 then
        love.graphics.printf('Congratulations! You get a bronze medal!', 0, 0, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(bronzeMedal, (VIRTUAL_WIDTH / 2) - (31*4/5), VIRTUAL_HEIGHT / 2 + 30, 0, 0.2, 0.2)
    elseif self.score > 3 and self.score <=6 then
        love.graphics.printf('Congratulations! You get a silver medal!', 0 , 0,VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(silverMedal, (VIRTUAL_WIDTH / 2) - (31*4/5), VIRTUAL_HEIGHT / 2 + 30, 0, 0.2, 0.2)
    else
        love.graphics.printf('Congratulations! You get a gold medal', 0, 0, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(GoldenMedal, (VIRTUAL_WIDTH / 2) - (31*4/5), VIRTUAL_HEIGHT / 2 + 30, 0, 0.2, 0.2)
    end

    

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end