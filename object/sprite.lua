require "object/object"

Sprite = Object:inherit()

function Object:new(x, y, width, height, atlas)
    local sprite = {}
    setmetatable(sprite, self)
    self.__index = self
    sprite.x = x
    sprite.y = y
    sprite.width = width
    sprite.height = height
    sprite.center = {x = x + width / 2, y = y + height / 2}
    sprite.quad = assert(atlas.quad)
    sprite.image = assert(atlas.image)
    return sprite
end