Board = {}

function Board:new(x, y, width, height, board_atlas)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.center = {x = x + width / 2, y = y + height / 2}
    print("Board center at (" .. o.center.x .. ", " .. o.center.y .. ")")
    o.quad = assert(board_atlas.quad)
    o.image = assert(board_atlas.image)
    o.canvas = love.graphics.newCanvas(1024, 1024)
    return o
end

function Board:setBlockMatrix(xCount, yCount, block_atlas, width, height)
    self.xCount = xCount
    self.yCount = yCount
    self.blockMatrix = {}
    for i=1, xCount do
        self.blockMatrix[i] = {}
        for j=1, yCount do
            -- blocks located at center of the board_image. i and j are 1-based indeices
            local blockX = self.center.x - (self.xCount * width) / 2 + (i - 1) * width
            local blockY = self.center.y - (self.yCount * height) / 2 + (j - 1) * height
            self.blockMatrix[i][j] = Block:new(blockX, blockY, width, height, block_atlas)
        end
    end
end

function Board:update()
        
end

function Board:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.setColor(255,255,255)
    love.graphics.push()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
    self:draw_blocks()
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

function Board:draw_blocks()
    for i=1, #self.blockMatrix do
        for j=1, #self.blockMatrix[i] do
            self.blockMatrix[i][j]:draw()
        end
    end
end