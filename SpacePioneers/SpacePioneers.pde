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



int FPS;
float HALF_WIDTH, HALF_HEIGHT;

Game game;


void settings() {
    fullScreen(P3D);
}

void setup() {
    FPS = 60;
    HALF_WIDTH = width / 2.0;
    HALF_HEIGHT = height / 2.0;

    frameRate(FPS);
    noCursor();
}

void draw() {
    if(game == null) {
        game = new Game();
    }

    game.draw();
}

void keyPressed() {
    if(key == ESC) {
        key = '`';
    }
}
