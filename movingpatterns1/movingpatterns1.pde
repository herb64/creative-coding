/*
 * Creative Coding
 * Week 2, 05 - Moving Patterns 1
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
    
 * This sketch builds on the previous sketches, drawing shapes based on the
 * current framerate. The movement of individual shapes combine to create a
 * gestalt field of motion. Use the arrow keys on your keyboard to change the
 * frame rate. 
 * 
 */

// set initial value for global variable here - most values in one place
int frameRateValue = 6; // variable used to store the current frame rate value
int gridSize = 20; // number of circles in each column and row
int margin = 0; // margin in each circle cell
float gutter = 0; //distance between each cell
float cellsize; // declaring the variable here lets us access it in other functions in our program

void setup() {
  size(800, 800);

  //frameRateValue = 6; // now set at global definitionc
  frameRate(frameRateValue);
  rectMode(CENTER);
  background(255);
  cellsize = ( width - (2 * margin) - gutter * (gridSize - 1) ) / (gridSize - 1); //defining the value of the cellsize
}

void draw() {

  background(255);
  
  int circleNumber = 0; // counter
  for (int i=0; i<gridSize; i++) {
    for (int j=0; j<gridSize; j++) {
      circleNumber = (i * gridSize) + j; // different way to calculate the circle number from w2_04

      float centerpointX = margin + cellsize * i + gutter * i;
      float centerpointY = margin + cellsize * j + gutter * j;
      int col = (i*j);
      movingCircle(centerpointX, centerpointY, cellsize, circleNumber, col);
    }
  }
}

void movingCircle(float centerpointX, float centerpointY, float size, int circleNum, int col) {

  float finalAngle;
  finalAngle = frameCount + circleNum;
  float ccolor = finalAngle * 20  % 255;
  

  //the angle of rotation for each hand is affected by the frameRate and angle;  
  float endpointX = centerpointX + (size / 2) * sin(PI / frameRateValue * finalAngle);
  float endpointY = centerpointY + (size / 2) * cos(PI / frameRateValue * finalAngle);

  noStroke();
  fill(ccolor,0,255-ccolor);
  ellipse(endpointX, endpointY, size/2, size/3);
  //rect(endpointX, endpointY, size/5, size/5);
  rect(endpointX, endpointY, 1, size*5);
  noFill();
  stroke(0,0,0);
  line(centerpointX, centerpointY, endpointX, endpointY);
}

/*
 * keyReleased function
 *
 * called automatically by Processing when a keyboard key is released
 */
void keyReleased() {

  // right arrow -- increase frameRateValue
  if (keyCode == RIGHT && frameRateValue < 60) {
    frameRateValue++;
  }

  // left arrow -- decrease frameRateValue
  if ( keyCode == LEFT && frameRateValue > 1) {
    frameRateValue--;
  }
  
  if ( key == 's') {
  //if (keyPressed == true && key=='s') {
    saveFrame("movingpatterns1.jpg");
  }

  // set the frameRate and print current value on the screen
  frameRate(frameRateValue);
  // adding builtin variable frameCount to our output..
  println("Frame " + frameCount + ": Current frame Rate is: " + frameRateValue);
}