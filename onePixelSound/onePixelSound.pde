/*
 * Creative Coding - original Code from Futurelearn Course on "Creative Coding"
 * Week 4, 03 - one pixel cinema
 * by Indae Hwang and Jon McCormack
 * Updated 2016
 * Copyright (c) 2014-2016 Monash University
 * Modifications (c) 2017 by Herbert Mehlhose

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
 * Code adaption by Herbert Mehlhose: Play 10 sinus tones which are
 * dependent on the color hue value. Each tone corresponds to one
 * of the sampled colour values, which are updated every second frame.
 * Tones can be switched on/off by keys '1'..'0', where '0' is the
 * 10nth column on the right.
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
    float hueval = (float)hue(pixelColors[i]);
    float brightval = (float)brightness(pixelColors[i]);
    sine[i].freq(map(hueval,0.0,255.0,80.0,1500.0));
    sine[i].pan(map(brightval,0.0,255.0,-1.0,1.0));
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
    // yellow ones are the active "voices"
    if(amp[i] > 0.0) {
      stroke(255, 255, 0);
    } else {
      stroke(0, 0, 0);
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
  if (keyCode >= 48 && keyCode <= 57) {
    //            0                9
    // keycode represents the ASCII value...
    // only 0 to 9 are of interest for our 10 columns / sine waves
    int n = (keyCode == 48 ? 9 : keyCode - 49);
    amp[n] = 1.0 - amp[n];
    sine[n].amp(amp[n]);
  }
}