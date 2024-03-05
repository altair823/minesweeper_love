require "game/mine_game_handler"

require "resource_enum"

mouseLocation = {x = 0, y = 0}

function love.load()
    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    love.window.setTitle("Mine Sweeper")


    MineGameHandler = MineGameHandler:new(mineAtlas)

end

function love.draw()
    MineGameHandler:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    MineGameHandler:mouseMoved(x, y)
end

function love.mousepressed(x, y, button, istouch)
    
end

function love.mousereleased(x, y, button, istouch)
    MineGameHandler:mouseReleased(x, y, button)    
end

function love.quit()
    print("Bye...")
end