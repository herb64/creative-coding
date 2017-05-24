# My colourwheel

This is the first attempt to modify the code. You can toggle to the new implementation
by using the "w" key. 

The sketch can also be found at from [openprocessing](https://www.openprocessing.org/sketch/429868). Have fun.

## News

Note, that increasing numbers of segments makes the difference between QUAD strips and
ARCS invisible in the end.

Added the color bar at left to show the last 5 selected colors. The colors are always
stored at the top, while the others shift downwards. Using a class named historybar
to implement the color bar at the left. You can cnange quite some parameters

A help text is shown by default.

### Controlling saturation

This is now implemented by using the mouse wheel while having the color handle in use with
left mouse key pressed.

## TODOs

Also, the colorbar could get some nice animation, showing the falling elements... First steps
are prepared for this... see next release

## bugs and fixes

The mirror problem with colours has now really been solved. You can select the number of segments now
for the modified as well as the original wheel.