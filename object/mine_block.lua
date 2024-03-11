--[[
    MineBlock class
    This class is used to represent a single block that covers a single cell in the minefield.
    It inherits from the Sprite class and adds some additional functionality
    to handle the block state and the block's position in the minefield.
]]--

require "common/sprite"
-- Values for block state
BlockEnum = {
    DEFAULT = 1, -- Block is not flagged
    FLAG = 2 -- Block is flagged
}

MineBlock = Sprite:inherit()

--[[
    Constructor for the MineBlock class
    x: x position of the block
    y: y position of the block
    width: width of the block
    height: height of the block
    defaultAtlas: atlas for the block when it is not flagged
    flagAtlas: atlas for the block when it is flagged
    spriteTable: sprite table to add the block for scaling
    i: x index of the block in the minefield
    j: y index of the block in the minefield
]]--
function MineBlock:new(x, y, width, height, defaultAtlas, flagAtlas, spriteTable, i, j)
    local block = Sprite.new(self, x, y, width, height, defaultAtlas, spriteTable, "MineBlock" .. i .. " " .. j)
    block.i = i
    block.j = j
    block.isToggled = false
    block.isShown = true
    block.isFlagged = false
    block.defaultAtlas = defaultAtlas
    block.flagAtlas = flagAtlas
    return block
end

--[[
    Function to draw the block
]]--
function MineBlock:draw()
    if self.isToggled then
        love.graphics.setColor(255, 0, 0)
    end
    if self.isShown then
        self.super.draw(self)
    end
    love.graphics.setColor(255, 255, 255)
end

--[[
    Function to toggle the block
]]--
function MineBlock:toggle()
    self.isToggled = true
end

--[[
    Function to untoggle the block
]]--
function MineBlock:untoggle()
    self.isToggled = false
end

--[[
    Function to open the block
]]--
function MineBlock:open()
    if self.isFlagged then
        return
    end
    self.isToggled = false
    self.isShown = false
end

--[[
    Function to handle right click on the block
]]--
function MineBlock:toggleFlag()
    if not self.isShown then
        return
    end
    if self.isFlagged then
        self.isFlagged = false
        self:changeAtlas(self.width, self.height, self.defaultAtlas)
    else
        self.isFlagged = true
        self:changeAtlas(self.width, self.height, self.flagAtlas)
    end
end
