--[[
	GD50 FINAL PROJECT

    SPACE ATTACK

    -- TitleScreenState CLASS --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

	The starting screen of our game. It should display 4 different options: Play, HighScores, How to play and quit
]]

TitleScreenState = Class{__includes = BaseState}

local highlighted = 0

function TitleScreenState:init()
    self.highScores = {}
end

function TitleScreenState:enter(params)
    self.highScores = params.highScores
end

-- helper function to get a mod b for negatives too
local function rem(a,b) return a-b*math.floor(a/b) end


function TitleScreenState:update(dt)
    -- update highlighted mod 4 (number of options)
    if love.keyboard.wasPressed('up') then
        highlighted = rem((highlighted - 1),  4)
        sounds['select']:play()
    elseif love.keyboard.wasPressed('down') then
        highlighted = rem((highlighted + 1),  4)
        sounds['select']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        sounds['confirm']:play()

        if highlighted == 0 then
            gStateMachine:change('countdown', {
                highScores = self.highScores,
                boss = false,
                message = ''
            })
        elseif highlighted == 1 then
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        elseif highlighted == 2 then
            gStateMachine:change('how-to-play',{
                highScores = self.highScores
            })
        else
            love.event.quit()
        end
    end
end

function TitleScreenState:render()
    love.graphics.setFont(gFonts['spaceFont'])
    love.graphics.printf('Space Attack', 0, 96, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['mediumFont'])
    

    -- if we're highlighting 1, render that option yellow
    if highlighted == 0 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf("PLAY", 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 yellow if we're highlighting that one
    if highlighted == 1 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
    -- render option 3 yellow if we're highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf("HOW TO PLAY", 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')
    -- reset the color
    love.graphics.setColor(1,1,1,1)
    -- render option 4 yellow if we're highlighting that one
    if highlighted == 3 then
        love.graphics.setColor(1, 1, 0, 1)
    end
    love.graphics.printf("QUIT", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
    -- reset the color
    love.graphics.setColor(1,1,1,1)
end