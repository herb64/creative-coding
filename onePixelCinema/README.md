# My "One Pixel Camera"

This is the first attempt to modify the code. 

The sketch can also be found at [openprocessing](https://www.openprocessing.org/sketch/430564). This does not work yet, because
I get error *mySketch, Line 55: missing ; before statement*, although code has been pasted exactly as in local installation.
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

### Random sampling and reconstruction and adding interaction
The code now does a random scan of the image. The amount of samples taken per frame can be adjusted. The sampled points
are reconstructed with ellipses on the left, which start at a larger size and get smaller over time. In the end, it 
might end up in a complete reconstruction of the original image, depending on the minimum size for the ellipses.

The 'UP' or 'DOWN' keys can change the minimum ellipse during runtime, so after some time, you can produce larger
bubbles in your image.

Yu can use the 'p' key to pause the sketch. This is useful to watch your image and to take a screenshot with key 's'.
You also can pause the execution and change ellipse sizes.

The following settings have been used to create the example picture below: 
```
int maxWidth = 1800;
int maxHeight = 700;
String imgfile = "havanna2.JPG";
int nScansPerFrame = 30;
int maxDotSize = 40;
int minDotSize = 20;
```
In addition I did pause the sketch, increased the ellipse size again, did run it a short time, paused again, decreased
ellipses, run again short time and then pause again and save. This way, large bubbles and small bubbles appear as shown below.

![text description](/havanna-test-1.jpg)

## TODOs

After loading ghe image in a more comfortable way, now the real stuff will begin...

## bugs and fixes

Code seems ok, but openprocessing.org version does not work for some reason... need to check that further...