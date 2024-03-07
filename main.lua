require "common/conf"

require "game/mine_game_handler"

require "resource_enum"

function love.load()
    if PROFILER then
        love.profiler = require('profile') 
        love.profiler.start()
    end

    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    love.window.setTitle("Mine Sweeper")


    mineGameHandler = MineGameHandler:new(mineAtlas, 30, 16, 99)
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
    mineGameHandler:draw()
    if PROFILER then
        love.graphics.print(love.report or "Please wait...")
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    mineGameHandler:mouseMoved(x, y)
    mineGameHandler:makeCanvas()
end

function love.mousepressed(x, y, button, istouch)
    
end

function love.mousereleased(x, y, button, istouch)
    if button == 1 then
        mineGameHandler:leftClicked(x, y)
    elseif button == 2 then
        mineGameHandler:rightClicked(x, y)
    end 
    mineGameHandler:makeCanvas()
end

function love.quit()
    print("Bye...")
end