require "object/sprite"

Cell = Sprite:inherit()

function Cell:new(x, y, width, height, number, atlas)
    local cell = Sprite.new(self, x, y, width, height, atlas)
    cell.number = number
    return cell
end

function Cell:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
end