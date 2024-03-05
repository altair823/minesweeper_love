require("common/object")
require("object/mine_board")
require("common/clickable_table")

MineGameButtonEnum = {
    RESTART = 1
}

MineGameHandler = Object:inherit()

function MineGameHandler:new(mineAtlas)
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
    handler.buttonClickTable:registerClick(handler.restartButton, ClickTypeEnum.LEFT)
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
    return self.isGameOver
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
    self.mineField = MineField:new(20, 20, 80)
    self.mineBoard = MineBoard:new(0, 0, 1024, 700, self.mineAtlas.boardAtlas)
    self.mineBoard:setBlockMatrix(self.mineField, self.mineAtlas.cellAtlas, self.mineAtlas.blockAtlas, 32, 32)
    self.isGameOver = false
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notGameover)
    self.mineBoard.clickableTable:activate()
end

function MineGameHandler:draw()
    self.canvas = love.graphics.newCanvas(1024, 1024)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setColor(255,255,255)
    love.graphics.push()
    self.mineBoard:draw()
    self.restartButton:draw()
    self.gameoverIndicator:draw()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

function MineGameHandler:leftClicked(x, y)
    self.buttonClickTable:leftClicked(x, y)
    self.mineBoard.clickableTable:leftClicked(x, y)
    if not self.isGameOver and self:isMineCellReveal() then
        self.isGameOver = true
        print("Game Over")
        self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.gameover)
        self.mineBoard.clickableTable:deactivate()
    end
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