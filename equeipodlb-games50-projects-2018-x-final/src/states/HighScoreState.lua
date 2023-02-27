--[[
    GD50 - FINAL PROJECT
    SPACE ATTACK

    -- HighScoreState Class --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    Represents the screen where we can view all high scores previously recorded.
]]

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    -- return to the start screen if we press escape
    if love.keyboard.wasPressed('return') then
        gStateMachine:change('title', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['hugeFont'])
    love.graphics.printf('High Scores', 0, 15, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])

    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local score = self.highScores[i]
        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 
            80 + i * 13, 50, 'center')
        
        -- score itself
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            80 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['smallFont'])
    love.graphics.printf("Press Enter to return to the main menu!", 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')

end