local mineImages = {
    block_image = love.graphics.newImage("resource/mine_cell.png"),
    board_image = love.graphics.newImage("resource/mine_board.png"),
    num0_image = love.graphics.newImage("resource/mine_cell.png"),
    num1_image = love.graphics.newImage("resource/mine_cell.png"),
    num2_image = love.graphics.newImage("resource/mine_cell.png"),
    num3_image = love.graphics.newImage("resource/mine_cell.png"),
    num4_image = love.graphics.newImage("resource/mine_cell.png"),
    num5_image = love.graphics.newImage("resource/mine_cell.png"),
    num6_image = love.graphics.newImage("resource/mine_cell.png"),
    num7_image = love.graphics.newImage("resource/mine_cell.png"),
    num8_image = love.graphics.newImage("resource/mine_cell.png"),
    flag_image = love.graphics.newImage("resource/mine_cell.png"),
    mine_image = love.graphics.newImage("resource/mine_cell.png"),
}
mineAtlas = {
    blockAtlas = {
        [BlockEnum.DEFAULT] = {image = mineImages.block_image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.block_image)},
        [BlockEnum.FLAG] = {image = mineImages.flag_image, quad = love.graphics.newQuad(64, 0, 32, 32, mineImages.flag_image)},
    }, 
    boardAtlas = {image = mineImages.board_image, quad = love.graphics.newQuad(0, 0, 1024, 700, mineImages.board_image)}, 
    cellAtlas = {
        [MineEnum.MINE] = {image = mineImages.mine_image, quad = love.graphics.newQuad(96, 0, 32, 32, mineImages.mine_image)},
        [MineEnum.EMPTY] = {image = mineImages.num0_image, quad = love.graphics.newQuad(128, 0, 32, 32, mineImages.num0_image)},
        [MineEnum.ONE] = {image = mineImages.num1_image, quad = love.graphics.newQuad(160, 0, 32, 32, mineImages.num1_image)},
        [MineEnum.TWO] = {image = mineImages.num2_image, quad = love.graphics.newQuad(192, 0, 32, 32, mineImages.num2_image)},
        [MineEnum.THREE] = {image = mineImages.num3_image, quad = love.graphics.newQuad(224, 0, 32, 32, mineImages.num3_image)},
        [MineEnum.FOUR] = {image = mineImages.num4_image, quad = love.graphics.newQuad(256, 0, 32, 32, mineImages.num4_image)},
        [MineEnum.FIVE] = {image = mineImages.num5_image, quad = love.graphics.newQuad(288, 0, 32, 32, mineImages.num5_image)},
        [MineEnum.SIX] = {image = mineImages.num6_image, quad = love.graphics.newQuad(320, 0, 32, 32, mineImages.num6_image)},
        [MineEnum.SEVEN] = {image = mineImages.num7_image, quad = love.graphics.newQuad(352, 0, 32, 32, mineImages.num7_image)},
        [MineEnum.EIGHT] = {image = mineImages.num8_image, quad = love.graphics.newQuad(384, 0, 32, 32, mineImages.num8_image)},
    }
}