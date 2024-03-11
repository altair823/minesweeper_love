require "common/object"

if DEBUG then
    math.randomseed(1)
else 
    math.randomseed(os.time())
end

MineEnum = {
    MINE = 'x',
    EMPTY = 0,
    ONE = 1,
    TWO = 2,
    THREE = 3,
    FOUR = 4,
    FIVE = 5,
    SIX = 6,
    SEVEN = 7,
    EIGHT = 8
}

CellStateEnum = {
    HIDDEN = 0,
    REVEALED = 1,
}

BlockEnum = {
    DEFAULT = 1,
    FLAG = 2
}

MineField = Object:inherit()

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

function MineField:setEmpty(emptylocations)
    print("emptylocations: " .. #emptylocations)
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

function MineField:setMine(mineCount)
    if self.xCount < 1 or self.yCount < 1 or mineCount < 1 or mineCount > self.xCount * self.yCount then
        return nil
    end
    self.mineCount = mineCount
    for i=1, self.mineCount do
        local x = math.random(1, self.xCount)
        local y = math.random(1, self.yCount)
        while self.mineMatrix[x][y] ~= nil do
            x = math.random(1, self.xCount)
            y = math.random(1, self.yCount)
        end
        table.insert(self.mineLocation, {x = x, y = y})
    end
    for i=1, #self.mineLocation do
        self.mineMatrix[self.mineLocation[i].x][self.mineLocation[i].y] = MineEnum.MINE
    end
    self:setAdjacent()
end

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

function MineField:getValue(x, y)
    return self.mineMatrix[x][y]
end

function MineField:getState(x, y)
    return self.mineMatrix[x][y].state
end

function MineField:setState(x, y, state)
    self.mineMatrix[x][y].state = state
end
