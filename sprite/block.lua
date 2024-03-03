Block = {}

function Block:new(x, y, width, height, block_atlas)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.quad = assert(block_atlas.quad)
    o.image = assert(block_atlas.image)
    o.isClicked = false
    return o
end

function Block:draw()
    if self.isClicked then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    love.graphics.draw(self.image, self.quad, self.x, self.y)
    love.graphics.setColor(255, 255, 255)
end

function Block:clicked()
    self.isClicked = true
end

function Block:released()
    self.isClicked = false
end