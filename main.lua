local GUI = require("gui")
local lg = love.graphics

-- Create GUI instances
-- Doing this allows you to change settings between the two GUI's
local myGui = GUI:new(GUI)
local myGui2 = GUI:new(GUI)

local myBox = myGui:addBox("myBox")
local myBox2 = myGui:addBox("myBox2")

local myBox3 = myGui2:addBox("myBox3")
local myBox4 = myGui2:addBox("myBox4")

local colors = GUI.color

function love.load()
	-- Add color to global GUI
	GUI:addColor({1,1,1,1}, "white")
	GUI:addColor({0,0,0,1}, "black")
	GUI:addColor({0,0,0,0}, "empty")
	
	-- Add images to your box, easily.
	-- image (userdata)
	-- name (string)
	-- default (boolean)
	myBox:addImage(lg.newImage("res/img/background.png"), "background")
	
	-- [PARAMS]
	-- borderColor  (table)
	-- clickable    (boolean)
	-- color        (table)
	-- h | height   (number)
	-- image        (string)
	-- opacity      (number)
	-- padding      (numbers)(top, right, bottom, left)
	-- useBorder    (boolean)
	-- w | width    (number)
	-- x            (number)
	-- y            (number)
	-- z            (number)
	myBox:setData({w = 800, h = 600, x = 0, y = 0, z = 0, image = "background"})
	-- This line can do the same as these 12. Order does not matter. Assosciative table required.

	--[[
		myBox:setBorderColor({1,0,1,1})
		myBox:setClickable(false)
		myBox:setColor({0,0,1,1})
		myBox:setHeight(50)
		myBox:setImage(love.graphics.newImage("path/to/image.png"))
		myBox:setOpacity(0.5)
		myBox:setPadding(0,5,0,5)
		myBox:setUseBorder(true)
		myBox:setWidth(50)
		myBox:setX(5)
		myBox:setY(10)
		myBox:setZ(2)
	--]]
	
	-- You can disable whether or not a box is read as a clickable object.
	-- Clicks will pass through this object.
	myBox:setClickable(false)
	
	myBox2:setData({w = 250, h = 50, x = 105, y = 10, color = colors("green"), useBorder = true, borderColor = colors("yellow")})
	myBox3:setData({w = 100, h = 50, x = 105, y = 10, color = colors("yellow"), useBorder = false})
	myBox4:setData({w = 50, h = 250, x = 105, y = 200, color = colors("purple"), useBorder = true, borderColor = colors("blue")})
	
	
	-- You can change the Z index of an entire GUI container, or just a single object
	myGui2:setZ(1)
	
	-- You can define onClick callbacks for your GUI elements
	function myBox2:onClick(button)
		print("Hello! I clicked.")
	end
	
	-- You can define onHoverEnter callbacks for your GUI elements
	function myBox3:onHoverEnter()
		-- You can animate your objects to a new color
		myBox3:animateToColor(colors("white"))
	end
	
	function myBox4:onHoverEnter()
		-- You can animate your objects to a new position
		-- x
		-- y
		-- speed
		myBox4:animateToPosition(150, 64, 1)
	end
	
	function myBox4:onHoverExit()
		myBox4:stopAnimation()
	end
	
	-- You can define onHoverExit callbacks for your GUI elements
	function myBox3:onHoverExit()
		myBox3:animateToColor(colors("red"))
	end
	
	function myBox3:onClick()
		-- You can make an object fade in or out, and also disable the object by using (true)
		-- :fadeIn() will automatically restore an object to update status
		myBox3:fadeOut(true)
	end
	
	-- You can define onFadeOut callbacks for your GUI elements
	function myBox3:onFadeOut()
		print(1)
	end
	
	-- You can define onFadeIn callbacks for your GUI elements
	function myBox3:onFadeIn()
		print(2)
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