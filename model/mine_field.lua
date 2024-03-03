
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

Field = {}

function Field:new(xCount, yCount, mineCount)
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
    for i=1, xCount do
        field.mineMatrix[i] = {}
        for j=1, yCount do
            field.mineMatrix[i][j] = 0
        end
    end
    math.randomseed(os.time())
    for i=1, field.mineCount do
        local x = math.random(1, field.xCount)
        local y = math.random(1, field.yCount)
        while field.mineMatrix[x][y] == MineEnum.MINE do
            x = math.random(1, field.xCount)
            y = math.random(1, field.yCount)            
        end
        field.mineMatrix[x][y] = MineEnum.MINE
    end
    field:setAdjacent()
    return field
end

function Field:setAdjacent()
    adjacents = {
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
                    if x >= 1 and x <= self.xCount and y >= 1 and y <= self.yCount and self.mineMatrix[x][y] ~= MineEnum.MINE then
                        self.mineMatrix[x][y] = self.mineMatrix[x][y] + 1
                    end
                end
            end
        end
    end
end

function Field:printTest()
    local mineC = 0
    for i=1, self.xCount do
        temp = ""
        for j=1, self.yCount do
            temp = temp .. self.mineMatrix[i][j] .. " "
            if self.mineMatrix[i][j] == MineEnum.MINE then
                mineC = mineC + 1
            end
        end
        print(temp)
    end
    print("Mine count: " .. mineC)
end
