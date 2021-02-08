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
	b.pos = {
		x = 0,
		y = 0,
		z = 0
	}
	b.border = false
	b.borderColor = {1,1,1,1}
	b.color = {1,1,1,1}
	b.hovered = false
	b.clicked = false
	b.clickable = true
	b.image = nil
	b.inAnimation = false
	b.colorToAnimateTo = {1,1,1,1}
	b.colorAnimateSpeed = 0
	b.positionToAnimateTo = {x = 0, y = 0}
	b.positionAnimateSpeed = 0
	
	function b:animateToColor(c, s)
		assert(c, "FAILURE: box:animateToColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: box:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c == 4, "FAILURE: box:animateToColor() :: Incorrect param[color] - table length 4 expected and got " .. #c)
		s = s or 2
		assert(type(s) == "number", "FAILURE: box:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.colorToAnimateTo = c
		self.colorAnimateSpeed = s
		self.inAnimation = true
	end
	
	function b:animateToPosition(x, y, s)
		assert(x, "FAILURE: box:animateToPosition() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
		assert(y, "FAILURE: box:animateToPosition() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
		s = s or 2
		assert(type(s) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.positionToAnimateTo = {x = x, y = y}
		self.positionAnimateSpeed = s
		self.inAnimation = true
	end
	
	function b:setBorderColor(bC)
		assert(bC, "FAILURE: box:setBorderColor() :: Missing param[color]")
		assert(type(bC) == "table", "FAILURE: box:setBorderColor() :: Incorrect param[color] - expecting table and got " .. type(bC))
		assert(#bC == 4, "FAILURE: box:setBorderColor() :: Incorrect param[color] - table length 4 expected and got " .. #bC)
		self.borderColor = bC
	end
	
	function b:setClickable(c)
		assert(c ~= nil, "FAILURE: box:setClickable() :: Missing param[clickable]")
		assert(type(c) == "boolean", "FAILURE: box:setClickable() :: Incorrect param[clickable] - expecting boolean and got " .. type(c))
		self.clickable = c
	end
	
	function b:isClickable()
		return self.clickable
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
		self.pos.x = t.x or self.pos.x
		self.pos.y = t.y or self.pos.y
		self.pos.z = t.z or self.pos.z
		self.border = t.useBorder and t.useBorder or self.border
		self.borderColor = t.borderColor or self.borderColor
		self.color = t.color or self.color
		self.image = t.image or self.image
		self.clickable = t.clickable and t.clickable or self.clickable
	end
	
	function b:draw()
		lg.push("all")
		
		lg.setColor(1,1,1,1)
		if self.border then
			lg.setColor(self.borderColor)
			lg.rectangle("line", self.pos.x - 1, self.pos.y - 1, self.w + 2, self.h + 2)
		end
		
		lg.setColor(self.color)
		if self.image then 
			assert(type(self.image) == "userdata", "FAILURE: box:update() :: Incorrect param[color] - expecting userdata and got " .. type(self.image))
			lg.draw(self.image, self.pos.x, self.pos.y)
		else
			lg.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
		end
		lg.setColor(1,1,1,1)
		lg.pop("all")
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
	
	function b:setImage(i)
		assert(i, "FAILURE: box:setImage() :: Missing param[img]")
		assert(type(i) == "userdata", "FAILURE: box:setImage() :: Incorrect param[img] - expecting image userdata and got " .. type(i))
		self.image = i
	end
	
	function b:getImage()
		return self.image
	end
	
	function b:update(dt)
		local x,y = love.mouse.getPosition()
		if (x >= self.pos.x and x <= self.pos.x + self.w) and (y >= self.pos.y and y <= self.pos.y + self.h) then
			if not self.hovered then
				if self.onHoverEnter then self:onHoverEnter() end
				self.hovered = true 
			end
			if self.whileHovering then self:whileHovering() end
		else
			if self.hovered then 
				if self.onHoverExit then self:onHoverExit() end
				self.hovered = false 
			end
		end
		if self.inAnimation then
			local allColorsMatch = true
			local inProperPosition = true
			
			for k,v in ipairs(self.colorToAnimateTo) do
				if self.color[k] ~= v then
					if v > self.color[k] then
						self.color[k] = min(v, self.color[k] + (self.colorAnimateSpeed * dt))
					else
						self.color[k] = max(v, self.color[k] - (self.colorAnimateSpeed * dt))
					end
					allColorsMatch = false
				end
			end
			
			for k,v in ipairs(self.positionToAnimateTo) do
				if self.pos[k] ~= v then
					if v > self.pos[k] then
						self.pos[k] = min(v, self.pos[k] + (self.positionAnimateSpeed * dt))
					else
						self.pos[k] = max(v, self.pos[k] - (self.positionAnimateSpeed * dt))
					end
					inProperPosition = false
				end
			end
			
			if allColorsMatch and inProperPosition then
				self.inAnimation = false
			end
		end
	end
	
	function b:setUseBorder(uB)
		assert(uB ~= nil, "FAILURE: box:setUseBorder() :: Missing param[useBorder]")
		assert(type(uB) == "boolean", "FAILURE: box:setUseBorder() :: Incorrect param[useBorder] - expecting boolean and got " .. type(uB))
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
		self.pos.x = x
	end
	
	function b:getX()
		return self.pos.x
	end
	
	function b:setY(y)
		assert(y, "FAILURE: box:setY() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: box:setY() :: Incorrect param[y] - expecting number and got " .. type(y))
		self.pos.y = y
	end
	
	function b:getY()
		return self.pos.y
	end
	
	function b:setZ(z)
		assert(z, "FAILURE: box:setZ() :: Missing param[z]")
		assert(type(z) == "number", "FAILURE: box:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
		self.pos.z = z
	end
	
	function b:getZ()
		return self.pos.z
	end
	
	self.items[b.id] = b
	return b
end

return box