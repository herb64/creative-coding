/*
 * Creative Coding
 * Week 4, 01 - an interactive colour wheel picker
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
    
 * This program draws an interactive colour selection wheel
 * Drag the colour circle around the hue wheel to change hue, change the distance
 * from the wheel to control brightness.
 *
 * Another colour circle is displayed showing the colour 180 degrees from the current colour
 * 
 */

/* Code changes by Herbert Mehlhose, 05/2017
 * 
 * 1. Make it a real circle. Using arc() for this. Original color wheel
 *    code moved into wheelOrig() function. New function wheelHerb() implements
 *    the "real wheel"... You can use key "w" to toggle between both...
 * 2. Key "s" allows to save your image to "colourwheel1.jpg"
 * 3. wheelSegments can be set in the variables below... 10 was the default, using
 *    20 now
 * 
 * There is still a mirror around the positive 45degrees axis comparing the original
 * with my implementation..
 *
 */

// Some new variables for state information with my code
boolean useHerbWheel = true;   // by default, use the new one
int wheelSegments = 20;        // change this as you like
int standardSegments = 20;     // allows variable segments for original as well

// colourHandle: the user interface element to changing colours over the wheel
// It has a postion and a size
//
float colorHandleX;
float colorHandleY;
float handleSize = 30;

// boolean isLocked
// the state of handle: when the color handle is pressed, 
// color hand is locked–released as the left mouse button is released 
//
boolean isLocked = false;

// Wheel radius: inner and outer
//
float innerR = 100; // inner
float outerR = 200; // outer
float outerR2 = outerR * 1.5; // limit of the handle's "pull" range

// current and complementry colour
float hueValue = 180;
float brightValue = 100;
float complementryHue = 0;

void setup() {

  size(800, 800);
  colorMode(HSB, 360, 100, 100); // use HSB colour mode, H=0->360, S=0->100, B=0->100

  colorHandleX = width/2+300;
  colorHandleY = height/2;
  background(0,0,0);
}


void draw() {
  //Since were using HSB colour mode this clears the display window to white
  //         H  S  B
  background(0, 0, 0);
  // Playing with blend...
  //blendMode(BLEND); // actually, this is default mode, see ref
  //fill(0, 50);
  //rect(0, 0, width/2, height/2);
  
  // draw reference line at the 0/360 hue boundary
  stroke(0, 40);
  line(width/2 - innerR, height/2, width/2 - outerR2, height/2);

  //draw itten's color wheel - we'll use a QUAD_STRIP for this
  noStroke();
  if(useHerbWheel) {
    wheelHerb();
  } else {
    wheelOrig();
  }

  // colour handle Position Update
  colorHandleUpdate();

  //draw dotted line from center to colorhandle
  dotLine(width/2, height/2, colorHandleX, colorHandleY, 40); 

  //draw color handle
  noStroke();
  fill(0);
  ellipse(width/2, height/2, 10, 10);

  //   Hue       Sat  Brightness
  fill(hueValue, 100, brightValue);
  ellipse(colorHandleX, colorHandleY, handleSize, handleSize );

  //complementry color for colorHandle (comHand)
  float angleComHand = atan2(colorHandleY-height/2, colorHandleX-width/2) + PI;
  float radiusComeHand = 150;
  float comHandX = width/2  + radiusComeHand * cos(angleComHand);
  float comHandY = height/2 + radiusComeHand * sin(angleComHand);

  //dotline from center to comHand
  dotLine(width/2, height/2, comHandX, comHandY, 20); 

  complementryHue = calculateCompHue(hueValue);

  //println("hueValue: "+hueValue + " + "+"comhue: "+complementryHue);

  fill( complementryHue, 100, brightValue );
  ellipse(comHandX, comHandY, 40, 40);
}

/*
 * calculateCompHue
 *
 * Calculates the complimentary hue from the hue supplied
 */
float calculateCompHue(float hueValue) {

  // Calculate complimentary color with hueValue
  // The complimentary colour should be 180 degrees opposite the selected colour
  if (hueValue >= 180 && hueValue < 360) {
    return hueValue-180;
  } else 
    return hueValue+180;
}


/*
 * colorHandleUpdate
 *
 * Updates the position and orientation of the colour handle based on
 * mouse position when left mouse button is pressed.
 */
void colorHandleUpdate() {

  // isLocked will be true if we pressed the mouse down while over the handle
  if (isLocked) {

    // calculate angle of handle based on mouse position
    // atan2 value is in the range from pi to -pi
    float angle = atan2(mouseY-height/2, mouseX-width/2  );
    float distance = dist(mouseX, mouseY, width/2, height/2);
    float radius = constrain(distance, outerR, outerR2); 
    colorHandleX = width/2  + radius * cos(angle);
    colorHandleY = height/2 + radius * sin(angle);

    hueValue = map (degrees(angle), -180, 180, 360, 0);

    // map distance from outer edge of the wheel to brightness
    brightValue = map(radius, outerR, outerR2, 0, 100);

    //Shape for the locked colorHandle 
    noStroke(); 
    fill(0, 0, 85);
    ellipse(colorHandleX, colorHandleY, handleSize+20, handleSize+20);
  }
}


/*
 * isWithinCircle
 * boolean function that returns true if the mouse is within the circle with centre (x,y) radius r
 */
boolean isWithinCircle(float x, float y, float r) {
  float distance = dist(mouseX, mouseY, x, y);
  return (distance <= r);
}

/*
 * dotLine
 * draw a dotted line from (x1,y1) to (x2,y2)
 */
void dotLine(float x1, float y1, float x2, float y2, int dotDetail) {

  for (int i=0; i<=dotDetail; i++) {
    float dotDetailFloat = (float) dotDetail;
    float dotX = lerp(x1, x2, i/dotDetailFloat);
    float dotY = lerp(y1, y2, i/dotDetailFloat);
    strokeWeight(2);
    stroke(0, 0, 40);
    point(dotX, dotY);
  }
}

/*
 * wheelOrig()
 * draw the original colorwheel - this has been moved from draw() into a
 * separate function to make it switchable (use key "w")
 */
void wheelOrig() {
  beginShape(QUAD_STRIP);
  for (int i=0; i<=standardSegments; i++) {
    float angle = radians(360.0/standardSegments*i-90.0); // 10 x 36 degree steps

    //   Hue   Sat  Brightness 
    fill(360.0/standardSegments*i, 100, 100);  // change the colour as we're building the quads
    //outside(top)
    vertex( width/2 + outerR*sin(angle), height/2 + outerR*cos(angle) );
    //inside(down)
    vertex( width/2 + innerR*sin(angle), height/2 + innerR*cos(angle) );
  }
endShape(CLOSE);
}

/*
 * wheelHerb()
 * draw a wheel as circle instad of quad strips
 * as mentioned in the processing reference, the arc() function might be inaccurate...
 * Note: it is important to use float numbers (xx.x) in calculations, otherwise larger
 * number of segments will not get drawn (rounding errors)
 */
void wheelHerb() {
  float ang = 0.0;
  for (int i=1; i<=wheelSegments; i++) {
    float angle = radians((360.0/wheelSegments)*i);
    float hue = 180.0 - (i-1) * 360.0/wheelSegments;
    fill(hue < 0 ? hue + 360.0 : hue, 100, 100);
    arc(400.0, 400.0, outerR*2, outerR*2, ang, angle);
    ang = angle;  
  }
  noStroke();
  // here, we just fill the inner area to get a ring instead of a "piechart"
  fill(0,0,0);
  ellipse(400,400,outerR,outerR);
}

/*
 * mousePressed
 * When mouse button is first pressed, check if the user has pressed over the colour handle
 * If so, set isLocked to true to lock manipulation of the handle
 *
 */
void mousePressed() {
  if (isWithinCircle(colorHandleX, colorHandleY, handleSize)) {
    isLocked = true;
  }
}

/*
 * mouseReleased
 * Unlock control of the handle
 *
 */
void mouseReleased() {
  isLocked = false;
  fill(0,100,100);
  ellipse(100,100,20,20);
}

/*
 * keyReleased function
 */
void keyReleased() {
  if ( key == 'w') {
    useHerbWheel = !useHerbWheel;
  }

  if ( key == 's') {
    saveFrame("colorwheel1.jpg");
  }
}