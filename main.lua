require "common/conf"

require "game/mine_game_handler"

require "resource_enum"

WindowXCenter = math.floor(love.graphics.getWidth()/2)
WindowYCenter = math.floor(love.graphics.getHeight()/2)
love.window.setTitle("Mine Sweeper")


function love.load()
    if PROFILER then
        love.profiler = require('profile') 
        love.profiler.start()
    end


    mineGameHandler = MineGameHandler:new(MineAtlas, 30, 16, 99)
    mineGameHandler:makeCanvas()
end

if PROFILER then
    love.frame = 0
end
function love.update(dt)
    if PROFILER then
        love.frame = love.frame + 1
        if love.frame%100 == 0 then
            love.report = love.profiler.report(20)
            love.profiler.reset()
        end
    end
end

function love.draw()
    love.graphics.translate(WindowXCenter, WindowYCenter)
    mineGameHandler:draw()
    if PROFILER then
        love.graphics.print(love.report or "Please wait...")
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    x = x - WindowXCenter
    y = y - WindowYCenter

    mineGameHandler:mouseMoved(x, y)
    mineGameHandler:makeCanvas()
end

function love.mousepressed(x, y, button, istouch)
    
end

function love.mousereleased(x, y, button, istouch)
    x = x - WindowXCenter
    y = y - WindowYCenter
    if button == 1 then
        mineGameHandler:leftClicked(x, y)
    elseif button == 2 then
        mineGameHandler:rightClicked(x, y)
    end 
    mineGameHandler:makeCanvas()
end

function love.resize(w, h)
    
    mineGameHandler.mineGameSpriteTable:resizeAllSprite(w, h)
    

    WindowXCenter = math.floor(love.graphics.getWidth()/2)
    WindowYCenter = math.floor(love.graphics.getHeight()/2)
end

function love.quit()
    print("Bye...")
end