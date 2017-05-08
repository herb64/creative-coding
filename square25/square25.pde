// Code for 25 squares for futurelearn creative coding
// Herbert Mehlhose, 2017
// not yet nice code, just fun to play with code and datastructures.
// everything far from being optimal

IntList slots;   // slots for our rectangles
int[] arr;
int nrows = 5;
int ncols = 5;
float hgt = 0.3;
FloatList offsetx, offsety, squaresize, rotate;
float[] xoff, yoff, sqsize, rot;
//float sizex, sizey;
int frame = 15;  // spacing around image
int drawwidth, drawheight;

void setup() {
  size(850, 850);
  drawwidth = width - 4 * frame;
  drawheight = height - 4 * frame;
  slots = new IntList();
  for(int i=1;i<=nrows;i++) // row
  {
    for(int k=1;k<=ncols;k++) // col
    {
      slots.append(i*10 + k);
    }
  }
  // squares are drawn bottom to top, so shuffle the slots
  slots.shuffle();
  // prepare an array of offsets to be used during draw
  offsetx = new FloatList();
  offsety = new FloatList();
  rotate = new FloatList();
  squaresize = new FloatList();
  for(int i=0; i < nrows*ncols; i++) {
     offsetx.append(random(-3.0, 13.0));
     offsety.append(random(-3.0, 13.0));
     squaresize.append(drawwidth / nrows * random(0.8, 1.1));
     rotate.append(random(-0.1, 0.1));
  }
  xoff = offsetx.array();
  yoff = offsety.array();
  sqsize = squaresize.array();
  rot = rotate.array();
  noStroke();
  fill(200, 130, 0);
  rectMode(CENTER); // CORNER is default
  // we only want to draw this ONCE, use noLoop() function
  noLoop();
}

void draw() {
  background(220,220,230);
  print("Width: " + width +", Height: " + height + "\n");
  // draw all shadows first
  int idx = 0;
  for(int elem : slots.array()) {
    // hgt: determines the shadow offset
    hgt = hgt + random(0.5, 1.5);
    fill(40 + int(hgt*5));
    int row = elem/(2*ncols) - 1;
    int centery = row * (drawheight / nrows) + (drawheight / nrows) / 2 + int(hgt) + int(yoff[idx]) + frame;
    int col = elem - (elem/(2*nrows))*10 - 1;
    int centerx = col * (drawwidth / ncols) + (drawwidth / ncols) / 2 + int(hgt) + int(xoff[idx]) + frame;
    print("element " + elem + " : have row " + row + " and col " + col +"\n");
    translate(centerx, centery);
    rotate(rot[idx]);
    rect(0, 0, sqsize[idx], sqsize[idx]);
    rotate(-rot[idx]);
    translate(-centerx, -centery);
    idx++;
  }
  // draw all squares in second run
  idx = 0;
  for(int elem : slots.array()) {
    fill(random(130,210), random(50,70), random(50,70));
    //rotate(0.1);
    int row = elem/(2*ncols) - 1;
    int centery = row * (drawheight / nrows) + (drawheight / nrows) / 2 + int(yoff[idx]) + frame;
    int col = elem - (elem/(2*nrows))*10 - 1;
    int centerx = col * (drawwidth / ncols) + (drawwidth / ncols) / 2 + int(xoff[idx] + frame);
    translate(centerx, centery);
    rotate(rot[idx]);
    rect(0, 0, sqsize[idx], sqsize[idx]);
    rotate(-rot[idx]);
    translate(-centerx, -centery);
    idx++;
  }
  // save the masterpiece :)
  saveFrame("square25.jpg");
}