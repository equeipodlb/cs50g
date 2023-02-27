--[[
    GD50 FINAL PROJECT

    SPACE ATTACK

    -- Dependencies.lua --

    Author: Enrique Queipo de Llano
    equeipodlb@gmail.com

    Some libraries and the requirements our game needs
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

require 'src/constants'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'src/StateMachine'

require 'src/states/BaseState'
require 'src/states/CountdownState'
require 'src/states/PlayState'
require 'src/states/TitleScreenState'
require 'src/states/ScoreState'
require 'src/states/PauseState'
require 'src/states/HighScoreState'
require 'src/states/HowToPlayState'
require 'src/states/BossState'

require 'src/Ship'
require 'src/Alien'
require 'src/FriendlyLaser'
require 'src/EnemyLaser'
require 'src/Util'
require 'src/PickUp'
require 'src/Animation'
require 'src/Boss'