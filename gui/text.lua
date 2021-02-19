local lg, lt = love.graphics, love.timer
local min, max = math.min, math.max
local text = {}

text.items = {}
text.guis = {}

function text:new(n, p)
	local t = {}
	if not self.guis[p.id] then self.guis[p.id] = p end
	
	t.name = n
	t.id = #self.items + 1
	t.parent = p.id
	t.text = ""
	t.w = 0
	t.h = 0
	t.pos = {
		x = 0,
		y = 0,
		z = 0
	}
	t.timerEvent = nil
	t.border = false
	t.borderColor = {1,1,1,1}
	t.background = false
	t.backgroundColor = {1,1,1,1}
	t.backgroundData = {}
	t.color = {1,1,1,1}
	t.font = love.graphics.getFont()
	t.hovered = false
	t.clicked = false
	t.clickable = true
	t.faded = false
	t.typewriter = false
	t.typewriterPrint = ""
	t.typewriterText = self:split(t.text)
	t.typewriterPos = 1
	t.typewriterSpeed = 0
	t.typewriterWaited = 0
	t.typewriterFinished = false
	t.typewriterPaused = false
	t.typewriterStopped = false
	t.typewriterRunCount = 0
	t.inAnimation = false
	t.animateColor = false
	t.colorToAnimateTo = {1,1,1,1}
	t.colorAnimateSpeed = 0
	t.colorAnimateTime = lt.getTime()
	t.animatePosition = false
	t.positionAnimateSpeed = 0
	t.positionToAnimateTo = {x = 0, y = 0}
	t.positionToAnimateFrom = {x = 0, y = 0}
	t.positionAnimateTime = lt.getTime()
	t.animateOpacity = false
	t.opacityAnimateSpeed = 0
	t.opacityToAnimateTo = 0
	t.opacityAnimateTime = lt.getTime()
	
	function t:animateToColor(c, s)
		assert(c, "FAILURE: text:animateToColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: text:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c == 4, "FAILURE: text:animateToColor() :: Incorrect param[color] - table length 4 expected and got " .. #c)
		s = s or 2
		assert(s, "FAILURE: text:animateToColor() :: Missing param[speed]")
		assert(type(s) == "number", "FAILURE: text:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.colorToAnimateTo = c
		self.colorAnimateSpeed = s
		self.colorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateColor = true
	end
	
	function t:animateToPosition(x, y, s)
		assert(x, "FAILURE: text:animateToPosition() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: text:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
		assert(y, "FAILURE: text:animateToPosition() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: text:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
		s = s or 2
		assert(type(s) == "number", "FAILURE: text:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
		for k,v in pairs(self.pos) do self.positionToAnimateFrom[k] = v end
		self.positionToAnimateTo = {x = x, y = y}
		self.positionAnimateDrag = s
		self.positionAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animatePosition = true
	end
	
	function t:animateToOpacity(o, s)
		assert(o, "FAILURE: text:animateToOpacity() :: Missing param[o]")
		assert(type(o) == "number", "FAILURE: text:animateToOpacity() :: Incorrect param[o] - expecting number and got " .. type(o))
		s = s or 1
		assert(s, "FAILURE: text:animateToOpacity() :: Missing param[speed]")
		assert(type(s) == "number", "FAILURE: text:animateToOpacity() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.opacityToAnimateTo = o
		self.opacityAnimateTime = lt.getTime()
		self.opacityAnimateSpeed = s
		self.inAnimation = true
		self.animateOpacity = true
	end
	
	function t:isAnimating()
		return self.inAnimation
	end
	
	function t:setClickable(c)
		assert(c ~= nil, "FAILURE: text:setClickable() :: Missing param[clickable]")
		assert(type(c) == "boolean", "FAILURE: text:setClickable() :: Incorrect param[clickable] - expecting boolean and got " .. type(c))
		self.clickable = c
	end
	
	function t:isClickable()
		return self.clickable
	end
	
	function t:setColor(c)
		assert(c, "FAILURE: text:setColor() :: Missing param[color]")
		assert(type(c) == "table", "FAILURE: text:setColor() :: Incorrect param[color] - expecting table and got " .. type(c))
		assert(#c == 4, "FAILURE: text:setColor() :: Incorrect param[color] - table length 4 expected and got " .. #c)
		self.color = c
	end
	
	function t:setData(d)
		assert(d, "FAILURE: text:setData() :: Missing param[data]")
		assert(type(d) == "table", "FAILURE: text:setData() :: Incorrect param[data] - expecting table and got " .. type(d))
		assert(d.t or d.text, "FAILURE: text:setData() :: Missing param[data['text']")
		assert(type(d.text) == "string", "FAILURE: text:setData() :: Incorrect param[text] - expecting string and got " .. type(d.text))
		assert(d.x, "FAILURE: text:setData() :: Missing param[data['x']")
		assert(type(d.x) == "number", "FAILURE: text:setData() :: Incorrect param[x] - expecting number and got " .. type(d.x))
		assert(d.y, "FAILURE: text:setData() :: Missing param[data['y']")
		assert(type(d.y) == "number", "FAILURE: text:setData() :: Incorrect param[y] - expecting number and got " .. type(d.y))
		self.w = d.w or self.w
		self.h = d.h or self.h
		self.text = d.t or or d.text or self.text
		self.typewriterText = self:split(self.text)
		self.pos.x = d.x or self.pos.x
		self.pos.y = d.y or self.pos.y
		self.pos.z = d.z or self.pos.z
		self.background = d.useBackground and d.useBackground or self.background
		self.border = d.useBorder and d.useBorder or self.border
		self.backgroundColor = d.backgroundColor or self.backgroundColor
		self.borderColor = d.borderColor or self.borderColor
		self.color = d.color or self.color
		self.font = d.font or self.font
		self.clickable = d.clickable and d.clickable or self.clickable
	end
	
	function t:disable()
		self.hidden = true
	end
	
	function t:draw()
		lg.push()
		lg.setColor(self.color)
		
		if self.typewriter then
			lg.print({self.color, self.typewriterPrint}, self.font, self.pos.x, self.pos.y)
		else
			lg.print({self.color, self.text}, self.font, self.pos.x, self.pos.y)
		end
		
		lg.setColor(1,1,1,1)
		lg.pop()
	end
	
	function t:enable()
		self.hidden = false
	end
	
	function t:fadeIn()
		self:animateToOpacity(1)
		self.hidden = false
		self.faded = false
		if self.onFadeIn then self:onFadeIn() end
	end
	
	function t:fadeOut(p)
		if p then self.faded = true end
		self:animateToOpacity(0)
		if self.onFadeOut then self:onFadeOut() end
	end
	
	function t:isHovered()
		return self.hovered
	end
	
	function t:startAnimation()
		self.inAnimation = true
	end
	
	function t:stopAnimation()
		self.inAnimation = false
	end
	
	function t:update(dt)
		local x,y = love.mouse.getPosition()
		if (x >= self.pos.x and x <= self.pos.x + self.w) and (y >= self.pos.y and y <= self.pos.y + self.h) then
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
		
		if self.typewriter then
			self.typewriterWaited = self.typewriterWaited + dt
			while self.typewriterWaited >= self.typewriterSpeed and self.typewriterPrint <= #self.typewriterText do
				self.typewriterWaited = self.typewriterWaited - self.typewriterSpeed
				self.typewriterPrint = self.typewriterPrint .. self.typewriterText[self.typewriterPos]
				self.typewriterPos = self.typewriterPos + 1
			end
			if self.typewriterPos >= #self.typewriterText and not self.typewriterFinished then
				if not self.typewriterRepeat then self.typewriterFinished = true else self:typewriterCycle() end
				self.typewriterRunCount = self.typewriterRunCount + 1
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
	
	function t:setOpacity(o)
		assert(o, "FAILURE: text:setUseBorder() :: Missing param[opacity]")
		assert(type(o) == "number", "FAILURE: text:setUseBorder() :: Incorrect param[opacity] - expecting number and got " .. type(o))
		self.color[4] = o
	end
	
	function t:getOpacity()
		return self.color[4]
	end
	
	function t:typewriterCycle()
		self.typewriterWaited = 0
		self.typewriterPos = 1
		self.typewriterPrint = ""
		self.typewriterFinished = false
		self.typewriterStopped = false
		self.typewriterPaused = false
	end
	
	function t:setUseBorder(uB)
		assert(uB ~= nil, "FAILURE: text:setUseBorder() :: Missing param[useBorder]")
		assert(type(uB) == "boolean", "FAILURE: text:setUseBorder() :: Incorrect param[useBorder] - expecting boolean and got " .. type(uB))
		self.border = uB
	end
	
	function t:getUseBorder()
		return self.border
	end
	
	function t:setText(text)
		assert(text ~= nil, "FAILURE: text:setText() :: Missing param[text]")
		assert(type(text) == "string", "FAILURE: text:setText() :: Incorrect param[text] - expecting boolean and got " .. type(text))
		self.text = text
		self.typewriterText = self:split(text)
	end
	
	function t:getText()
		return self.text
	end
	
	function t:setAsTypewriter(aT)
		assert(aT ~= nil, "FAILURE: text:setAsTypewriter() :: Missing param[useBorder]")
		assert(type(aT) == "boolean", "FAILURE: text:setAsTypewriter() :: Incorrect param[useBorder] - expecting boolean and got " .. type(aT))
		self.typewriter = aT
	end
	
	function t:isTypewriter()
		return self.typewriter
	end
	
	function t:setX(x)
		assert(x, "FAILURE: text:setX() :: Missing param[x]")
		assert(type(x) == "number", "FAILURE: text:setX() :: Incorrect param[x] - expecting number and got " .. type(x))
		self.pos.x = x
	end
	
	function t:getX()
		return self.pos.x
	end
	
	function t:setY(y)
		assert(y, "FAILURE: text:setY() :: Missing param[y]")
		assert(type(y) == "number", "FAILURE: text:setY() :: Incorrect param[y] - expecting number and got " .. type(y))
		self.pos.y = y
	end
	
	function t:getY()
		return self.pos.y
	end
	
	function t:setZ(z)
		assert(z, "FAILURE: text:setZ() :: Missing param[z]")
		assert(type(z) == "number", "FAILURE: text:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
		self.pos.z = z
	end
	
	function t:getZ()
		return self.pos.z
	end
	
	function t.lerp(t1,t2,t)
		return (1 - t) * t1 + t * t2
	end
end

function text:update(dt)

end

function text:draw()

end

function text:split(str)
	local t={}
	for s in string.gmatch(str, ".") do
		t[#t+1] = s
	end
	return t
end

return text