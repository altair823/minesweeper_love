local mineImages = {
    blockImage = love.graphics.newImage("resource/mine_cell.png"),
    boardImage = love.graphics.newImage("resource/mine_board.png"),
    num0Image = love.graphics.newImage("resource/mine_cell.png"),
    num1Image = love.graphics.newImage("original_resource/mine_num1_blue.png"),
    num2Image = love.graphics.newImage("original_resource/mine_num2_green.png"),
    num3Image = love.graphics.newImage("original_resource/mine_num3_red.png"),
    num4Image = love.graphics.newImage("original_resource/mine_num4_purple.png"),
    num5Image = love.graphics.newImage("original_resource/mine_num5_brown.png"),
    num6Image = love.graphics.newImage("original_resource/mine_num6_cyan.png"),
    num7Image = love.graphics.newImage("original_resource/mine_num7_black.png"),
    num8Image = love.graphics.newImage("original_resource/mine_num8_gray.png"),
    flagImage = love.graphics.newImage("resource/mine_cell.png"),
    mineImage = love.graphics.newImage("resource/mine_cell.png"),

    restartImage = love.graphics.newImage("original_resource/mine_restart.png"),
    gameoverToggledImage = love.graphics.newImage("original_resource/mine_gameover_toggled.png"),
    gameoverUntoggledImage = love.graphics.newImage("original_resource/mine_gameover_untoggled.png"),
    winToggleImage = love.graphics.newImage("original_resource/mine_win_toggled.png"),
    winUntoggleImage = love.graphics.newImage("original_resource/mine_win_untoggled.png"),
}
mineAtlas = {
    blockAtlas = {
        [BlockEnum.DEFAULT] = {image = mineImages.blockImage, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.blockImage)},
        [BlockEnum.FLAG] = {image = mineImages.flagImage, quad = love.graphics.newQuad(64, 0, 32, 32, mineImages.flagImage)},
    }, 
    boardAtlas = {image = mineImages.boardImage, quad = love.graphics.newQuad(0, 0, 1024, 700, mineImages.boardImage)}, 
    cellAtlas = {
        [MineEnum.MINE] = {image = mineImages.mineImage, quad = love.graphics.newQuad(96, 0, 32, 32, mineImages.mineImage)},
        [MineEnum.EMPTY] = {image = mineImages.num0Image, quad = love.graphics.newQuad(128, 0, 32, 32, mineImages.num0Image)},
        [MineEnum.ONE] = {image = mineImages.num1Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num1Image)},
        [MineEnum.TWO] = {image = mineImages.num2Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num2Image)},
        [MineEnum.THREE] = {image = mineImages.num3Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num3Image)},
        [MineEnum.FOUR] = {image = mineImages.num4Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num4Image)},
        [MineEnum.FIVE] = {image = mineImages.num5Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num5Image)},
        [MineEnum.SIX] = {image = mineImages.num6Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num6Image)},
        [MineEnum.SEVEN] = {image = mineImages.num7Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num7Image)},
        [MineEnum.EIGHT] = {image = mineImages.num8Image, quad = love.graphics.newQuad(0, 0, 32, 32, mineImages.num8Image)},
    },
    buttonAtlas = {
        [MineGameButtonEnum.RESTART] = {image = mineImages.restartImage, quad = love.graphics.newQuad(0, 0, 64, 64, mineImages.restartImage)},
    }, 
    indicatorAtlas = {
        gameover = {image = mineImages.gameoverToggledImage, quad = love.graphics.newQuad(0, 0, 64, 64, mineImages.gameoverToggledImage)},
        notGameover = {image = mineImages.gameoverUntoggledImage, quad = love.graphics.newQuad(0, 0, 64, 64, mineImages.gameoverUntoggledImage)},
        win = {image = mineImages.winToggleImage, quad = love.graphics.newQuad(0, 0, 64, 64, mineImages.winToggleImage)},
        notWin = {image = mineImages.winUntoggleImage, quad = love.graphics.newQuad(0, 0, 64, 64, mineImages.winUntoggleImage)},
    }
}