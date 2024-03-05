require("common/object")
require("object/mine_board")

MineGameHandler = Object:inherit()

function MineGameHandler:new(mineAtlas)
    local handler = {}
    setmetatable(handler, self)
    self.__index = self
    handler.mineAtlas = mineAtlas
    handler.mineField = MineField:new(20, 20, 80)
    handler.mineBoard = MineBoard:new(0, 0, 1024, 700, mineAtlas.boardAtlas)
    handler.mineBoard:setBlockMatrix(handler.mineField, mineAtlas.cellAtlas, mineAtlas.blockAtlas, 32, 32)
    return handler
end

function MineGameHandler:draw()
    self.canvas = love.graphics.newCanvas(1024, 1024)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setColor(255,255,255)
    love.graphics.push()
    self.mineBoard:draw()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

function MineGameHandler:mouseReleased(x, y, button)
    self.mineBoard:mouseReleased(x, y, button)
end

function MineGameHandler:mouseMoved(x, y)
    self.mineBoard:mouseMoved(x, y)
end