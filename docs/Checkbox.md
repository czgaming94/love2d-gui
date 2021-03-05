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
## API Callbacks
##### :onClick(event) -- {x, y, button, istouch, presses}
> Triggered when a user clicks on the object.
##### :onTouch(event) -- {id, x, y, dx, dy, pressure}
> Triggered when a user taps on the object on mobile.
##### :onHoverEnter()
> Triggered when a user initially hovers over an object.
##### :onHoverExit()
> Triggered when a user initially stops hovering an object.
##### :beforeFadeIn()
> Triggered when an object is about to fade in.
##### :onFadeIn()
> Triggered when an object is fading in.
##### :afterFadeIn()
> Triggered after an object fades in.
##### :beforeFadeOut()
> Triggered when an object is about to fade out.
##### :onFadeOut()
> Triggered when an object is fading out.
##### :afterFadeOut()
> Triggered after an object fades out.
##### :onOptionChange()
> Triggered when a user clicks an option on a checkbox.
## Data Handling
##### :isAnimating()
> Returns true/false depending on whether the object is in the process of any animation.
##### :setBorderColor(table color)
##### :getBorderColor()
#####:setClickable(boolean clickable
#####:isClickable()
#####:setColor(table color)
#####:getColor()
#####:setData(table data)
There are several options you can set in the `setData` function. Here is a list:
> table                             borderColor
> table                             color
> boolean                           clickable
> boolean                           fixPadding | fix
> number                            height | h
> userdata                          image
> boolean                           keepOptions
> string                            label | text
> table                             labelColor
> userdata                          labelFont
> table                             labelPosition | labelPos
> boolean                           moveable
> number                            opacity
> table                             options
> table                             optionsColor
> table                             overlayColor
> table                             padding
> boolean                           round
> number                            roundRadius | radius
> boolean                           singleSelection | single
> boolean                           useBorder
> number                            width | w
> number                            x
> number                            y
> number                            z
> boolean                           vertical
##### :fixPadding(boolean fix)
> Adjusts padding to be ignored on the top of first line, and ignore left padding on first object.
##### :getFixPadding()
##### :setFont(userdata font OR string fontName)
##### :getFont()
##### :setHeight(number height)
##### :getHeight()
##### :setHollow(boolean hollow)
> When an object is hollow, it will allow the user to click through it, while also triggering its own onClick() function.
##### :getHollow()
##### :isHovered()
##### :setLabel(string label)
##### :getLabel()
##### :setLabelColor(table color)
##### :getLabelColor()
##### :setLabelFont(userdata font OR string fontName)
##### :getLabelFont()
##### :setLabelPosition(table pos)
##### :getLabelPosition()
##### :setMoveable(boolean canMove)
> Currently unfunctional.
##### :getMoveable()
##### :setOpacity(number opacity)
##### :getOpacity()
##### :addOption(string option)
##### :removeOption(string option)
##### :setOptionColor(table color)
##### :getOptionColor()
##### :setOptionPadding(table padding) [top, right, bottom, left]
##### :setOptionPaddingBottom(number padding)
##### :setOptionPaddingLeft(number padding)
##### :setOptionPaddingRight(number padding)
##### :setOptionPaddingTop(number padding)
##### :setOverlayColor(table color)
##### :getOverlayColor()
##### :getParent()
> Returns the parent GUI object of the current object.
##### :setUseBorder(boolean useBorder)
##### :getUseBorder()
##### :setWidth(number width)
##### :getWidth()
##### :setX(number x)
##### :getX()
##### :setY(number y)
##### :getY()
##### :setZ(number z)
##### :getZ()
## Object Manipulation
##### :animateToColor(table color, number speed)
> Animate the current object to a new color, at the provided speed, or at 2s without a speed given.
##### :animateBorderToColor(table color, number speed)
> Animate the current object to a new border color, at the provided speed, or at 2s without a speed given.
##### :animateToPosition(number x, number y, number speed)
> Animate the current object to a new position, at the provided speed, or at 2s without a speed given.
##### :animateToOpacity(number opacity, number speed)
> Animate the current object to a new opacity, at the provided speed, or at 2s without a speed given.
##### :disable()
> Fully disable and hide the object.
##### :enable()
> Enable and show the object if it was hidden.
##### :fadeIn()
> Fade the object in from X opacity to full 1.0 opacity.
##### :fadeOut(boolean permanent, boolean hard)
> Fade the object out to 0 opacity.
##### :startAnimation()
> Resumes any halted animations.
##### :stopAnimation()
> Halts any currently progressing animations.