# Checkbox
The checkbox is designed to be used for taking user input on choices. A top use<br>
for the checkbox is for Poll option selection. Checkboxes can accept multiple<br>
selections, or be limited to a single selection.
## Object Creation
```lua
local GUI = require("gui")
GUI:addColor({1,0,0,.5}, "alphaRed")
GUI:addColor({.92,.97,.92,1}, "eggshell")
local colors = GUI.color
local myFont = lg.newFont("res/font/thicktext.otf", 32)
local myGui = GUI:new(GUI)
local myCheckbox = myGui:addCheckbox("myCheckbox")
myCheckbox:setData({
	w = 10, h = 10, x = 250, y = 150, z = 1, 
	label = "Favorite Color?", labelColor = colors("black"), labelFont = myFont, labelPos = {290, 105, 1},
	padding = {10,10,10,10}, fixPadding = true, 
	options = {"Red", "Blue", "Green", "Yellow"}, optionColor = colors("blue"), singleSelection = true,
	color = colors("eggshell"), 
	useBorder = true, borderColor = colors("red"),
	round = true, radius = 3,
	overlayColor = colors("alphaRed")
})
```
There are several options you can set in the `setData` function. Here is a list:
```lua
width | w
height | h
x
y
z
label | text
labelColor
useBorder
borderColor
color
clickable
image
moveable
opacity
padding [top, right, bottom, left]
options
keepOptions
optionsColor
vertical
overlayColor
labelFont
labelPosition | labelPos
round
roundRadius | radius
singleSelection | single
fixPadding | fix
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
:onOptionChange()
```
### Data Handling
```lua
:addImage(userdata image, string name, boolean automatic)
:isAnimating()
:setBorderColor(table color)
:getBorderColor()
:setClickable(boolean clickable)
:isClickable()
:setColor(table color)
:getColor()
:setData(table data)
:fixPadding(boolean fix)
:getFixPadding()
:setFont(userdata font OR string fontName)
:getFont()
:setHeight(number height)
:getHeight()
:setHollow(boolean hollow)
:getHollow()
:isHovered()
:setLabel(string label)
:getLabel()
:setLabelColor(table color)
:getLabelColor()
:setLabelFont(userdata font OR string fontName)
:getLabelFont()
:setLabelPosition(table pos)
:getLabelPosition()
:setMoveable(boolean canMove)
:getMoveable()
:setOpacity(number opacity)
:getOpacity()
:addOption(string option)
:removeOption(string option)
:setOptionColor(table color)
:getOptionColor()
:setOptionPadding(table padding) [top, right, bottom, left]
:setOptionPaddingBottom(number padding)
:setOptionPaddingLeft(number padding)
:setOptionPaddingRight(number padding)
:setOptionPaddingTop(number padding)
:setOverlayColor(table color)
:getOverlayColor()
:getParent() -- returns parent GUI object
:setUseBorder(boolean useBorder)
:getUseBorder()
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
:animateBorderToColor(table color, number speed)
:animateToPosition(number x, number y, number speed)
:animateToOpacity(number opacity, number speed)
:disable()
:enable()
:fadeIn()
:fadeOut(boolean permanent, boolean hard)
:startAnimation()
:stopAnimation()
```