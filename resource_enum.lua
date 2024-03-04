atlas = {
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
blockAtlas = {
    [BlockEnum.DEFAULT] = {image = atlas.block_image, quad = love.graphics.newQuad(0, 0, 32, 32, atlas.block_image)},
    [BlockEnum.FLAG] = {image = atlas.flag_image, quad = love.graphics.newQuad(64, 0, 32, 32, atlas.flag_image)},
}
boardAtlas = {image = atlas.board_image, quad = love.graphics.newQuad(0, 0, 1024, 700, atlas.board_image)}
cellAtlas = {
    [MineEnum.MINE] = {image = atlas.mine_image, quad = love.graphics.newQuad(96, 0, 32, 32, atlas.mine_image)},
    [MineEnum.EMPTY] = {image = atlas.num0_image, quad = love.graphics.newQuad(128, 0, 32, 32, atlas.num0_image)},
    [MineEnum.ONE] = {image = atlas.num1_image, quad = love.graphics.newQuad(160, 0, 32, 32, atlas.num1_image)},
    [MineEnum.TWO] = {image = atlas.num2_image, quad = love.graphics.newQuad(192, 0, 32, 32, atlas.num2_image)},
    [MineEnum.THREE] = {image = atlas.num3_image, quad = love.graphics.newQuad(224, 0, 32, 32, atlas.num3_image)},
    [MineEnum.FOUR] = {image = atlas.num4_image, quad = love.graphics.newQuad(256, 0, 32, 32, atlas.num4_image)},
    [MineEnum.FIVE] = {image = atlas.num5_image, quad = love.graphics.newQuad(288, 0, 32, 32, atlas.num5_image)},
    [MineEnum.SIX] = {image = atlas.num6_image, quad = love.graphics.newQuad(320, 0, 32, 32, atlas.num6_image)},
    [MineEnum.SEVEN] = {image = atlas.num7_image, quad = love.graphics.newQuad(352, 0, 32, 32, atlas.num7_image)},
    [MineEnum.EIGHT] = {image = atlas.num8_image, quad = love.graphics.newQuad(384, 0, 32, 32, atlas.num8_image)},
}