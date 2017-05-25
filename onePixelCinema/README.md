# My "One Pixel Camera"

This is the first attempt to modify the code. 

The sketch can also be found at [openprocessing](https://www.openprocessing.org/sketch/430564). This does not work yet, because
I get error *mySketch, Line 1: missing ; before statement*, although code has been pasted exactly as in local installation.
Images have been uploaded. It's not the first time, that I encounter that problem...

Any photos, except melbourneCity.jpg and nasaImage.jpg which are provided as course material, are copyrighted by Herbert Mehlhose.

## News

This first version jsut implements a way to automatically adjust your window size to the image loaded. I found, that
the size() function does not allow to use variables. 

The following code works fine
```
PImage i = loadImage(filename);
int imgWidth = i.width;
int imgHeight = i.height;
// ... process image including rescaling calculations for new imgWidth/height
i.resize(imgWidth, imgHeight);
surface.setSize(2*imgWidth, imgHeight);
```

## TODOs

After loading ghe image in a more comfortable way, now the real stuff will begin...

## bugs and fixes

Not yet any found