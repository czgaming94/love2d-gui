local box = require("gui.box")
local checkbox = require("gui.checkbox")
local dropdown = require("gui.dropdown")
local text = require("gui.text")
local textfield = require("gui.textfield")
local toggle = require("gui.toggle")

local gui = {}

local items = {}

local colors = {
	red = {1,0,0,1},
	green = {0,1,0,1},
	blue = {0,0,1,1},
	yellow = {1,1,0,1},
	purple = {1,0,1,1}
}

gui.items = {}
gui.z = 0
gui.use255 = false


gui.images = {}

function gui.color(c)
	assert(c, "FAILURE: gui:color() :: Missing param[name]")
	assert(type(c) == "string", "FAILURE: gui:color() :: Incorrect param[name] - expecting string and got " .. type(c))
	return gui:generate(colors[c])
end

function gui:new(item)
	local new = self:generate(item)
	new.id = #items
	items[#items + 1] = new
	return new
end

function gui:copy(item, skip)
    local c
    if type(item) == "table" then
        c = {}
        for orig_key, orig_value in pairs(item) do
			if skip and orig_key == skip then
				c[orig_key] = {}
			else
				c[orig_key] = orig_value
			end
		end
    else
        c = item
    end
    return c
end

function gui:generate(item, copies, skip)
	local copies = copies or {}
    local copy
    if type(item) == 'table' then
        if copies[item] then
            copy = copies[item]
        else
            copy = {}
            copies[item] = copy
            for orig_key, orig_value in next, item, nil do
				if skip and orig_key == skip then
					copy[skip] = {}
				else
					copy[self:generate(orig_key, copies)] = self:generate(orig_value, copies)
				end
            end
            setmetatable(copy, self:generate(getmetatable(item), copies))
        end
    else
        copy = item
    end
    return copy
end

function gui:setUse255(u)
	assert(u ~= nil, "FAILURE: gui:setUse255() :: Missing param[use255]")
	assert(type(o) == "boolean", "FAILURE: gui:setUse255() :: Incorrect param[use255] - expecting boolean and got " .. type(o))
	self.use255 = u
end

function gui:animateToColor(o, c, s)
	assert(o, "FAILURE: gui:animateToColor() :: Missing param[object]")
	assert(type(o) == "table", "FAILURE: gui:animateToColor() :: Incorrect param[object] - expecting table and got " .. type(o))
	assert(c, "FAILURE: gui:animateToColor() :: Missing param[color]")
	assert(type(c) == "table", "FAILURE: gui:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
	assert(#c > 2, "FAILURE: gui:animateToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c)
	s = s or 2
	assert(type(s) == "number", "FAILURE: gui:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
	o.colorToAnimateTo = c
	o.colorAnimateSpeed = s
	o.colorAnimateTime = lt.getTime()
	o.inAnimation = true
	o.animateColor = true
end

function gui:animateBorderToColor(o, c, s)
	assert(o, "FAILURE: gui:animateToColor() :: Missing param[object]")
	assert(type(o) == "table", "FAILURE: gui:animateToColor() :: Incorrect param[object] - expecting table and got " .. type(o))
	assert(c, "FAILURE: gui:animateBorderToColor() :: Missing param[color]")
	assert(type(c) == "table", "FAILURE: gui:animateBorderToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
	assert(#c > 2, "FAILURE: gui:animateBorderToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c)
	s = s or 2
	assert(type(s) == "number", "FAILURE: gui:animateBorderToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
	o.borderColorToAnimateTo = c
	o.borderColorAnimateSpeed = s
	o.borderColorAnimateTime = lt.getTime()
	o.inAnimation = true
	o.animateBorderColor = true
end
	
function gui:animateToPosition(o, x, y, s)
	assert(o, "FAILURE: gui:animateToPosition() :: Missing param[object]")
	assert(type(o) == "table", "FAILURE: gui:animateToPosition() :: Incorrect param[object] - expecting table and got " .. type(o))
	assert(x, "FAILURE: gui:animateToPosition() :: Missing param[x]")
	assert(type(x) == "number", "FAILURE: gui:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
	assert(y, "FAILURE: gui:animateToPosition() :: Missing param[y]")
	assert(type(y) == "number", "FAILURE: gui:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
	s = s or 2
	assert(type(s) == "number", "FAILURE: gui:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
	for k,v in pairs(o.pos) do o.positionToAnimateFrom[k] = v end
	o.positionToAnimateTo = {x = x, y = y}
	o.positionAnimateSpeed = s
	o.positionAnimateTime = lt.getTime()
	o.inAnimation = true
	o.animatePosition = true
end

function gui:animateToOpacity(obj, o, s)
	assert(obj, "FAILURE: gui:animateToColor() :: Missing param[object]")
	assert(type(obj) == "table", "FAILURE: gui:animateToColor() :: Incorrect param[object] - expecting table and got " .. type(obj))
	assert(o, "FAILURE: gui:animateToOpacity() :: Missing param[o]")
	assert(type(o) == "number", "FAILURE: gui:animateToOpacity() :: Incorrect param[o] - expecting number and got " .. type(o))
	s = s or 1
	assert(s, "FAILURE: gui:animateToOpacity() :: Missing param[s]")
	assert(type(s) == "number", "FAILURE: gui:animateToOpacity() :: Incorrect param[s] - expecting number and got " .. type(s))
	obj.opacityToAnimateTo = o
	obj.opacityAnimateTime = lt.getTime()
	obj.opacityAnimateSpeed = s
	obj.inAnimation = true
	obj.animateOpacity = true
end

function gui:addColor(c, n)
	assert(c, "FAILURE: gui:addColor() :: Missing param[color]")
	assert(type(c) == "table", "FAILURE: gui:addColor() :: Incorrect param[color] - expecting table and got " .. type(c))
	assert(#c > 2, "FAILURE : gui:addColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c)
	assert(n, "FAILURE: gui:addColor() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addColor() :: Incorrect param[name] - expecting string and got " .. type(n))
	colors[n] = c
end

function gui:addBox(n)
	assert(n, "FAILURE: gui:addBox() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addBox() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = box:new(n, self)
	return self.items[id]
end

function gui:addCheckbox(n)
	assert(n, "FAILURE: gui:addCheckbox() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addCheckbox() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = checkbox:new(n, self)
	return self.items[id]
end

function gui:addDropdown(n)
	assert(n, "FAILURE: gui:addDropdown() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addDropdown() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = dropdown:new(n, self)
	return self.items[id]
end

function gui:addImage(i, n)
	assert(i, "FAILURE: gui:addImage() :: Missing param[img]")
	assert(type(i) == "userdata", "FAILURE: gui:addImage() :: Incorrect param[img] - expecting image userdata and got " .. type(i))
	assert(n, "FAILURE gui:addImage() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addImage() :: Incorrect param[img] - expecting string and got " .. type(n))
	self.images[n] = i
end

function gui:addTextfield(n)
	assert(n, "FAILURE: gui:addTextfield() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addTextfield() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = textfield:new(n, self)
	return self.items[id]
end

function gui:addToggle(n)
	assert(n, "FAILURE: gui:addToggle() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addToggle() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = toggle:new(n, self)
	return self.items[id]
end

function gui:addText(n)
	assert(n, "FAILURE: gui:addText() :: Missing param[name]")
	assert(type(n) == "string", "FAILURE: gui:addText() :: Incorrect param[name] - expecting string and got " .. type(n))
	local id = #self.items + 1
	self.items[id] = text:new(n, self)
	return self.items[id]
end

function gui:update(dt)
	for _,v in ipairs(items) do 
		for _,i in ipairs(v.items) do 
			if not i.hidden then i:update(dt) end
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
	local objs = self:generate(items)
	table.sort(objs, function(a, b) return a.z > b.z end)
	local hitTarget = false
	for o,v in ipairs(objs) do
		for k,i in ipairs(v.items) do
			if not i.hidden and not i.faded then 
				if (x >= i.pos.x + i.paddingLeft and x <= (i.pos.x + i.w) - i.paddingRight) and 
				(y >= i.pos.y + i.paddingTop and y <= (i.pos.y + i.h) - i.paddingBottom) then
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
	end
	objs = nil
end

function gui:remove(n)
	assert(n, "FAILURE: gui:remove() :: Missing param[name]")
	if type(n) ~= "string" and type(n) ~= "number" then
		error("FAILURE: gui:remove() :: Incorrect param[name] - expecting string or number and got " .. type(n))
	end
	
	if type(n) == "string" then
		for k,v in ipairs(self.items) do
			if v.name == n then 
				self.items[k] = nil
			end
		end
	else
		self.items[n] = nil
	end
end

function gui:setZ(z)
	assert(z, "FAILURE: gui:setZ() :: Missing param[z]")
	assert(type(z) == "number", "FAILURE: gui:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
	self.z = z
end

return gui