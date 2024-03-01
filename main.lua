function love.load()
    image = love.graphics.newImage("resource/mine_block.png")
    love.graphics.setNewFont(12)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setBackgroundColor(255, 255, 255)
end

function love.update(dt)
    mx, my = love.mouse.getPosition()
end

function love.draw()
    love.graphics.draw(image, mx, my)
    love.graphics.print("Click and drag the cake around or use the arow keys", 10, 10)
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("This text is red", 100, 200)
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