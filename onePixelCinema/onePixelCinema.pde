/* @pjs preload="havanna2.JPG"; */
/*
 * Creative Coding
 * Week 4, 03 - one pixel cinema
 * by Indae Hwang and Jon McCormack
 * Updated 2016
 * Copyright (c) 2014-2016 Monash University

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
 * This simple sketch demonstrates how to read pixel values from an image
 * It simulates a 10 pixel "scanner" that moves from the top to the bottom of the image
 * reading the colour values for 10 equally spaced points, then displaying those colours
 * as vertical bars on the left half of the screen.
 *
 */

/******************************************************************************************* 
 *
 * Code Modifications by Herbert Mehlhose, 05/2017
 *
 * - change code to adjust window size automatically to fit image - DONE
 *
 * Basic idea behind this sketch - TODO
 * 1. Sample the original image at random positions
 * 2. "Reconstruct" the image in some distorted manner, by placing circles of random size etc
 *    into the destination at same position. Maybe also change destination position slightly.
 *    - depending on the number of scanned pixels, start with larger circles, which get
 *      smaller with increasing samples. Thus, in the end, the original image might appear...
 *    - use clip() to avoid overdraw between left and right half of window.
 * 3. Adding randomness
 *    - do some distortion by shifting to right by a value dependent on x or y position.
 *    - change the color within the reproduced image, e.g. invert hue or at least change
 *    - ...
 * 5. Make algorithms changeable by keystrokes dynamically to add interaction
 *
 * Questions of interest: high contrast images vs. low contrast images behaviour
 *
 * TODO: size and aspect ratio of original image - should be somewhat independent...
 * is it possible to load image and calculate size of screen according to these values?
 *
 *
 *******************************************************************************************/

// adjust these limits for window size, used by automatic scaling to given image
int maxWidth = 1800;
int maxHeight = 700;
String imgfile = "havanna2.JPG";
int nScansPerFrame = 30;
int maxDotSize = 80;
int minDotSize = 20;
boolean isSuspended = false;    // key 'p' can be used to pause

PImage myImg;
color[] pixelColors;
int scanLine;  // vertical position
int myWidth, myHeight;          // storing width and height after running getImage
int imageIndex = 1;             // index to save images
int[] x, y;

void setup() {
  // get image and adjust window automatically
  myImg = getImage(imgfile);
  myWidth = myImg.width;
  myHeight = myImg.height;
  pixelColors = new color[nScansPerFrame];
  x = new int[nScansPerFrame];
  y = new int[nScansPerFrame];
  scanLine = 0;
  smooth(4);
}

/* 
 * function getImage()
 * Load an image passed by filename and adjust window size to fit
 * surface.setSize() is the solution to set size depending on
 * variable values.
 */
PImage getImage(String filename) {
  PImage i = loadImage(filename);
  int imgWidth = i.width;
  int imgHeight = i.height;
  float wfactor = 1.0;
  float hfactor = 1.0;
  println("Image '" + filename + "': " + imgWidth + " * " + imgHeight);
  // if image is to large to fit into given window size limits, adjust
  // the image. Make sure to keep aspect ratio. No upscaling is done!
  if (imgWidth > maxWidth/2) {
    wfactor = (float)(maxWidth/2) / imgWidth;
    println("Image too wide, wfactor = " + wfactor);
  }
  if (imgHeight > maxHeight) {
    hfactor = (float)(maxHeight) / imgHeight;
    println("Image too high, hfactor = " + hfactor);
  }
  // the smaller factor wins
  if(wfactor < hfactor) {
    imgHeight *= wfactor;
    imgWidth *= wfactor;
    i.resize(imgWidth, imgHeight);
    println("Resizing by factor " + wfactor);
    
  } else if ((hfactor <= wfactor) && hfactor < 1.0) {
    imgHeight *= hfactor;
    imgWidth *= hfactor;
    i.resize(imgWidth, imgHeight);
    println("Resizing by factor " + wfactor);
  }
  surface.setSize(2*imgWidth, imgHeight);
  return i;
}

void draw() {
  //background(0);
  if (isSuspended) {
    return;
  }
  float dotSize = constrain((float)maxDotSize / (1.0 + (float)frameCount/150.0), minDotSize, maxDotSize);
  //int t = myWidth / nScansPerFrame; // 35
  
  // Read color information from image using a certain amount of 
  // sampling points.
  for (int i=0; i<nScansPerFrame; i++) {
    y[i] = scanLine;
    x[i] = (int)random(0, myWidth);
    y[i] = (int)random(0, myHeight);
    pixelColors[i] = myImg.get(x[i], y[i]);
  }

  // Redraw the sampled pixels on the left canvas.
  for (int i=0; i< nScansPerFrame; i++) {
    noStroke();
    clip(0, 0, myWidth, myHeight);
    fill(pixelColors[i]);
    //rect(i*35, 0, 35, 622);
    //rect(i*t, 0, t, myHeight);
    ellipse(x[i], y[i], dotSize, dotSize);
    noClip();
  }

  // draw the image just once
  if(frameCount == 1) {
    background(0);
    image(myImg, width/2, 0);
  }
  
  // increment scan line position every second frame
  if (frameCount % 2 == 0) {
    scanLine ++;
  }

  if (scanLine > height) {
    scanLine = 0;
  }

  // draw circles over where the "scanner" is currently reading pixel values
  for (int i=0; i<nScansPerFrame; i++) {
    clip(myWidth, 0, width, height);
    //stroke(255, 0, 0);
    noFill();
    //stroke(pixelColors[i]);
    //ellipse(width/2 + t/2 + i*t, y[i], 5, 5 );
    //ellipse(width/2 + x[i], y[i], maxDotSize-dotSize, 2*maxDotSize-dotSize);
    stroke(0);
    ellipse(width/2 + x[i], y[i], 23, 23);
    //point(width/2 + x[i], y[i]);
    noClip();
  }
}

/*
 * keyReleased function
 */
void keyReleased() {
  if ( keyCode == UP) {
    minDotSize += 5;
    if (minDotSize >= maxDotSize) {
      minDotSize = maxDotSize;
      println("Upper size limit reached... (" + minDotSize + ")");
    }
  }
  if ( keyCode == DOWN) {
    minDotSize -= 5;
    if (minDotSize <= 0) {
      minDotSize = 1;
      println("Lower size limit reached... (1)");
    }
  }
  if (key == 'p') {
    isSuspended = !isSuspended;
    println("Suspended: " + isSuspended);
  }
  if (key == 'r') {
    frameCount = 0;
    println("Restarting from beginning....");
  }
  // save for now saves the whole frame only, we might
  // have a save for left portion only
  if ( key == 's') {
    String filename="onePixelCam" + imageIndex++ + ".jpg";
    saveFrame(filename);
  }
}