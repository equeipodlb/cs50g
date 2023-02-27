--[[
    GD50 FINAL PROJECT

    SPACE ATTACK

    -- constants.lua --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    Some global constants and parameters for the game
]]

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- ship movement speed
SHIP_SPEEDX = 150
SHIP_SPEEDY = 125

--Laser speed and dimensions
LASER_SPEED = 200
LASER_WIDTH = 24
LASER_HEIGHT = 14
-- ship dimensions and max health
SHIP_WIDTH = 24
SHIP_HEIGHT = 24
MAX_HEALTH = 8
-- alien dimension
ALIEN_WIDTH = 24
ALIEN_HEIGHT = 24
-- alien speed
ALIEN_SPEED = 125
ALIEN_SPEEDY = 50
-- Shooting cooldowns
SHOOTING_COOLDOWN = 0.25
SHOOTING_COULDOWN_POWERUP = 0.15
-- Powerup dimensions
POWERUP_WIDTH = 12
POWERUP_HEIGHT = 12
-- Powerup durations
MULTI_SHOT_DURATION = 10
FIRE_RATE_DURATION = 10
-- Boss real from image dimensions
BOSS_WIDTH = 172
BOSS_HEIGHT = 524
-- Boss flat cooldown (scales with level)
BOSS_COOLDOWN = 30
-- Big laser dimensions
BIG_LASER_WIDTH = 44
BIG_LASER_HEIGHT = 25