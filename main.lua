local GUI = require("gui")

local myGui = GUI:new(GUI)
local myGui2 = GUI:new(GUI)

local myBox = myGui:addBox("myBox")
local myBox2 = myGui:addBox("myBox2")

local myBox3 = myGui2:addBox("myBox3")
local myBox4 = myGui2:addBox("myBox4")

local colors = GUI.colors

function love.load()
	-- Add color to global GUI
	GUI:addColor({1,1,1,1}, "white")
	
	
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

	--[[
		myBox:setWidth(50)
		myBox:setHeight(50)
		myBox:setX(5)
		myBox:setY(10)
		myBox:setColor({0,0,1,1})
		myBox:setUseBorder(true)
		myBox:setBorderColor({1,0,1,1})
	--]]
	
	myBox2:setData({w = 250, h = 50, x = 105, y = 10, color = colors.green, useBorder = true, borderColor = colors.yellow})
	myBox3:setData({w = 100, h = 50, x = 105, y = 10, color = colors.yellow, useBorder = false})
	myBox4:setData({w = 50, h = 250, x = 105, y = 200, color = colors.purple, useBorder = true, borderColor = colors.yellow})
	
	myGui2:setZ(1)
	
	-- You can define onClick callbacks for your GUI elements
	function myBox2:onClick(button)
		print("Hello! I clicked.")
	end
	
	-- You can define onHoverEnter callbacks for your GUI elements
	function myBox:onHoverEnter()
		myBox:animateToColor(colors.white)
	end
	
	function myBox4:onHoverEnter()
		myBox4:animateToPosition(150, 64)
	end
	
	-- You can define onHoverExit callbacks for your GUI elements
	function myBox:onHoverExit()
		myBox:setColor(colors.red)
	end
end

function love.update(dt)
	-- Use global source for callbacks
	GUI:update(dt)
end

function love.draw()
	-- Use global source for callbacks
	GUI:draw()
end

function love.mousepressed(button)
	-- Use global source for callbacks
	GUI:mousepressed(button)
end