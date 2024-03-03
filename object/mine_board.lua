require "model/mine_field"

require "object/mine_block"
require "object/mine_cell"

Board = Sprite:inherit()

function Board:new(x, y, width, height, atlas)
    local board = Sprite.new(self, x, y, width, height, atlas)
    return board
end

function Board:setBlockMatrix(field, cellAtlas, blockAtlas, width, height)
    self.field = field
    self.numberMatrix = {}
    self.blockMatrix = {}
    for i=1, self.field.xCount do
        self.numberMatrix[i] = {}
        self.blockMatrix[i] = {}
        for j=1, self.field.yCount do
            local cellX = self.center.x - (self.field.xCount * width) / 2 + (i - 1) * width
            local cellY = self.center.y - (self.field.yCount * height) / 2 + (j - 1) * height
            self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas[self.field.mineMatrix[i][j]])
            self.blockMatrix[i][j] = Block:new(cellX, cellY, width, height, blockAtlas)
        end
    end
end

function Board:draw()
    self.canvas = love.graphics.newCanvas(1024, 1024)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setColor(255,255,255)
    love.graphics.push()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
    self:draw_numbers()
    self:draw_blocks()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

function Board:draw_numbers()
    for i=1, #self.numberMatrix do
        for j=1, #self.numberMatrix[i] do
            self.numberMatrix[i][j]:draw()
        end
    end
end

function Board:draw_blocks()
    for i=1, #self.blockMatrix do
        for j=1, #self.blockMatrix[i] do
            self.blockMatrix[i][j]:draw()
        end
    end
end

prevLoc = {i = 0, j = 0}

function Board:mouseMoved(x, y)
    mouseLocation.x = x
    mouseLocation.y = y
    if x >= board.center.x - (board.field.xCount * 32) / 2 and x <= board.center.x + (board.field.xCount * 32) / 2 - 1
    and y >= board.center.y - (board.field.yCount * 32) / 2 and y <= board.center.y + (board.field.yCount * 32) / 2 - 1 then
        local i = math.floor((x - (board.center.x - (board.field.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (board.center.y - (board.field.yCount * 32) / 2)) / 32) + 1
        if prevLoc.i ~= i or prevLoc.j ~= j then
            if prevLoc.i ~= 0 and prevLoc.j ~= 0 then
                board.blockMatrix[prevLoc.i][prevLoc.j]:untoggle()
            end
            board.blockMatrix[i][j]:toggle()
            prevLoc.i = i
            prevLoc.j = j
        end
    else
        if prevLoc.i ~= 0 and prevLoc.j ~= 0 then
            board.blockMatrix[prevLoc.i][prevLoc.j]:untoggle()
            prevLoc.i = 0
            prevLoc.j = 0
        end
    end
end

function Board:mouseReleased(x, y, button)
    if x >= board.center.x - (board.field.xCount * 32) / 2 and x <= board.center.x + (board.field.xCount * 32) / 2
    and y >= board.center.y - (board.field.yCount * 32) / 2 and y <= board.center.y + (board.field.yCount * 32) / 2 then
        if button == 1 then
            local i = math.floor((x - (board.center.x - (board.field.xCount * 32) / 2)) / 32) + 1
            local j = math.floor((y - (board.center.y - (board.field.yCount * 32) / 2)) / 32) + 1
            if board.blockMatrix[i][j].isToggled then
                board.blockMatrix[i][j]:release()
            end
        end
    end
end