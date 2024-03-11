--[[
    MineBoard class
    This class is responsible for creating the board of the game. 
    It is also responsible for creating the blocks and cells of the game. 
    It also defines the logic of the game.
]]--

require "model/mine_field"

require "object/mine_block"
require "object/mine_cell"

require "common/clickable_table"

MineBoard = Sprite:inherit()

--[[
    Constructor for the MineBoard class
    x: x position of the board
    y: y position of the board
    width: width of the board
    height: height of the board
    atlas: initial atlas of the board
    spriteTable: sprite table to add the board for scaling
]]--
function MineBoard:new(x, y, width, height, atlas, spriteTable)
    local board = Sprite.new(self, x, y, width, height, atlas, spriteTable, "MineBoard")
    board.clickableTable = ClickableTable:new(
        function (cx, cy)
            local i, j = board:toBlockCoordinate(cx, cy)
            if i == nil then
                return nil
            else
                return "MineBlock" .. i .. " " .. j
            end
        end
    )
    board.spriteTable = spriteTable
    self.openedCells = {}
    self.flaggedCells = {}
    return board
end

--[[
    Function to convert the x and y coordinates to the block indices
    x and y are the coordinates that is started with top left corner of the window.
    x: x coordinate
    y: y coordinate
]]--
function MineBoard:toBlockCoordinate(x, y)
    local blockWidth = self.blockMatrix[1][1].width
    local blockHeight = self.blockMatrix[1][1].height
    if x < self.center.x - (self.xCount * blockWidth) / 2 or x > self.center.x + (self.xCount * blockWidth) / 2 - 1
    or y < self.center.y - (self.yCount * blockHeight) / 2 or y > self.center.y + (self.yCount * blockHeight) / 2 - 1 then
        return nil
    end
    local i = math.floor((x - (self.center.x - (self.xCount * blockWidth) / 2)) / blockWidth) + 1
    local j = math.floor((y - (self.center.y - (self.yCount * blockHeight) / 2)) / blockHeight) + 1
    return i, j
end

--[[
    Function to check if the x and y coordinates are inside the block board
    x and y are the coordinates that is started with top left corner of the window.
    x: x coordinate
    y: y coordinate
    blockWidth: width of the block
    blockHeight: height of the block
]]--
function MineBoard:isXYInsideBlockBoard(x, y, blockWidth, blockHeight)
    if x >= self.center.x - (self.xCount * blockWidth * self.scale.x) / 2 and x <= self.center.x + (self.xCount * blockWidth * self.scale.x) / 2 - 1
    and y >= self.center.y - (self.yCount * blockHeight * self.scale.y) / 2 and y <= self.center.y + (self.yCount * blockHeight * self.scale.y) / 2 - 1 then
        return true
    end
    return false
    
end

--[[
    Function to create the blocks and cells of the board
    xCount: number of blocks in the x direction
    yCount: number of blocks in the y direction
    cellAtlas: atlas for the cells
    blockAtlas: atlas for the blocks
]]--
function MineBoard:createBlocks(xCount, yCount, cellAtlas, blockAtlas)
    self.xCount = xCount
    self.yCount = yCount
    self.cellMatrix = {}
    self.blockMatrix = {}
    for i=1, xCount do
        self.cellMatrix[i] = {}
        self.blockMatrix[i] = {}
        for j=1, yCount do
            self.cellMatrix[i][j] = MineCell:new(
                self.center.x - (xCount * MineImages.mineCellWidth) / 2 + (i - 1) * MineImages.mineCellWidth,
                self.center.y - (yCount * MineImages.mineCellHeight) / 2 + (j - 1) * MineImages.mineCellHeight,
                MineImages.mineCellWidth, MineImages.mineCellHeight,
                MineEnum.EMPTY, cellAtlas[MineEnum.EMPTY], self.spriteTable, i, j)
            self.blockMatrix[i][j] = MineBlock:new(
                self.center.x - (xCount * MineImages.mineCellWidth) / 2 + (i - 1) * MineImages.mineCellWidth,
                self.center.y - (yCount * MineImages.mineCellHeight) / 2 + (j - 1) * MineImages.mineCellHeight,
                MineImages.mineCellWidth, MineImages.mineCellHeight,
                blockAtlas[BlockEnum.DEFAULT], blockAtlas[BlockEnum.FLAG],
                self.spriteTable, i, j)
        end
    end
end

--[[
    Function to activate the clickable table
]]--
function MineBoard:activate()
    self.clickableTable:activate()
end

--[[
    Function to deactivate the clickable table
]]--
function MineBoard:deactivate()
    self.clickableTable:deactivate()
end

--[[
    Function to set the block matrix and cell matrix of the board with the mine field
    mineField: mine field object
    cellAtlas: atlas for the cells
    blockAtlas: atlas for the blocks
    width: width of the block
    height: height of the block
]]--
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
            self.cellMatrix[i][j] = MineCell:new(
                cellX, cellY, width, height, 
                self.mineField:getValue(i, j), 
                cellAtlas[self.mineField:getValue(i, j)], 
                self.spriteTable, i, j)
            self.blockMatrix[i][j] = MineBlock:new(
                cellX, cellY, width, height, 
                blockAtlas[BlockEnum.DEFAULT], 
                blockAtlas[BlockEnum.FLAG], 
                self.spriteTable, i, j)
        end
    end
    for i=1, #self.cellMatrix do
        for j=1, #self.cellMatrix[i] do
            -- Register the left click events for the blocks
            self.clickableTable:registerClick(ClickTypeEnum.LEFT, self.blockMatrix[i][j], function ()
                if self.blockMatrix[i][j].isFlagged then
                    return nil
                end
                if self.blockMatrix[i][j].isShown then
                    self.blockMatrix[i][j]:open()
                end
                if not self.blockMatrix[i][j].isShown then 
                    self:tryOpenAdjacent(i, j)
                end
                table.insert(self.openedCells, {i = i, j = j})
            end)
            -- Register the right click events for the blocks
            self.clickableTable:registerClick(ClickTypeEnum.RIGHT, self.blockMatrix[i][j], function ()
                if self.blockMatrix[i][j].isShown then
                    self.blockMatrix[i][j]:toggleFlag()
                    if self.blockMatrix[i][j].isFlagged then
                        self.flaggedCells[i .. " " .. j] = true
                    else
                        self.flaggedCells[i .. " " .. j] = nil
                    end
                else
                    self:tryOpenAdjacent(i, j)
                    table.insert(self.openedCells, {i = i, j = j})
                end
            end)
        end
    end
end

--[[
    Function to open the block
    i: x index of the block
    j: y index of the block
]]--
function MineBoard:openBlock(i, j)
    self.blockMatrix[i][j]:open()
end

--[[
    Function to open the adjacent blocks that only when it is empty block
    x: x index of the block
    y: y index of the block
]]--
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

--[[
    Function to try to open the adjacent blocks of the block.
    x: x index of the block
    y: y index of the block
]]--
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

--[[
    Function to draw the board
]]--
function MineBoard:draw()
    self.super.draw(self)
    self:draw_numbers()
    self:draw_blocks()
end

--[[
    Function to draw the numbers of the cells
]]--
function MineBoard:draw_numbers()
    for i=1, #self.cellMatrix do
        for j=1, #self.cellMatrix[i] do
            self.cellMatrix[i][j]:draw()
        end
    end
end

--[[
    Function to draw the blocks of the board
]]--
function MineBoard:draw_blocks()
    for i=1, #self.blockMatrix do
        for j=1, #self.blockMatrix[i] do
            self.blockMatrix[i][j]:draw()
        end
    end
end

-- Mouse previous location
MousePrevLoc = {i = 0, j = 0}

--[[
    Function to handle the mouse moved event
    x: x coordinate of the mouse
    y: y coordinate of the mouse
]]--
function MineBoard:mouseMoved(x, y)
    local blockWidth = self.blockMatrix[1][1].width
    local blockHeight = self.blockMatrix[1][1].height
    if x >= self.center.x - (self.xCount * blockWidth) / 2 and x <= self.center.x + (self.xCount * blockWidth) / 2 - 1
    and y >= self.center.y - (self.yCount * blockHeight) / 2 and y <= self.center.y + (self.yCount * blockHeight) / 2 - 1 then
        local i = math.floor((x - (self.center.x - (self.xCount * blockWidth) / 2)) / blockWidth) + 1
        local j = math.floor((y - (self.center.y - (self.yCount * blockHeight) / 2)) / blockHeight) + 1
        if MousePrevLoc.i ~= i or MousePrevLoc.j ~= j then
            if MousePrevLoc.i ~= 0 and MousePrevLoc.j ~= 0 then
                self.blockMatrix[MousePrevLoc.i][MousePrevLoc.j]:untoggle()
            end
            self.blockMatrix[i][j]:toggle()
            MousePrevLoc.i = i
            MousePrevLoc.j = j
        end
    else
        if MousePrevLoc.i ~= 0 and MousePrevLoc.j ~= 0 then
            self.blockMatrix[MousePrevLoc.i][MousePrevLoc.j]:untoggle()
            MousePrevLoc.i = 0
            MousePrevLoc.j = 0
        end
    end
end