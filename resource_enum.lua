local cwd = love.filesystem.getWorkingDirectory( )
if love.filesystem.getInfo("original_resources") and not USE_ATLAS then
    MineImages = {
        blockImage = love.graphics.newImage("original_resources/mine_block_40.png"),
        boardImage = love.graphics.newImage("original_resources/mine_background_alpha.png"),
        num0Image = love.graphics.newImage("original_resources/mine_num0_40.png"),
        num1Image = love.graphics.newImage("original_resources/mine_num1_40.png"),
        num2Image = love.graphics.newImage("original_resources/mine_num2_40.png"),
        num3Image = love.graphics.newImage("original_resources/mine_num3_40.png"),
        num4Image = love.graphics.newImage("original_resources/mine_num4_40.png"),
        num5Image = love.graphics.newImage("original_resources/mine_num5_40.png"),
        num6Image = love.graphics.newImage("original_resources/mine_num6_40.png"),
        num7Image = love.graphics.newImage("original_resources/mine_num7_40.png"),
        num8Image = love.graphics.newImage("original_resources/mine_num8_40.png"),
        flagImage = love.graphics.newImage("original_resources/mine_flag_40.png"),
        mineImage = love.graphics.newImage("original_resources/mine_mine_40.png"),
        mineCellWidth = 40,
        mineCellHeight = 40,

        restartImage = love.graphics.newImage("original_resources/mine_restart.png"),
        gameoverToggledImage = love.graphics.newImage("original_resources/mine_gameover_toggled.png"),
        gameoverUntoggledImage = love.graphics.newImage("original_resources/mine_gameover_untoggled.png"),
        winToggleImage = love.graphics.newImage("original_resources/mine_win_toggled.png"),
        winUntoggleImage = love.graphics.newImage("original_resources/mine_win_untoggled.png"),

        remainingMineWindowImage = love.graphics.newImage("original_resources/mine_remaining_mine_window.png"),
    }
    MineAtlas = {
        blockAtlas = {
            [BlockEnum.DEFAULT] = {image = MineImages.blockImage, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.blockImage)},
            [BlockEnum.FLAG] = {image = MineImages.flagImage, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.flagImage)},
        }, 
        boardAtlas = {image = MineImages.boardImage, quad = love.graphics.newQuad(0, 0, 1600, 900, MineImages.boardImage)}, 
        cellAtlas = {
            [MineEnum.MINE] = {image = MineImages.mineImage, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.mineImage)},
            [MineEnum.EMPTY] = {image = MineImages.num0Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num0Image)},
            [MineEnum.ONE] = {image = MineImages.num1Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num1Image)},
            [MineEnum.TWO] = {image = MineImages.num2Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num2Image)},
            [MineEnum.THREE] = {image = MineImages.num3Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num3Image)},
            [MineEnum.FOUR] = {image = MineImages.num4Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num4Image)},
            [MineEnum.FIVE] = {image = MineImages.num5Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num5Image)},
            [MineEnum.SIX] = {image = MineImages.num6Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num6Image)},
            [MineEnum.SEVEN] = {image = MineImages.num7Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num7Image)},
            [MineEnum.EIGHT] = {image = MineImages.num8Image, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num8Image)},
        },
        buttonAtlas = {
            [MineGameButtonEnum.RESTART] = {image = MineImages.restartImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.restartImage)},
        }, 
        indicatorAtlas = {
            gameover = {image = MineImages.gameoverToggledImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.gameoverToggledImage)},
            notGameover = {image = MineImages.gameoverUntoggledImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.gameoverUntoggledImage)},
            win = {image = MineImages.winToggleImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.winToggleImage)},
            notWin = {image = MineImages.winUntoggleImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.winUntoggleImage)},
        }, 
        uiAtlas = {
            remainingMineWindow = {image = MineImages.remainingMineWindowImage, quad = love.graphics.newQuad(0, 0, 200, 157, MineImages.remainingMineWindowImage)},
        }
    }
else
    MineImages = {
        blockImage = love.graphics.newImage("resources/mineAtlas.png"),
        boardImage = love.graphics.newImage("resources/mine_board.png"),
        num0Image = love.graphics.newImage("resources/mineAtlas.png"),
        num1Image = love.graphics.newImage("resources/mineAtlas.png"),
        num2Image = love.graphics.newImage("resources/mineAtlas.png"),
        num3Image = love.graphics.newImage("resources/mineAtlas.png"),
        num4Image = love.graphics.newImage("resources/mineAtlas.png"),
        num5Image = love.graphics.newImage("resources/mineAtlas.png"),
        num6Image = love.graphics.newImage("resources/mineAtlas.png"),
        num7Image = love.graphics.newImage("resources/mineAtlas.png"),
        num8Image = love.graphics.newImage("resources/mineAtlas.png"),
        flagImage = love.graphics.newImage("resources/mineAtlas.png"),
        mineImage = love.graphics.newImage("resources/mineAtlas.png"),
        mineCellWidth = 40,
        mineCellHeight = 40,

        restartImage = love.graphics.newImage("resources/mine_restart.png"),
        gameoverToggledImage = love.graphics.newImage("resources/mine_gameover_toggled.png"),
        gameoverUntoggledImage = love.graphics.newImage("resources/mine_gameover_untoggled.png"),
        winToggleImage = love.graphics.newImage("resources/mine_win_toggled.png"),
        winUntoggleImage = love.graphics.newImage("resources/mine_win_untoggled.png"),
    }
    MineAtlas = {
        blockAtlas = {
            [BlockEnum.DEFAULT] = {image = MineImages.blockImage, quad = love.graphics.newQuad(0, 0, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.blockImage)},
            [BlockEnum.FLAG] = {image = MineImages.flagImage, quad = love.graphics.newQuad(0, 40, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.flagImage)},
        }, 
        boardAtlas = {image = MineImages.boardImage, quad = love.graphics.newQuad(0, 0, 1600, 900, MineImages.boardImage)}, 
        cellAtlas = {
            [MineEnum.MINE] = {image = MineImages.mineImage, quad = love.graphics.newQuad(0, 80, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.mineImage)},
            [MineEnum.EMPTY] = {image = MineImages.num0Image, quad = love.graphics.newQuad(0, 120, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num0Image)},
            [MineEnum.ONE] = {image = MineImages.num1Image, quad = love.graphics.newQuad(0, 160, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num1Image)},
            [MineEnum.TWO] = {image = MineImages.num2Image, quad = love.graphics.newQuad(0, 200, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num2Image)},
            [MineEnum.THREE] = {image = MineImages.num3Image, quad = love.graphics.newQuad(0, 240, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num3Image)},
            [MineEnum.FOUR] = {image = MineImages.num4Image, quad = love.graphics.newQuad(0, 280, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num4Image)},
            [MineEnum.FIVE] = {image = MineImages.num5Image, quad = love.graphics.newQuad(0, 320, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num5Image)},
            [MineEnum.SIX] = {image = MineImages.num6Image, quad = love.graphics.newQuad(0, 360, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num6Image)},
            [MineEnum.SEVEN] = {image = MineImages.num7Image, quad = love.graphics.newQuad(0, 400, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num7Image)},
            [MineEnum.EIGHT] = {image = MineImages.num8Image, quad = love.graphics.newQuad(0, 440, MineImages.mineCellWidth, MineImages.mineCellHeight, MineImages.num8Image)},
        },
        buttonAtlas = {
            [MineGameButtonEnum.RESTART] = {image = MineImages.restartImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.restartImage)},
        },
        indicatorAtlas = {
            gameover = {image = MineImages.gameoverToggledImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.gameoverToggledImage)},
            notGameover = {image = MineImages.gameoverUntoggledImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.gameoverUntoggledImage)},
            win = {image = MineImages.winToggleImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.winToggleImage)},
            notWin = {image = MineImages.winUntoggleImage, quad = love.graphics.newQuad(0, 0, 64, 64, MineImages.winUntoggleImage)},
        }
    }
end
