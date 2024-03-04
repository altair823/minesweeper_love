require "object/sprite"

Block = Sprite:inherit()

function Block:new(x, y, width, height, defaultAtlas, flagAtlas)
    local block = Sprite.new(self, x, y, width, height, defaultAtlas)
    block.isToggled = false
    block.isShown = true
    block.isFlagged = false
    block.defaultAtlas = defaultAtlas
    block.flagAtlas = flagAtlas
    return block
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

function Block:leftClicked()
    self.isToggled = false
    self.isShown = false
end

function Block:rightClicked()
    if self.isFlagged then
        self.isFlagged = false
        self:changeAtlas(self.width, self.height, self.defaultAtlas)
    else
        self.isFlagged = true
        self:changeAtlas(self.width, self.height, self.flagAtlas)
    end
end