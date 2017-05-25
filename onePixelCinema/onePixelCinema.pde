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
String imgfile = "venice2.JPG";

PImage myImg;
color[] pixelColors;
int scanLine;  // vertical position
int myWidth, myHeight;     // storing width and height after running getImage


void setup() {
  // get image and adjust window automatically
  myImg = getImage(imgfile);
  myWidth = myImg.width;
  myHeight = myImg.height;
  pixelColors = new color[10];
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
  } else if (hfactor < wfactor) {
    imgHeight *= hfactor;
    imgWidth *= hfactor;
    i.resize(imgWidth, imgHeight);
    println("Resizing by factor " + wfactor);
  }
  surface.setSize(2*imgWidth, imgHeight);
  return i;
}

void draw() {
  background(0);
  int t = myWidth / 10; // 35
  
  // read the colours for the current scanLine
  for (int i=0; i<10; i++) {
    //pixelColors[i] = myImg.get(17+i*35, scanLine);
    pixelColors[i] = myImg.get(t/2+i*t, scanLine);
  }

  // draw the sampled pixels as verticle bars
  for (int i=0; i< 10; i++) {
    noStroke();
    fill(pixelColors[i]);
    //rect(i*35, 0, 35, 622);
    rect(i*t, 0, t, myHeight);
  }

  // draw the image
  image(myImg, width/2, 0);

  // increment scan line position every second frame
  if (frameCount % 2 == 0) {
    scanLine ++;
  }

  if (scanLine > height) {
    scanLine = 0;
  }

  // draw circles over where the "scanner" is currently reading pixel values
  for (int i=0; i<10; i++) {
    stroke(255, 0, 0);
    noFill();
    //ellipse(width/2 + 17 + i*35, scanLine, 5, 5 );
    ellipse(width/2 + t/2 + i*t, scanLine, 5, 5 );
  }
}