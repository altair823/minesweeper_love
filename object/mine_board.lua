require "model/mine_field"

require "object/mine_block"
require "object/mine_cell"

require("common/clickable_table")

MineBoard = Sprite:inherit()

function MineBoard:new(x, y, width, height, atlas, spriteTable)
    local board = Sprite.new(self, x, y, width, height, atlas, spriteTable, "MineBoard")
    board.clickableTable = ClickableTable:new(
        -- function (cx, cy)
        --     local blockWidth = self.blockMatrix[1][1].width
        --     local blockHeight = self.blockMatrix[1][1].height
        --     if cx >= board.center.x - (board.mineField.xCount * blockWidth) / 2 and cx <= board.center.x + (board.mineField.xCount * blockWidth) / 2 - 1
        --     and cy >= board.center.y - (board.mineField.yCount * blockHeight) / 2 and cy <= board.center.y + (board.mineField.yCount * blockHeight) / 2 - 1 then
        --         local i = math.floor((cx - (board.center.x - (board.mineField.xCount * blockWidth) / 2)) / blockWidth) + 1
        --         local j = math.floor((cy - (board.center.y - (board.mineField.yCount * blockHeight) / 2)) / blockHeight) + 1
        --         return (i - 1) * board.mineField.yCount + j
        --     end
        --     return nil
        -- end
    )
    board.spriteTable = spriteTable
    self.openedCells = {}
    return board
end

function MineBoard:getLastOpenedCells()
    return self.openedCells[#self.openedCells]
end

function MineBoard:isCellNumber(i, j)
    return self.cellMatrix[i][j].value ~= MineEnum.MINE and self.cellMatrix[i][j].value ~= MineEnum.EMPTY
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
            self.cellMatrix[i][j] = MineCell:new(cellX, cellY, width, height, self.mineField:getValue(i, j), cellAtlas[self.mineField:getValue(i, j)], self.spriteTable)
            self.blockMatrix[i][j] = MineBlock:new(cellX, cellY, width, height, blockAtlas[BlockEnum.DEFAULT], blockAtlas[BlockEnum.FLAG], self.spriteTable)
        end
    end
    for i=1, #self.cellMatrix do
        for j=1, #self.cellMatrix[i] do
            self.clickableTable:registerClick(ClickTypeEnum.LEFT, self.blockMatrix[i][j], function ()
                if not self.blockMatrix[i][j].isShown then 
                    self:tryOpenAdjacent(i, j)
                end
                table.insert(self.openedCells, {i = i, j = j})
            end)
            self.clickableTable:registerClick(ClickTypeEnum.RIGHT, self.blockMatrix[i][j])
        end
    end
end

function MineBoard:openBlock(i, j)
    self.blockMatrix[i][j]:leftClicked()
end

function MineBoard:openAdjacentOfEmpty(x, y)
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
    if self.mineField:getValue(x, y) == MineEnum.EMPTY then
        for i=1, #adjacents do
            local newX = x + adjacents[i][1]
            local newY = y + adjacents[i][2]
            if newX >= 1 and newX <= self.mineField.xCount and newY >= 1 and newY <= self.mineField.yCount then
                if not self.blockMatrix[newX][newY].isFlagged 
                and self.blockMatrix[newX][newY].isShown then
                    self:openBlock(newX, newY)
                    if self.mineField:getValue(newX, newY) == MineEnum.EMPTY then
                        self:openAdjacentOfEmpty(newX, newY)
                    end
                end
            end
        end
    end
end

function MineBoard:tryOpenAdjacent(x, y)
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
    local adjacentFlagCount = 0
    for i=1, #adjacents do
        local newX = x + adjacents[i][1]
        local newY = y + adjacents[i][2]
        if newX >= 1 and newX <= self.mineField.xCount and newY >= 1 and newY <= self.mineField.yCount then
            if self.blockMatrix[newX][newY].isFlagged then
                adjacentFlagCount = adjacentFlagCount + 1
            end
        end
    end
    if adjacentFlagCount == self.mineField:getValue(x, y) then
        for i=1, #adjacents do
            local newX = x + adjacents[i][1]
            local newY = y + adjacents[i][2]
            if newX >= 1 and newX <= self.mineField.xCount and newY >= 1 and newY <= self.mineField.yCount then
                if not self.blockMatrix[newX][newY].isFlagged then
                    self:openBlock(newX, newY)
                    if self.mineField:getValue(newX, newY) == MineEnum.EMPTY then
                        self:openAdjacentOfEmpty(newX, newY)
                    end
                end
            end
        end
    end
end

function MineBoard:draw()
    self.super.draw(self)
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
    local blockWidth = self.blockMatrix[1][1].width
    local blockHeight = self.blockMatrix[1][1].height
    if x >= self.center.x - (self.mineField.xCount * blockWidth) / 2 and x <= self.center.x + (self.mineField.xCount * blockWidth) / 2 - 1
    and y >= self.center.y - (self.mineField.yCount * blockHeight) / 2 and y <= self.center.y + (self.mineField.yCount * blockHeight) / 2 - 1 then
        local i = math.floor((x - (self.center.x - (self.mineField.xCount * blockWidth) / 2)) / blockWidth) + 1
        local j = math.floor((y - (self.center.y - (self.mineField.yCount * blockHeight) / 2)) / blockHeight) + 1
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