--[[
    MineGameHandler class
    This class is responsible for handling the game logic of the mine sweeper game.
    It is responsible for handling the input events and drawing the game.
    It is also responsible for handling the game over and win events.
]]--

require "common/object"
require "object/mine_board"
require "common/clickable_table"
require "common/sprite_table"

-- Enum for the mine game button types
MineGameButtonEnum = {
    RESTART = 1
}

MineGameHandler = Object:inherit()

--[[
    Constructor for the MineGameHandler class
    mineAtlas: atlas for the mine game
    xCount: number of cells in the x direction
    yCount: number of cells in the y direction
    mineCount: number of mines in the game
]]--
function MineGameHandler:new(mineAtlas, xCount, yCount, mineCount)
    local handler = {}
    setmetatable(handler, self)
    self.__index = self
    handler.mineAtlas = mineAtlas
    handler.mineGameSpriteTable = SpriteTable:new()
    handler.mineField = MineField:new(xCount, yCount)
    handler.isGameOver = false
    handler.mineCount = mineCount
    handler.buttonClickTable = ClickableTable:new()
    handler.isStarted = false
    handler.mineBoard = MineBoard:new(
        -math.floor(DefaultWindowSize.width / 2), 
        -math.floor(DefaultWindowSize.height / 2), 
        DefaultWindowSize.width, 
        DefaultWindowSize.height, 
        handler.mineAtlas.boardAtlas, 
        handler.mineGameSpriteTable)
    handler.mineBoard:createBlocks(xCount, yCount, handler.mineAtlas.cellAtlas, handler.mineAtlas.blockAtlas)
    handler:makeButtons()
    handler.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "NumberFont", 64)
    handler.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "TextFont", 28)
    return handler
end

--[[
    Function to print the remaining mine count
]]--
function MineGameHandler:printRemainingMines()
    local remainingMine = self.mineCount - self:countFlaggedCell()
    love.graphics.setFont(self.mineGameSpriteTable:getFont("TextFont"))
    love.graphics.print("찾지 못한 지뢰", -790 * self.mineBoard.scale.x, -280 * self.mineBoard.scale.y)
    love.graphics.setFont(self.mineGameSpriteTable:getFont("NumberFont"))
    love.graphics.print(remainingMine, -730 * self.mineBoard.scale.x, -240 * self.mineBoard.scale.y)
end

--[[
    Function to initialize the texts
]]--
function MineGameHandler:initTexts()
    self.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "NumberFont", 64)
    self.mineGameSpriteTable:addFont("fonts/NeoDunggeunmoPro-Regular.ttf", "TextFont", 28)
end

--[[
    Function to make the buttons
]]--
function MineGameHandler:makeButtons()
    self.restartButton = Sprite:new(
        self.mineBoard.center.x - (32 * self.mineBoard.scale.x), 
        -self.mineBoard.height / 2 + (16 * self.mineBoard.scale.y),
        64, 64, 
        MineAtlas.buttonAtlas[MineGameButtonEnum.RESTART],
        self.mineGameSpriteTable,
        "restartButton")
    self.buttonClickTable:registerClick(ClickTypeEnum.LEFT, self.restartButton)
    self.restartButton.leftClicked = function()
        print("Restarting")
        self:restart()
    end
    self.gameoverIndicator = Sprite:new(
        self.mineBoard.center.x - (128 * self.mineBoard.scale.x), 
        -self.mineBoard.height / 2 + (16 * self.mineBoard.scale.y),
        64, 64, 
        MineAtlas.indicatorAtlas.notGameover,
        self.mineGameSpriteTable, 
        "gameoverIndicator")
    self.winIndicator = Sprite:new(
        self.mineBoard.center.x + (64 * self.mineBoard.scale.x), 
        -self.mineBoard.height / 2 + (16 * self.mineBoard.scale.y),
        64, 64, 
        MineAtlas.indicatorAtlas.notWin,
        self.mineGameSpriteTable,
        "winIndicator")
end

--[[
    Function to initialize the buttons
]]--
function MineGameHandler:initButtons()
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notGameover)
    self.winIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.notWin)
    self.mineGameSpriteTable:addSprite(self.gameoverIndicator, "gameoverIndicator")
    self.mineGameSpriteTable:addSprite(self.winIndicator, "winIndicator")
    self.mineGameSpriteTable:addSprite(self.restartButton, "restartButton")
end

--[[
    Function to check if the input is blocked
]]--
function MineGameHandler:isInputBlocked()
    return self.isGameOver or self.isWin
end

--[[
    Function to check if the mine cell is revealed
]]--
function MineGameHandler:isMineCellReveal()
    for i=1, #self.mineField.mineLocation do
        if not self.mineBoard.blockMatrix[self.mineField.mineLocation[i].x][self.mineField.mineLocation[i].y].isShown then
            return true
        end
    end
    return false
end

--[[
    Function to restart the game
]]--
function MineGameHandler:restart()
    local xCount = self.mineField.xCount
    local yCount = self.mineField.yCount
    self.mineField = MineField:new(xCount, yCount)
    self.mineGameSpriteTable = SpriteTable:new()
    self.mineBoard = MineBoard:new(
        -math.floor(DefaultWindowSize.width / 2), 
        -math.floor(DefaultWindowSize.height / 2), 
        DefaultWindowSize.width, 
        DefaultWindowSize.height, 
        self.mineAtlas.boardAtlas, 
        self.mineGameSpriteTable)
    self.mineBoard:createBlocks(xCount, yCount, self.mineAtlas.cellAtlas, self.mineAtlas.blockAtlas)
    self.isGameOver = false
    self.isWin = false
    self:initButtons()
    self:initTexts()
    self.mineGameSpriteTable:resizeAllSprite(love.graphics.getWidth(), love.graphics.getHeight())
    self.mineBoard:activate()
    self.isStarted = false
end

--[[
    Function to handle the game over event
]]--
function MineGameHandler:gameover()
    self.isGameOver = true
    print("Game Over")
    self.gameoverIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.gameover)
    self.mineBoard:deactivate()
    for i=1, #self.mineField.mineLocation do
        self.mineBoard.blockMatrix[self.mineField.mineLocation[i].x][self.mineField.mineLocation[i].y]:changeAtlas(MineImages.mineCellWidth, MineImages.mineCellHeight, self.mineAtlas.cellAtlas[MineEnum.MINE])
    end
end

--[[
    Function to check if the player wins
]]--
function MineGameHandler:checkWin()
    local count = 0
    for i=1, #self.mineBoard.blockMatrix do
        for j=1, #self.mineBoard.blockMatrix[i] do
            if self.mineBoard.blockMatrix[i][j].isShown then
                count = count + 1
            end
        end
    end
    if count == self.mineField.mineCount then
        print("You Win!")
        self.isWin = true
        self.winIndicator:changeAtlas(64, 64, self.mineAtlas.indicatorAtlas.win)
        self.mineBoard:deactivate()
    end
end

--[[
    Function to count the flagged cell
]]--
function MineGameHandler:countFlaggedCell()
    local count = 0
    for k, v in pairs(self.mineBoard.flaggedCells) do
        if v then
            count = count + 1
        end
    end
    return count
    
end

--[[
    Function to update the game
    dt: time passed since the last update
]]--
function MineGameHandler:makeCanvas()
    -- self.canvas = love.graphics.newCanvas(1024, 700)
    -- love.graphics.setCanvas(self.canvas)
    -- love.graphics.setCanvas()
end

--[[
    Function to draw the game
]]--
function MineGameHandler:draw()
    -- love.graphics.draw(self.canvas, 0, 0)
    
    self.mineBoard:draw()
    self.restartButton:draw()
    self.gameoverIndicator:draw()
    self.winIndicator:draw()
    self:printRemainingMines()
end

--[[
    Function to handle the left click event
    x: x coordinate of the click
    y: y coordinate of the click
]]--
function MineGameHandler:leftClicked(x, y)
    if self.mineBoard:isXYInsideBlockBoard(x, y, MineImages.mineCellWidth, MineImages.mineCellHeight) then
        if not self.isStarted then
            local i, j = self.mineBoard:toBlockCoordinate(x, y)
            self.mineField:setEmpty{{i, j}}
            self.mineField:setMine(self.mineCount)
            self.isStarted = true
            self.mineBoard:setBlockMatrix(self.mineField, self.mineAtlas.cellAtlas, self.mineAtlas.blockAtlas, MineImages.mineCellWidth, MineImages.mineCellHeight)
            self.mineGameSpriteTable:resizeAllSprite(love.graphics.getWidth(), love.graphics.getHeight())
        end
    end

    self.buttonClickTable:leftClicked(x, y)
    self.mineBoard.clickableTable:leftClicked(x, y)
    self:blockOpenEvent()
    self:checkWin()
end

--[[
    Function to handle the right click event
    x: x coordinate of the click
    y: y coordinate of the click
]]--
function MineGameHandler:rightClicked(x, y)
    self.mineBoard.clickableTable:rightClicked(x, y)
    self:blockOpenEvent()
end

--[[
    Function to handle the mouse moved event
    x: x coordinate of the mouse
    y: y coordinate of the mouse
]]--
function MineGameHandler:mouseMoved(x, y)
    if self:isInputBlocked() then
        return
    end
    self.mineBoard:mouseMoved(x, y)
end

--[[
    Function to handle the block open event
]]--
function MineGameHandler:blockOpenEvent()
    if #self.mineBoard.openedCells == 0 then
        return
    end
    if not self.isGameOver and self:isMineCellReveal() then
        self:gameover()
    else
        local i = self.mineBoard.openedCells[#self.mineBoard.openedCells].i
        local j = self.mineBoard.openedCells[#self.mineBoard.openedCells].j
        if self.mineField:getValue(i, j) ~= MineEnum.MINE then
            self.mineBoard:openAdjacentOfEmpty(i, j)
        end
    end
end

