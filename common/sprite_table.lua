require "common/object"

SpriteTable = {}

SpriteTable = Object:inherit()

function SpriteTable:new()
    local spriteTable = {}
    setmetatable(spriteTable, self)
    self.__index = self
    spriteTable.sprites = {}
    return spriteTable
end

function SpriteTable:addSprite(sprite, name)
    self.sprites[name] = sprite
end

function SpriteTable:resizeAllSprite(width, height)
    local defaultWindowSize = {width = 1024, height = 700}
    local spriteRatio = 1
    if width / height > defaultWindowSize.width / defaultWindowSize.height then
        spriteRatio = height / defaultWindowSize.height
    else
        spriteRatio = width / defaultWindowSize.width
    end
    for k, v in pairs(self.sprites) do
        v:rescale(spriteRatio, spriteRatio)
    end
end