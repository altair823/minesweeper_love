--[[
    SpriteTable class
    This class is used to store all the sprites and fonts used in the game. 
    It provides a simple way to add sprites and fonts and to rescale all the sprites and fonts.
]]--

require "common/object"

SpriteTable = {}

SpriteTable = Object:inherit()

--[[
    Constructor for the SpriteTable class
]]--
function SpriteTable:new()
    local spriteTable = {}
    setmetatable(spriteTable, self)
    self.__index = self
    spriteTable.sprites = {}
    spriteTable.fonts = {}
    return spriteTable
end

--[[
    Function to add a sprite to the sprite table
    sprite: sprite to be added
    name: name of the sprite
]]--
function SpriteTable:addSprite(sprite, name)
    self.sprites[name] = sprite
end

--[[
    Function to get a sprite from the sprite table
    name: name of the sprite
]]--
function SpriteTable:addFont(fontPath, name, defaultSize)
    self.fonts[name] = {fontPath = fontPath, defaultSize = defaultSize, font = love.graphics.newFont(fontPath, defaultSize)}
end

--[[
    Function to get a font from the sprite table
    name: name of the font
]]--
function SpriteTable:getFont(name)
    return self.fonts[name].font
end

--[[
    Function to rescale all the sprites and fonts in the sprite table
    width: new width of the window
    height: new height of the window
]]--
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