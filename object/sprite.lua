Sprite = {}
Sprite.__index = Sprite

function Sprite:inherit()
    local cls = {}
    for k, v in pairs(self) do
        if k:find("__") == 1 then
            cls[k] = v
        end
    end
    cls.__index = cls
    cls.super = self
    setmetatable(cls, self)
    return cls
end
  
function Sprite:new(x, y, width, height, Atlas)
    local sprite = {}
    setmetatable(sprite, self)
    self.__index = self
    sprite.x = x
    sprite.y = y
    sprite.width = width
    sprite.height = height
    sprite.center = {x = x + width / 2, y = y + height / 2}
    sprite.quad = assert(Atlas.quad)
    sprite.image = assert(Atlas.image)
    return sprite
end