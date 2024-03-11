--[[
    Sprite class
    This class is the base class for all sprites in the game. It is a wrapper for the love.graphics.draw function.
    It provides a simple way to draw sprites and to handle mouse events.
    It also provides a simple way to scale sprites.
    It is inherited from the Object class.
]]--
require "common/object"
require "common/sprite_table"

Sprite = Object:inherit()

--[[
    Constructor for the Sprite class
    x: x position of the sprite
    y: y position of the sprite
    width: width of the sprite
    height: height of the sprite
    atlas: initial atlas of the sprite
    spriteTable: sprite table to add the sprite for scaling
    name: name of the sprite - string
]]--
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
    sprite.name = name
    spriteTable:addSprite(sprite, sprite.name)
    return sprite
end

--[[
    Function to change the atlas of the sprite
    width: new width of the atlas
    height: new height of the atlas
]]--
function Sprite:changeAtlas(width, height, atlas)
    self.width = width
    self.height = height
    self.center = {x = self.x + width / 2, y = self.y + height / 2}
    self.quad = atlas.quad
    self.image = atlas.image
end

--[[
    Function to rescale the sprite
    xScale: new x scale
    yScale: new y scale
]]--
function Sprite:rescale(xScale, yScale)
    self.scale.x = xScale
    self.scale.y = yScale
    self.width = self.originalWidth * xScale
    self.height = self.originalHeight * yScale
    self.x = self.originalX * xScale
    self.y = self.originalY * yScale
    self.center = {x = self.x + self.width / 2, y = self.y + self.height / 2}
end

--[[
    Function to check if the sprite is clicked
]]--
function Sprite:leftClicked()
    assert(false, "leftClicked not implemented")
end

--[[
    Function to check if the sprite is right clicked
]]--
function Sprite:rightClicked()
    assert(false, "rightClicked not implemented")
end

--[[
    Function to draw the sprite
]]--
function Sprite:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y, 0, self.scale.x, self.scale.y)
end