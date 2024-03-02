require "sprite/block"
img = love.graphics.newImage("resource/mine_block.png")

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setBackgroundColor(255, 255, 255)
end

a = {image = img, quad = love.graphics.newQuad(0, 0, 32, 32, img)}

function love.draw()
    blocks = {}
    for i=1, 10 do
        for j=1, 10 do
            blocks[i] = Block:new(i*32, j*32, a)
            blocks[i]:draw()
        end
    end

end

function love.mousemoved(x, y, button, istouch)
    if button == 1 then
        imgx = x
        imgy = y
    end
end

function love.quit()
    print("Bye...")
end