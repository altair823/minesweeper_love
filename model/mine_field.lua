require "common/object"

--[[
    MineField class
    This class is representing the model of the mine field.
    The minesweeper game is based on this class.
    This class is responsible for generating the mine field and
    managing the state of the mine field.
    The mine field is represented by a 2D array.
--]]

-- Set DEBUG to true to make the mine field deterministic
if DEBUG then
    math.randomseed(1)
else 
    math.randomseed(os.time())
end

-- Values for mine matrix.
MineEnum = {
    MINE = 'x', -- mine
    EMPTY = 0, -- empty cell
    ONE = 1, -- cell with one mine adjacent
    TWO = 2, -- cell with two mines adjacent and so on
    THREE = 3,
    FOUR = 4,
    FIVE = 5,
    SIX = 6,
    SEVEN = 7,
    EIGHT = 8
}

MineField = Object:inherit()

--[[
    Constructor for the MineField class
    xCount: number of cells in the x direction
    yCount: number of cells in the y direction
]]--
function MineField:new(xCount, yCount)
    local field = {}
    setmetatable(field, self)
    self.__index = self
    field.xCount = xCount
    field.yCount = yCount
    field.mineMatrix = {}
    field.mineLocation = {}
    for i=1, xCount do
        field.mineMatrix[i] = {}
        for j=1, yCount do
            field.mineMatrix[i][j] = nil
        end
    end
    return field
end

--[[
    Function to set the empty cells in the mine field
    emptylocations: locations of the empty cells - 2D array
]]--
function MineField:setEmpty(emptylocations)
    for i=1, #emptylocations do
        self.mineMatrix[emptylocations[i][1]][emptylocations[i][2]] = MineEnum.EMPTY
        -- make adjacent cells empty
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
        for j=1, #adjacents do
            local x = emptylocations[i][1] + adjacents[j][1]
            local y = emptylocations[i][2] + adjacents[j][2]
            if x >= 1 and x <= self.xCount and y >= 1 and y <= self.yCount then
                self.mineMatrix[x][y] = MineEnum.EMPTY
            end
        end
    end    
end

--[[
    Function to set the mine in the mine field
    mineCount: number of mines
]]--
function MineField:setMine(mineCount)
    if self.xCount < 1 or self.yCount < 1 or mineCount < 1 or mineCount > self.xCount * self.yCount then
        return nil
    end
    self.mineCount = mineCount
    for i=1, mineCount do
        local x = math.random(1, self.xCount)
        local y = math.random(1, self.yCount)
        while self.mineMatrix[x][y] ~= nil do
            x = math.random(1, self.xCount)
            y = math.random(1, self.yCount)
        end
        self.mineMatrix[x][y] = MineEnum.MINE
        table.insert(self.mineLocation, {x = x, y = y})
    end
    self:setAdjacent()
end

--[[
    Function to set the adjacent cells of the mine field
]]--
function MineField:setAdjacent()
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
    for i=1, self.xCount do
        for j=1, self.yCount do
            if self.mineMatrix[i][j] == MineEnum.MINE then
                for k=1, #adjacents do
                    local x = i + adjacents[k][1]
                    local y = j + adjacents[k][2]
                    if x >= 1 and x <= self.xCount and y >= 1 and y <= self.yCount then
                        if self.mineMatrix[x][y] ~= MineEnum.MINE then
                            self.mineMatrix[x][y] = self.mineMatrix[x][y] or 0
                            self.mineMatrix[x][y] = self.mineMatrix[x][y] + 1
                        end
                    end
                end
            else
                self.mineMatrix[i][j] = self.mineMatrix[i][j] or 0
            end
        end
    end
end

--[[
    Function to print the mine field for testing
]]--
function MineField:printTest()
    -- first index is x, second index is y
    local mineCount = 0
    for j=1, self.yCount do
        local temp = ""
        for i=1, self.xCount do
            local printValue = ""
            if self.mineMatrix[i][j] == nil then
                printValue = "n"
            else
                printValue = self.mineMatrix[i][j]
            end
            temp = temp .. printValue .. " "
            if self.mineMatrix[i][j] == MineEnum.MINE then
                mineCount = mineCount + 1
            end
        end
        print(temp)
    end
    print("Mine count: " .. mineCount)
end

--[[
    Function to get the value of the mine field
    x: x index of the mine field
    y: y index of the mine field
]]--
function MineField:getValue(x, y)
    return self.mineMatrix[x][y]
end

--[[
    Function to get the state of the mine field
    x: x index of the mine field
    y: y index of the mine field
]]--
function MineField:getState(x, y)
    return self.mineMatrix[x][y].state
end

