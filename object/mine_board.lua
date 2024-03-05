require "model/mine_field"

require "object/mine_block"
require "object/mine_cell"

require("common/clickable_table")

MineBoard = Sprite:inherit()

function MineBoard:new(x, y, width, height, atlas)
    local board = Sprite.new(self, x, y, width, height, atlas)
    board.clickableTable = ClickableTable:new()
    self.openedCells = {}
    return board
end

function MineBoard:getLastOpenedCells()
    return self.openedCells[#self.openedCells]
end

function MineBoard:activate()
    self.clickableTable:activate()
end

function MineBoard:deactivate()
    self.clickableTable:deactivate()
end

function MineBoard:setBlockMatrix(mineField, cellAtlas, blockAtlas, width, height)
    self.mineField = mineField
    self.cellMatrix = {}
    self.blockMatrix = {}
    for i=1, self.mineField.xCount do
        self.cellMatrix[i] = {}
        self.blockMatrix[i] = {}
        for j=1, self.mineField.yCount do
            local cellX = self.center.x - (self.mineField.xCount * width) / 2 + (i - 1) * width
            local cellY = self.center.y - (self.mineField.yCount * height) / 2 + (j - 1) * height
            self.cellMatrix[i][j] = MineCell:new(cellX, cellY, width, height, self.mineField:getMineMatrixValue(i, j), cellAtlas[self.mineField:getMineMatrixValue(i, j)])
            self.blockMatrix[i][j] = MineBlock:new(cellX, cellY, width, height, blockAtlas[BlockEnum.DEFAULT], blockAtlas[BlockEnum.FLAG])
            self.clickableTable:registerClick(ClickTypeEnum.LEFT, self.blockMatrix[i][j], function ()
                table.insert(self.openedCells, {i = i, j = j})
            end)
            self.clickableTable:registerClick(ClickTypeEnum.RIGHT, self.blockMatrix[i][j])
        end
    end
end

function MineBoard:openBlock(i, j)
    self.blockMatrix[i][j]:leftClicked()
end

function MineBoard:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
    self:draw_numbers()
    self:draw_blocks()
end

function MineBoard:draw_numbers()
    for i=1, #self.cellMatrix do
        for j=1, #self.cellMatrix[i] do
            self.cellMatrix[i][j]:draw()
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