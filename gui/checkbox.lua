local lg, lt = love.graphics, love.timer
local min, max = math.min, math.max
local checkbox = {}

checkbox.items = {}
checkbox.guis = {}

function checkbox:new(n, p)
	local c = {}
	if not self.guis[p.id] then self.guis[p.id] = p end
	
	c.name = n
	c.id = #self.items + 1
	if p and p.id then c.parent = p.id else c.parent = nil end
	c.w = 0
	c.h = 0
	c.pos = {
		x = 0,
		y = 0,
		z = 0
	}
	c.border = false
	c.borderColor = {1,1,1,1}
	c.color = {1,1,1,1}
	c.overlayColor = {1,1,1,.5}
	c.hovered = false
	c.clicked = false
	c.clickable = true
	c.faded = false
	c.hidden = false
	c.paddingLeft = 0
	c.paddingRight = 0
	c.paddingTop = 0
	c.paddingBottom = 0
	c.options = {}
	c.selected = {}
	c.font = lg.getFont()
	c.inAnimation = false
	c.animateColor = false
	c.colorToAnimateTo = {1,1,1,1}
	c.colorAnimateSpeed = 0
	c.colorAnimateTime = lt.getTime()
	c.animatePosition = false
	c.positionAnimateSpeed = 0
	c.positionToAnimateTo = {x = 0, y = 0}
	c.positionToAnimateFrom = {x = 0, y = 0}
	c.positionAnimateTime = lt.getTime()
	c.animateOpacity = false
	c.opacityAnimateSpeed = 0
	c.opacityToAnimateTo = 0
	c.opacityAnimateTime = lt.getTime()
	
	function c:animateToColor(t, s)
		assert(t, "FAILURE: checkbox:animateToColor() :: Missing param[color]")
		assert(type(t) == "table", "FAILURE: checkbox:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "FAILURE: checkbox:animateToColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		s = s or 2
		assert(s, "FAILURE: checkbox:animateToColor() :: Missing param[speed]")
		assert(type(s) == "number", "FAILURE: checkbox:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.colorToAnimateTo = t
		self.colorAnimateSpeed = s
		self.colorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateColor = true
	end
	
	function c:animateBorderToColor(t, s)
		assert(t, "FAILURE: checkbox:animateBorderToColor() :: Missing param[color]")
		assert(type(t) == "table", "FAILURE: checkbox:animateBorderToColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t > 2, "FAILURE: checkbox:animateBorderToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #t)
		s = s or 2
		assert(type(s) == "number", "FAILURE: checkbox:animateBorderToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.borderColorToAnimateTo = t
		self.borderColorAnimateSpeed = s
		self.borderColorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateBorderColor = true
	end
	
	function c:animateToPosition(x, y, s)
		assert(x, "FAILURE: checkbox:animateToPosition() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: checkbox:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
		assert(y, "FAILURE: checkbox:animateToPosition() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: checkbox:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
		s = s or 2
		assert(type(s) == "number", "FAILURE: checkbox:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
		for k,v in pairs(self.pos) do self.positionToAnimateFrom[k] = v end
		self.positionToAnimateTo = {x = x, y = y}
		self.positionAnimateDrag = s
		self.positionAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animatePosition = true
	end
	
	function c:animateToOpacity(o, s)
		assert(o, "FAILURE: checkbox:animateToOpacity() :: Missing param[o]")
		assert(type(o) == "number", "FAILURE: checkbox:animateToOpacity() :: Incorrect param[o] - expecting number and got " .. type(o))
		s = s or 1
		assert(s, "FAILURE: checkbox:animateToOpacity() :: Missing param[speed]")
		assert(type(s) == "number", "FAILURE: checkbox:animateToOpacity() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.opacityToAnimateTo = o
		self.opacityAnimateTime = lt.getTime()
		self.opacityAnimateSpeed = s
		self.inAnimation = true
		self.animateOpacity = true
	end
	
	function c:isAnimating()
		return self.inAnimation
	end
	
	function c:setBorderColor(bC)
		assert(bC, "FAILURE: checkbox:setBorderColor() :: Missing param[color]")
		assert(type(bC) == "table", "FAILURE: checkbox:setBorderColor() :: Incorrect param[color] - expecting table and got " .. type(bC))
		assert(#bC == 4, "FAILURE: checkbox:setBorderColor() :: Incorrect param[color] - table length 4 expected and got " .. #bC)
		self.borderColor = bC
	end
	
	function c:getBorderColor()
		return self.borderColor
	end
	
	function c:setClickable(t)
		assert(t ~= nil, "FAILURE: checkbox:setClickable() :: Missing param[clickable]")
		assert(type(t) == "boolean", "FAILURE: checkbox:setClickable() :: Incorrect param[clickable] - expecting boolean and got " .. type(t))
		self.clickable = t
	end
	
	function c:isClickable()
		return self.clickable
	end
	
	function c:setColor(t)
		assert(t, "FAILURE: checkbox:setColor() :: Missing param[color]")
		assert(type(t) == "table", "FAILURE: checkbox:setColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "FAILURE: checkbox:setColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		self.color = t
	end
	
	function c:setData(d)
		assert(d, "FAILURE: checkbox:setData() :: Missing param[data]")
		assert(type(d) == "table", "FAILURE: checkbox:setData() :: Incorrect param[data] - expecting table and got " .. type(d))
		assert(d.t or d.text, "FAILURE: checkbox:setData() :: Missing param[data['text']")
		assert(type(d.text) == "string", "FAILURE: checkbox:setData() :: Incorrect param[text] - expecting string and got " .. type(d.text))
		assert(d.x, "FAILURE: checkbox:setData() :: Missing param[data['x']")
		assert(type(d.x) == "number", "FAILURE: checkbox:setData() :: Incorrect param[x] - expecting number and got " .. type(d.x))
		assert(d.y, "FAILURE: checkbox:setData() :: Missing param[data['y']")
		assert(type(d.y) == "number", "FAILURE: checkbox:setData() :: Incorrect param[y] - expecting number and got " .. type(d.y))
		self.w = d.w or d.width or self.w
		self.h = d.h or d.height or self.h
		self.pos.x = d.x or self.pos.x
		self.pos.y = d.y or self.pos.y
		self.pos.z = d.z or self.pos.z
		self.color = d.color or self.color
		self.font = d.font or self.font
		self.clickable = d.clickable and d.clickable or self.clickable
		if d.options then
			if not d.keepOptions then
				self.options = {}
			end
			for k,v in ipairs(d.options) do
				local id #self.options + 1
				if k == 1 then
					self.options[id] = {text = v, x = self.pos.x + self.font:getWidth(v), y = self.pos.y}
				else
					self.options[id] = {text = v, x = self.pos.x + self.font:getWidth(v), y = self.pos.y}
					if d.verticalOptions then
						self.options[id].x = self.pos.x
						self.options[id].y = self.options[id - 1].y + self.font:getHeight(v)
					end
				end
			end
		end
	end
	
	function c:disable()
		self.hidden = true
	end
	
	function c:draw()
		lg.setColor(1,1,1,1)
		lg.setFont(self.font)
		for k,v in ipairs(self.options) do
			lg.push()
			if self.border then
				if self.parent and checkbox.guis[self.parent].use255 then
					lg.setColor(love.math.colorFromBytes(self.borderColor))
				else
					lg.setColor(self.borderColor)
				end
				lg.rectangle("line", v.x - 1, v.y - 1, v.w + 2, v.h + 2)
			end
			if self.parent and box.guis[self.parent].use255 then
				lg.setColor(love.math.colorFromBytes(self.color))
			else
				lg.setColor(self.color)
			end
			lg.rectangle("fill", v.x, v.y, v.w, v.h)
			for _,i in ipairs(self.selected) do
				lg.setColor(self.overlayColor)
				lg.rectangle("fill", v.x, v.y, v.w, v.h)
				lg.setColor(self.color)
			end
			lg.print(v.text, v.x + self.paddingRight, v.y)
			lg.pop()
		end
	end
	
	function c:enable()
		self.hidden = false
	end
	
	function c:fadeIn()
		self:animateToOpacity(1)
		self.hidden = false
		self.faded = false
		if self.onFadeIn then self:onFadeIn() end
	end
	
	function c:fadeOut(p)
		if p then self.faded = true end
		self:animateToOpacity(0)
		if self.onFadeOut then self:onFadeOut() end
	end
	
	function c:setFont(f)
		assert(f, "FAILURE: text:setFont() :: Missing param[font]")
		assert(type(f) == "userdata", "FAILURE: text:setFont() :: Incorrect param[font] - expecting userdata and got " .. type(f))
		self.font = f
	end
	
	function c:isHovered()
		return self.hovered
	end
	
	function c:startAnimation()
		self.inAnimation = true
	end
	
	function c:stopAnimation()
		self.inAnimation = false
	end
	
	function c:mousepressed(button)
		local x,y = love.mouse.getPosition()
		if button == 1 then
			for k,v in ipairs(self.options) do
				if x >= v.x and x <= v.x + self.font:getWidth(v.text) and y >= v.y and y <= v.y + self.font:getHeight(v.text) then
					if self.selected[k] then
						self.selected[k] = nil
					else
						self.selected[k] = v
					end
				end
			end
		end
	end
	
	function c:update(dt)
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
	
	function c:setOpacity(o)
		assert(o, "FAILURE: checkbox:setUseBorder() :: Missing param[opacity]")
		assert(type(o) == "number", "FAILURE: checkbox:setUseBorder() :: Incorrect param[opacity] - expecting number and got " .. type(o))
		self.color[4] = o
	end
	
	function c:getOpacity()
		return self.color[4]
	end
	
	function c:setX(x)
		assert(x, "FAILURE: checkbox:setX() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: checkbox:setX() :: Incorrect param[x] - expecting number and got " .. type(x))
		self.pos.x = x
	end
	
	function t:getX()
		return self.pos.x
	end
	
	function c:setY(y)
		assert(y, "FAILURE: checkbox:setY() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: checkbox:setY() :: Incorrect param[y] - expecting number and got " .. type(y))
		self.pos.y = y
	end
	
	function c:getY()
		return self.pos.y
	end
	
	function c:setZ(z)
		assert(z, "FAILURE: checkbox:setZ() :: Missing param[z]")
		assert(type(z) == "number", "FAILURE: checkbox:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
		self.pos.z = z
	end
	
	function c:getZ()
		return self.pos.z
	end
	
	function c.lerp(e,s,c)
		return (1 - c) * e + c * s
	end
end

return checkbox