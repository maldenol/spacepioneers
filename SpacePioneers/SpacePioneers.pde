/***
  "Space Pioneers"
  Main .pde file
  Malovanyi Denys Olehovych
***/

final int FPS = 60;

Interface iface;


void settings() {
    fullScreen(P3D);
}

void setup() {
    frameRate(FPS);
    noCursor();
    
    iface = new Interface();
}

void draw() {
    iface.draw();
}
