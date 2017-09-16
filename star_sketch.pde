void setup() {
  background(0, 60, 60);
  
  XML xml;
  xml = loadXML("dreamdict.xml");
  XML[] children = xml.getChildren("animal");
  
  
  PImage img;
  img = loadImage("8ball.png");
  imageMode(CORNER);
  image(img, 10, 10, 200, 200);

  textSize(32);
  
  for (int i = 0; i < children.length; i++) {
    int id = children[i].getInt("id");
    String coloring = children[i].getString("species");
    String name = children[i].getContent();

    text(name, 10, 35*(i+1)); 

  }

void draw() {
  background(102);
 
  pushMatrix();
  translate(width*0.8, height*0.5);
  rotate(frameCount / -100.0);
  star(0, 0, 30, 70, 5); 
  popMatrix();
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
