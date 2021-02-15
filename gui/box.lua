local lg, lt = love.graphics, love.timer
local min, max = math.min, math.max
local box = {}

box.items = {}

function box:new(n, p)
	local b = {}
	
	b.name = n
	b.id = #self.items + 1
	b.parent = p
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
	b.faded = false
	b.hidden = false
	b.images = {}
	b.image = nil
	b.paddingLeft = 0
	b.paddingRight = 0
	b.paddingTop = 0
	b.paddingBottom = 0
	b.inAnimation = false
	b.animateColor = false
	b.colorToAnimateTo = {1,1,1,1}
	b.colorAnimateSpeed = 0
	b.colorAnimateTime = lt.getTime()
	b.animateBorderColor = false
	b.borderColorToAnimateTo = {1,1,1,1}
	b.borderColorAnimateSpeed = 0
	b.borderColorAnimateTime = lt.getTime()
	b.animatePosition = false
	b.positionAnimateSpeed = 0
	b.positionToAnimateTo = {x = 0, y = 0}
	b.positionToAnimateFrom = {x = 0, y = 0}
	b.positionAnimateTime = lt.getTime()
	b.animateOpacity = false
	b.opacityAnimateSpeed = 0
	b.opacityToAnimateTo = 0
	b.opacityAnimateTime = lt.getTime()
	
	function b:addImage(i, n, a)
		assert(i, "FAILURE: box:addImage() :: Missing param[img]")
		assert(type(i) == "userdata", "FAILURE: box:addImage() :: Incorrect param[img] - expecting image userdata and got " .. type(i))
		assert(n, "FAILURE box:addImage() :: Missing param[name]")
		assert(type(n) == "string", "FAILURE: box:addImage() :: Incorrect param[img] - expecting string and got " .. type(n))
		self.images[n] = i
		if a and a == true then self:setImage(n) end
	end
	
	function b:animateToColor(c, s)
		assert(c, "FAILURE: box:animateToColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: box:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c > 2, "FAILURE: box:animateToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c)
		s = s or 2
		assert(type(s) == "number", "FAILURE: box:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.colorToAnimateTo = c
		self.colorAnimateSpeed = s
		self.colorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateColor = true
	end
	
	function b:animateBorderToColor(c, s)
		assert(c, "FAILURE: box:animateBorderToColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: box:animateBorderToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c > 2, "FAILURE: box:animateBorderToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c)
		s = s or 2
		assert(type(s) == "number", "FAILURE: box:animateBorderToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.borderColorToAnimateTo = c
		self.borderColorAnimateSpeed = s
		self.borderColorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateBorderColor = true
	end
	
	function b:animateToPosition(x, y, s)
		assert(x, "FAILURE: box:animateToPosition() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
		assert(y, "FAILURE: box:animateToPosition() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
		s = s or 2
		assert(type(s) == "number", "FAILURE: box:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
		for k,v in pairs(self.pos) do self.positionToAnimateFrom[k] = v end
		self.positionToAnimateTo = {x = x, y = y}
		self.positionAnimateSpeed = s
		self.positionAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animatePosition = true
	end
	
	function b:animateToOpacity(o, s)
		assert(o, "FAILURE: box:animateToOpacity() :: Missing param[o]")
		assert(type(o) == "number", "FAILURE: box:animateToOpacity() :: Incorrect param[o] - expecting number and got " .. type(o))
		s = s or 1
		assert(s, "FAILURE: box:animateToOpacity() :: Missing param[s]")
		assert(type(s) == "number", "FAILURE: box:animateToOpacity() :: Incorrect param[s] - expecting number and got " .. type(s))
		self.opacityToAnimateTo = o
		self.opacityAnimateTime = lt.getTime()
		self.opacityAnimateSpeed = s
		self.inAnimation = true
		self.animateOpacity = true
	end
	
	function b:isAnimating()
		return self.inAnimation
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
		assert(#c > 2, "FAILURE: box:setColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c)
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
		self.image = self.images[t.image] or self.image
		self.clickable = t.clickable and t.clickable or self.clickable
		if t.padding then
			self.padding = unpack(t.padding)
		end
	end
	
	function b:disable()
		self.hidden = true
	end
	
	function b:draw()
		lg.push()
		
		lg.setColor(1,1,1,1)
		if self.border then
			if self.parent.use255 then
				lg.setColor(love.math.colorFromBytes(self.borderColor))
			else
				lg.setColor(self.borderColor)
			end
			lg.rectangle("line", self.pos.x - 1, self.pos.y - 1, self.paddingLeft + self.w + self.paddingRight + 2, self.paddingTop + self.h + self.paddingBottom + 2)
		end
		
		if self.parent.use255 then
			lg.setColor(love.math.colorFromBytes(self.color))
		else
			lg.setColor(self.color)
		end
		if self.image then 
			assert(type(self.image) == "userdata", "FAILURE: box:update() :: Incorrect param[image] - expecting userdata and got " .. type(self.image))
			lg.draw(self.image, self.pos.x, self.pos.y)
		else
			lg.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
		end
		lg.setColor(1,1,1,1)
		lg.pop()
	end
	
	function b:enable()
		self.hidden = false
	end
	
	function b:fadeIn()
		self:animateToOpacity(1)
		self.hidden = false
		self.faded = false
		if self.onFadeIn then self:onFadeIn() end
	end
	
	function b:fadeOut(p)
		if p then self.faded = true end
		self:animateToOpacity(0)
		if self.onFadeOut then self:onFadeOut() end
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
		assert(type(i) == "string", "FAILURE: box:setImage() :: Incorrect param[img] - expecting string and got " .. type(i))
		self.image = self.images[i] or self.parent.images[i]
	end
	
	function b:getImage()
		return self.image
	end
	
	function b:setPadding(p)
		assert(p, "FAILURE: box:setPadding() :: Missing param[padding]")
		assert(type(p) == "table", "FAILURE: box:setPadding() :: Incorrect param[padding] - expecting table and got " .. type(p))
		assert(#p == 4, "FAILURE: box:setPadding() :: Incorrect param[padding] - expecting table length 4 and got " .. #p)
		self.paddingTop, self.paddingRight, self.paddingBottom, self.paddingTop = unpack(p)
	end
	
	function b:setPaddingBottom(p)
		assert(p, "FAILURE: box:setPaddingBottom() :: Missing param[padding]")
		assert(type(p) == "number", "FAILURE: box:setPaddingBottom() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.paddingBottom = p
	end
	
	function b:setPaddingLeft(p)
		assert(p, "FAILURE: box:setPaddingLeft() :: Missing param[padding]")
		assert(type(p) == "number", "FAILURE: box:setPaddingLeft() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.paddingLeft = p
	end
	
	function b:setPaddingRight(p)
		assert(p, "FAILURE: box:setPaddingRight() :: Missing param[padding]")
		assert(type(p) == "number", "FAILURE: box:setPaddingRight() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.paddingRight = p
	end
	
	function b:setPaddingTop(p)
		assert(p, "FAILURE: box:setPaddingTop() :: Missing param[padding]")
		assert(type(p) == "number", "FAILURE: box:setPaddingTop() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.paddingTop = p
	end
	
	function b:startAnimation()
		self.inAnimation = true
	end
	
	function b:stopAnimation()
		self.inAnimation = false
	end
	
	function b:update(dt)
		local x,y = love.mouse.getPosition()
		if (x >= self.pos.x + self.paddingLeft and x <= self.pos.x + self.w + self.paddingRight) and (y >= self.pos.y + self.paddingTop and y <= self.pos.y + self.h + self.paddingBottom) then
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
			local allBorderColorsMatch = true
			local inProperPosition = true
			local atProperOpacity = true
			
			if self.animateColor then
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
			end
			
			if self.animatePosition then
				local t = math.min((lt.getTime() - self.positionAnimateTime) * (self.positionAnimateSpeed / 2), 1.0)
				if self.pos.x ~= self.positionToAnimateTo.x or self.pos.y ~= self.positionToAnimateTo.y then
					self.pos.x = self.lerp(self.positionToAnimateFrom.x, self.positionToAnimateTo.x, t)
					self.pos.y = self.lerp(self.positionToAnimateFrom.y, self.positionToAnimateTo.y, t)
					inProperPosition = false
				end
			end
			
			if self.animateOpacity then
				if self.color[4] ~= self.opacityToAnimateTo then
					if self.color[4] < self.opacityToAnimateTo then
						self.color[4] = min(self.opacityToAnimateTo, self.color[4] + (self.opacityAnimateSpeed * dt))
					else
						self.color[4] = max(self.opacityToAnimateTo, self.color[4] - (self.opacityAnimateSpeed * dt))
					end
					atProperOpacity = false
				end
			end
			
			if self.animateBorderColor then
				for k,v in ipairs(self.borderColorToAnimateTo) do
					if self.borderColor[k] ~= v then
						if v > self.borderColor[k] then
							self.borderColor[k] = min(v, self.borderColor[k] + (self.borderColorAnimateSpeed * dt))
						else
							self.borderColor[k] = max(v, self.borderColor[k] - (self.borderColorAnimateSpeed * dt))
						end
						allBorderColorsMatch = false
					end
				end
			end
			
			if allColorsMatch and inProperPosition and atProperOpacity and allBorderColorsMatch then
				self.inAnimation = false
				self.animateColor = false
				self.animatePosition = false
				if self.animateOpacity and self.faded then self.hidden = true end
				self.animateOpacity = false
			end
		end
	end
	
	function b:setOpacity(o)
		assert(o, "FAILURE: box:setUseBorder() :: Missing param[opacity]")
		assert(type(o) == "number", "FAILURE: box:setUseBorder() :: Incorrect param[opacity] - expecting number and got " .. type(o))
		self.color[4] = o
	end
	
	function b:getOpacity()
		return self.color[4]
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
	
	function b.lerp(t1,t2,t)
		return (1 - t) * t1 + t * t2
	end
	
	self.items[b.id] = b
	return b
end

return box