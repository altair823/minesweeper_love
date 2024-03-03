require "object/sprite"

Block = Sprite:inherit()

Block.isToggled = false
Block.isShown = true

function Block:draw()
    if self.isToggled then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    if self.isShown then
        love.graphics.draw(self.image, self.quad, self.x, self.y)
    end
    love.graphics.setColor(255, 255, 255)
end

function Block:toggle()
    self.isToggled = true
end

function Block:untoggle()
    self.isToggled = false
end

function Block:release()
    self.isToggled = false
    self.isShown = false
end