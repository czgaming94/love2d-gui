local gui = require("gui")
local myBox = gui:addBox("myBox")

function love.load()
	myBox:setWidth(50)
	myBox:setHeight(50)
	myBox:setX(5)
	myBox:setY(10)
	myBox:setColor({0,0,1,1})
	myBox:setUseBorder(true)
	myBox:setBorderColor({1,0,1,1})
end

function love.update(dt)
	gui:update(dt)
end

function love.draw()
	gui:draw()
end