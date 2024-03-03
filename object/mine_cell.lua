require "object/sprite"

Cell = Sprite:inherit()

function Cell:new(x, y, width, height, type, atlas)
    local cell = Sprite.new(self, x, y, width, height, atlas)
    cell.type = type
    return cell
end

function Cell:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
end