# Box
The goal of the box object is for backgrounds, buttons, and HUD containers. This is<br>
the most commonly used type of object in a GUI.
## Object Creation
```lua
local GUI = require("gui")
local myGui = GUI:new(GUI)
local myBox = myGui:addBox("myBox")
myBox:addImage(lg.newImage("res/img/background.png"), "background", true)
myBox:setData({ w = 800, h = 600, x = 0, y = 0, z = 0})
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
moveable
opacity
padding [top, right, bottom, left]
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
## Data Handling
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
:setHeight(number height)
:getHeight()
:isHovered()
:setImage(userdata image OR string imageName)
:getImage()
:setPadding(table padding) [top, right, bottom, left]
:setPaddingBottom(number padding)
:setPaddingLeft(number padding)
:setPaddingRight(number padding)
:setPaddingTop(number padding)
:setMoveable(boolean canMove)
:getMoveable()
:setOpacity(number opacity)
:getOpacity()
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