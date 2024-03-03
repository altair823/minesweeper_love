require "object/sprite"

Number = Sprite:inherit()

function Number:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
end