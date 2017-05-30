/*
 * Creative Coding
 * Week 4, 03 - one pixel cinema
 * by Indae Hwang and Jon McCormack
 * Updated 2016
 * Copyright (c) 2014-2016 Monash University
 * Modifications by Herbert Mehlhose, 2017
 * Include some sound processing to acoustically scan the image

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
 * Code adaption by Herbert Mehlhose: Play 10 sinus tones according to the
 * scanned pixels.
 *
 */

// setup the sound library and audio player
import processing.sound.*;

PImage myImg;
color[] pixelColors;
SinOsc[] sine;
float[] amp;
int scanLine;  // vertical position

void setup() {
  size(700, 622);
  myImg = loadImage("nasaImage.jpg");
  //myImg = loadImage("melbourneCity.jpg");
  pixelColors = new color[10];
  sine = new SinOsc[10];
  amp = new float[10];
  for(int i=0; i<10; i++) {
    sine[i] = new SinOsc(this);
    amp[i] = 1.0;
    sine[i].amp(amp[i]);
    sine[i].play();
  }
  scanLine = 0;
  smooth(4);
}

void draw() {
  background(0);

  // read the colours for the current scanLine
  for (int i=0; i<10; i++) {
    pixelColors[i] = myImg.get(17+i*35, scanLine);
    //if(i == 2) {
      float hueval = (float)hue(pixelColors[i]);
      float blueval = (float)blue(pixelColors[i]);
      float freq = map(hueval,0.0,255.0,80.0,1500.0);
      float pan = map(blueval,0.0,255.0,-1.0,1.0);
      //println("Red: " + hueval + ", Freq: " + freq);
      sine[i].freq(freq);
      sine[i].pan(pan);
    //}
  }

  // draw the sampled pixels as verticle bars
  for (int i=0; i< 10; i++) {
    noStroke();
    fill(pixelColors[i]);
    rect(i*35, 0, 35, 622);
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
    if(amp[i] > 0.0) {
      stroke(0, 255, 0);
    } else {
      stroke(100, 100, 255);
    }
    noFill();
    ellipse(width/2 + 17 + i*35, scanLine, 5, 5 );
  }
}

/*
 * stop
 * Stop audio playback and cleanup
 */
void stop() {
  for(int i=0;i < 10;i++){
    sine[i].stop();  
  }
  super.stop();
}

/*
 * keyReleased function
 */
void keyReleased() {
  int n;
  /*if ( keyCode == UP) {
    minDotSize += 5;
    if (minDotSize >= maxDotSize) {
      minDotSize = maxDotSize;
      println("Upper size limit reached... (" + minDotSize + ")");
    }
  }*/
  // we should use keycode, which is the ascii value...
  if (keyCode >= 48 && keyCode <= 57) {
    //            0                9
    if(keyCode == 48) {
      n = 9;
    } else {
      n = keyCode - 49;
    }
    //keyCode == 48 ? n = 9 : n = keyCode - 48;
    println("changing " + n );
    amp[n] = 1.0 - amp[n];
    sine[n].amp(amp[n]);
  }
}