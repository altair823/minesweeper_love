require "common/object"

Sprite = Object:inherit()

function Sprite:new(x, y, width, height, atlas)
    local sprite = {}
    setmetatable(sprite, self)
    self.__index = self
    sprite.x = x
    sprite.y = y
    sprite.width = width
    sprite.height = height
    sprite.center = {x = x + width / 2, y = y + height / 2}
    sprite.quad = atlas.quad
    sprite.image = atlas.image
    return sprite
end

function Sprite:changeAtlas(width, height, atlas)
    self.width = width
    self.height = height
    self.center = {x = self.x + width / 2, y = self.y + height / 2}
    self.quad = atlas.quad
    self.image = atlas.image
end

function Sprite:leftClicked()
    assert(false, "leftClicked not implemented")
end

function Sprite:rightClicked()
    assert(false, "rightClicked not implemented")
end

function Sprite:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
end