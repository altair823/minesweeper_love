require "common/object"

ClickTypeEnum = {
    LEFT = "left",
    RIGHT = "right",
    MOVE = "move"
}

ClickableTable = Object:inherit()

function ClickableTable:new(findFunction)
    local clickable = {}
    setmetatable(clickable, self)
    self.__index = self
    clickable.isActive = true
    clickable.leftClickRegistry = {}
    clickable.rightClickRegistry = {}
    clickable.findFunction = findFunction or nil
    return clickable
end

function ClickableTable:activate()
    self.isActive = true
end

function ClickableTable:deactivate()
    self.isActive = false
end

function ClickableTable:registerClick(clickType, sprite, callback)
    local registry = {}
    registry.sprite = sprite
    registry.callback = callback or nil
    if clickType == "left" then 
        if self.leftClickRegistry[registry.sprite.name] then
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

function ClickableTable:leftClicked(x, y)
    if not self.isActive then
        return
    end
    if self.findFunction then
        local name = self.findFunction(x, y)
        if name and self.leftClickRegistry[name] then
            if self.leftClickRegistry[name].callback then
                self.leftClickRegistry[name].callback()
            end
            self.leftClickRegistry[name].sprite:leftClicked()
            return
        end
    end
    for k, v in pairs(self.leftClickRegistry) do
        if x >= v.sprite.x and x <= v.sprite.x + v.sprite.width - 1
        and y >= v.sprite.y and y <= v.sprite.y + v.sprite.height - 1 then
            if v.callback then
                v.callback()
            end
            v.sprite:leftClicked()
        end
    end
end

function ClickableTable:rightClicked(x, y)
    if not self.isActive then
        return
    end
    if self.findFunction then
        local name = self.findFunction(x, y)
        if name and self.rightClickRegistry[name] then
            if self.rightClickRegistry[name].callback then
                self.rightClickRegistry[name].callback()
            end
            self.rightClickRegistry[name].sprite:rightClicked()
            return
        end
    end
    for k, v in pairs(self.rightClickRegistry) do
        if x >= v.sprite.x and x <= v.sprite.x + v.sprite.width - 1
        and y >= v.sprite.y and y <= v.sprite.y + v.sprite.height - 1 then
            if v.callback then
                v.callback()
            end
            v.sprite:rightClicked()
        end
    end
end