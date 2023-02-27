--[[
    GD50 FINAL PROJECT

    SPACE ATTACK

    -- main.lua --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    This is my final project for the GD50 course. It is a 2D space shooter made with LOVE2D and lua. With 
    an infinite scrolling background, we create the illusion that the player is travelling through space defeating
    enemies and bosses and trying to score as high as possible
]]


require 'src/Dependencies'
local background = love.graphics.newImage('graphics/background.png')
local backgroundScroll = 0

local BACKGROUND_SCROLL_SPEED = 25

local BACKGROUND_LOOPING_POINT = 1024

-- global variable we can use to scroll the map
Scrolling = true


-- Local helper function for loading the highScores from a .lst file
local function loadHighScores()
    love.filesystem.setIdentity('space-attack')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('spaceAttack.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. tostring(0) .. '\n'
        end

        love.filesystem.write('spaceAttack.lst', scores)
    end

    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a score
        scores[i] = 0
    end

    -- iterate over each line in the file, filling the scores
    for line in love.filesystem.lines('spaceAttack.lst') do
        scores[counter] = tonumber(line)
        counter = counter + 1
    end

    return scores
end

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- seed the RNG
    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Space Attack')

    -- initialize our nice-looking retro text fonts. https://www.dafontfree.net
    gFonts = {
        ['smallFont'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['mediumFont'] = love.graphics.newFont('fonts/space_invaders.ttf', 14),
        ['spaceFont'] = love.graphics.newFont('fonts/space_invaders.ttf', 28),
        ['hugeFont'] = love.graphics.newFont('fonts/space_invaders.ttf', 56)
    }
    love.graphics.setFont(gFonts['spaceFont'])

    -- initialize our table of sounds. https://freesound.org
    sounds = {
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['pause_sound'] = love.audio.newSource('sounds/pause.mp3','static'),
        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('sounds/space_music.mp3', 'static'),
        ['fire'] = love.audio.newSource('sounds/laser-gun.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['1up'] = love.audio.newSource('sounds/1up.wav', 'static'),
        ['power-up'] = love.audio.newSource('sounds/power-up.wav','static'),
        ['large-explosion'] = love.audio.newSource('sounds/large-explosion.wav', 'static')
    }
    --Initialize some different frames and images that we will need 
    gFrames = {
        ['powerups'] = GenerateQuads(love.graphics.newImage('graphics/powerups.png'),24,24),
        ['boss'] = {
            [1] = love.graphics.newImage('graphics/bossframe0.png'),
            [2] = love.graphics.newImage('graphics/bossframe1.png'),
            [3] = love.graphics.newImage('graphics/bossframe2.png'),
            [4] = love.graphics.newImage('graphics/bossframe3.png')
        },
        ['lasers'] = {
            [1] = love.graphics.newImage('graphics/enemy-laser.png'),
            [2] = love.graphics.newImage('graphics/bigLaser.png')
        },
    }
    --since we want the 5th powerup in the image to be our 3rd powerup and we won't the rest of them:
    gFrames['powerups'][3] = gFrames['powerups'][5]
    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['score'] = function() return ScoreState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['how-to-play'] = function() return HowToPlayState() end,
        ['boss'] = function() return BossState() end
    }
    -- enter title screen
    gStateMachine:change('title', {
        highScores = loadHighScores()
    })
    

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if Scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    
    push:finish()
end

