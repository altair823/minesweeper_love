require("common/object")
require("object/mine_board")
require("common/clickable_table")

MineGameButtonEnum = {
    RESTART = 1
}

mineGameHandler = Object:inherit()

function mineGameHandler:new(mineAtlas)
    local handler = {}
    setmetatable(handler, self)
    self.__index = self
    handler.mineAtlas = mineAtlas
    handler.mineField = MineField:new(20, 20, 80)
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

function mineGameHandler:isInputBlocked()
    return self.isGameOver
end

function mineGameHandler:isMineCellReveal()
    for i=1, #self.mineField.mineLocation do
        if not self.mineBoard.blockMatrix[self.mineField.mineLocation[i].x][self.mineField.mineLocation[i].y].isShown then
            return true
        end
    end
    return false
end

function mineGameHandler:restart()
    self.mineField = MineField:new(20, 20, 80)
    self.mineBoard = MineBoard:new(0, 0, 1024, 700, self.mineAtlas.boardAtlas)
    self.mineBoard:setBlockMatrix(self.mineField, self.mineAtlas.cellAtlas, self.mineAtlas.blockAtlas, 32, 32)
    self.isGameOver = false
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notGameover)
    self.mineBoard:activate()
end

function mineGameHandler:makeCanvas()
    self.canvas = love.graphics.newCanvas(1024, 700)
    love.graphics.setCanvas(self.canvas)
    self.mineBoard:draw()
    self.restartButton:draw()
    self.gameoverIndicator:draw()
    love.graphics.setCanvas()
end

function mineGameHandler:draw()
    love.graphics.draw(self.canvas, 0, 0)
end

function mineGameHandler:leftClicked(x, y)
    self.buttonClickTable:leftClicked(x, y)
    self.mineBoard.clickableTable:leftClicked(x, y)
    self:blockOpenEvent()
end

function mineGameHandler:rightClicked(x, y)
    self.mineBoard.clickableTable:rightClicked(x, y)
end

function mineGameHandler:mouseMoved(x, y)
    if self:isInputBlocked() then
        return
    end
    self.mineBoard:mouseMoved(x, y)
end

function mineGameHandler:blockOpenEvent()
    if #self.mineBoard.openedCells == 0 then
        return
    end
    if not self.isGameOver and self:isMineCellReveal() then
        self.isGameOver = true
        print("Game Over")
        self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.gameover)
        self.mineBoard:deactivate()
    else
        i = self.mineBoard.openedCells[#self.mineBoard.openedCells].i
        j = self.mineBoard.openedCells[#self.mineBoard.openedCells].j
        if self.mineField:getMineMatrixValue(i, j) == 0 then
            self:openAdjacent(i, j)
        end
    end
end

function mineGameHandler:openAdjacent(x, y)
    local adjacents = {
        {0, 1},
        {0, -1},
        {1, 0},
        {-1, 0},
        {1, 1},
        {1, -1},
        {-1, 1},
        {-1, -1}
    }
    for i=1, #adjacents do
        local newX = x + adjacents[i][1]
        local newY = y + adjacents[i][2]
        -- Open the adjacent cell if it is not a mine and not opened
        -- If it is a empty cell, call this function recursively
        if newX >= 1 and newX <= self.mineField.xCount and newY >= 1 and newY <= self.mineField.yCount then
            if self.mineField:getMineMatrixValue(newX, newY) ~= MineEnum.MINE and self.mineBoard.blockMatrix[newX][newY].isShown then
                self.mineBoard:openBlock(newX, newY)
                if self.mineField:getMineMatrixValue(newX, newY) == MineEnum.EMPTY then
                    self:openAdjacent(newX, newY)
                end
            end
        end
    end
end