require "common/object"

SpriteTable = {}

SpriteTable = Object:inherit()

function SpriteTable:new()
    local spriteTable = {}
    setmetatable(spriteTable, self)
    self.__index = self
    spriteTable.sprites = {}
    spriteTable.fonts = {}
    return spriteTable
end

function SpriteTable:addSprite(sprite, name)
    self.sprites[name] = sprite
end

function SpriteTable:addFont(fontPath, name, defaultSize)
    self.fonts[name] = {fontPath = fontPath, defaultSize = defaultSize, font = love.graphics.newFont(fontPath, defaultSize)}
end

function SpriteTable:getFont(name)
    return self.fonts[name].font
end

function SpriteTable:resizeAllSprite(width, height)
    local defaultWindowSize = {width = DefaultWindowSize.width, height = DefaultWindowSize.height}
    local spriteRatio = 1
    if width / height > defaultWindowSize.width / defaultWindowSize.height then
        spriteRatio = height / defaultWindowSize.height
    else
        spriteRatio = width / defaultWindowSize.width
    end
    for k, v in pairs(self.sprites) do
        v:rescale(spriteRatio, spriteRatio)
    end
    for k, v in pairs(self.fonts) do
        v.font = love.graphics.newFont(v.fontPath, v.defaultSize * spriteRatio)
    end
end