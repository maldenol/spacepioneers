// This file is part of SpacePioneers.
//
// SpacePioneers is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// SpacePioneers is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SpacePioneers.  If not, see <https://www.gnu.org/licenses/>.



/***
  "Space Pioneers"
  Main .pde file
  Malovanyi Denys Olehovych
***/



final int FPS = 60;
final float HALF_WIDTH = width / 2, HALF_HEIGHT = height / 2;

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
