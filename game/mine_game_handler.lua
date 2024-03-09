require("common/object")
require("object/mine_board")
require("common/clickable_table")
require("common/sprite_table")


MineGameButtonEnum = {
    RESTART = 1
}

MineGameHandler = Object:inherit()

function MineGameHandler:new(mineAtlas, width, height, mineCount)
    local handler = {}
    setmetatable(handler, self)
    self.__index = self
    handler.mineAtlas = mineAtlas
    handler.mineGameSpriteTable = SpriteTable:new()
    handler.mineField = MineField:new(width, height, mineCount)
    handler.mineBoard = MineBoard:new(
        -math.floor(DefaultWindowSize.width / 2), 
        -math.floor(DefaultWindowSize.height / 2), 
        DefaultWindowSize.width, 
        DefaultWindowSize.height, 
        mineAtlas.boardAtlas, 
        handler.mineGameSpriteTable)
    handler.mineBoard:setBlockMatrix(handler.mineField, mineAtlas.cellAtlas, mineAtlas.blockAtlas, MineImages.mineCellWidth, MineImages.mineCellHeight)
    handler.isGameOver = false
    handler.buttonClickTable = ClickableTable:new()
    handler:makeButtons()
    handler.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "NumberFont", 64)
    handler.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "TextFont", 28)
    return handler
end

function MineGameHandler:print()
    local remainingMine = self.mineField.mineCount - self:countFlaggedCell()
    love.graphics.setFont(self.mineGameSpriteTable:getFont("TextFont"))
    love.graphics.print("찾지 못한 지뢰", -790 * self.mineBoard.scale.x, -280 * self.mineBoard.scale.y)
    love.graphics.setFont(self.mineGameSpriteTable:getFont("NumberFont"))
    love.graphics.print(remainingMine, -730 * self.mineBoard.scale.x, -240 * self.mineBoard.scale.y)
end

function MineGameHandler:initTexts()
    self.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "NumberFont", 64)
    self.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "TextFont", 28)
end

function MineGameHandler:makeButtons()
    self.restartButton = Sprite:new(
        self.mineBoard.center.x - (32 * self.mineBoard.scale.x), 
        -self.mineBoard.height / 2 + (16 * self.mineBoard.scale.y),
        64, 64, 
        MineAtlas.buttonAtlas[MineGameButtonEnum.RESTART],
        self.mineGameSpriteTable,
        "restartButton")
    self.buttonClickTable:registerClick(ClickTypeEnum.LEFT, self.restartButton)
    self.restartButton.leftClicked = function()
        print("Restarting")
        self:restart()
    end
    self.gameoverIndicator = Sprite:new(
        self.mineBoard.center.x - (128 * self.mineBoard.scale.x), 
        -self.mineBoard.height / 2 + (16 * self.mineBoard.scale.y),
        64, 64, 
        MineAtlas.indicatorAtlas.notGameover,
        self.mineGameSpriteTable, 
        "gameoverIndicator")
    self.winIndicator = Sprite:new(
        self.mineBoard.center.x + (64 * self.mineBoard.scale.x), 
        -self.mineBoard.height / 2 + (16 * self.mineBoard.scale.y),
        64, 64, 
        MineAtlas.indicatorAtlas.notWin,
        self.mineGameSpriteTable,
        "winIndicator")
end

function MineGameHandler:initButtons()
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notGameover)
    self.winIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notWin)
    self.mineGameSpriteTable:addSprite(self.gameoverIndicator, "gameoverIndicator")
    self.mineGameSpriteTable:addSprite(self.winIndicator, "winIndicator")
    self.mineGameSpriteTable:addSprite(self.restartButton, "restartButton")
end

function MineGameHandler:isInputBlocked()
    return self.isGameOver or self.isWin
end

function MineGameHandler:isMineCellReveal()
    for i=1, #self.mineField.mineLocation do
        if not self.mineBoard.blockMatrix[self.mineField.mineLocation[i].x][self.mineField.mineLocation[i].y].isShown then
            return true
        end
    end
    return false
end

function MineGameHandler:restart()
    local width = self.mineField.xCount
    local height = self.mineField.yCount
    local mineCount = self.mineField.mineCount
    self.mineField = MineField:new(width, height, mineCount)
    self.mineGameSpriteTable = SpriteTable:new()
    self.mineBoard = MineBoard:new(
        -math.floor(DefaultWindowSize.width / 2), 
        -math.floor(DefaultWindowSize.height / 2), 
        DefaultWindowSize.width, 
        DefaultWindowSize.height, 
        self.mineAtlas.boardAtlas, 
        self.mineGameSpriteTable)
    self.mineBoard:setBlockMatrix(self.mineField, self.mineAtlas.cellAtlas, self.mineAtlas.blockAtlas, MineImages.mineCellWidth, MineImages.mineCellHeight)
    self.isGameOver = false
    self.isWin = false
    self:initButtons()
    self:initTexts()
    self.mineGameSpriteTable:resizeAllSprite(love.graphics.getWidth(), love.graphics.getHeight())
    self.mineBoard:activate()
end

function MineGameHandler:gameover()
    self.isGameOver = true
    print("Game Over")
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.gameover)
    self.mineBoard:deactivate()
    for i=1, #self.mineField.mineLocation do
        self.mineBoard.blockMatrix[self.mineField.mineLocation[i].x][self.mineField.mineLocation[i].y]:changeAtlas(MineImages.mineCellWidth, MineImages.mineCellHeight, self.mineAtlas.cellAtlas[MineEnum.MINE])
    end
end

function MineGameHandler:checkWin()
    local count = 0
    for i=1, #self.mineBoard.blockMatrix do
        for j=1, #self.mineBoard.blockMatrix[i] do
            if self.mineBoard.blockMatrix[i][j].isShown then
                count = count + 1
            end
        end
    end
    if count == self.mineField.mineCount then
        print("You Win!")
        self.isWin = true
        self.winIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.win)
        self.mineBoard:deactivate()
    end
end

function MineGameHandler:countFlaggedCell()
    local count = 0
    for k, v in pairs(self.mineBoard.flaggedCells) do
        if v then
            count = count + 1
        end
    end
    return count
    
end


function MineGameHandler:makeCanvas()
    -- self.canvas = love.graphics.newCanvas(1024, 700)
    -- love.graphics.setCanvas(self.canvas)
    -- love.graphics.setCanvas()
end

function MineGameHandler:draw()
    -- love.graphics.draw(self.canvas, 0, 0)
    
    self.mineBoard:draw()
    self.restartButton:draw()
    self.gameoverIndicator:draw()
    self.winIndicator:draw()
    self:print()
end

function MineGameHandler:leftClicked(x, y)
    self.buttonClickTable:leftClicked(x, y)
    self.mineBoard.clickableTable:leftClicked(x, y)
    self:blockOpenEvent()
    self:checkWin()
end

function MineGameHandler:rightClicked(x, y)
    self.mineBoard.clickableTable:rightClicked(x, y)
    self:blockOpenEvent()
end

function MineGameHandler:mouseMoved(x, y)
    if self:isInputBlocked() then
        return
    end
    self.mineBoard:mouseMoved(x, y)
end

function MineGameHandler:blockOpenEvent()
    if #self.mineBoard.openedCells == 0 then
        return
    end
    if not self.isGameOver and self:isMineCellReveal() then
        self:gameover()
    else
        local i = self.mineBoard.openedCells[#self.mineBoard.openedCells].i
        local j = self.mineBoard.openedCells[#self.mineBoard.openedCells].j
        if self.mineField:getValue(i, j) ~= MineEnum.MINE then
            self.mineBoard:openAdjacentOfEmpty(i, j)
        end
    end
end

