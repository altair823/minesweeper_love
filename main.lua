require "sprite/block"
require "sprite/board"

mouseLocation = {x = 0, y = 0}

function love.load()
    love.graphics.setColor(255, 255, 255)
    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    atlas = {
        block_image = assert(love.graphics.newImage("resource/mine_block.png")),
        board_image = assert(love.graphics.newImage("resource/mine_board.png")),
    }
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255, 255, 255)
    block_atlas = {image = atlas.block_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.block_image)}
    board_atlas = {image = atlas.board_image, quad = love.graphics.newQuad(0, 0, 1024, 700, atlas.board_image)}
    
    board = Board:new(0, 0, 1024, 700, board_atlas)
    board:setBlockMatrix(17, 15, block_atlas, 32, 32)
end

function love.draw()
    board:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    mouseLocation.x = x
    mouseLocation.y = y
    if x >= board.center.x - (board.xCount * 32) / 2 and x <= board.center.x + (board.xCount * 32) / 2 - 1
    and y >= board.center.y - (board.yCount * 32) / 2 and y <= board.center.y + (board.yCount * 32) / 2 - 1 then
        local i = math.floor((x - (board.center.x - (board.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (board.center.y - (board.yCount * 32) / 2)) / 32) + 1
        print("x: " .. x .. ", y: " .. y)
        print("Block (" .. i .. ", " .. j .. ")")
        board.blockMatrix[i][j]:toggle()
        
        -- untoggle other blocks
        for ii=1, board.xCount do
            for jj=1, board.yCount do
                if ii ~= i or jj ~= j then
                    board.blockMatrix[ii][jj]:untoggle()
                end
            end
        end
    else
        for i=1, board.xCount do
            for j=1, board.yCount do
                board.blockMatrix[i][j]:untoggle()
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    -- check if mouse is pressed block
    
end

function love.mousereleased(x, y, button, istouch)
    -- check if mouse is released block
    if x >= board.center.x - (board.xCount * 32) / 2 and x <= board.center.x + (board.xCount * 32) / 2
    and y >= board.center.y - (board.yCount * 32) / 2 and y <= board.center.y + (board.yCount * 32) / 2 then
        local i = math.floor((x - (board.center.x - (board.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (board.center.y - (board.yCount * 32) / 2)) / 32) + 1
        board.blockMatrix[i][j]:release()
    end
    
end

function love.quit()
    print("Bye...")
end