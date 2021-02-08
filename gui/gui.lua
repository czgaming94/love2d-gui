local box = require("gui.box")
local checkbox = require("gui.checkbox")
local dropdown = require("gui.dropdown")
local text = require("gui.text")
local textfield = require("gui.textfield")
local toggle = require("gui.toggle")

local gui = {}

local items = {}

gui.items = {}
gui.z = 0

gui.colors = {
	red = {1,0,0,1},
	green = {0,1,0,1},
	blue = {0,0,1,1},
	yellow = {1,1,0,1},
	purple = {1,0,1,1}
}

function gui:new(item)
	local newGUI = self:generate(item)
	newGUI.id = #items
	items[#items + 1] = newGUI
	return newGUI
end

function gui:generate(item)
	local copies = {}
    local copy
    if type(item) == 'table' then
        if copies[item] then
            copy = copies[item]
        else
            copy = {}
            copies[item] = copy
            for orig_key, orig_value in next, item, nil do
                copy[self:generate(orig_key, copies)] = self:generate(orig_value, copies)
            end
            setmetatable(copy, self:generate(getmetatable(item), copies))
        end
    else
        copy = item
    end
    return copy
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

function gui:addCheckbox(n)
	assert(n, "FAILURE: gui:addCheckbox() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addCheckbox() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = checkbox:new(n, id)
	return self.items[id]
end

function gui:removeCheckbox(n)

end

function gui:addDropdown(n)
	assert(n, "FAILURE: gui:addDropdown() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addDropdown() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = dropdown:new(n, id)
	return self.items[id]
end

function gui:removeDropdown(n)

end

function gui:addTextfield(n)
	assert(n, "FAILURE: gui:addTextfield() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addTextfield() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = textfield:new(n, id)
	return self.items[id]
end

function gui:removeTextfield(n)

end

function gui:addToggle(n)
	assert(n, "FAILURE: gui:addToggle() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addToggle() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = toggle:new(n, id)
	return self.items[id]
end

function gui:addToggle(n)

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
	for _,v in ipairs(items) do 
		for _,i in ipairs(v.items) do 
			i:update(dt) 
		end 
	end
end

function gui:draw()
	table.sort(items, function(a, b) return a.z < b.z end)
	for _,v in ipairs(items) do
		table.sort(v.items, function(a, b) return a.pos.z < b.pos.z end)
		for _,i in ipairs(v.items) do 
			i:draw(dt) 
		end
	end
end

function gui:mousepressed(button)
	local x,y = love.mouse.getPosition()
	local guis = self:generate(items)
	table.sort(guis, function(a, b) return a.z > b.z end)
	local hitTarget = false
	for _,v in ipairs(guis) do
		for k,i in ipairs(v.items) do
			if (x >= i.pos.x and x <= i.pos.x + i.w) and (y >= i.pos.y and y <= i.pos.y + i.h) then
				if not hitTarget then 
					if i.clickable then
						if i.onClick then 
							i:onClick(button)
						end
						hitTarget = true
					end
				end
			end
		end
	end
	guis = nil
end

function gui:setZ(z)
	assert(z, "FAILURE: gui:setZ() :: Missing param[z]")
	assert(type(z) == "number", "FAILURE: gui:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
	self.z = z
end

return gui