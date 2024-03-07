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
    registry.x = sprite.x
    registry.y = sprite.y
    registry.width = sprite.width
    registry.height = sprite.height
    registry.sprite = sprite
    registry.callback = callback or nil
    if clickType == "left" then
        table.insert(self.leftClickRegistry, registry)
    elseif clickType == "right" then
        table.insert(self.rightClickRegistry, registry)
    end
end

function ClickableTable:leftClicked(x, y)
    if not self.isActive then
        return
    end
    if self.findFunction then
        local index = self.findFunction(x, y)
        if index and self.leftClickRegistry[index] then
            if self.leftClickRegistry[index].callback then
                self.leftClickRegistry[index].callback()
            end
            self.leftClickRegistry[index].sprite:leftClicked()
            return
        end
    end
    for i=1, #self.leftClickRegistry do
        if x >= self.leftClickRegistry[i].x and x <= self.leftClickRegistry[i].x + self.leftClickRegistry[i].width - 1
        and y >= self.leftClickRegistry[i].y and y <= self.leftClickRegistry[i].y + self.leftClickRegistry[i].height - 1 then
            if self.leftClickRegistry[i].callback then
                self.leftClickRegistry[i].callback()
            end
            self.leftClickRegistry[i].sprite:leftClicked()
        end
    end
end

function ClickableTable:rightClicked(x, y)
    if not self.isActive then
        return
    end
    if self.findFunction then
        local index = self.findFunction(x, y)
        if index and self.rightClickRegistry[index] then
            if self.rightClickRegistry[index].callback then
                self.rightClickRegistry[index].callback()
            end
            self.rightClickRegistry[index].sprite:rightClicked()
            return
        end
    end
    for i=1, #self.rightClickRegistry do
        if x >= self.rightClickRegistry[i].x and x <= self.rightClickRegistry[i].x + self.rightClickRegistry[i].width - 1
        and y >= self.rightClickRegistry[i].y and y <= self.rightClickRegistry[i].y + self.rightClickRegistry[i].height - 1 then
            if self.rightClickRegistry[i].callback then
                self.rightClickRegistry[i].callback()
            end
            self.rightClickRegistry[i].sprite:rightClicked()
        end
    end
end