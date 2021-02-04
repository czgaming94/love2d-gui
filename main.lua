local gui = require("gui")
local myBox = gui:addBox("myBox")

function love.load()
	-- w | width
	-- h | height
	-- x
	-- y
	-- z
	-- color
	-- useBorder
	-- borderColor
	myBox:setData({w = 50, h = 50, x = 5, y = 10, color = {0,0,1,1}, useBorder = true, borderColor = {1,0,1,1}})
	-- This line can do the same as these 7. Order does not matter. Assosciative table required.
	
	--[[
		myBox:setWidth(50)
		myBox:setHeight(50)
		myBox:setX(5)
		myBox:setY(10)
		myBox:setColor({0,0,1,1})
		myBox:setUseBorder(true)
		myBox:setBorderColor({1,0,1,1})
	--]]
end

function love.update(dt)
	gui:update(dt)
end

function love.draw()
	gui:draw()
end