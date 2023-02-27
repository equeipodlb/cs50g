LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(pkmnstats, increases)
    self.pkmnstats = pkmnstats
    self.increases = increases
    self.lvlupMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 128 - 64,
        width = 64,
        height = 128,
        cursor = false,
        items = {
            {
                text = self.pkmnstats.baseHP .. "+" .. self.increases[1] .. "="..  self.pkmnstats.baseHP + self.increases[1],
            },
            {
                text =  self.pkmnstats.baseAttack .. "+" .. self.increases[2] .. "="..  self.pkmnstats.baseAttack + self.increases[2],    
            },
            {
                text =  self.pkmnstats.baseDefense .. "+" .. self.increases[3] .. "="..  self.pkmnstats.baseDefense + self.increases[3],
            },
            {
                text =  self.pkmnstats.baseSpeed .. "+" .. self.increases[4] .. "="..  self.pkmnstats.baseSpeed + self.increases[4],
            }
        }
    }
end

function LevelUpMenuState:update(dt)
    self.lvlupMenu:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateStack:pop()
    end
end

function LevelUpMenuState:render()
    self.lvlupMenu:render()
end