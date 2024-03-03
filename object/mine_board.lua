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
            if self.field.mineMatrix[i][j] == MineEnum.MINE then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, MineEnum.MINE, cellAtlas.mine)
            elseif self.field.mineMatrix[i][j] == MineEnum.EMPTY then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num0)
            elseif self.field.mineMatrix[i][j] == MineEnum.ONE then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num1)
            elseif self.field.mineMatrix[i][j] == MineEnum.TWO then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num2)
            elseif self.field.mineMatrix[i][j] == MineEnum.THREE then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num3)
            elseif self.field.mineMatrix[i][j] == MineEnum.FOUR then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num4)
            elseif self.field.mineMatrix[i][j] == MineEnum.FIVE then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num5)
            elseif self.field.mineMatrix[i][j] == MineEnum.SIX then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num6)
            elseif self.field.mineMatrix[i][j] == MineEnum.SEVEN then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num7)
            elseif self.field.mineMatrix[i][j] == MineEnum.EIGHT then
                self.numberMatrix[i][j] = Cell:new(cellX, cellY, width, height, self.field.mineMatrix[i][j], cellAtlas.num8)
            end
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