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
  Game class
      Telescope class
      TextureLoaderThread class that extends Thread
      SoundtrackThread class that extends Thread
  Malovanyi Denys Olehovych
***/



import java.awt.Robot;
import java.awt.AWTException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;

import java.util.concurrent.atomic.AtomicBoolean;


class Game {
    private Database db;

    private int context;

    private Interface.ButtonServer buttonServer;
    private Interface.KeyServer keyServer;

    private Interface.ButtonServer.Button buttonMenuBack;
    private Interface.ButtonServer.Button buttonMenuCredits, buttonMenuSettings, buttonMenuPlay;
    private Interface.ButtonServer.Button buttonPlayMenu, buttonPlayResume, buttonPlaySettings, buttonPlayExit;
    private Interface.ButtonServer.Button buttonEditorMenu, buttonEditorResume, buttonEditorSettings, buttonEditorExit, buttonEditorSave;
    private Interface.ButtonServer.Button buttonMenuSingleplayer, buttonMenuMultiplayer, buttonMenuEditor;
    private Interface.ButtonServer.Button buttonMenuHost, buttonMenuConnect;
    private Interface.ButtonServer.Button fieldMenuIP, fieldMenuPort;
    private Interface.ButtonServer.Button[] buttonsMenuWorlds, buttonsEditorBodies;

    private PImage[] buffer;
    private int xo, yo, swap;
    private AtomicBoolean textureLoaderWork;
    private TextureLoaderThread textureLoader;

    private SoundtrackThread soundtrack;

    private String creditsContent;

    private boolean pause;
    private float speed;

    private Space space;

    private PShape skybox;

    private boolean controlCameraOrTelescope;

    private Interface.Camera camera;

    private Telescope telescope;


    public Game() {
        this.db = new Database();

        this.context = 0;

        this.pause = false;
        this.speed = 1.0;

        this.controlCameraOrTelescope = false;

        this.buttonServer = new Interface().new ButtonServer();
        float w, h, x, y0;
        w = width;
        h = height / 16.0;
        x = h / 10.0;
        y0 = h / 10.0;
        this.buttonMenuBack = this.buttonServer.new Button(x, y0, w - 2.0 * x, h, "BACK");
        w = width / 4.0;
        h = height / 4.0;
        this.buttonPlayMenu = this.buttonServer.new Button(w, h, width - w * 2.0, height - h * 2.0, h / 16.0, h / 4.0, "");
        w = width / 8.0;
        h = height / 16.0;
        x = (width - w) / 2.0;
        this.buttonMenuPlay = this.buttonServer.new Button(x, height / 5.0 * 2.5 - h * 2.0, w, h, "PLAY");
        this.buttonMenuSettings = this.buttonServer.new Button(x, height / 5.0 * 3.0 - h * 2.0, w, h, "SETTINGS");
        this.buttonMenuCredits = this.buttonServer.new Button(x, height / 5.0 * 3.5 - h * 2.0, w, h, "CREDITS");
        this.buttonPlayResume = this.buttonServer.new Button(x + 1, height / 5.0 * 2.5 - h * 2.0 + 1, w, h, "RESUME");
        this.buttonPlaySettings = this.buttonServer.new Button(x + 1, height / 5.0 * 3.0 - h * 2.0 + 1, w, h, "SETTINGS");
        this.buttonPlayExit = this.buttonServer.new Button(x + 1, height / 5.0 * 3.5 - h * 2.0 + 1, w, h, "EXIT");
        w = width / 3.0;
        this.buttonEditorMenu = this.buttonServer.new Button(width - w, -5.0, width, height + 5.0, 5.0, 0.0, "");
        w = width / 8.0;
        h = height / 4.0;
        x = 0;
        this.buttonEditorSave = this.buttonServer.new Button(x, h * 0.0, w, h, 2.0, 5.0, "SAVE");
        this.buttonEditorResume = this.buttonServer.new Button(x, h * 1.0, w, h, 2.0, 5.0, "RESUME");
        this.buttonEditorSettings = this.buttonServer.new Button(x, h * 2.0, w, h, 2.0, 5.0, "SETTINGS");
        this.buttonEditorExit = this.buttonServer.new Button(x, h * 3.0, w, h, 2.0, 5.0, "EXIT");
        w = width / 8.0;
        h = height / 8.0;
        x = width - w;
        this.buttonMenuSingleplayer = this.buttonServer.new Button(x - h / 10.0, height / 5.0 * 2.0 - h * 3.0 / 2.0, w, h, "SINGLEPLAYER");
        this.buttonMenuMultiplayer = this.buttonServer.new Button(x - h / 10.0, height / 5.0 * 3.0 - h * 3.0 / 2.0, w, h, "MULTIPLAYER");
        this.buttonMenuEditor = this.buttonServer.new Button(x - h / 10.0, height / 5.0 * 4.0 - h * 3.0 / 2.0, w, h, "EDITOR");
        w = width / 4.0;
        h = height / 16.0;
        x = (width - w) / 2.0;
        y0 = height / 2.0 - h * 2.0;
        this.fieldMenuIP = this.buttonServer.new Button(x, y0 + h * 0.0, w, h, "0.0.0.0");
        this.fieldMenuPort = this.buttonServer.new Button(x, y0 + h * 1.0, w, h, "16384");
        this.buttonMenuHost = this.buttonServer.new Button(x, y0 + h * 2.0, w, h, "HOST");
        this.buttonMenuConnect = this.buttonServer.new Button(x, y0 + h * 3.0, w, h, "CONNECT");
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonMenuPlay, this.buttonMenuSettings, this.buttonMenuCredits}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // main menu
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonMenuBack}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // credits
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonMenuBack}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // settings
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonPlayMenu, this.buttonPlayResume, this.buttonPlaySettings, this.buttonPlayExit}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // play menu
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonEditorMenu, this.buttonEditorSave, this.buttonEditorResume, this.buttonEditorSettings, this.buttonEditorExit}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // editor menu
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonMenuBack, this.buttonMenuSingleplayer, this.buttonMenuMultiplayer, this.buttonMenuEditor}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{this.buttonsMenuWorlds}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // choose world
        this.buttonServer.addContext(new Interface.ButtonServer.Button[]{this.buttonMenuBack, this.buttonMenuHost, this.buttonMenuConnect}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{this.fieldMenuIP, this.fieldMenuPort}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // choose host

        this.keyServer = new Interface().new KeyServer();
        this.keyServer.addKey(TAB);
        this.keyServer.addKey('`');
        this.keyServer.addKey('w');
        this.keyServer.addKey('s');
        this.keyServer.addKey('d');
        this.keyServer.addKey('a');
        this.keyServer.addKey(' ');
        this.keyServer.addKey(SHIFT);
        this.keyServer.addKey('q');
        this.keyServer.addKey('e');
        this.keyServer.addKey(UP);
        this.keyServer.addKey(DOWN);
        this.keyServer.addKey(RIGHT);
        this.keyServer.addKey(LEFT);
        this.keyServer.addKey('1');
        this.keyServer.addKey('2');
        this.keyServer.addKey('3');
        this.keyServer.addKey('4');
        this.keyServer.addKey('5');
        this.keyServer.addKey('6');
        this.keyServer.addKey('7');
        this.keyServer.addKey('8');
        this.keyServer.addKey('9');
        this.keyServer.addKey('-');
        this.keyServer.addKey('+');
        this.keyServer.addKey('/');
        this.keyServer.addKey('*');
        this.keyServer.addKey(ENTER);

        this.xo = this.yo = this.swap = 0;
        this.buffer = new PImage[2];
        this.buffer[1] = this.db.getTexture("skybox");
        this.buffer[1].resize(width, height);
        this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[0]);
        this.buffer[0].resize(width, height);
        this.textureLoaderWork = new AtomicBoolean(false);

        this.creditsContent = "Space Pioneers\n\nCreated by Malovanyi Denys Olehovych\n2018-2020\n\nhttps://gitlab.com/maldenol/spacepioneers\nThis project is licensed under the GNU Affero General Public License v3.0.\n\nThanks for playing!";
    }

    public void draw() {
        switch(this.context) {
            case 0:
                this.mainMenu();
                break;
            case 1:
                this.credits();
                break;
            case 2:
                this.settings();
                break;
            case 3:
                this.play();
                break;
            case 4:
                this.editor();
                break;
            case 5:
                this.chooseWorld();
                break;
            case 6:
                this.chooseHost();
                break;
            default:
                this.context = 0;
                break;
        }
    }

    private void mainMenu() {
        if(this.keyServer.isClicked('`')) {
            this.buttonServer.clear(this.context);
            this.context = 1;
        }

        this.drawBackground();

        this.buttonServer.serve(this.context);

        if(this.buttonMenuCredits.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 1;
        } else if(this.buttonMenuSettings.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 2;
        } else if(this.buttonMenuPlay.isActive()) {
            this.buttonServer.clear(this.context);

            this.drawBackground();

            ArrayList<Interface.ButtonServer.Button> buttonsList = new ArrayList<Interface.ButtonServer.Button>();
            float w = width / 2.0, h = height / 16.0;
            float x = (width - w) / 2.0, y0 = height / 8.0;
            for(String name : this.db.getXMLs()) {
                buttonsList.add(this.buttonServer.new Button(x, y0 + buttonsList.size() * h, w, h, name));
            }
            this.buttonsMenuWorlds = new Interface.ButtonServer.Button[buttonsList.size()];
            this.buttonsMenuWorlds = buttonsList.toArray(this.buttonsMenuWorlds);

            this.context = 5;

            this.buttonServer.setContext(this.context, new Interface.ButtonServer.Button[]{this.buttonMenuBack, this.buttonMenuSingleplayer, this.buttonMenuMultiplayer, this.buttonMenuEditor}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{this.buttonsMenuWorlds}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // choose world
        }
    }

    private void credits() {
        if(this.keyServer.isClicked('`')) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }

        this.drawBackground();

        this.buttonServer.serve(this.context);

        if(this.buttonMenuBack.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }

        float w = width / 10.0, h = height / 10.0;
        fill(0, 127);
        stroke(255);
        strokeWeight(h / 10.0);
        rect(w, h, width - w * 2.0, height - h * 2.0, h / 2.0, h / 2.0, h / 2.0, h / 2.0);
        fill(255);
        stroke(0);
        strokeWeight(1);
        textSize(24);
        text(this.creditsContent, (width - textWidth(this.creditsContent)) / 2.0, height / 2.0 - h * 2.0);
        noFill();
    }

    private void settings() {
        if(this.keyServer.isClicked('`')) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }

        this.drawBackground();

        this.buttonServer.serve(this.context);

        if(this.buttonMenuBack.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
    }

    private void play() {
        if(this.keyServer.isClicked('`')) {
            this.pause = !this.pause;
            try {
                Robot mouse = new Robot();
                mouse.mouseMove((int)(HALF_WIDTH), (int)(HALF_HEIGHT));
            } catch(AWTException e) {}
        }

        if(!this.pause) {
            this.space.tick();

            if(!this.controlCameraOrTelescope) {
                this.camera.controls();
            } else {
                this.telescope.controls();
            }

            if(this.keyServer.isPressed('*')) { // camera controls
                this.controlCameraOrTelescope = false;
            }
            if(this.keyServer.isPressed('/')) { // telescope controls
                this.controlCameraOrTelescope = true;
            }
        }

        background(0);
        this.camera.begin(this.skybox);
        this.space.draw();
        this.camera.end();

        if(this.pause) {
            this.playMenu();
        }
    }

    private void editor() {
        if(this.keyServer.isClicked('`')) {
            this.pause = !this.pause;
        }

        if(!this.pause) {
            this.camera.controls();
        }

        background(0);
        this.camera.begin(this.skybox);
        this.space.draw();
        this.camera.end();

        if(this.pause) {
            this.editorMenu();
        }
    }

    private void chooseWorld() {
        if(this.keyServer.isClicked('`')) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }

        this.drawBackground();

        this.buttonServer.serve(this.context);

        if(this.buttonMenuBack.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }

        int choose = 0;
        if(this.buttonMenuSingleplayer.isActive()) {
            choose = 1;
        } else if(this.buttonMenuMultiplayer.isActive()) {
            choose = 2;
        } else if(this.buttonMenuEditor.isActive()) {
            choose = 3;
        }
        if(choose != 0) {
            for(Interface.ButtonServer.Button button : this.buttonsMenuWorlds) {
                if(button.isActive()) {
                    this.buttonServer.clear(this.context);

                    try {
                        Robot mouse = new Robot();
                        mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
                    } catch(AWTException e) {}

                    this.drawBackground();

                    this.space = new Space(button.getContent(), this.db);
                    this.camera = new Interface().new Camera(this.keyServer);
                    noStroke();
                    fill(255);
                    this.skybox = createShape(SPHERE, 6E3);
                    this.skybox.setTexture(this.space.getSkybox());
                    this.skybox.rotateY(HALF_PI);
                    this.pause = false;

                    this.telescope = new Telescope(this.space.getTelescope(), this.keyServer);
                    this.camera.setRelativeBody(this.telescope.getBody());

                    this.textureLoader.kill();
                    this.textureLoader = null;

                    this.soundtrack.kill();
                    this.soundtrack = null;

                    try {
                        Robot mouse = new Robot();
                        mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
                    } catch(AWTException e) {}

                    break;
                }
            }

            switch(choose) {
                case 1:
                    this.context = 3;
                    break;
                case 2:
                    this.context = 6;
                    break;
                case 3:
                    ArrayList<Interface.ButtonServer.Button> buttonsList = new ArrayList<Interface.ButtonServer.Button>();
                    float w = width / 2.0, h = height / 16.0;
                    float x = (width - w) / 2.0, y0 = height / 8.0;
                    for(String name : this.db.getXMLs()) {
                        buttonsList.add(this.buttonServer.new Button(x, y0 + buttonsList.size() * h, w, h, name));
                    }
                    this.buttonsEditorBodies = new Interface.ButtonServer.Button[buttonsList.size()];
                    this.buttonsEditorBodies = buttonsList.toArray(this.buttonsEditorBodies);

                    this.context = 4;

                    this.buttonServer.setContext(this.context, new Interface.ButtonServer.Button[]{this.buttonEditorMenu, this.buttonEditorSave, this.buttonEditorResume, this.buttonEditorSettings, this.buttonEditorExit}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[]{}, new Interface.ButtonServer.Button[][]{this.buttonsEditorBodies}, new Interface.ButtonServer.Button[][]{{}}, new Interface.ButtonServer.Button[][]{{}}); // editor

                    break;
            }
        }
    }

    private void chooseHost() {
        if(this.keyServer.isClicked('`')) {
            this.buttonServer.clear(this.context);
            this.context = 5;
        }

        this.drawBackground();

        this.buttonServer.serve(this.context);

        if(this.buttonMenuBack.isActive()) {
            this.buttonServer.clear(this.context);

            this.context = 5;
        } else if(this.buttonMenuHost.isActive()) {
            this.buttonServer.clear(this.context);

            try {
                Robot mouse = new Robot();
                mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
            } catch(AWTException e) {}
        } else if(this.buttonMenuConnect.isActive()) {
            this.buttonServer.clear(this.context);

            try {
                Robot mouse = new Robot();
                mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
            } catch(AWTException e) {}
        }
    }

    private void drawBackground() {
        camera();
        perspective();
        background(0);

        if(this.swap == 1) {
            tint(255, yo);
            image(this.buffer[0], -width + this.xo, 0);
            image(this.buffer[0], this.xo, 0);
        }
        tint(255, 255 - yo);
        image(this.buffer[1], -width + this.xo, 0);
        image(this.buffer[1], this.xo, 0);

        this.xo = (this.xo + 1) % width;

        if(this.xo == 0 && this.swap == 0) {
            this.swap = 1;
        }

        if(this.swap == 1) {
            this.yo++;

            if(this.yo == 255) {
                this.yo = 0;

                this.textureLoaderWork.set(true);

                this.swap = 0;
            }
        }

        stroke(255);
        strokeWeight(2);
        fill(0, 127);
        circle(mouseX, mouseY, 8);
        noFill();

        if(this.textureLoader == null) {
            this.textureLoader = new TextureLoaderThread(this.db, this.buffer, this.textureLoaderWork);
            this.textureLoader.start();
        }
        if(this.soundtrack == null) {
            this.soundtrack = new SoundtrackThread(this.db);
            this.soundtrack.start();
        }
    }

    private void playMenu() {
        camera();
        perspective();

        this.buttonServer.serve(this.context);

        stroke(255);
        strokeWeight(2);
        fill(0, 127);
        circle(mouseX, mouseY, 8);
        noFill();

        if(this.buttonPlayResume.isActive()) {
            try {
                Robot mouse = new Robot();
                mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
            } catch(AWTException e) {}

            this.buttonServer.clear(this.context);
            this.pause = false;
        } else if(this.buttonMenuSettings.isActive()) {
            this.buttonServer.clear(this.context);
            //this.context = 2;
        } else if(this.buttonPlayExit.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
    }

    public void editorMenu() {
        camera();
        perspective();

        this.buttonServer.serve(this.context);

        stroke(255);
        strokeWeight(2);
        fill(0, 127);
        circle(mouseX, mouseY, 8);
        noFill();

        if(this.buttonEditorSave.isActive()) {
            this.buttonServer.clear(this.context);

        } else if(this.buttonEditorResume.isActive()) {
            try {
                Robot mouse = new Robot();
                mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
            } catch(AWTException e) {}

            this.buttonServer.clear(this.context);
            this.pause = false;
        } else if(this.buttonEditorSettings.isActive()) {
            this.buttonServer.clear(this.context);
            //this.context = 2;
        } else if(this.buttonEditorExit.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
    }


    private class Telescope {
        private Space.Body body;

        private float speed, angleSpeed;

        private Interface.KeyServer keyServer;


        public Telescope(Space.Body body, Interface.KeyServer keyServer) {
            this.body = body;

            this.speed = 1E0;
            this.angleSpeed = TWO_PI / FPS * 2E-1;

            this.keyServer = keyServer;
        }


        public Space.Body getBody() {
            return this.body;
        }

        public void controls() {
            float[] orientation = this.body.getOrientation();
            float forwardX = orientation[0], forwardY = orientation[1], forwardZ = orientation[2], upX = orientation[3], upY = orientation[4], upZ = orientation[5], rightX = orientation[6], rightY = orientation[7], rightZ = orientation[8];
            float[] quaternion;
            float[] vector;
            float vectorLength;

            if(this.keyServer.isPressed('w')) { // move forward
                this.body.accelerate(forwardX * this.speed, forwardY * this.speed, forwardZ * this.speed);
            }
            if(this.keyServer.isPressed('s')) { // move backward
                this.body.accelerate(-forwardX * this.speed, -forwardY * this.speed, -forwardZ * this.speed);
            }
            if(this.keyServer.isPressed('d')) { // move right
                this.body.accelerate(rightX * this.speed, rightY * this.speed, rightZ * this.speed);
            }
            if(this.keyServer.isPressed('a')) { // move left
                this.body.accelerate(-rightX * this.speed, -rightY * this.speed, -rightZ * this.speed);
            }
            if(this.keyServer.isPressed(' ')) { // move up
                this.body.accelerate(upX * this.speed, upY * this.speed, upZ * this.speed);
            }
            if(this.keyServer.isPressed(SHIFT)) { // move down
                this.body.accelerate(-upX * this.speed, -upY * this.speed, -upZ * this.speed);
            }
            if(this.keyServer.isPressed(UP)) { // pitch up
                quaternion = Mathematics.rotateOnQuaternion(forwardX, forwardY, forwardZ, upX, upY, upZ, -this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                quaternion = Mathematics.vectorProduct(upX, upY, upZ, forwardX, forwardY, forwardZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                rightX = vector[0];
                rightY = vector[1];
                rightZ = vector[2];

                quaternion = Mathematics.vectorProduct(rightX, rightY, rightZ, upX, upY, upZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                this.body.setOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ);
            }
            if(this.keyServer.isPressed(DOWN)) { // pitch down
                quaternion = Mathematics.rotateOnQuaternion(forwardX, forwardY, forwardZ, upX, upY, upZ, this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                quaternion = Mathematics.vectorProduct(upX, upY, upZ, forwardX, forwardY, forwardZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                rightX = vector[0];
                rightY = vector[1];
                rightZ = vector[2];

                quaternion = Mathematics.vectorProduct(rightX, rightY, rightZ, upX, upY, upZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                this.body.setOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ);
            }
            if(this.keyServer.isPressed(RIGHT)) { // yaw right
                quaternion = Mathematics.rotateOnQuaternion(forwardX, forwardY, forwardZ, rightX, rightY, rightZ, -this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                quaternion = Mathematics.vectorProduct(forwardX, forwardY, forwardZ, rightX, rightY, rightZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                upX = vector[0];
                upY = vector[1];
                upZ = vector[2];

                quaternion = Mathematics.vectorProduct(rightX, rightY, rightZ, upX, upY, upZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                this.body.setOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ);
            }
            if(this.keyServer.isPressed(LEFT)) { // yaw left
                quaternion = Mathematics.rotateOnQuaternion(forwardX, forwardY, forwardZ, rightX, rightY, rightZ, this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                quaternion = Mathematics.vectorProduct(forwardX, forwardY, forwardZ, rightX, rightY, rightZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                upX = vector[0];
                upY = vector[1];
                upZ = vector[2];

                quaternion = Mathematics.vectorProduct(rightX, rightY, rightZ, upX, upY, upZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                forwardX = vector[0];
                forwardY = vector[1];
                forwardZ = vector[2];

                this.body.setOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ);
            }
            if(this.keyServer.isPressed('q')) { // roll counterclockwise
                quaternion = Mathematics.rotateOnQuaternion(upX, upY, upZ, forwardX, forwardY, forwardZ, this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                upX = vector[0];
                upY = vector[1];
                upZ = vector[2];

                quaternion = Mathematics.vectorProduct(upX, upY, upZ, forwardX, forwardY, forwardZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                rightX = vector[0];
                rightY = vector[1];
                rightZ = vector[2];

                quaternion = Mathematics.vectorProduct(forwardX, forwardY, forwardZ, rightX, rightY, rightZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                upX = vector[0];
                upY = vector[1];
                upZ = vector[2];

                this.body.setOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ);
            }
            if(this.keyServer.isPressed('e')) { // roll clockwise
                quaternion = Mathematics.rotateOnQuaternion(upX, upY, upZ, forwardX, forwardY, forwardZ, -this.angleSpeed);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                upX = vector[0];
                upY = vector[1];
                upZ = vector[2];

                quaternion = Mathematics.vectorProduct(upX, upY, upZ, forwardX, forwardY, forwardZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                rightX = vector[0];
                rightY = vector[1];
                rightZ = vector[2];

                quaternion = Mathematics.vectorProduct(forwardX, forwardY, forwardZ, rightX, rightY, rightZ);
                vector = new float[]{quaternion[0], quaternion[1], quaternion[2]};
                vectorLength = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
                vector[0] /= vectorLength;
                vector[1] /= vectorLength;
                vector[2] /= vectorLength;
                upX = vector[0];
                upY = vector[1];
                upZ = vector[2];

                this.body.setOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ);
            }
            if(this.keyServer.isClicked(ENTER)) { // take a screenshot
                saveFrame("data/screenshots/" + System.currentTimeMillis() + ".png");
            }
        }
    }

    public class TextureLoaderThread extends Thread {
        private Database db;
        private PImage[] buffer;
        private int index, indexMax;
        private boolean killed;
        private AtomicBoolean work;

        public TextureLoaderThread(Database db, PImage[] buffer, AtomicBoolean work) {
            this.db = db;
            this.buffer = buffer;
            this.index = 0;
            this.killed = false;
            this.work = work;
            this.work.set(false);
        }

        @Override
        public void run() {
            this.indexMax = this.db.getTextures().length;
            this.index = (this.index + 1) % this.indexMax;

            while(true) {
                if(this.killed) {
                    return;
                } else if(this.work.get()) {
                    this.buffer[1] = this.buffer[0].copy();
                    this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[this.index]);
                    this.buffer[0].resize(width, height);

                    this.index = (this.index + 1) % this.indexMax;

                    this.work.set(false);
                }
            }
        }

        public void kill() {
            this.killed = true;
        }
    }

    private class SoundtrackThread extends Thread {
        private Database db;
        private int index, indexMax;
        private boolean killed;

        public SoundtrackThread(Database db) {
            this.db = db;
            this.killed = false;
        }

        @Override
        public void run() {
            this.index = 0;
            this.indexMax = this.db.getSounds().length;

            AudioInputStream audioInputStream;
            Clip clip;

            int wait, delayDuration;

            while(true) {
                try {
                    audioInputStream = AudioSystem.getAudioInputStream(this.db.getSound(this.db.getSoundsOld()[index]));
                    this.index = (this.index + 1) % this.indexMax;
                    clip = AudioSystem.getClip();
                    clip.open(audioInputStream);
                    clip.start();
                    wait = (int)(1E-3 * clip.getMicrosecondLength());
                    delayDuration = 10;
                    for(int i = 0; i < wait / delayDuration; i++) {
                        if(this.killed) {
                            clip.close();
                            return;
                        }
                        delay(delayDuration);
                    }
                    clip.close();
                } catch(Exception e) {}
            }
        }

        public void kill() {
            this.killed = true;
        }
    }
}
