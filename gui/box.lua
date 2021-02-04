local lg = love.graphics
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
	b.border = false
	b.borderColor = {1,1,1,1}
	b.color = {1,1,1,1}
	b.font = love.graphics.getFont()
	
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
	
	function b:draw()
		lg.push()
		
		
		if self.border then
			lg.setColor(self.borderColor)
			lg.rectangle("line", self.x - 1, self.y - 1, self.w + 2, self.h + 2)
		end
		
		lg.setColor(self.color)
		lg.rectangle("fill", self.x, self.y, self.w, self.h)
		lg.pop()
	end
	
	function b:setFont(f)
		assert(f, "FAILURE: box:setFont() :: Missing param[font]")
		assert(type(f) == "userdata", "FAILURE: box:setFont() :: Incorrect param[font] - expecting userdata and got " .. type(f))
		self.font = f
	end
	
	function b:getFont()
		return self.font
	end
	
	function b:setHeight(h)
		assert(h, "FAILURE: box:setHeight() :: Missing param[height]")
		assert(type(h) == "number", "FAILURE: box:setHeight() :: Incorrect param[height] - expecting number and got " .. type(h))
		self.h = h
	end
	
	function b:getHeight(h)
		return self.h
	end
	
	function b:update(dt)
	
	end
	
	function b:setUseBorder(uB)
		assert(uB, "FAILURE: box:setBorder() :: Missing param[useBorder]")
		assert(type(uB) == "boolean", "FAILURE: box:setBorder() :: Incorrect param[useBorder] - expecting boolean and got " .. type(uB))
		self.border = uB
	end
	
	function b:getUseBorder()
		return b.border
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