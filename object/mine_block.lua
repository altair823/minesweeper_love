require "object/sprite"

MineBlock = Sprite:inherit()

function MineBlock:new(x, y, width, height, defaultAtlas, flagAtlas)
    local block = Sprite.new(self, x, y, width, height, defaultAtlas)
    block.isToggled = false
    block.isShown = true
    block.isFlagged = false
    block.defaultAtlas = defaultAtlas
    block.flagAtlas = flagAtlas
    return block
end

function MineBlock:draw()
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

function MineBlock:toggle()
    self.isToggled = true
end

function MineBlock:untoggle()
    self.isToggled = false
end

function MineBlock:leftClicked()
    self.isToggled = false
    self.isShown = false
end

function MineBlock:rightClicked()
    if self.isFlagged then
        self.isFlagged = false
        self:changeAtlas(self.width, self.height, self.defaultAtlas)
    else
        self.isFlagged = true
        self:changeAtlas(self.width, self.height, self.flagAtlas)
    end
end