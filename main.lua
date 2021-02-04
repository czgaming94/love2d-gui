local gui = require("gui")
local myBox = gui:addBox("myBox")
local myBox2 = gui:addBox("myBox2")
local colors = gui.colors

function love.load()
	-- w | width
	-- h | height
	-- x
	-- y
	-- z
	-- color
	-- useBorder
	-- borderColor
	myBox:setData({w = 50, h = 50, x = 5, y = 10, color = colors.red, useBorder = true, borderColor = colors.purple})
	-- This line can do the same as these 7. Order does not matter. Assosciative table required.
	
	
	myBox2:setData({w = 250, h = 50, x = 105, y = 10, color = colors.green, useBorder = true, borderColor = colors.yellow})
	
	-- You can define onClick callbacks for your GUI elements
	function myBox2:onClick(button)
		print("Hello! I clicked.")
	end
	
	-- You can define onHoverEnter callbacks for your GUI elements
	function myBox:onHoverEnter()
		myBox:setColor(colors.blue)
	end
	
	
	-- You can define onHoverExit callbacks for your GUI elements
	function myBox:onHoverExit()
		myBox:setColor(colors.red)
	end
	
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

function love.mousepressed(button)
	gui:mousepressed(button)
end