require "common/object"
require "common/sprite_table"

Sprite = Object:inherit()

function Sprite:new(x, y, width, height, atlas, spriteTable, name)
    local sprite = {}
    setmetatable(sprite, self)
    self.__index = self
    sprite.originalX = x
    sprite.originalY = y
    sprite.x = x
    sprite.y = y
    sprite.originalWidth = width
    sprite.originalHeight = height
    sprite.width = width
    sprite.height = height
    sprite.center = {x = x + width / 2, y = y + height / 2}
    sprite.quad = atlas.quad
    sprite.image = atlas.image
    sprite.scale = {x = 1, y = 1}
    spriteTable:addSprite(sprite, name)
    return sprite
end

function Sprite:changeAtlas(width, height, atlas)
    self.width = width
    self.height = height
    self.center = {x = self.x + width / 2, y = self.y + height / 2}
    self.quad = atlas.quad
    self.image = atlas.image
end

function Sprite:rescale(xScale, yScale)
    self.scale.x = xScale
    self.scale.y = yScale
    self.width = self.originalWidth * xScale
    self.height = self.originalHeight * yScale
    self.x = self.originalX * xScale
    self.y = self.originalY * yScale
    self.center = {x = self.x + self.width / 2, y = self.y + self.height / 2}
end

function Sprite:leftClicked()
    assert(false, "leftClicked not implemented")
end

function Sprite:rightClicked()
    assert(false, "rightClicked not implemented")
end

function Sprite:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y, 0, self.scale.x, self.scale.y)
end