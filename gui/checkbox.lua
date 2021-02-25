--[[
	Copyright (c) 2021- David Ashton | CognizanceGaming
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	Except as contained in this notice, the name(s) of the above copyright holders
	shall not be used in advertising or otherwise to promote the sale, use or
	other dealings in this Software without prior written authorization.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
--]]



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
	c.label = ""
	c.labelColor = {1,1,1,1}
	c.labelPosition = {
		x = 0,
		y = 0,
		z = 0
	}
	c.border = false
	c.borderColor = {1,1,1,1}
	c.color = {1,1,1,1}
	c.overlayColor = {1,1,1,.5}
	c.optionsColor = {1,1,1,1}
	c.paddingLeft = 0
	c.paddingRight = 0
	c.paddingTop = 0
	c.paddingBottom = 0
	c.hovered = false
	c.clicked = false
	c.clickable = true
	c.faded = false
	c.fadedByFunc = false
	c.hidden = false
	c.vertical = false
	c.hollow = false
	c.options = {}
	c.optionsPaddingLeft = 0
	c.optionsPaddingRight = 0
	c.optionsPaddingTop = 0
	c.optionsPaddingBottom = 0
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
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:animateToColor() :: Missing param[color]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:animateToColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "[" .. self.name .. "] FAILURE: checkbox:animateToColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		s = s or 2
		assert(s, "[" .. self.name .. "] FAILURE: checkbox:animateToColor() :: Missing param[speed]")
		assert(type(s) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.colorToAnimateTo = t
		self.colorAnimateSpeed = s
		self.colorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateColor = true
	end
	
	function c:animateBorderToColor(t, s)
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:animateBorderToColor() :: Missing param[color]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:animateBorderToColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t > 2, "[" .. self.name .. "] FAILURE: checkbox:animateBorderToColor() :: Incorrect param[color] - expecting table length 3 or 4 and got " .. #t)
		s = s or 2
		assert(type(s) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateBorderToColor() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.borderColorToAnimateTo = t
		self.borderColorAnimateSpeed = s
		self.borderColorAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animateBorderColor = true
	end
	
	function c:animateToPosition(x, y, s)
		assert(x, "[" .. self.name .. "] FAILURE: checkbox:animateToPosition() :: Missing param[x]")
		assert(type(x) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateToPosition() :: Incorrect param[x] - expecting number and got " .. type(x))
		assert(y, "[" .. self.name .. "] FAILURE: checkbox:animateToPosition() :: Missing param[y]")
		assert(type(y) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateToPosition() :: Incorrect param[y] - expecting number and got " .. type(y))
		s = s or 2
		assert(type(s) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateToPosition() :: Incorrect param[speed] - expecting number and got " .. type(s))
		for k,v in pairs(self.pos) do self.positionToAnimateFrom[k] = v end
		self.positionToAnimateTo = {x = x, y = y}
		self.positionAnimateDrag = s
		self.positionAnimateTime = lt.getTime()
		self.inAnimation = true
		self.animatePosition = true
	end
	
	function c:animateToOpacity(o, s)
		assert(o, "[" .. self.name .. "] FAILURE: checkbox:animateToOpacity() :: Missing param[o]")
		assert(type(o) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateToOpacity() :: Incorrect param[o] - expecting number and got " .. type(o))
		s = s or 1
		assert(s, "[" .. self.name .. "] FAILURE: checkbox:animateToOpacity() :: Missing param[speed]")
		assert(type(s) == "number", "[" .. self.name .. "] FAILURE: checkbox:animateToOpacity() :: Incorrect param[speed] - expecting number and got " .. type(s))
		self.opacityToAnimateTo = o
		self.opacityAnimateTime = lt.getTime()
		self.opacityAnimateSpeed = s
		self.inAnimation = true
		self.animateOpacity = true
	end
	
	function c:isAnimating()
		return self.inAnimation
	end
	
	function c:startAnimation()
		self.inAnimation = true
	end
	
	function c:stopAnimation()
		self.inAnimation = false
	end
	
	function c:setBorderColor(bC)
		assert(bC, "[" .. self.name .. "] FAILURE: checkbox:setBorderColor() :: Missing param[color]")
		assert(type(bC) == "table", "[" .. self.name .. "] FAILURE: checkbox:setBorderColor() :: Incorrect param[color] - expecting table and got " .. type(bC))
		assert(#bC == 4, "[" .. self.name .. "] FAILURE: checkbox:setBorderColor() :: Incorrect param[color] - table length 4 expected and got " .. #bC)
		self.borderColor = bC
	end
	
	function c:getBorderColor()
		return self.borderColor
	end
	
	function c:setClickable(t)
		assert(t ~= nil, "[" .. self.name .. "] FAILURE: checkbox:setClickable() :: Missing param[clickable]")
		assert(type(t) == "boolean", "[" .. self.name .. "] FAILURE: checkbox:setClickable() :: Incorrect param[clickable] - expecting boolean and got " .. type(t))
		self.clickable = t
	end
	
	function c:isClickable()
		return self.clickable
	end
	
	function c:setColor(t)
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:setColor() :: Missing param[color]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:setColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "[" .. self.name .. "] FAILURE: checkbox:setColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		self.color = t
	end
	
	function c:getColor()
		return self.color
	end
	
	function c:setData(d)
		assert(d, "[" .. self.name .. "] FAILURE: checkbox:setData() :: Missing param[data]")
		assert(type(d) == "table", "[" .. self.name .. "] FAILURE: checkbox:setData() :: Incorrect param[data] - expecting table and got " .. type(d))
		assert(d.label or d.text, "[" .. self.name .. "] FAILURE: checkbox:setData() :: Missing param[data['text']]")
		assert(type(d.label) or type(d.text) == "string", "[" .. self.name .. "] FAILURE: checkbox:setData() :: Incorrect param[data['text']] - expecting string and got " .. type(d.label or d.text))
		assert(d.x, "[" .. self.name .. "] FAILURE: checkbox:setData() :: Missing param[data['x']]")
		assert(type(d.x) == "number", "[" .. self.name .. "] FAILURE: checkbox:setData() :: Incorrect param[data['x']] - expecting number and got " .. type(d.x))
		assert(d.y, "[" .. self.name .. "] FAILURE: checkbox:setData() :: Missing param[data['y']]")
		assert(type(d.y) == "number", "[" .. self.name .. "] FAILURE: checkbox:setData() :: Incorrect param[data['y']] - expecting number and got " .. type(d.y))
		self.w = d.w or d.width or self.w
		self.h = d.h or d.height or self.h
		self.label = d.label or d.text or self.label
		self.labelColor = d.labelColor or self.labelColor
		if d.labelPosition or d.labelPos then
			local i = d.labelPosition or d.labelPos
			if i.x then
				self.labelPosition = i
			else
				self.labelPosition.x, self.labelPosition.y, self.labelPosition.z = unpack(i)
			end
		end
		if d.padding then
			if d.padding.top or d.padding.paddingTop then
				self.optionsPaddingTop = d.padding.paddingTop or d.padding.top
				self.optionsPaddingRight = d.padding.paddingRight or d.padding.right or self.optionsPaddingRight
				self.optionsPaddingBottom = d.padding.paddingBottom or d.padding.bottom or self.optionsPaddingBottom
				self.optionsPaddingLeft = d.padding.paddingLeft or d.padding.left or self.optionsPaddingLeft
			else
				self.optionsPaddingTop, self.optionsPaddingRight, self.optionsPaddingBottom, self.optionsPaddingLeft = unpack(d.padding)
			end
		end
		self.pos.x = d.x or self.pos.x
		self.pos.y = d.y or self.pos.y
		self.pos.z = d.z or self.pos.z
		self.color = d.color or self.color
		self.border = d.useBorder and d.useBorder or self.border
		self.borderColor = d.borderColor or self.borderColor
		self.optionsColor = d.optionColor or self.optionsColor
		self.font = d.font or self.font
		self.clickable = d.clickable and d.clickable or self.clickable
		if d.options then
			if not d.keepOptions then
				self.options = {}
			end
			for k,v in ipairs(d.options) do
				if k == 1 then
					self.options[k] = {text = v, x = self.pos.x + self.font:getWidth(v), y = self.pos.y, w = self.w + self.font:getWidth(v), h = self.font:getHeight()}
				else
					self.options[k] = {text = v, x = self.options[k - 1].x + self.w + self.font:getWidth(v) + self.optionsPaddingLeft, y = self.pos.y, w = self.w + self.font:getWidth(v), h = self.font:getHeight()}
					if d.verticalOptions then
						self.vertical = true
						self.options[k].x = self.pos.x
						self.options[k].y = self.options[k - 1].y + self.font:getHeight(v)
					end
				end
			end
		end
	end
	
	function c:disable()
		self.hidden = true
	end
	
	function c:draw()
		lg.push()
		lg.setColor(1,1,1,1)
		lg.setFont(self.font)
		for k,v in ipairs(self.options) do
			if v.text then
				lg.push()
				if self.border then
					if self.parent and checkbox.guis[self.parent].use255 then
						lg.setColor(love.math.colorFromBytes(self.borderColor))
					else
						lg.setColor(self.borderColor)
					end
					lg.rectangle("line", v.x - 1, v.y - 1, v.w + 2, v.h + 2)
				end
				if self.parent and checkbox.guis[self.parent].use255 then
					lg.setColor(love.math.colorFromBytes(self.color))
				else
					lg.setColor(self.color)
				end
				lg.rectangle("fill", v.x, v.y, v.w, v.h)
				if self.selected[k] then
					lg.setColor(self.overlayColor)
					lg.rectangle("fill", v.x, v.y, v.w, v.h)
					lg.setColor(self.color)
				end
				lg.setColor(self.optionsColor)
				lg.print(v.text, v.x + self.optionsPaddingRight, v.y  + self.optionsPaddingTop)
				lg.pop()
			end
		end
		lg.setColor(self.labelColor)
		lg.print(self.label, self.labelPosition.x, self.labelPosition.y)
		lg.pop()
	end
	
	function c:enable()
		self.hidden = false
	end
	
	function c:fadeIn()
		if self.beforeFadeIn then self:beforeFadeIn() end
		self.hidden = false
		if self.faded then
			self.animateColor = true
			self.animatePosition = true
			self.animateBorderColor = true
		end
		self.faded = false
		self.fadedByFunc = true
		self:animateToOpacity(1)
		if self.onFadeIn then self:onFadeIn() end
	end
	
	function c:fadeOut(p, h)
		if self.beforeFadeOut then self:beforeFadeOut() end
		if p then 
			self.faded = true
			if h then
				self.animateColor = false
				self.animatePosition = false
				self.animateBorderColor = false
			end
		end
		self.fadedByFunc = true
		self:animateToOpacity(0)
		if self.onFadeOut then self:onFadeOut() end
	end
	
	function c:setFont(f)
		assert(f, "[" .. self.name .. "] FAILURE: checkbox:setFont() :: Missing param[font]")
		assert(type(f) == "userdata", "[" .. self.name .. "] FAILURE: checkbox:setFont() :: Incorrect param[font] - expecting font userdata and got " .. type(f))
		self.font = f
	end
	
	function c:setHollow(h)
		assert(h ~= nil, "[" .. self.name .. "] FAILURE: checkbox:setHollow() :: Missing param[hollow]")
		assert(type(h) == "boolean", "[" .. self.name .. "] FAILURE: checkbox:setHollow() :: Incorrect param[hollow] - expecting boolean and got " .. type(h))
		self.hollow = h
	end
	
	function c:isHollow()
		return self.hollow
	end
	
	function c:isHovered()
		return self.hovered
	end
	
	function c:setLabel(l)
		assert(l, "[" .. self.name .. "] FAILURE: checkbox:setLabel() :: Missing param[label]")
		assert(type(l) == "string", "[" .. self.name .. "] FAILURE: checkbox:setLabel() :: Incorrect param[label] - expecting string and got " .. type(l))
		self.label = l
	end
	
	function c:getLabel()
		return self.label
	end
	
	function c:setLabelColor(t)
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:setLabelColor() :: Missing param[color]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:setLabelColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "[" .. self.name .. "] FAILURE: checkbox:setLabelColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		self.labelColor = t
	end
	
	function c:getLabelColor()
		return self.labelColor
	end
	
	function c:setLabelPosition(t)
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:setLabelPosition() :: Missing param[position]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:setLabelPosition() :: Incorrect param[position] - expecting table and got " .. type(t))
		assert(#t == 3, "[" .. self.name .. "] FAILURE: checkbox:setLabelPosition() :: Incorrect param[position] - table length 4 expected and got " .. #t)
		if t.x then
			self.labelPosition = t
		else
			self.labelPosition.x, self.labelPosition.y, self.labelPosition.z = unpack(t)
		end
	end
	
	function c:getLabelPosition()
		return self.labelPosition
	end
	
	function c:mousepressed(x, y, button, istouch, presses)
		if button == 1 then
			print(1)
			for k,v in ipairs(self.options) do
				if x >= v.x and x <= v.x + v.w and y >= v.y and y <= v.y + v.h then
					if self.selected[k] then
						print(1)
						self.selected[k] = nil
					else
						print(2)
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
	
	function c:setOpacity(o)
		assert(o, "[" .. self.name .. "] FAILURE: checkbox:setUseBorder() :: Missing param[opacity]")
		assert(type(o) == "number", "[" .. self.name .. "] FAILURE: checkbox:setUseBorder() :: Incorrect param[opacity] - expecting number and got " .. type(o))
		self.color[4] = o
	end
	
	function c:getOpacity()
		return self.color[4]
	end
	
	function c:addOption(o)
		assert(o, "[" .. self.name .. "] FAILURE: checkbox:addOption() :: Missing param[option]")
		assert(type(o) == "string", "[" .. self.name .. "] FAILURE: checkbox:addOption() :: Incorrect param[option] - expecting string and got " .. type(o))
		local x,y
		
		if self.vertical then
			x,y = self.pos.x, self.pos.y + self.font:getHeight(o)
		else
			x,y = self.options[#self.options].x + self.font:getWidth(o), self.pos.y
		end
		self.options[#self.options + 1] = {text = o, x = x, y = y}
	end
	
	function c:removeOption(o)
		assert(o, "[" .. self.name .. "] FAILURE: checkbox:addOption() :: Missing param[option]")
		assert(type(o) == "string", "[" .. self.name .. "] FAILURE: checkbox:addOption() :: Incorrect param[option] - expecting string and got " .. type(o))
		for k,v in ipairs(self.options) do
			if v.text == o then self.options[k] = nil end
		end
	end
	
	function c:setOptionColor(t)
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:setOverlayColor() :: Missing param[color]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:setOverlayColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "[" .. self.name .. "] FAILURE: checkbox:setOverlayColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		self.optionsColor = t
	end
	
	function c:getOptionColor()
		return self.optionsColor
	end
	
	function c:setOptionPadding(p)
		assert(p, "[" .. self.name .. "] FAILURE: checkbox:setOptionPadding() :: Missing param[padding]")
		assert(type(p) == "table", "[" .. self.name .. "] FAILURE: checkbox:setOptionPadding() :: Incorrect param[padding] - expecting table and got " .. type(p))
		assert(#p == 4, "[" .. self.name .. "] FAILURE: checkbox:setOptionPadding() :: Incorrect param[padding] - expecting table length 4 and got " .. #p)
		if p.top or p.paddingTop then
			self.optionPaddingTop = p.paddingTop or p.top
			self.optionPaddingRight = p.paddingRight or p.right or self.optionPaddingRight
			self.optionPaddingBottom = p.paddingBottom or p.bottom or self.optionPaddingBottom
			self.optionPaddingLeft = p.paddingLeft or p.left or self.optionPaddingLeft
		else
			self.optionPaddingTop, self.optionPaddingRight, self.optionPaddingBottom, self.optionPaddingTop = unpack(p)
		end
	end
	
	function c:setOptionPaddingBottom(p)
		assert(p, "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingBottom() :: Missing param[padding]")
		assert(type(p) == "number", "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingBottom() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.OptionaddingBottom = p
	end
	
	function c:setOptionPaddingLeft(p)
		assert(p, "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingLeft() :: Missing param[padding]")
		assert(type(p) == "number", "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingLeft() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.OptionaddingLeft = p
	end
	
	function c:setOptionPaddingRight(p)
		assert(p, "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingRight() :: Missing param[padding]")
		assert(type(p) == "number", "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingRight() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.OptionaddingRight = p
	end
	
	function c:setOptionPaddingTop(p)
		assert(p, "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingTop() :: Missing param[padding]")
		assert(type(p) == "number", "[" .. self.name .. "] FAILURE: checkbox:setOptionPaddingTop() :: Incorrect param[padding] - expecting number and got " .. type(p))
		self.OptionaddingTop = p
	end
	
	function c:setOverlayColor(t)
		assert(t, "[" .. self.name .. "] FAILURE: checkbox:setOverlayColor() :: Missing param[color]")
		assert(type(t) == "table", "[" .. self.name .. "] FAILURE: checkbox:setOverlayColor() :: Incorrect param[color] - expecting table and got " .. type(t))
		assert(#t == 4, "[" .. self.name .. "] FAILURE: checkbox:setOverlayColor() :: Incorrect param[color] - table length 4 expected and got " .. #t)
		self.overlayColor = t
	end
	
	function c:getOverlayColor()
		return self.overlayColor
	end
	
	function c:touchmoved(id, x, y, dx, dy, pressure)
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
	end
	
	function c:setX(x)
		assert(x, "[" .. self.name .. "] FAILURE: checkbox:setX() :: Missing param[x]")
		assert(type(x) == "number", "[" .. self.name .. "] FAILURE: checkbox:setX() :: Incorrect param[x] - expecting number and got " .. type(x))
		self.pos.x = x
	end
	
	function c:getX()
		return self.pos.x
	end
	
	function c:setY(y)
		assert(y, "[" .. self.name .. "] FAILURE: checkbox:setY() :: Missing param[y]")
		assert(type(y) == "number", "[" .. self.name .. "] FAILURE: checkbox:setY() :: Incorrect param[y] - expecting number and got " .. type(y))
		self.pos.y = y
	end
	
	function c:getY()
		return self.pos.y
	end
	
	function c:setZ(z)
		assert(z, "[" .. self.name .. "] FAILURE: checkbox:setZ() :: Missing param[z]")
		assert(type(z) == "number", "[" .. self.name .. "] FAILURE: checkbox:setZ() :: Incorrect param[z] - expecting number and got " .. type(z))
		self.pos.z = z
	end
	
	function c:getZ()
		return self.pos.z
	end
	
	function c.lerp(e,s,c)
		return (1 - c) * e + c * s
	end
	
	return c
end

return checkbox