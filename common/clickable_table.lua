--[[
    ClickableTable class
    This class is used to handle click events on sprites. It is used to register sprites and their click events.
    It provides a simple way to register left and right click events on sprites.
    It also provides a simple way to activate and deactivate the click events.
]]--

require "common/object"

function convertAbsoluteToWindowCentered(x, y)
    print(x, y)
    print(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    return x - love.graphics.getWidth() / 2, y - love.graphics.getHeight() / 2
end

ClickTypeEnum = {
    LEFT = "left",
    RIGHT = "right"
}

ClickableTable = Object:inherit()

--[[
    Constructor for the ClickableTable class
    findFunction(optional): function to find the sprite from the x and y position. If not provided, the table will find the sprite by linear search.
]]--
function ClickableTable:new(findFunction)
    local clickable = {}
    setmetatable(clickable, self)
    self.__index = self
    clickable.isActive = false
    clickable.leftClickRegistry = {}
    clickable.rightClickRegistry = {}
    clickable.findFunction = findFunction or nil
    return clickable
end

--[[
    Function to activate the click events
]]--
function ClickableTable:activate()
    self.isActive = true
end

--[[
    Function to deactivate the click events
]]--
function ClickableTable:deactivate()
    self.isActive = false
end

--[[
    Function to register a click event
    clickType: type of the click event - string
    sprite: sprite to register the click event
    callback(optional): callback function to be called when the sprite is clicked. 
        If not provided, the leftClicked or rightClicked function of the sprite will be called.
]]--
function ClickableTable:registerClick(clickType, sprite, callback)
    local registry = {}
    registry.sprite = sprite
    registry.callback = callback or nil
    if clickType == "left" then 
        if self.leftClickRegistry[registry.sprite.name] then
            -- There is only one sprite with the same name in the clickabletable
            assert(false, "Left click for " .. registry.sprite.name .. " already registered")
        else
            self.leftClickRegistry[registry.sprite.name] = registry
        end
    elseif clickType == "right" then
        if self.rightClickRegistry[registry.sprite.name] then
            assert(false, "Right click for " .. registry.sprite.name .. " already registered")
        else
            self.rightClickRegistry[registry.sprite.name] = registry
        end
    end
end

--[[
    Function to handle left click event
    x: x position of the click
    y: y position of the click
]]--
function ClickableTable:leftClicked(x, y)
    if not self.isActive then
        return
    end
    -- If findFunction is provided, use it to find the sprite.
    if self.findFunction then
        local name = self.findFunction(x, y)
        if name and self.leftClickRegistry[name] then
            if self.leftClickRegistry[name].callback then
                self.leftClickRegistry[name].callback()
            else
                self.leftClickRegistry[name].sprite:leftClicked()
            end
            return
        end
    end
    -- If findFunction is not provided, use linear search to find the sprite.
    for k, v in pairs(self.leftClickRegistry) do
        if x >= v.sprite.x and x <= v.sprite.x + v.sprite.width - 1
        and y >= v.sprite.y and y <= v.sprite.y + v.sprite.height - 1 then
            if v.callback then
                v.callback()
            else
                v.sprite:leftClicked()
            end
        end
    end
end

--[[
    Function to handle right click event
    x: x position of the click
    y: y position of the click
]]--
function ClickableTable:rightClicked(x, y)
    if not self.isActive then
        return
    end
    if self.findFunction then
        local name = self.findFunction(x, y)
        if name and self.rightClickRegistry[name] then
            if self.rightClickRegistry[name].callback then
                self.rightClickRegistry[name].callback()
            else
                self.rightClickRegistry[name].sprite:rightClicked()
            end
            return
        end
    end
    for k, v in pairs(self.rightClickRegistry) do
        if x >= v.sprite.x and x <= v.sprite.x + v.sprite.width - 1
        and y >= v.sprite.y and y <= v.sprite.y + v.sprite.height - 1 then
            if v.callback then
                v.callback()
            else
                v.sprite:rightClicked()
            end
        end
    end
end