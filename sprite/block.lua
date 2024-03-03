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
    o.isShown = true
    return o
end

function Block:draw()
    if self.isToggled then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    if self.isShown then
        love.graphics.draw(self.image, self.quad, self.x, self.y)
    end
    love.graphics.setColor(255, 255, 255)
end

function Block:toggle()
    self.isToggled = true
end

function Block:untoggle()
    self.isToggled = false
end

function Block:release()
    self.isToggled = false
    self.isShown = false
end