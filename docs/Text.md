# Box
The text object has a few abilities. It can be treated as regular static text, or<br>
it can be treated as a typewriter, and given syntax coding to morph and affect how<br>
the text is displayed.
## Object Creation
```lua
local GUI = require("gui")
local myGui = GUI:new(GUI)
local myFont = lg.newFont("res/font/thicktext.otf", 32)
local myText = myGui:addText("continue")
myText:setData({
	x = 110, y = 490, z = 2, 
	color = colors("yellow"), 
	text = "Hello {c=red,d=1,f=myFont}World!{/}",
	typewriter = true, speed = 0.5,
	fonts = {myFont = myFont}
})
```
There are several options you can set in the `setData` function. Here is a list:
```lua
width | w
height | h
x
y
z
useBorder
borderColor
color
clickable
image
typewriter
speed
moveable
opacity
padding [top, right, bottom, left]
```
### API Callbacks
```lua
:onClick()
:onHoverEnter()
:onHoverExit()
:beforeFadeIn()
:onFadeIn()
:afterFadeIn()
:beforeFadeOut()
:onFadeOut()
:afterFadeOut()
```
### Data Handling
```lua
:isAnimating()
:setClickable(boolean clickable)
:isClickable()
:setColor(table color)
:getColor()
:setData(table data)
:addFont(userdata font, string name)
:setFont(string font)
:getFont()
:setHeight(number height)
:getHeight()
:isHovered()
:setHollow(boolean hollow)
:isHollow()
:setTypewriterSpeed(number s)
:getTypewriterSpeed()
:setOpacity(number opacity)
:getOpacity()
:getParent() -- returns parent GUI object
:setText(string text)
:getText()
:setAsTypewriter(boolean beTypewriter)
:isTypewriter()
:setWidth(number width)
:getWidth()
:setX(number x)
:getX()
:setY(number y)
:getY()
:setZ(number z)
:getZ()
```
### Object Manipulation
```lua
:animateToColor(table color, number speed)
:animateToPosition(number x, number y, number speed)
:animateToOpacity(number opacity, number speed)
:disable()
:enable()
:fadeIn()
:fadeOut(boolean permanent, boolean hard)
:startAnimation()
:stopAnimation()
:typewriterCycle()
```