require "common/object"

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

function MineField:new(xCount, yCount, mineCount)
    if xCount < 1 or yCount < 1 or mineCount < 1 or mineCount > xCount * yCount then
        return nil
    end
    local field = {}
    setmetatable(field, self)
    self.__index = self
    field.xCount = xCount
    field.yCount = yCount
    field.mineCount = mineCount
    field.mineMatrix = {}
    field.mineLocation = {}
    for i=1, xCount do
        field.mineMatrix[i] = {}
        for j=1, yCount do
            field.mineMatrix[i][j] = {value = MineEnum.EMPTY, state = CellStateEnum.HIDDEN}
        end
    end
    if DEBUG then
        math.randomseed(1)
    else 
        math.randomseed(os.time())
    end
    for i=1, field.mineCount do
        local x = math.random(1, field.xCount)
        local y = math.random(1, field.yCount)
        while field.mineMatrix[x][y].value == MineEnum.MINE do
            x = math.random(1, field.xCount)
            y = math.random(1, field.yCount)            
        end
        field.mineMatrix[x][y].value = MineEnum.MINE
        table.insert(field.mineLocation, {x = x, y = y})
    end
    field:setAdjacent()
    return field
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
            if self.mineMatrix[i][j].value == MineEnum.MINE then
                for k=1, #adjacents do
                    local x = i + adjacents[k][1]
                    local y = j + adjacents[k][2]
                    if x >= 1 and x <= self.xCount and y >= 1 and y <= self.yCount then
                        if self.mineMatrix[x][y].value ~= MineEnum.MINE then
                            self.mineMatrix[x][y].value = self.mineMatrix[x][y].value + 1
                        end
                    end
                end
            end
        end
    end
end

function MineField:printTest()
    local mineC = 0
    for i=1, self.xCount do
        temp = ""
        for j=1, self.yCount do
            temp = temp .. self.mineMatrix[i][j].value .. " "
            if self.mineMatrix[i][j].value == MineEnum.MINE then
                mineC = mineC + 1
            end
        end
        print(temp)
    end
    print("Mine count: " .. mineC)
end

function MineField:getValue(x, y)
    return self.mineMatrix[x][y].value
end

function MineField:getState(x, y)
    return self.mineMatrix[x][y].state
end

function MineField:setState(x, y, state)
    self.mineMatrix[x][y].state = state
end