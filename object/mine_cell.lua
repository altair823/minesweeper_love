require "object/sprite"

MineCell = Sprite:inherit()

function MineCell:new(x, y, width, height, type, atlas)
    local cell = Sprite.new(self, x, y, width, height, atlas)
    cell.type = type
    cell.value = type
    return cell
end
