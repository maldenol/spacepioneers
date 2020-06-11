# This file is part of SpacePioneers.
#
# SpacePioneers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SpacePioneers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SpacePioneers.  If not, see <https://www.gnu.org/licenses/>.



final int FPS = 60;
String world = "SolarSystem";

float cameraPosX, cameraPosY, cameraPosZ, cameraCenterX, cameraCenterY, cameraCenterZ, cameraUpX, cameraUpY, cameraUpZ;

Space space;


void settings() {
    fullScreen(P3D);
}

void setup() {
    frameRate(FPS);
    noCursor();
    
    
    cameraPosX = cameraPosY = cameraPosZ = 0;
    cameraCenterX = cameraCenterY = 0;
    cameraCenterZ = 1;
    cameraUpX = cameraUpZ = 0;
    cameraUpY = 1;
    
    //space = new Space(world);
}

void draw() {
    if(space == null)
        space = new Space(world);
    
    
    space.tick();
    
    
    background(0);
    beginCamera();
    camera(cameraPosX, cameraPosY, cameraPosZ, cameraCenterX, cameraCenterY, cameraCenterZ, cameraUpX, cameraUpY, cameraUpZ);
    
    noStroke();
    translate(cameraPosX, cameraPosY, cameraPosZ);
    PShape pshape = createShape(SPHERE, 6E3);
    pshape.setTexture(space.getSkybox());
    pshape.rotateY(HALF_PI);
    shape(pshape, 0, 0);
    translate(-cameraPosX, -cameraPosY, -cameraPosZ);
    
    space.show();  
    
    endCamera();
}
