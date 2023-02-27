--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local keyHasSpawned = false
    local lockHasSpawned = false
    local keyandlockColor = -1
    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and not(x == 1 or x==width) then --x!= 1 condition ensures 1st one is not empty
            for y = 7, height do                                -- x!= width ensures flag is there
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 and not(x==width) then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                -- chance to generate key on pilar
                elseif math.random(10) == 1 and not(keyHasSpawned) then
                    keyHasSpawned = true
                    keyandlockColor = math.random(#KEYS)
                    table.insert(objects,
                        --key
                        GameObject{
                            texture = 'keys',
                            x = (x-1) * TILE_SIZE,
                            y = (4-1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = keyandlockColor,
                            collidable = true,
                            consumable = true,
                            solid =false,
    
                            -- collision
                            onConsume = function(player,object)
                                gSounds['pickup']:play()
                                player.keyIsPickedUp = true
                            end
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            
            -- chance to spawn the key
            elseif math.random(10) == 1 and not(keyHasSpawned) then
                keyHasSpawned = true
                keyandlockColor = math.random(#KEYS)
                table.insert(objects,
                    --key
                    GameObject{
                        texture = 'keys',
                        x = (x-1) * TILE_SIZE,
                        y = (6-1)*TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = keyandlockColor,
                        collidable = true,
                        consumable = true,
                        solid =false,

                        -- collision
                        onConsume = function(player,object)
                            gSounds['pickup']:play()
                            player.keyIsPickedUp = true
                        end
                    }
                )
            end



            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            -- Chance to spawn a locked block
            elseif math.random(10) == 1 and keyHasSpawned and not(lockHasSpawned) then
                lockHasSpawned = true
                table.insert(objects,
                    --Locked block
                    GameObject {
                        texture = 'locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = keyandlockColor,
                        collidable = true,
                        consumable = true,
                        solid = true,
                        
                        --collision function
                        onCollide = function(object,player)
                            if player.keyIsPickedUp then
                                object.onConsume(player,object)
                            else
                                gSounds['empty-block']:play()
                            end
                        end,
                        --Consuming function generates pole an flag
                        onConsume = function(player, object)
                            local goalpost = GameObject {
                                texture = 'goalposts',
                                x = (width - 1) * TILE_SIZE,
                                y = (blockHeight - 1) * TILE_SIZE - 4,
                                width = 16,
                                height = 48,
                                frame = math.random(#GOALPOSTS),
                                collidable = true,
                                consumable = true,
                                solid = false,

                                onConsume = function(player, object)
                                    gStateMachine:change('play', { -- change to play
                                        score = player.score,
                                        levelwidth = width + 50
                                    })
                                end
                            }
                            table.insert(objects, goalpost)
                            local flag = GameObject {
                                texture = 'flags',
                                x = (width - 1) * TILE_SIZE,
                                y = (blockHeight - 1) * TILE_SIZE - 4,
                                width = 48,
                                height = 16,
                                frame = math.random(#FLAGS),
                                collidable = true,
                                consumable = true,
                                solid = false,

                                -- gem has its own function to add to the player's score
                                onConsume = function(player, object)
                                    gStateMachine:change('play', { -- change to play
                                        score = player.score,
                                        levelwidth = width + 50
                                    })
                                end
                            }
                            table.insert(objects,flag)

                        end

                    }
                )



            end
        end
    end
    



    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end