require "object/mine_block"
require "object/mine_board"

mouseLocation = {x = 0, y = 0}

function love.load()
    love.graphics.setColor(255, 255, 255)
    love.window.setMode(1024, 900, {resizable=false, vsync=false, minwidth=400, minheight=300})
    local atlas = {
        block_image = assert(love.graphics.newImage("resource/mine_block.png")),
        board_image = assert(love.graphics.newImage("resource/mine_board.png")),
        num0_image = assert(love.graphics.newImage("resource/mine_num0.png")),
        num1_image = assert(love.graphics.newImage("resource/mine_num1.png")),
        num2_image = assert(love.graphics.newImage("resource/mine_num2.png")),
        num3_image = assert(love.graphics.newImage("resource/mine_num3.png")),
        num4_image = assert(love.graphics.newImage("resource/mine_num4.png")),
        num5_image = assert(love.graphics.newImage("resource/mine_num5.png")),
        num6_image = assert(love.graphics.newImage("resource/mine_num6.png")),
        num7_image = assert(love.graphics.newImage("resource/mine_num7.png")),
        num8_image = assert(love.graphics.newImage("resource/mine_num8.png")),
        flag_image = assert(love.graphics.newImage("resource/mine_flag.png")),
        mine_image = assert(love.graphics.newImage("resource/mine_mine.png")),
    }
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255, 255, 255)
    blockAtlas = {image = atlas.block_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.block_image)}
    boardAtlas = {image = atlas.board_image, quad = love.graphics.newQuad(0, 0, 1024, 700, atlas.board_image)}
    cellAtlas = {
        [MineEnum.MINE] = {image = atlas.mine_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.mine_image)},
        [MineEnum.EMPTY] = {image = atlas.num0_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num0_image)},
        [MineEnum.ONE] = {image = atlas.num1_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num1_image)},
        [MineEnum.TWO] = {image = atlas.num2_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num2_image)},
        [MineEnum.THREE] = {image = atlas.num3_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num3_image)},
        [MineEnum.FOUR] = {image = atlas.num4_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num4_image)},
        [MineEnum.FIVE] = {image = atlas.num5_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num5_image)},
        [MineEnum.SIX] = {image = atlas.num6_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num6_image)},
        [MineEnum.SEVEN] = {image = atlas.num7_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num7_image)},
        [MineEnum.EIGHT] = {image = atlas.num8_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.num8_image)},
    }
    
    board = Board:new(0, 0, 1024, 700, boardAtlas)
    field = Field:new(20, 20, 80)
    board:setBlockMatrix(field, cellAtlas, blockAtlas, 32, 32)
end

function love.draw()
    board:draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    mouseLocation.x = x
    mouseLocation.y = y
    if x >= board.center.x - (board.field.xCount * 32) / 2 and x <= board.center.x + (board.field.xCount * 32) / 2 - 1
    and y >= board.center.y - (board.field.yCount * 32) / 2 and y <= board.center.y + (board.field.yCount * 32) / 2 - 1 then
        local i = math.floor((x - (board.center.x - (board.field.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (board.center.y - (board.field.yCount * 32) / 2)) / 32) + 1
        board.blockMatrix[i][j]:toggle()
        
        -- untoggle other blocks
        for ii=1, board.field.xCount do
            for jj=1, board.field.yCount do
                if ii ~= i or jj ~= j then
                    board.blockMatrix[ii][jj]:untoggle()
                end
            end
        end
    else
        for i=1, board.field.xCount do
            for j=1, board.field.yCount do
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