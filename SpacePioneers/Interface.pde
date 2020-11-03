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
  Interface class
      ButtonServer class
          Button class
      KeyServer class
          Key class
      Camera class
  Malovanyi Denys Olehovych
***/



import java.awt.Robot;
import java.awt.AWTException;

import java.util.Iterator;


class Interface {
    private class ButtonServer {
        private ArrayList<Button[]> buttons;
        private ArrayList<Button[]> flags;
        private ArrayList<Button[]> fields;
        private ArrayList<Button[][]> buttonsLists;
        private ArrayList<Button[][]> flagsLists;
        private ArrayList<Button[][]> fieldsLists;

        private boolean fieldPressed;
        private char fieldLastChar;
        private int timeLastPress, timeBetweenPresses;


        public ButtonServer() {
            this.buttons = new ArrayList<Button[]>();
            this.flags = new ArrayList<Button[]>();
            this.fields = new ArrayList<Button[]>();
            this.buttonsLists = new ArrayList<Button[][]>();
            this.flagsLists = new ArrayList<Button[][]>();
            this.fieldsLists = new ArrayList<Button[][]>();

            this.fieldPressed = false;
            this.fieldLastChar = ' ';
            this.timeLastPress = 0;
            this.timeBetweenPresses = 300;
        }


        public void addContext(Button[] buttons, Button[] flags, Button[] fields, Button[][] buttonsLists, Button[][] flagsLists, Button[][] fieldsLists) {
            this.buttons.add(buttons.clone());
            this.flags.add(flags.clone());
            this.fields.add(fields.clone());
            this.buttonsLists.add(buttonsLists.clone());
            this.flagsLists.add(flagsLists.clone());
            this.fieldsLists.add(fieldsLists.clone());
        }

        public void setContext(int context, Button[] buttons, Button[] flags, Button[] fields, Button[][] buttonsLists, Button[][] flagsLists, Button[][] fieldsLists) {
            this.buttons.set(context, buttons.clone());
            this.flags.set(context, flags.clone());
            this.fields.set(context, fields.clone());
            this.buttonsLists.set(context, buttonsLists.clone());
            this.flagsLists.set(context, flagsLists.clone());
            this.fieldsLists.set(context, fieldsLists.clone());
        }

        public void serve(int context) {
            for(Button button : this.buttons.get(context)) {
                button.draw();

                if(button.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                    button.activate();
                    for(Button b : this.buttons.get(context)) {
                        if(b != button) {
                            b.deactivate();
                        }
                    }
                    this.timeLastPress = millis();
                }
            }

            for(Button flag : this.flags.get(context)) {
                flag.draw();

                if(flag.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                    flag.toggle();
                    this.timeLastPress = millis();
                }
            }

            for(Button field : this.fields.get(context)) {
                field.draw();

                if(field.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                    field.activate();
                    for(Button f : this.fields.get(context)) {
                        if(f != field) {
                            f.deactivate();
                        }
                    }
                    this.timeLastPress = millis();
                }

                if(field.isActive()) {
                    if(keyPressed) {
                        if(!this.fieldPressed || this.fieldLastChar != key) {
                            if(keyCode == BACKSPACE) {
                                field.pop();
                            } else if(key != CODED) {
                                field.push(key);
                            }
                            this.fieldLastChar = key;
                        }
                        this.fieldPressed = true;
                    } else {
                        this.fieldPressed = false;
                    }
                }
            }

            for(Button[] buttonList : this.buttonsLists.get(context)) {
                for(Button button : buttonList) {
                    button.draw();

                    if(button.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                        button.activate();
                        for(Button e : buttonList) {
                            if(e != button) {
                                e.deactivate();
                            }
                        }
                        this.timeLastPress = millis();
                    }
                }
            }

            for(Button[] flagList : this.flagsLists.get(context)) {
                for(Button button : flagList) {
                    button.draw();

                    if(button.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                        button.toggle();
                        this.timeLastPress = millis();
                    }
                }
            }

            for(Button[] fieldList : this.fieldsLists.get(context)) {
                for(Button button : fieldList) {
                    button.draw();

                    if(button.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                        button.activate();
                        for(Button[] fL : this.fieldsLists.get(context)) {
                            for(Button e : fL) {
                                if(e != button) {
                                    e.deactivate();
                                }
                            }
                        }
                        this.timeLastPress = millis();
                    }

                    if(button.isActive()) {
                        if(keyPressed) {
                            if(!this.fieldPressed || this.fieldLastChar != key) {
                                if(keyCode == BACKSPACE) {
                                    button.pop();
                                } else if(key != CODED) {
                                    button.push(key);
                                }
                                this.fieldLastChar = key;
                            }
                            this.fieldPressed = true;
                        } else {
                            this.fieldPressed = false;
                        }
                    }
                }
            }
        }

        public void clear(int context) {
            for(Button button : this.buttons.get(context)) {
                button.deactivate();
            }

            for(Button flag : this.flags.get(context)) {
                flag.deactivate();
            }

            for(Button field : this.fields.get(context)) {
                field.deactivate();
            }

            for(Button[] buttonsList : this.buttonsLists.get(context)) {
                for(Button button : buttonsList) {
                    button.deactivate();
                }
            }

            for(Button[] flagsList : this.flagsLists.get(context)) {
                for(Button button : flagsList) {
                    button.deactivate();
                }
            }

            for(Button[] fieldsList : this.fieldsLists.get(context)) {
                for(Button button : fieldsList) {
                    button.deactivate();
                }
            }
        }


        private class Button {
            private float x, y, w, h, b, c;
            private String content;
            private boolean active;


            public Button(float x, float y, float w, float h, String content) {
                this.x = x;
                this.y = y;
                this.w = w;
                this.h = h;
                if(this.h <= this.w) {
                    this.b = this.h / 16.0;
                    this.c = this.h / 4.0;
                } else {
                    this.b = this.w / 16.0;
                    this.c = this.w / 4.0;
                }
                this.content = content;
                this.active = false;
            }

            public Button(float x, float y, float w, float h, float b, float c, String content) {
                this(x, y, w, h, content);
                this.b = b;
                this.c = c;
            }

            public boolean isPressed() {
                return (this.content.length() > 0 && mousePressed && mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
            }

            public void draw() {
                if(this.active) {
                    fill(255, 127);
                } else {
                    fill(0, 127);
                }
                stroke(255);
                strokeWeight(this.b);
                rect(this.x, this.y, this.w, this.h, this.c, this.c, this.c, this.c);
                if(this.active) {
                    fill(0);
                } else {
                    fill(255);
                }
                stroke(0);
                strokeWeight(1);
                textSize(16);
                text(this.content, this.x + (this.w - textWidth(this.content)) / 2.0, this.y + this.h / 2.0);
                noFill();
            }

            public void activate() {
                this.active = true;
            }

            public void deactivate() {
                this.active = false;
            }

            public void toggle() {
                this.active = !this.active;
            }

            public boolean isActive() {
                return this.active;
            }

            public void pop() {
                 if(this.content.length() >= 1) {
                     this.content = this.content.substring(0, this.content.length() - 1);
                 }
            }

            public void push(char character) {
                this.content += character;
            }

            public String getContent() {
                return this.content;
            }
        }
    }


    private class KeyServer {
        private ArrayList<Key> keys;


        public KeyServer() {
            this.keys = new ArrayList<Key>();
        }


        public void addKey(char content) {
            this.keys.add(new Key(content));
        }

        public void addKey(int content) {
            this.keys.add(new Key(content));
        }

        public void removeKey(char content) {
            Iterator<Key> iter = this.keys.iterator();
            while (iter.hasNext()) {
                if(iter.next().getContent() == content) {
                    iter.remove();
                }
            }
        }

        public void removeKey(int content) {
            this.removeKey((char)content);
        }

        public boolean isPressed(char content) {
            for(Key key : this.keys) {
                if(key.getContent() == content) {
                    return key.isPressed();
                }
            }
            return false;
        }

        public boolean isPressed(int content) {
            return this.isPressed((char)content);
        }

        public boolean isClicked(char content) {
            for(Key key : this.keys) {
                if(key.getContent() == content) {
                    return key.isClicked();
                }
            }
            return false;
        }

        public boolean isClicked(int content) {
            return this.isClicked((char)content);
        }


        private class Key {
            private char content;
            private int timeLastPress, timeBetweenPresses;
            private boolean coded;


            public Key(char content) {
                this.content = content;

                this.timeLastPress = 0;
                this.timeBetweenPresses = 300;
                this.coded = false;
            }

            public Key(int content) {
                this((char)content);

                this.coded = true;
            }


            public boolean isPressed() {
                return (keyPressed && ((!this.coded && key == this.content) || (this.coded && keyCode == (int)this.content)));
            }

            public boolean isClicked() {
                if(this.isPressed() && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                    this.timeLastPress = millis();
                    return true;
                }
                return false;
            }

            public char getContent() {
                return this.content;
            }
        }
    }


    private class Camera {
        private float positionX, positionY, positionZ, forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ;
        private float speed, angleSpeed, pitchAndYawToRollRatio;
        private float zoom;
        private final float zoomInit, zoomMin, zoomMax, zoomDiffDiv;

        private boolean dof5or6;

        private int viewingMode;
        private Space.Body relativeBody;
        private float relativeDistance;
        private final float relativeDistanceInit, relativeDistanceMin, relativeDistanceMax, relativeDistanceDiffDiv;

        private Robot mouse;

        private Interface.KeyServer keyServer;


        public Camera(Interface.KeyServer keyServer) {
            this.positionX = this.positionY = this.positionZ = 0.0;
            this.forwardX = this.forwardY = 0.0;
            this.forwardZ = 1.0;
            this.upX = this.upZ = 0.0;
            this.upY = 1.0;
            this.rightX = 1.0;
            this.rightY = this.rightZ = 0.0;
            this.angleSpeed = TWO_PI / FPS * 2E-1;
            this.pitchAndYawToRollRatio = 8.0;
            this.speed = 1E2;
            this.zoom = 1.0;
            this.zoomInit = this.zoom;
            this.zoomMin = 5E-1;
            this.zoomMax = 36E2;
            this.zoomDiffDiv = 1E2;

            this.dof5or6 = true;

            this.viewingMode = 0;
            this.relativeDistance = 10.0;
            this.relativeDistanceInit = this.relativeDistance;
            this.relativeDistanceMin = 1E0;
            this.relativeDistanceMax = 1E3;
            this.relativeDistanceDiffDiv = 1E1;

            try {
                this.mouse = new Robot();
            } catch(AWTException e) {}

            this.keyServer = keyServer;
        }


        public void begin() {
            float[] bodyPosition = this.relativeBody.getPosition();
            float r = this.relativeBody.getRadius();
            float[] orientation = this.relativeBody.getOrientation();
            orientation[0] *= r;
            orientation[1] *= r;
            orientation[2] *= r;
            r *= this.relativeDistance;

            beginCamera();
            switch(this.viewingMode) {
                case 0: // free
                    camera(this.positionX, this.positionY, this.positionZ, this.positionX + this.forwardX, this.positionY + this.forwardY, this.positionZ + this.forwardZ, this.upX, this.upY, this.upZ);
                    break;
                case 1: // free relative to the body
                    camera(bodyPosition[0] + this.positionX, bodyPosition[1] + this.positionY, bodyPosition[2] + this.positionZ, bodyPosition[0] + this.positionX + this.forwardX, bodyPosition[1] + this.positionY + this.forwardY, bodyPosition[2] + this.positionZ + this.forwardZ, this.upX, this.upY, this.upZ);
                    break;
                case 2: // around the body
                    camera(bodyPosition[0] - r * this.forwardX, bodyPosition[1] - r * this.forwardY, bodyPosition[2] - r * this.forwardZ, bodyPosition[0], bodyPosition[1], bodyPosition[2], this.upX, this.upY, this.upZ);
                    break;
                case 3: // fixed body view from 1st person
                    camera(bodyPosition[0] + orientation[0], bodyPosition[1] + orientation[1], bodyPosition[2] + orientation[2], bodyPosition[0] + orientation[0] * 2, bodyPosition[1] + orientation[1] * 2, bodyPosition[2] + orientation[2] * 2, orientation[6], orientation[7], orientation[8]);
                    break;
                case 4: // free body view from 1st person
                    camera(bodyPosition[0] + orientation[0], bodyPosition[1] + orientation[1], bodyPosition[2] + orientation[2], bodyPosition[0] + orientation[0] + this.forwardX, bodyPosition[1] + orientation[1] + this.forwardY, bodyPosition[2] + orientation[2] + this.forwardZ, this.upX, this.upY, this.upZ);
                    break;
            }

            float fov = PI / 3.0 / zoom;
            float cameraZ = (height / 2.0) / tan(fov / 2.0);
            perspective(fov, float(width) / float(height), cameraZ / 100.0, cameraZ * 100.0);
        }

        public void begin(PShape skybox) {
            this.begin();

            float[] bodyPosition = this.relativeBody.getPosition();
            float r = this.relativeBody.getRadius();
            float[] orientation = this.relativeBody.getOrientation();
            orientation[0] *= r;
            orientation[1] *= r;
            orientation[2] *= r;
            r *= this.relativeDistance;

            if(this.relativeBody == null) {
                this.viewingMode = 0;
            }

            switch(this.viewingMode) {
                case 0: // free
                    translate(this.positionX, this.positionY, this.positionZ);
                    shape(skybox, 0, 0);
                    translate(-this.positionX, -this.positionY, -this.positionZ);
                    break;
                case 1: // free relative to the body
                    translate(bodyPosition[0] + this.positionX, bodyPosition[1] + this.positionY, bodyPosition[2] + this.positionZ);
                    shape(skybox, 0, 0);
                    translate(-(bodyPosition[0] + this.positionX), -(bodyPosition[1] + this.positionY), -(bodyPosition[2] + this.positionZ));
                    break;
                case 2: // around the body
                    translate(bodyPosition[0] - r * this.forwardX, bodyPosition[1] - r * this.forwardY, bodyPosition[2] - r * this.forwardZ);
                    shape(skybox, 0, 0);
                    translate(-(bodyPosition[0] - r * this.forwardX), -(bodyPosition[1] - r * this.forwardY), -(bodyPosition[2] - r * this.forwardZ));
                    break;
                case 3: // fixed body view from 1st person
                    translate(bodyPosition[0] + orientation[0], bodyPosition[1] + orientation[1], bodyPosition[2] + orientation[2]);
                    shape(skybox, 0, 0);
                    translate(-(bodyPosition[0] + orientation[0]), -(bodyPosition[1] + orientation[1]), -(bodyPosition[2] + orientation[2]));
                    break;
                case 4: // free body view from 1st person
                    translate(bodyPosition[0] + orientation[0], bodyPosition[1] + orientation[1], bodyPosition[2] + orientation[2]);
                    shape(skybox, 0, 0);
                    translate(-(bodyPosition[0] + orientation[0]), -(bodyPosition[1] + orientation[1]), -(bodyPosition[2] + orientation[2]));
                    break;
            }
        }

        public void end() {
            endCamera();
        }

        public void controls() {
            float[] quaternion;
            float[] vector;
            float vectorLength;

            if(this.dof5or6) { // 6 degrees of freedom
                if(mouseX != pmouseX) { // yaw
                    quaternion = Mathematics.rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, map(mouseX - HALF_WIDTH, -HALF_WIDTH, HALF_WIDTH, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.forwardX = vector[0];
                    this.forwardY = vector[1];
                    this.forwardZ = vector[2];

                    quaternion = Mathematics.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.rightX = vector[0];
                    this.rightY = vector[1];
                    this.rightZ = vector[2];

                    quaternion = Mathematics.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.forwardX = vector[0];
                    this.forwardY = vector[1];
                    this.forwardZ = vector[2];
                }
                if(mouseY != pmouseY) { // pitch
                    quaternion = Mathematics.rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, map(mouseY - HALF_HEIGHT, -HALF_HEIGHT, HALF_HEIGHT, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.forwardX = vector[0];
                    this.forwardY = vector[1];
                    this.forwardZ = vector[2];

                    quaternion = Mathematics.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.upX = vector[0];
                    this.upY = vector[1];
                    this.upZ = vector[2];

                    quaternion = Mathematics.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.forwardX = vector[0];
                    this.forwardY = vector[1];
                    this.forwardZ = vector[2];
                }
            } else { // 5 degrees of freedom
                if(mouseX != pmouseX) { // rotate left or right
                    quaternion = Mathematics.rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, map(mouseX - HALF_WIDTH, -HALF_WIDTH, HALF_WIDTH, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.forwardX = vector[0];
                    this.forwardY = vector[1];
                    this.forwardZ = vector[2];
                }
                if(mouseY != pmouseY) { // rotate up or down
                    quaternion = Mathematics.rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, map(mouseY - HALF_HEIGHT, -HALF_HEIGHT, HALF_HEIGHT, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                    vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                    vector[0] /= vectorLength;
                    vector[1] /= vectorLength;
                    vector[2] /= vectorLength;
                    this.forwardX = vector[0];
                    this.forwardY = vector[1];
                    this.forwardZ = vector[2];
                }
            }

            this.mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);

            if(this.keyServer.isPressed('w')) { // move forward
                this.positionX += this.forwardX * this.speed;
                this.positionY += this.forwardY * this.speed;
                this.positionZ += this.forwardZ * this.speed;
            }
            if(this.keyServer.isPressed('s')) { // move backward
                this.positionX -= this.forwardX * this.speed;
                this.positionY -= this.forwardY * this.speed;
                this.positionZ -= this.forwardZ * this.speed;
            }
            if(this.keyServer.isPressed('d')) { // move right
                this.positionX += -this.rightX * this.speed;
                this.positionY += -this.rightY * this.speed;
                this.positionZ += -this.rightZ * this.speed;
            }
            if(this.keyServer.isPressed('a')) { // move left
                this.positionX -= -this.rightX * this.speed;
                this.positionY -= -this.rightY * this.speed;
                this.positionZ -= -this.rightZ * this.speed;
            }
            if(this.keyServer.isPressed(' ')) { // move up
                this.positionX -= this.upX * this.speed;
                this.positionY -= this.upY * this.speed;
                this.positionZ -= this.upZ * this.speed;
            }
            if(this.keyServer.isPressed(SHIFT)) { // move down
                this.positionX += this.upX * this.speed;
                this.positionY += this.upY * this.speed;
                this.positionZ += this.upZ * this.speed;
            }
            if(this.keyServer.isPressed('q')) { // roll counterclockwise
                quaternion = Mathematics.rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                this.upX = vector[0];
                this.upY = vector[1];
                this.upZ = vector[2];

                quaternion = Mathematics.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                this.rightX = vector[0];
                this.rightY = vector[1];
                this.rightZ = vector[2];

                quaternion = Mathematics.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                this.upX = vector[0];
                this.upY = vector[1];
                this.upZ = vector[2];
            }
            if(this.keyServer.isPressed('e')) { // roll clockwise
                quaternion = Mathematics.rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, -this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                this.upX = vector[0];
                this.upY = vector[1];
                this.upZ = vector[2];

                quaternion = Mathematics.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                this.rightX = vector[0];
                this.rightY = vector[1];
                this.rightZ = vector[2];

                quaternion = Mathematics.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                this.upX = vector[0];
                this.upY = vector[1];
                this.upZ = vector[2];
            }
            if(this.keyServer.isPressed('1')) { // zoom out
                this.zoom -= this.zoom / this.zoomDiffDiv;
                if(this.zoom < this.zoomMin) {
                    this.zoom = this.zoomMin;
                }
            }
            if(this.keyServer.isPressed('2')) { // default zoom
                this.zoom = this.zoomInit;
            }
            if(this.keyServer.isPressed('3')) { // zoom in
                this.zoom += this.zoom / this.zoomDiffDiv;
                if(this.zoom > this.zoomMax) {
                    this.zoom = this.zoomMax;
                }
            }
            if(this.keyServer.isPressed('4')) { // increase relative distance
                if(this.viewingMode != 0) {
                    this.relativeDistance -= this.relativeDistance / this.relativeDistanceDiffDiv;
                    if(this.relativeDistance < this.relativeDistanceMin) {
                        this.relativeDistance = this.relativeDistanceMin;
                    }
                }
            }
            if(this.keyServer.isPressed('5')) { // default relative distance
                if(this.viewingMode != 0) {
                    this.relativeDistance = this.relativeDistanceInit;
                }
            }
            if(this.keyServer.isPressed('6')) { // decrease relative distance
                if(this.viewingMode != 0) {
                    this.relativeDistance += this.relativeDistance / this.relativeDistanceDiffDiv;
                    if(this.relativeDistance > this.relativeDistanceMax) {
                        this.relativeDistance = this.relativeDistanceMax;
                    }
                }
            }
            if(this.keyServer.isClicked('7')) { // previous viewing mode
                float[] bodyPosition = this.relativeBody.getPosition();
                float r = this.relativeDistance * this.relativeBody.getRadius();

                this.viewingMode = (this.viewingMode - 1 + 5) % 5;

                switch(this.viewingMode) {
                    case 0:
                        this.positionX += bodyPosition[0];
                        this.positionY += bodyPosition[1];
                        this.positionZ += bodyPosition[2];
                        break;
                    case 1:
                        this.positionX = -r * this.forwardX;
                        this.positionY = -r * this.forwardY;
                        this.positionZ = -r * this.forwardZ;
                        break;
                }
            }
            if(this.keyServer.isClicked('8')) { // default viewing mode
                float[] bodyPosition = this.relativeBody.getPosition();
                float r = this.relativeDistance * this.relativeBody.getRadius();

                switch(this.viewingMode) {
                    case 1:
                        this.positionX += bodyPosition[0];
                        this.positionY += bodyPosition[1];
                        this.positionZ += bodyPosition[2];
                        break;
                    case 2:
                        this.positionX = bodyPosition[0] - r * this.forwardX;
                        this.positionY = bodyPosition[1] - r * this.forwardY;
                        this.positionZ = bodyPosition[2] - r * this.forwardZ;
                        break;
                }

                this.viewingMode = 0;
            }
            if(this.keyServer.isClicked('9')) { // next viewing mode
                float[] bodyPosition = this.relativeBody.getPosition();
                float r = this.relativeDistance * this.relativeBody.getRadius();

                this.viewingMode = (this.viewingMode + 1) % 5;

                switch(this.viewingMode) {
                    case 1:
                        this.positionX -= bodyPosition[0];
                        this.positionY -= bodyPosition[1];
                        this.positionZ -= bodyPosition[2];
                        break;
                    case 2:
                        this.positionX = bodyPosition[0] - r * this.forwardX;
                        this.positionY = bodyPosition[1] - r * this.forwardY;
                        this.positionZ = bodyPosition[2] - r * this.forwardZ;
                        break;
                }
            }
            if(this.keyServer.isPressed('-')) { // 5 degree of freedom
                this.dof5or6 = false;
            }
            if(this.keyServer.isPressed('+')) { // 6 degree of freedom
                this.dof5or6 = true;
            }
        }

        public void setRelativeBody(Space.Body relativeBody) {
            this.relativeBody = relativeBody;
        }
    }
}
