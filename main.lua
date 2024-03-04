require "object/mine_block"
require "object/mine_board"

require "resource_enum"

mouseLocation = {x = 0, y = 0}

function love.load()
    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    love.window.setTitle("Mine Sweeper")


    board = MineBoard:new(0, 0, 1024, 700, boardAtlas)
    field = Field:new(20, 20, 80)
    board:setBlockMatrix(field, cellAtlas, blockAtlas, 32, 32)
end

function love.draw()
    board:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    board:mouseMoved(x, y)
end

function love.mousepressed(x, y, button, istouch)
    
end

function love.mousereleased(x, y, button, istouch)
    board:mouseReleased(x, y, button)    
end

function love.quit()
    print("Bye...")
end