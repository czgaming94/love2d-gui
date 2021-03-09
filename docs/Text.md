# Text
The text object has a few abilities. It can be treated as regular static text, or it can be treated as a<br>
typewriter, and given syntax coding to morph and affect how the text is displayed.
## Object Creation
```lua
local GUI = require("gui")
local myText = GUI:addText("continue")
local colors = GUI.color
myText:setData({
	x = 110, y = 490, z = 2, 
	color = colors("yellow"), 
	text = "Hello {c=red,d=1,f=myFont}World!{/}",
	typewriter = true, speed = 0.5,
	fonts = {myFont = myFont}
})
```
## API Callbacks
This API brings several user defined callbacks which allow you to customize what happens when a user interacts with your elements.<br>
Any callback with an `event` paramter has a table provided to it with data accessible to the user. You can easily define these<br>
with `myBox:registerEvent("onClick", function(target, event) print(target.name, event.x, event.y) end, yourTargetObject)`
##### :onClick(target, event) -- {x, y, button, istouch, presses}
> Triggered when a user clicks on the object.
##### :onTouch(target, event) -- {id, x, y, dx, dy, pressure}
> Triggered when a user taps on the object on mobile.
##### :onHoverEnter(target, event) -- {x, y}
> Triggered when a user initially hovers over an object.
##### :onHoverExit(target, event) -- {x, y}
> Triggered when a user initially stops hovering an object.
##### :beforeFadeIn(target)
> Triggered when an object is about to fade in.
##### :onFadeIn(target)
> Triggered when an object is fading in.
##### :afterFadeIn(target)
> Triggered after an object fades in.
##### :beforeFadeOut(target)
> Triggered when an object is about to fade out.
##### :onFadeOut(target)
> Triggered when an object is fading out.
##### :afterFadeOut(target)
> Triggered after an object fades out.
##### :onTypewriterFinish(target)
> Triggered each time a typewriter element cycles its full text.
## Data Handling
These functions provide the ability to directly modify many variables of your elements. The way these work currently may change.<br>
The biggest change that may happen, is accepting additional parameter types. No old elements will be broken by updates.
##### :isAnimating()
> Returns true/false depending on whether the object is in the process of any animation.
##### :setBorderColor(table color)
> Set the border color of your element to a new color. Default is white.
##### :getBorderColor()
> Returns a table of the current element border color.
##### :setClickable(boolean clickable)
> Set whether the element will register as a clickable object.
##### :isClickable()
> Returns whether the element is clickable.
##### :setColor(table color)
> Set the color of your element as a new color. Default is white.
##### :getColor()
> Returns a table of the current element color.
##### :setData(table data)
There are several options you can set in the `setData` function. Here is a list:
var type | var name
---------|---------
table | borderColor
table | color
boolean | clickable
number | height / h
userdata | image
boolean | moveable
number | opacity
boolean | typewriter
boolean | useBorder
number | width / w
number | x
number | y
number | z
boolean | vertical
##### :setHeight(number height)
> Set the height of the current element
##### :getHeight()
> Get the height of the current element
##### :setHollow(boolean hollow)
> Sets whether an element is detected as hollow. When an element is hollow, it will allow the user to click through it,<br>
> while also triggering its own onClick() function.
##### :getHollow()
> Returns whether an element is hollow.
##### :isHovered()
> Returns whether an element is hovered.
##### :setMoveable(boolean canMove)
> Set whether an element is moveable.<br>
> Currently unfunctional.
##### :getMoveable()
> Get whether the element is moveable.<br>
> Currently unfunctional.
##### :setOpacity(number opacity)
> Set the opacity of the current element
##### :getOpacity()
> Get the opacity of the current element
##### :getParent()
> Returns the parent GUI object of the current element.
##### :setUseBorder(boolean useBorder)
> Set whether the element should have a border.
##### :getUseBorder()
> Get whether the element has a border.
##### :setWidth(number width)
> Set the width of the current element.
##### :getWidth()
> Get the width of the current element.
##### :setX(number x)
> Set the X position of the current element.
##### :getX()
> Get the X position of the current element.
##### :setY(number y)
> Set the Y position of the current element.
##### :getY()
> Get the Y position of the current element.
##### :setZ(number z)
> Set the Z position of the current element.
##### :getZ()
> Get the Z position of the current element.
## Object Manipulation
These functions are used for animating, enabling, and disabling elements.
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
##### :fadeOut(boolean disableClick, boolean haltAnimations)
> Fade the object out to 0 opacity.
> <br>`disableClick` will prevent the API from performing click operations on the object while it is faded out.
> <br>`haltAnimations` will stop the object in its animation state and fade out to 0 opacity.
##### :startAnimation()
> Resumes any halted animations.
##### :stopAnimation()
> Halts any currently progressing animations.
