local lg, lt = love.graphics, love.timer
local min, max = math.min, math.max
local box = {}

box.items = {}
box.guis = {}

function box:new(n, p)
	local b = {}
	if not self.guis[p.id] then self.guis[p.id] = p end
	b.name = n
	b.id = #self.items + 1
	if p and p.id then b.parent = p.id else b.parent = nil end
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
	b.fadedByFunc = false
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
		assert(i, error("[" .. self.name .. "] FAILURE: box:addImage() :: Missing param[img]"), 3)
		assert(type(i) == "userdata", error("[" .. self.name .. "] FAILURE: box:addImage() :: Incorrect param[img] - expecting image userdata and got " .. type(i)), 3)
		assert(n, error("[" .. self.name .. "] FAILURE box:addImage() :: Missing param[name]"), 3)
		assert(type(n) == "string", error("[" .. self.name .. "] FAILURE: box:addImage() :: Incorrect param[img] - expecting string and got " .. type(n)), 3)
		self.images[n] = i
		if a and a == true then self:setImage(n) end
	end
	
	function b:animateToColor(c, s)
		assert(c, error("[" .. self.name .. "] FAILURE: box:animateToColor() :: Missing param[color]"), 3)
		assert(type(c) == "table", error("[" .. self.name .. "] FAILURE: box:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(c)), 3)
		assert(#c > 2, error("[" .. self.name .. "] FAILURE: box:animateToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c), 3)
		s = s or 2
		assert(type(s) == "number", error("[" .. self.name .. "] FAILURE: box:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s)), 3)
		self.colorToAnimateTo = c
		self.colorAnimateSpeed = s
		self.colorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateColor = true
	end
	
	function b:animateBorderToColor(c, s)
		assert(c, error("[" .. self.name .. "] FAILURE: box:animateBorderToColor() :: Missing param[color]"), 3)
		assert(type(c) == "table", error("[" .. self.name .. "] FAILURE: box:animateBorderToColor() :: Incorrect param[color] - expecting table and got " .. type(c)), 3)
		assert(#c > 2, error("[" .. self.name .. "] FAILURE: box:animateBorderToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c), 3)
		s = s or 2
		assert(type(s) == "number", error("[" .. self.name .. "] FAILURE: box:animateBorderToColor() :: Incorrect param[speed] - expecting number and got " .. type(s)), 3)
		self.borderColorToAnimateTo = c
		self.borderColorAnimateSpeed = s
		self.borderColorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateBorderColor = true
	end
	
	function b:animateToPosition(x, y, s)
		assert(x, error("[" .. self.name .. "] FAILURE: box:animateToPosition() :: Missing param[x]"), 3)
		assert(type(x) == "number", error("[" .. self.name .. "] FAILURE: box:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x)), 3)
		assert(y, error("[" .. self.name .. "] FAILURE: box:animateToPosition() :: Missing param[y]"), 3)
		assert(type(y) == "number", error("[" .. self.name .. "] FAILURE: box:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y)), 3)
		s = s or 2
		assert(type(s) == "number", error("[" .. self.name .. "] FAILURE: box:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s)), 3)
		for k,v in pairs(self.pos) do self.positionToAnimateFrom[k] = v end
		self.positionToAnimateTo = {x = x, y = y}
		self.positionAnimateSpeed = s
		self.positionAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animatePosition = true
	end
	
	function b:animateToOpacity(o, s)
		assert(o, error("[" .. self.name .. "] FAILURE: box:animateToOpacity() :: Missing param[o]"), 3)
		assert(type(o) == "number", error("[" .. self.name .. "] FAILURE: box:animateToOpacity() :: Incorrect param[o] - expecting number and got " .. type(o)), 3)
		s = s or 1
		assert(s, error("[" .. self.name .. "] FAILURE: box:animateToOpacity() :: Missing param[speed]"), 3)
		assert(type(s) == "number", error("[" .. self.name .. "] FAILURE: box:animateToOpacity() :: Incorrect param[speed] - expecting number and got " .. type(s)), 3)
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
		assert(bC, error("[" .. self.name .. "] FAILURE: box:setBorderColor() :: Missing param[color]"), 3)
		assert(type(bC) == "table", error("[" .. self.name .. "] FAILURE: box:setBorderColor() :: Incorrect param[color] - expecting table and got " .. type(bC)), 3)
		assert(#bC == 4, error("[" .. self.name .. "] FAILURE: box:setBorderColor() :: Incorrect param[color] - table length 4 expected and got " .. #bC), 3)
		self.borderColor = bC
	end
	
	function b:getBorderColor()
		return self.borderColor
	end
	
	function b:setClickable(c)
		assert(c ~= nil, error("[" .. self.name .. "] FAILURE: box:setClickable() :: Missing param[clickable]"), 3)
		assert(type(c) == "boolean", error("[" .. self.name .. "] FAILURE: box:setClickable() :: Incorrect param[clickable] - expecting boolean and got " .. type(c)), 3)
		self.clickable = c
	end
	
	function b:isClickable()
		return self.clickable
	end
	
	function b:setColor(c)
		assert(c, error("[" .. self.name .. "] FAILURE: box:setColor() :: Missing param[color]"), 3)
		assert(type(c) == "table", error("[" .. self.name .. "] FAILURE: box:setColor() :: Incorrect param[color] - expecting table and got " .. type(c)), 3)
		assert(#c > 2, error("[" .. self.name .. "] FAILURE: box:setColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #c), 3)
		self.color = c
	end
	
	function b:getColor()
		return self.color
	end
	
	function b:setData(t)
		assert(t, error("[" .. self.name .. "] FAILURE: box:setData() :: Missing param[data]"), 3)
		assert(type(t) == "table", error("[" .. self.name .. "] FAILURE: box:setData() :: Incorrect param[data] - expecting table and got " .. type(t)), 3)
		assert(t.w or t.width, error("[" .. self.name .. "] FAILURE: box:setData() :: Missing param[data['width']"), 3)
		assert(type(t.w) == "number" or type(t.width) == "number", error("[" .. self.name .. "] FAILURE: box:setData() :: Incorrect param[data['width']] - expecting number and got " .. (type(t.w) or type(t.width))), 3)
		assert(t.h or t.height, error("[" .. self.name .. "] FAILURE: box:setData() :: Missing param[data['height']"), 3)
		assert(type(t.h) == "number" or type(t.height) == "number", error("[" .. self.name .. "] FAILURE: box:setData() :: Incorrect param[data['height']] - expecting number and got " .. (type(t.h) or type(t.height))), 3)
		assert(t.x, error("[" .. self.name .. "] FAILURE: box:setData() :: Missing param[data['x']"), 3)
		assert(type(t.x) == "number", error("[" .. self.name .. "] FAILURE: box:setData() :: Incorrect param[x] - expecting number and got " .. type(t.x)), 3)
		assert(t.y, error("[" .. self.name .. "] FAILURE: box:setData() :: Missing param[data['y']"), 3)
		assert(type(t.y) == "number", error("[" .. self.name .. "] FAILURE: box:setData() :: Incorrect param[y] - expecting number and got " .. type(t.y)), 3)
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
			if self.parent then
				if box.guis[self.parent].use255 then
					lg.setColor(love.math.colorFromBytes(self.borderColor))
				end
			else
				lg.setColor(self.borderColor)
			end
			lg.rectangle("line", self.pos.x - 1, self.pos.y - 1, self.paddingLeft + self.w + self.paddingRight + 2, self.paddingTop + self.h + self.paddingBottom + 2)
		end
		
		if self.parent and box.guis[self.parent].use255 then
			lg.setColor(love.math.colorFromBytes(self.color))
		else
			lg.setColor(self.color)
		end
		if self.image then 
			assert(type(self.image) == "userdata", error("[" .. self.name .. "] FAILURE: box:update(" .. self.name .. ") :: Incorrect param[image] - expecting image userdata and got " .. type(self.image)), 3)
			lg.draw(self.image, self.pos.x, self.pos.y)
		else
			lg.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
		end
		lg.pop()
	end
	
	function b:enable()
		self.hidden = false
	end
	
	function b:fadeIn()
		if self.beforeFadeIn then self:beforeFadeIn() end
		self:animateToOpacity(1)
		self.hidden = false
		self.faded = false
		self.fadedByFunc = true
		if self.onFadeIn then self:onFadeIn() end
	end
	
	function b:fadeOut(p)
		if self.beforeFadeOut then self:beforeFadeOut() end
		if p then self.faded = true end
		self.fadedByFunc = true
		self:animateToOpacity(0)
		if self.onFadeOut then self:onFadeOut() end
	end
	
	function b:setHeight(h)
		assert(h, error("[" .. self.name .. "] FAILURE: box:setHeight() :: Missing param[height]"), 3)
		assert(type(h) == "number", error("[" .. self.name .. "] FAILURE: box:setHeight() :: Incorrect param[height] - expecting number and got " .. type(h)), 3)
		self.h = h
	end
	
	function b:getHeight(h)
		return self.h
	end
	
	function b:isHovered()
		return self.hovered
	end
	
	function b:setImage(i)
		assert(i, error("[" .. self.name .. "] FAILURE: box:setImage() :: Missing param[img]"), 3)
		assert(type(i) == "string" or type(i) == "userdata", error("[" .. self.name .. "] FAILURE: box:setImage() :: Incorrect param[img] - expecting string or image userdata and got " .. type(i)), 3)
		
		if type(i) == "string" then
			if self.parent then
				self.image = self.images[i] or box.guis[self.parent].images[i]
			else
				self.image = i or self.images[i]
			end
		else self.image = i end
	end
	
	function b:getImage()
		return self.image
	end
	
	function b:setPadding(p)
		assert(p, error("[" .. self.name .. "] FAILURE: box:setPadding() :: Missing param[padding]"), 3)
		assert(type(p) == "table", error("[" .. self.name .. "] FAILURE: box:setPadding() :: Incorrect param[padding] - expecting table and got " .. type(p)), 3)
		assert(#p == 4, error("[" .. self.name .. "] FAILURE: box:setPadding() :: Incorrect param[padding] - expecting table length 4 and got " .. #p), 3)
		self.paddingTop, self.paddingRight, self.paddingBottom, self.paddingTop = unpack(p)
	end
	
	function b:setPaddingBottom(p)
		assert(p, error("[" .. self.name .. "] FAILURE: box:setPaddingBottom() :: Missing param[padding]"), 3)
		assert(type(p) == "number", error("[" .. self.name .. "] FAILURE: box:setPaddingBottom() :: Incorrect param[padding] - expecting number and got " .. type(p)), 3)
		self.paddingBottom = p
	end
	
	function b:setPaddingLeft(p)
		assert(p, error("[" .. self.name .. "] FAILURE: box:setPaddingLeft() :: Missing param[padding]"), 3)
		assert(type(p) == "number", error("[" .. self.name .. "] FAILURE: box:setPaddingLeft() :: Incorrect param[padding] - expecting number and got " .. type(p)), 3)
		self.paddingLeft = p
	end
	
	function b:setPaddingRight(p)
		assert(p, error("[" .. self.name .. "] FAILURE: box:setPaddingRight() :: Missing param[padding]"), 3)
		assert(type(p) == "number", error("[" .. self.name .. "] FAILURE: box:setPaddingRight() :: Incorrect param[padding] - expecting number and got " .. type(p)), 3)
		self.paddingRight = p
	end
	
	function b:setPaddingTop(p)
		assert(p, error("[" .. self.name .. "] FAILURE: box:setPaddingTop() :: Missing param[padding]"), 3)
		assert(type(p) == "number", error("[" .. self.name .. "] FAILURE: box:setPaddingTop() :: Incorrect param[padding] - expecting number and got " .. type(p)), 3)
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
		if (x >= self.pos.x + self.paddingLeft and x <= self.pos.x + self.w + self.paddingRight) and 
		(y >= self.pos.y + self.paddingTop and y <= self.pos.y + self.h + self.paddingBottom) then
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
				else
					if self.fadedByFunc then
						if self.color[4] == 1 then
							if self.afterFadeIn then self:afterFadeIn() end
						elseif self.color[4] == 0 then
							if self.afterFadeOut then self:afterFadeOut() end
						end
						self.fadedByFunc = false
					end
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
		assert(o, error("[" .. self.name .. "] FAILURE: box:setUseBorder() :: Missing param[opacity]"), 3)
		assert(type(o) == "number", error("[" .. self.name .. "] FAILURE: box:setUseBorder() :: Incorrect param[opacity] - expecting number and got " .. type(o)), 3)
		self.color[4] = o
	end
	
	function b:getOpacity()
		return self.color[4]
	end
	
	function b:setUseBorder(uB)
		assert(uB ~= nil, error("[" .. self.name .. "] FAILURE: box:setUseBorder() :: Missing param[useBorder]"), 3)
		assert(type(uB) == "boolean", error("[" .. self.name .. "] FAILURE: box:setUseBorder() :: Incorrect param[useBorder] - expecting boolean and got " .. type(uB)), 3)
		self.border = uB
	end
	
	function b:getUseBorder()
		return self.border
	end
	
	function b:setWidth(w)
		assert(w, error("[" .. self.name .. "] FAILURE: box:setWidth() :: Missing param[width]"), 3)
		assert(type(w) == "number", error("[" .. self.name .. "] FAILURE: box:setWidth() :: Incorrect param[width] - expecting number and got " .. type(w)), 3)
		self.w = w
	end
	
	function b:getWidth()
		return self.w
	end
	
	function b:setX(x)
		assert(x, error("[" .. self.name .. "] FAILURE: box:setX() :: Missing param[x]"), 3)
		assert(type(x) == "number", error("[" .. self.name .. "] FAILURE: box:setX() :: Incorrect param[x] - expecting number and got " .. type(x)), 3)
		self.pos.x = x
	end
	
	function b:getX()
		return self.pos.x
	end
	
	function b:setY(y)
		assert(y, error("[" .. self.name .. "] FAILURE: box:setY() :: Missing param[y]"), 3)
		assert(type(y) == "number", error("[" .. self.name .. "] FAILURE: box:setY() :: Incorrect param[y] - expecting number and got " .. type(y)), 3)
		self.pos.y = y
	end
	
	function b:getY()
		return self.pos.y
	end
	
	function b:setZ(z)
		assert(z, error("[" .. self.name .. "] FAILURE: box:setZ() :: Missing param[z]"), 3)
		assert(type(z) == "number", error("[" .. self.name .. "] FAILURE: box:setZ() :: Incorrect param[z] - expecting number and got " .. type(z)), 3)
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