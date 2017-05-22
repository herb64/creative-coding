/*
 * Creative Coding
 * Week 3, 02 - array with sin()
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
    
 * This program demonstrates the use of arrays.
 * It creates three arrays that store the y-position, speed and phase of some oscillating circles.
 * You can change the number of circles by changing the value of num in setup()
 * You can change the background colour by holding the left mouse button and dragging.
 * 
 */

// code changed by Herbert Mehlhose, 22.05.2017 to stop circle movement by mouse 
// click and resume on clicking again.
// Current speed is kept by using negative speed value as indicator for stopped state
// which allows to toggle by mouse click and keeping original value at the same time.
// x position is kept in addition in a new array xs - to save the old position
// lost frame counts are used to resume movement at the point where it was stopped

// TODO: lostframes counter will get a problem if reaching limit of integer!!!

int     noCircles;    // the number of items in the array (# of circles)
float[] y;            // y-position of each circle (fixed)
float[] xs;           // x-position to be stored for stopped circle
int[] lostframes;     // lost frames during stopped state
float[] speed;        // speed of each circle
float[] phase;        // phase of each circle

float red = 120;
float green = 120;
float blue = 120;


void setup() {
  size(500, 500);

  noCircles = 20;

  // allocate space for each array
  y = new float[noCircles];
  xs = new float[noCircles];
  lostframes = new int[noCircles];
  speed = new float[noCircles];
  phase = new float[noCircles]; 

  // calculate the vertical gap between each circle based on the total number of circles
  float gap = height / (noCircles + 1);

  //setup an initial value for each item in the array
  for (int i=0; i<noCircles; i++) {
    y[i] = gap * (i + 1);      // y is constant for each so can be calculated once
    speed[i] = random(3);      // original 10 - too fast
    phase[i] = random(TWO_PI);
    lostframes[i] = 0;
  }
}


void draw() {
  background(red, green, blue);

  for (int i=0; i<noCircles; i++) {
    //float x;
    // calculate the x-position of each ball based on the speed, phase and current frame
    if(speed[i] < 0) {
      lostframes[i] += 1;
    } else {
      xs[i] = width/2 + sin(radians((frameCount - lostframes[i])*speed[i] ) + phase[i])* 200;
    }
    ellipse(xs[i], y[i], 20, 20);
  }
}


// change the background colour if the mouse is dragged
void mouseDragged() {
  red = map(mouseX, 0, width, 0, 255);
  green = map(mouseY, 0, height, 0, 255);
  blue = map(mouseX+mouseY, 0, width+height, 255, 0);
}

void mouseClicked() {
  for (int i=0; i<noCircles; i++) {
    if (dist(mouseX, mouseY, xs[i], y[i]) < 22) {
      // toggling speed to negative: flag and old value store at same time
      speed[i] = speed[i] * -1;
      println("Toggle circle index " + i + ", Speed = " + speed[i]);
      if (speed[i] > 0) {
        println("Circle " + i + " has now " + lostframes[i] + " lost frames"); 
      }
    }
  }
}