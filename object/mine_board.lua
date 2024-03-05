require "model/mine_field"

require "object/mine_block"
require "object/mine_cell"

MineBoard = Sprite:inherit()

function MineBoard:new(x, y, width, height, atlas)
    local board = Sprite.new(self, x, y, width, height, atlas)
    return board
end

function MineBoard:setBlockMatrix(mineField, cellAtlas, blockAtlas, width, height)
    self.mineField = mineField
    self.numberMatrix = {}
    self.blockMatrix = {}
    for i=1, self.mineField.xCount do
        self.numberMatrix[i] = {}
        self.blockMatrix[i] = {}
        for j=1, self.mineField.yCount do
            local cellX = self.center.x - (self.mineField.xCount * width) / 2 + (i - 1) * width
            local cellY = self.center.y - (self.mineField.yCount * height) / 2 + (j - 1) * height
            self.numberMatrix[i][j] = MineCell:new(cellX, cellY, width, height, self.mineField.mineMatrix[i][j], cellAtlas[self.mineField.mineMatrix[i][j]])
            self.blockMatrix[i][j] = MineBlock:new(cellX, cellY, width, height, blockAtlas[BlockEnum.DEFAULT], blockAtlas[BlockEnum.FLAG])
        end
    end
end

function MineBoard:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
    self:draw_numbers()
    self:draw_blocks()
end

function MineBoard:draw_numbers()
    for i=1, #self.numberMatrix do
        for j=1, #self.numberMatrix[i] do
            self.numberMatrix[i][j]:draw()
        end
    end
end

function MineBoard:draw_blocks()
    for i=1, #self.blockMatrix do
        for j=1, #self.blockMatrix[i] do
            self.blockMatrix[i][j]:draw()
        end
    end
end

prevLoc = {i = 0, j = 0}

function MineBoard:mouseMoved(x, y)
    mouseLocation.x = x
    mouseLocation.y = y
    if x >= self.center.x - (self.mineField.xCount * 32) / 2 and x <= self.center.x + (self.mineField.xCount * 32) / 2 - 1
    and y >= self.center.y - (self.mineField.yCount * 32) / 2 and y <= self.center.y + (self.mineField.yCount * 32) / 2 - 1 then
        local i = math.floor((x - (self.center.x - (self.mineField.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (self.center.y - (self.mineField.yCount * 32) / 2)) / 32) + 1
        if prevLoc.i ~= i or prevLoc.j ~= j then
            if prevLoc.i ~= 0 and prevLoc.j ~= 0 then
                self.blockMatrix[prevLoc.i][prevLoc.j]:untoggle()
            end
            self.blockMatrix[i][j]:toggle()
            prevLoc.i = i
            prevLoc.j = j
        end
    else
        if prevLoc.i ~= 0 and prevLoc.j ~= 0 then
            self.blockMatrix[prevLoc.i][prevLoc.j]:untoggle()
            prevLoc.i = 0
            prevLoc.j = 0
        end
    end
end

function MineBoard:mouseReleased(x, y, button)
    if x >= self.center.x - (self.mineField.xCount * 32) / 2 and x <= self.center.x + (self.mineField.xCount * 32) / 2
    and y >= self.center.y - (self.mineField.yCount * 32) / 2 and y <= self.center.y + (self.mineField.yCount * 32) / 2 then
        local i = math.floor((x - (self.center.x - (self.mineField.xCount * 32) / 2)) / 32) + 1
        local j = math.floor((y - (self.center.y - (self.mineField.yCount * 32) / 2)) / 32) + 1
        if button == 1 then
            if self.blockMatrix[i][j].isToggled and not self.blockMatrix[i][j].isFlagged then
                self.blockMatrix[i][j]:leftClicked()
            end
        elseif button == 2 then
            if self.blockMatrix[i][j].isToggled then
                self.blockMatrix[i][j]:rightClicked()
            end
        end
    end
end