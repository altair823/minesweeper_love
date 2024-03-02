Block = {}

function Block:new(x, y, block_image)
    self.block = {}
    self.block.x = x
    self.block.y = y
    self.block.quad = block_image.quad
    self.block.image = block_image.image
    setmetatable(self, Block)
    return self
end

function Block:draw()
    love.graphics.draw(self.block.image, self.block.quad, self.block.x, self.block.y)
end