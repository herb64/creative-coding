
float angle;
float jitter;
quad[] q;

void setup() {
  // setup some stuff
  q = new quad[2];
  q[0] = new quad();
  q[1] = new quad();
  //q[0].infos();
  //q[1].infos();
  size(640, 360);
  noStroke();
  fill(255);
  rectMode(CENTER);
  // we only want to draw this once
  noLoop();
}

class quad {
  int size;
  float hgt;
  quad(){
    size = int(random(5, 12));
    hgt = random(0.0, 0.5);
    
  }
  void infos(){
    print("size: " + size + ", hgt: " + hgt + "\n");
  }
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
  q[0].infos();
  q[1].infos();
}