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
	t.timer = require("lib.hump.timer")
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
	t.positionToAnimateTo = {x = 0, y = 0}
	b.positionToAnimateFrom = {x = 0, y = 0}
	t.positionAnimateDrag = 0
	t.positionAnimationTimer = lt.getTime()
	
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
		assert(d.texd, "FAILURE: text:setData() :: Missing param[data['text']")
		assert(type(d.text) == "number", "FAILURE: text:setData() :: Incorrect param[text] - expecting number and got " .. type(d.text))
		assert(d.x, "FAILURE: text:setData() :: Missing param[data['x']")
		assert(type(d.x) == "number", "FAILURE: text:setData() :: Incorrect param[x] - expecting number and got " .. type(d.x))
		assert(d.y, "FAILURE: text:setData() :: Missing param[data['y']")
		assert(type(d.y) == "number", "FAILURE: text:setData() :: Incorrect param[y] - expecting number and got " .. type(d.y))
		self.w = d.w or self.w
		self.h = d.h or self.h
		self.pos.x = d.x or self.pos.x
		self.pos.y = d.y or self.pos.y
		self.pos.z = d.z or self.pos.z
		self.background = d.useBackground and d.useBackground or self.background
		self.border = d.useBorder and d.useBorder or self.border
		self.backgroundColor = d.backgroundColor or self.backgroundColor
		self.borderColor = d.borderColor or self.borderColor
		self.color = d.color or self.color
		self.font = d.font or self.font
	end
	
	function t:draw()
		lg.push()
		
		if self.typewriter then
			if self.backgroundData[1] then
				local color, xPad, yPad, round = unpack(self.backgroundData)
				color = color or {1,1,1,1}
				xPad = xPad or 0
				yPad = yPad or 0
				round = round and round or false
				
				lg.setColor(color)
				if round then
					lg.rectangle("fill", self.pos.x - (xPad / 2), self.pos.y - (yPad / 2), self.font:getWidth(self.text) + xPad, self.font:getHeight(self.text) + yPad, 5, 5)
				else
					lg.rectangle("fill", self.pos.x - (xPad / 2), self.pos.y - (yPad / 2), self.font:getWidth(self.text) + xPad, self.font:getHeight(self.text) + yPad)
				end
				if self.border then
					lg.setColor(self.borderColor)
					if round then
						lg.rectangle("line", self.pos.x - (xPad / 2), self.pos.y - (yPad / 2), self.font:getWidth(self.text) + xPad, self.font:getHeight(self.text) + yPad, 5, 5)
					else
						lg.rectangle("line", self.pos.x - (xPad / 2), self.pos.y - (yPad / 2), self.font:getWidth(self.text) + xPad, self.font:getHeight(self.text) + yPad)
					end
				end
			end
			
			lg.print({self.color, self.typewriterPrint}, self.font, self.pos.x, self.pos.y)
		else
			lg.print({self.color, self.text}, self.font, self.pos.x, self.pos.y)
		end
		
		lg.setColor(1,1,1,1)
		lg.pop()
	end
	
	function t:isHovered()
		return self.hovered
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
			local inProperPosition = true
			
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
				local t = math.min((lt.getTime() - self.positionAnimateTime) / (self.positionAnimateDrag / 2), 1.0)
				if self.pos.x ~= self.positionToAnimateTo.x or self.pos.y ~= self.positionToAnimateTo.y then
					self.pos.x = self.lerp(self.positionToAnimateFrom.x, self.positionToAnimateTo.x, t)
					self.pos.y = self.lerp(self.positionToAnimateFrom.y, self.positionToAnimateTo.y, t)
					inProperPosition = false
				end
			end
			
			
			if allColorsMatch and inProperPosition then
				self.inAnimation = false
				self.animateColor = false
				self.animatePosition = false
			end
		end
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
	
	function t:setAsTypewriter(aT)
		assert(aT ~= nil, "FAILURE: text:setAsTypewriter() :: Missing param[useBorder]")
		assert(type(aT) == "boolean", "FAILURE: text:setAsTypewriter() :: Incorrect param[useBorder] - expecting boolean and got " .. type(aT))
		self.typewriter = aT
	end
	
	function t:isTypewriter()
		return self.typewriter
	end
	
	function t:setWidth(w)
		assert(w, "FAILURE: text:setWidth() :: Missing param[width]")
		assert(type(w) == "number", "FAILURE: text:setWidth() :: Incorrect param[width] - expecting number and got " .. type(w))
		self.w = w
	end
	
	function t:getWidth()
		return self.w
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

function text:split()
	local t={}
	for s in string.gmatch(str, ".") do
		t[#t+1] = s
	end
	return t
end

return text