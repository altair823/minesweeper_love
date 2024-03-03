require "object/mine_block"
require "object/mine_board"

require "resource_enum"

mouseLocation = {x = 0, y = 0}

function love.load()
    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    love.window.setTitle("Mine Sweeper")


    board = Board:new(0, 0, 1024, 700, boardAtlas)
    field = Field:new(20, 20, 80)
    board:setBlockMatrix(field, cellAtlas, blockAtlas, 32, 32)
end

function love.draw()
    board:draw()
end

prevLoc = {i = 0, j = 0}

function love.mousemoved(x, y, dx, dy, istouch)
    mouseLocation.x = x
    mouseLocation.y = y
    if x >= board.center.x - (board.field.xCount * 32) / 2 and x <= board.center.x + (board.field.xCount * 32) / 2 - 1
    and y >= board.center.y - (board.field.yCount * 32) / 2 and y <= board.center.y + (board.field.yCount * 32) / 2 - 1 then
        local i = math.floor((x - (board.center.x - (board.field.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (board.center.y - (board.field.yCount * 32) / 2)) / 32) + 1
        if prevLoc.i ~= i or prevLoc.j ~= j then
            if prevLoc.i ~= 0 and prevLoc.j ~= 0 then
                board.blockMatrix[prevLoc.i][prevLoc.j]:untoggle()
            end
            board.blockMatrix[i][j]:toggle()
            prevLoc.i = i
            prevLoc.j = j
        end
    else
        if prevLoc.i ~= 0 and prevLoc.j ~= 0 then
            board.blockMatrix[prevLoc.i][prevLoc.j]:untoggle()
            prevLoc.i = 0
            prevLoc.j = 0
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    -- check if mouse is pressed block
    
end

function love.mousereleased(x, y, button, istouch)
    -- check if mouse is released block
    if x >= board.center.x - (board.field.xCount * 32) / 2 and x <= board.center.x + (board.field.xCount * 32) / 2
    and y >= board.center.y - (board.field.yCount * 32) / 2 and y <= board.center.y + (board.field.yCount * 32) / 2 then
        local i = math.floor((x - (board.center.x - (board.field.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (board.center.y - (board.field.yCount * 32) / 2)) / 32) + 1
        board.blockMatrix[i][j]:release()
    end
    
end

function love.quit()
    print("Bye...")
end