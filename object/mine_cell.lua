--[[
    MineCell class
    This class is used to represent a cell in the mine board under the block.
]]--

require "common/sprite"

MineCell = Sprite:inherit()

function MineCell:new(x, y, width, height, value, atlas, spriteTable, i, j)
    local cell = Sprite.new(self, x, y, width, height, atlas, spriteTable, "MineCell" .. i .. " " .. j)
    cell.value = value -- Value of the cell
    return cell
end
