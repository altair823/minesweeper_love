require("common/object")
require("object/mine_board")
require("common/clickable_table")

MineGameButtonEnum = {
    RESTART = 1
}

MineGameHandler = Object:inherit()

function MineGameHandler:new(mineAtlas, width, height, mineCount)
    local handler = {}
    setmetatable(handler, self)
    self.__index = self
    handler.mineAtlas = mineAtlas
    handler.mineField = MineField:new(width, height, mineCount)
    handler.mineBoard = MineBoard:new(0, 0, 1024, 700, mineAtlas.boardAtlas)
    handler.mineBoard:setBlockMatrix(handler.mineField, mineAtlas.cellAtlas, mineAtlas.blockAtlas, 32, 32)
    handler.isGameOver = false
    handler.buttonClickTable = ClickableTable:new()
    handler.restartButton = Sprite:new(
        math.floor(handler.mineBoard.width / 8) - 32, 
        handler.mineBoard.center.y - 32, 
        64, 64, 
        mineAtlas.buttonAtlas[MineGameButtonEnum.RESTART])
    handler.buttonClickTable:registerClick(ClickTypeEnum.LEFT, handler.restartButton)
    handler.restartButton.leftClicked = function()
        print("Restarting")
        handler:restart()
    end
    handler.gameoverIndicator = Sprite:new(
        math.floor(handler.mineBoard.width / 8) - 32, 
        handler.mineBoard.center.y - 128, 
        64, 64, 
        mineAtlas.indicatorAtlas.notGameover)
    return handler
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
    self.mineBoard = MineBoard:new(0, 0, 1024, 700, self.mineAtlas.boardAtlas)
    self.mineBoard:setBlockMatrix(self.mineField, self.mineAtlas.cellAtlas, self.mineAtlas.blockAtlas, 32, 32)
    self.isGameOver = false
    self.isWin = false
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notGameover)
    self.mineBoard:activate()
end

function MineGameHandler:gameover()
    self.isGameOver = true
    print("Game Over")
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.gameover)
    self.mineBoard:deactivate()
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
        self.mineBoard:deactivate()
    end
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
end

function MineGameHandler:leftClicked(x, y)
    self.buttonClickTable:leftClicked(x, y)
    self.mineBoard.clickableTable:leftClicked(x, y)
    self:blockOpenEvent()
    self:checkWin()
end

function MineGameHandler:rightClicked(x, y)
    self.mineBoard.clickableTable:rightClicked(x, y)
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

