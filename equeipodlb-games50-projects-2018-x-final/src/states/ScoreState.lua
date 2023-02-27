--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- ScoreState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	Final Screen of the game
]]

ScoreState = Class{__includes = BaseState}


--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        for i = 1, 10, 1 do
            local score = self.highScores[i] or 0
            if self.score > score then
                table.insert(self.highScores,i,math.floor(self.score))
                break
            end
        end

        local scoresStr = ''
        for i = 1, 10 do
            scoresStr = scoresStr .. tostring(self.highScores[i]) .. '\n'
        end

        love.filesystem.write('spaceAttack.lst', scoresStr)

        gStateMachine:change('title', {
            highScores = self.highScores
        })
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(gFonts['spaceFont'])
    love.graphics.printf('Well played!', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['mediumFont'])
    love.graphics.printf('Score: ' .. tostring(math.floor(self.score)), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to go back to the title!', 0, 160, VIRTUAL_WIDTH, 'center')
end