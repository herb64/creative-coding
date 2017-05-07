
float angle;
float jitter;

void setup() {
  size(640, 360);
  noStroke();
  fill(255);
  rectMode(CENTER);
  // we only want to draw this once
  noLoop();
}

void draw() {
  background(51);

  // during even-numbered seconds (0, 2, 4, 6...)
  if (second() % 2 == 0) {  
    jitter = random(-0.1, 0.1);
  }
  //angle = angle + jitter;
  float c = cos(angle);
  translate(width/2, height/2);
  rotate(c);
  rect(0, 0, 180, 180);
  translate(90, 90);
  rect(0, 0, 90, 90);
  fill(200);
  translate(-90, -90);
  rotate(-c);
  rect(0,0,70,70);
  print("Done" + jitter +"\n");
  float[] a = {5.08,3,6.65,2};
  print(int(a[2]) + "\n");
  print(a[0] + "\n");
  float[] e = sort(a);
  print(e[0]);
}