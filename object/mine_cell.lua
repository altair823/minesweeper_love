require "common/sprite"

MineCell = Sprite:inherit()

function MineCell:new(x, y, width, height, type, atlas, spriteTable)
    local cell = Sprite.new(self, x, y, width, height, atlas, spriteTable, "MineCell" .. x .. y)
    cell.type = type
    cell.value = type
    return cell
end
