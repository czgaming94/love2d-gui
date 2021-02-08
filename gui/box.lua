local timer = require("gui.timer")
local lg = love.graphics
local min, max = math.min, math.max
local box = {}

box.items = {}

function box:new(n, id)
	local b = {}
	
	b.name = n
	b.id = #self.items + 1
	b.parent = id
	b.w = 0
	b.h = 0
	b.x = 0
	b.y = 0
	b.z = 0
	b.border = false
	b.borderColor = {1,1,1,1}
	b.color = {1,1,1,1}
	b.hovered = false
	b.clicked = false
	b.image = nil
	
	function b:animateToColor(c, s)
		assert(c, "FAILURE: box:animateToColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: box:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c == 4, "FAILURE: box:animateToColor() :: Incorrect param[color] - table length 4 expected and got " .. #c)
		s = s or 2
		assert(s, "FAILURE: box:animateToColor() :: Missing param[speed]")
		assert(type(s) == "number", "FAILURE: box:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		timer.tween(s, self.color, c, 'out-quint')
	end
	
	function b:animateToPosition(x, y, s)
		assert(x, "FAILURE: box:animateToPosition() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
		assert(y, "FAILURE: box:animateToPosition() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
		s = s or 2
		assert(s, "FAILURE: box:animateToPosition() :: Missing param[speed]")
		assert(type(s) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
		timer.tween(s, {self.x, self.y}, {x,y}, 'out-quint')
	end
	
	function b:setBorderColor(bC)
		assert(bC, "FAILURE: box:setBorderColor() :: Missing param[color]")
		assert(type(bC) == "table", "FAILURE: box:setBorderColor() :: Incorrect param[color] - expecting table and got " .. type(bC))
		assert(#bC == 4, "FAILURE: box:setBorderColor() :: Incorrect param[color] - table length 4 expected and got " .. #bC)
		self.borderColor = bC
	end
	
	function b:setColor(c)
		assert(c, "FAILURE: box:setColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: box:setColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c == 4, "FAILURE: box:setColor() :: Incorrect param[color] - table length 4 expected and got " .. #c)
		self.color = c
	end
	
	function b:setData(t)
		assert(t, "FAILURE: box:setData() :: Missing param[data]")
		assert(type(t) == "table", "FAILURE: box:setData() :: Incorrect param[data] - expecting table and got " .. type(t))
		assert(t.w or t.width, "FAILURE: box:setData() :: Missing param[data['width']")
		assert(type(t.w) == "number" or type(t.width) == "number", "FAILURE: box:SetData() :: Incorrect param[data['width']] - expecting number and got " .. (type(t.w) or type(t.width)))
		assert(t.h or t.height, "FAILURE: box:setData() :: Missing param[data['height']")
		assert(type(t.h) == "number" or type(t.height) == "number", "FAILURE: box:SetData() :: Incorrect param[data['height']] - expecting number and got " .. (type(t.h) or type(t.height)))
		assert(t.x, "FAILURE: box:setData() :: Missing param[data['x']")
		assert(type(t.x) == "number", "FAILURE: box:setData() :: Incorrect param[x] - expecting number and got " .. type(t.x))
		assert(t.y, "FAILURE: box:setData() :: Missing param[data['y']")
		assert(type(t.y) == "number", "FAILURE: box:setData() :: Incorrect param[y] - expecting number and got " .. type(t.y))
		self.w = t.w or t.width or self.w
		self.h = t.h or t.height or self.h
		self.x = t.x or self.x
		self.y = t.y or self.y
		self.z = t.z or self.z
		self.border = t.useBorder and t.useBorder or self.border
		self.borderColor = t.borderColor or self.borderColor
		self.color = t.color or self.color
		self.image = t.image or self.image
	end
	
	function b:draw()
		lg.push()
		
		if self.border then
			lg.setColor(self.borderColor)
			lg.rectangle("line", self.x - 1, self.y - 1, self.w + 2, self.h + 2)
		end
		
		lg.setColor(self.color)
		if self.image then 
			assert(type(self.image) == "userdata", "FAILURE: box:update() :: Incorrect param[color] - expecting userdata and got " .. type(self.image))
			lg.draw(self.image, self.x, self.y)
		else
			lg.rectangle("fill", self.x, self.y, self.w, self.h)
		end
		lg.pop()
	end
	
	function b:setHeight(h)
		assert(h, "FAILURE: box:setHeight() :: Missing param[height]")
		assert(type(h) == "number", "FAILURE: box:setHeight() :: Incorrect param[height] - expecting number and got " .. type(h))
		self.h = h
	end
	
	function b:getHeight(h)
		return self.h
	end
	
	function b:isHovered()
		return self.hovered
	end
	
	function b:update(dt)
		local x,y = love.mouse.getPosition()
		if (x >= self.x and x <= self.x + self.w) and (y >= self.y and y <= self.y + self.h) then
			if not self.hovered then
				if self.onHoverEnter then self:onHoverEnter() end
				self.hovered = true 
			end
		else
			if self.hovered then 
				if self.onHoverExit then self:onHoverExit() end
				self.hovered = false 
			end
		end
	end
	
	function b:setUseBorder(uB)
		assert(uB, "FAILURE: box:setBorder() :: Missing param[useBorder]")
		assert(type(uB) == "boolean", "FAILURE: box:setBorder() :: Incorrect param[useBorder] - expecting boolean and got " .. type(uB))
		self.border = uB
	end
	
	function b:getUseBorder()
		return self.border
	end
	
	function b:setWidth(w)
		assert(w, "FAILURE: box:setWidth() :: Missing param[width]")
		assert(type(w) == "number", "FAILURE: box:setWidth() :: Incorrect param[width] - expecting number and got " .. type(w))
		self.w = w
	end
	
	function b:getWidth()
		return self.w
	end
	
	function b:setX(x)
		assert(x, "FAILURE: box:setX() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: box:setX() :: Incorrect param[x] - expecting number and got " .. type(x))
		self.x = x
	end
	
	function b:getX()
		return self.x
	end
	
	function b:setY(y)
		assert(y, "FAILURE: box:setY() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: box:setY() :: Incorrect param[y] - expecting number and got " .. type(y))
		self.y = y
	end
	
	function b:getY()
		return self.y
	end
	
	function b:setZ(z)
		assert(z, "FAILURE: box:setZ() :: Missing param[z]")
		assert(type(z) == "number", "FAILURE: box:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
		self.z = z
	end
	
	function b:getZ()
		return self.z
	end
	
	self.items[b.id] = b
	return b
end

return box