require "common/conf"

require "game/mine_game_handler"

require "resource_enum"

mouseLocation = {x = 0, y = 0}

function love.load()
    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    love.window.setTitle("Mine Sweeper")


    mineGameHandler = MineGameHandler:new(mineAtlas, 10, 10, 5)
    mineGameHandler:makeCanvas()

end

function love.draw()
    mineGameHandler:draw()
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