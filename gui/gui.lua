local button = require("gui.button")
local box = require("gui.box")
local text = require("gui.text")

local gui = {}

gui.items = {}

gui.colors = {
	red = {1,0,0,1},
	green = {0,1,0,1},
	blue = {0,0,1,1},
	yellow = {1,1,0,1},
	purple = {1,0,1,1}
}

function gui:new(o)
	o = o or {}
	setmetatable(o, self)
end

function gui:addColor(c, n)
	assert(c, "FAILURE: gui:addColor() :: Missing param[color]")
	assert(type(c) == "table", "FAILURE: gui:addColor() :: Incorrect param[color] - expecting table and got " .. type(c))
	assert(n, "FAILURE: gui:addColor() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addColor() :: Incorrect param[name] - expecting string and got " .. type(n))
	self.colors[n] = c
end

function gui:addBox(n)
	assert(n, "FAILURE: gui:addBox() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addBox() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = box:new(n, id)
	return self.items[id]
end

function gui:removeBox(n)
	
end

function gui:addButton(n)
	assert(n, "FAILURE: gui:addButton() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addButton() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = button:new(n, id)
	return self.items[id]
end

function gui:removeButton(n)
end

function gui:addText(n)
	assert(n, "FAILURE: gui:addText() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addText() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = text:new(n, id)
	return self.items[id]
end

function gui:removeText(n)

end

function gui:update(dt)
	for _,i in ipairs(self.items) do i:update(dt) end
end

function gui:draw()
	for _,i in ipairs(self.items) do i:draw(dt) end
end

function gui:mousepressed(button)
	for _,i in ipairs(self.items) do
		if i.onClick then 
			local x,y = love.mouse.getPosition()
			if (x >= i.x and x <= i.x + i.w) and (y >= i.y and y <= i.y + i.h) then
				i:onClick(button) 
			end
		end
	end
end

return gui