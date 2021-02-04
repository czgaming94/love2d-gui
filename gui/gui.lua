local button = require("gui.button")
local box = require("gui.box")
local text = require("gui.text")

local gui = {}

gui.items = {}

function gui:new(o)
	o = o or {}
	setmetatable(o, self)
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

return gui