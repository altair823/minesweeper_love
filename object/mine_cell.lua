require "common/sprite"

MineCell = Sprite:inherit()

function MineCell:new(x, y, width, height, type, atlas, spriteTable, i, j)
    local cell = Sprite.new(self, x, y, width, height, atlas, spriteTable, "MineCell" .. i .. j)
    cell.type = type
    cell.value = type
    return cell
end
