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