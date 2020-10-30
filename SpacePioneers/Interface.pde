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
import java.util.Iterator;


class Interface {
    private Database db;

    private int context;

    private ButtonServer buttonServer;
    private KeyServer keyServer;

    private ButtonServer.Button buttonMenuBack;
    private ButtonServer.Button buttonMenuCredits, buttonMenuSettings, buttonMenuPlay;
    private ButtonServer.Button buttonPlayMenu, buttonPlayResume, buttonPlaySettings, buttonPlayExit;
    private ButtonServer.Button buttonEditorMenu, buttonEditorResume, buttonEditorSettings, buttonEditorExit, buttonEditorSave;
    private ButtonServer.Button buttonMenuSingleplayer, buttonMenuMultiplayer, buttonMenuEditor;
    private ButtonServer.Button buttonMenuHost, buttonMenuConnect;
    private ButtonServer.Button fieldMenuIP, fieldMenuPort;
    private ButtonServer.Button[] buttonsMenuWorlds, buttonsEditorBodies;

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

    private Camera camera;

    private Telescope telescope;


    public Interface() {
        this.db = new Database();

        this.context = 0;

        this.pause = false;
        this.speed = 1.0;

        this.controlCameraOrTelescope = false;

        this.buttonServer = new ButtonServer();
        float w, h, x, y0;
        w = width;
        h = height / 16.0;
        x = h / 10.0;
        y0 = h / 10.0;
        this.buttonMenuBack = this.buttonServer.newButton(x, y0, w - 2.0 * x, h, "BACK");
        w = width / 4.0;
        h = height / 4.0;
        this.buttonPlayMenu = this.buttonServer.newButton(w, h, width - w * 2.0, height - h * 2.0, h / 16.0, h / 4.0, "");
        w = width / 8.0;
        h = height / 16.0;
        x = (width - w) / 2.0;
        this.buttonMenuPlay = this.buttonServer.newButton(x, height / 5.0 * 2.5 - h * 2.0, w, h, "PLAY");
        this.buttonMenuSettings = this.buttonServer.newButton(x, height / 5.0 * 3.0 - h * 2.0, w, h, "SETTINGS");
        this.buttonMenuCredits = this.buttonServer.newButton(x, height / 5.0 * 3.5 - h * 2.0, w, h, "CREDITS");
        this.buttonPlayResume = this.buttonServer.newButton(x + 1, height / 5.0 * 2.5 - h * 2.0 + 1, w, h, "RESUME");
        this.buttonPlaySettings = this.buttonServer.newButton(x + 1, height / 5.0 * 3.0 - h * 2.0 + 1, w, h, "SETTINGS");
        this.buttonPlayExit = this.buttonServer.newButton(x + 1, height / 5.0 * 3.5 - h * 2.0 + 1, w, h, "EXIT");
        w = width / 3.0;
        this.buttonEditorMenu = this.buttonServer.newButton(width - w, -5.0, width, height + 5.0, 5.0, 0.0, "");
        w = width / 8.0;
        h = height / 4.0;
        x = 0;
        this.buttonEditorSave = this.buttonServer.newButton(x, h * 0.0, w, h, 2.0, 5.0, "SAVE");
        this.buttonEditorResume = this.buttonServer.newButton(x, h * 1.0, w, h, 2.0, 5.0, "RESUME");
        this.buttonEditorSettings = this.buttonServer.newButton(x, h * 2.0, w, h, 2.0, 5.0, "SETTINGS");
        this.buttonEditorExit = this.buttonServer.newButton(x, h * 3.0, w, h, 2.0, 5.0, "EXIT");
        w = width / 8.0;
        h = height / 8.0;
        x = width - w;
        this.buttonMenuSingleplayer = this.buttonServer.newButton(x - h / 10.0, height / 5.0 * 2.0 - h * 3.0 / 2.0, w, h, "SINGLEPLAYER");
        this.buttonMenuMultiplayer = this.buttonServer.newButton(x - h / 10.0, height / 5.0 * 3.0 - h * 3.0 / 2.0, w, h, "MULTIPLAYER");
        this.buttonMenuEditor = this.buttonServer.newButton(x - h / 10.0, height / 5.0 * 4.0 - h * 3.0 / 2.0, w, h, "EDITOR");
        w = width / 4.0;
        h = height / 16.0;
        x = (width - w) / 2.0;
        y0 = height / 2.0 - h * 2.0;
        this.fieldMenuIP = this.buttonServer.newButton(x, y0 + h * 0.0, w, h, "0.0.0.0");
        this.fieldMenuPort = this.buttonServer.newButton(x, y0 + h * 1.0, w, h, "16384");
        this.buttonMenuHost = this.buttonServer.newButton(x, y0 + h * 2.0, w, h, "HOST");
        this.buttonMenuConnect = this.buttonServer.newButton(x, y0 + h * 3.0, w, h, "CONNECT");
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonMenuPlay, this.buttonMenuSettings, this.buttonMenuCredits}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // main menu
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonMenuBack}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // credits
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonMenuBack}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // settings
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonPlayMenu, this.buttonPlayResume, this.buttonPlaySettings, this.buttonPlayExit}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // play menu
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonEditorMenu, this.buttonEditorSave, this.buttonEditorResume, this.buttonEditorSettings, this.buttonEditorExit}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // editor menu
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonMenuBack, this.buttonMenuSingleplayer, this.buttonMenuMultiplayer, this.buttonMenuEditor}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{this.buttonsMenuWorlds}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // choose world
        this.buttonServer.addContext(new ButtonServer.Button[]{this.buttonMenuBack, this.buttonMenuHost, this.buttonMenuConnect}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{this.fieldMenuIP, this.fieldMenuPort}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // choose host

        this.keyServer = new KeyServer();
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

            ArrayList<ButtonServer.Button> buttonsList = new ArrayList<ButtonServer.Button>();
            float w = width / 2.0, h = height / 16.0;
            float x = (width - w) / 2.0, y0 = height / 8.0;
            for(String name : this.db.getXMLs()) {
                buttonsList.add(this.buttonServer.newButton(x, y0 + buttonsList.size() * h, w, h, name));
            }
            this.buttonsMenuWorlds = new ButtonServer.Button[buttonsList.size()];
            this.buttonsMenuWorlds = buttonsList.toArray(this.buttonsMenuWorlds);

            this.context = 5;

            this.buttonServer.setContext(this.context, new ButtonServer.Button[]{this.buttonMenuBack, this.buttonMenuSingleplayer, this.buttonMenuMultiplayer, this.buttonMenuEditor}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{this.buttonsMenuWorlds}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // choose world
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
            for(ButtonServer.Button button : this.buttonsMenuWorlds) {
                if(button.isActive()) {
                    this.buttonServer.clear(this.context);

                    try {
                        Robot mouse = new Robot();
                        mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
                    } catch(AWTException e) {}

                    this.drawBackground();

                    this.space = new Space(button.getContent(), this.db);
                    this.camera = new Camera(this.keyServer);
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
                    ArrayList<ButtonServer.Button> buttonsList = new ArrayList<ButtonServer.Button>();
                    float w = width / 2.0, h = height / 16.0;
                    float x = (width - w) / 2.0, y0 = height / 8.0;
                    for(String name : this.db.getXMLs()) {
                        buttonsList.add(this.buttonServer.newButton(x, y0 + buttonsList.size() * h, w, h, name));
                    }
                    this.buttonsEditorBodies = new ButtonServer.Button[buttonsList.size()];
                    this.buttonsEditorBodies = buttonsList.toArray(this.buttonsEditorBodies);

                    this.context = 4;

                    this.buttonServer.setContext(this.context, new ButtonServer.Button[]{this.buttonEditorMenu, this.buttonEditorSave, this.buttonEditorResume, this.buttonEditorSettings, this.buttonEditorExit}, new ButtonServer.Button[]{}, new ButtonServer.Button[]{}, new ButtonServer.Button[][]{this.buttonsEditorBodies}, new ButtonServer.Button[][]{{}}, new ButtonServer.Button[][]{{}}); // editor

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

        public Button newButton(float x, float y, float w, float h, String content) {
            return new Button(x, y, w, h, content);
        }

        public Button newButton(float x, float y, float w, float h, float b, float c, String content) {
            return new Button(x, y, w, h, b, c, content);
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

        private KeyServer keyServer;


        public Camera(KeyServer keyServer) {
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
            PVector bodyPosition = this.relativeBody.getPosition();
            float x = bodyPosition.x, y = bodyPosition.y, z = bodyPosition.z;
            beginCamera();
            switch(this.viewingMode) {
                case 0:
                    camera(this.positionX, this.positionY, this.positionZ, this.positionX + this.forwardX, this.positionY + this.forwardY, this.positionZ + this.forwardZ, this.upX, this.upY, this.upZ);
                    break;
                case 1:
                    camera(x + this.positionX, y + this.positionY, z + this.positionZ, x + this.positionX + this.forwardX, y + this.positionY + this.forwardY, z + this.positionZ + this.forwardZ, this.upX, this.upY, this.upZ);
                    break;
                case 2:
                    float r = this.relativeDistance * this.relativeBody.getRadius();
                    camera(x - r * this.forwardX, y - r * this.forwardY, z - r * this.forwardZ, x, y, z, this.upX, this.upY, this.upZ);
                    break;
            }

            float fov = PI / 3.0 / zoom;
            float cameraZ = (height / 2.0) / tan(fov / 2.0);
            perspective(fov, float(width) / float(height), cameraZ / 100.0, cameraZ * 100.0);
        }

        public void begin(PShape skybox) {
            this.begin();

            PVector bodyPosition = this.relativeBody.getPosition();
            float x = bodyPosition.x, y = bodyPosition.y, z = bodyPosition.z;
            float r = this.relativeBody.getRadius() * this.relativeDistance;

            switch(this.viewingMode) {
                case 0:
                    translate(this.positionX, this.positionY, this.positionZ);
                    shape(skybox, 0, 0);
                    translate(-this.positionX, -this.positionY, -this.positionZ);
                    break;
                case 1:
                    translate(x + this.positionX, y + this.positionY, z + this.positionZ);
                    shape(skybox, 0, 0);
                    translate(-(x + this.positionX), -(y + this.positionY), -(z + this.positionZ));
                    break;
                case 2:
                    translate(x - r * this.forwardX, y - r * this.forwardY, z - r * this.forwardZ);
                    shape(skybox, 0, 0);
                    translate(-(x - r * this.forwardX), -(y - r * this.forwardY), -(z - r * this.forwardZ));
                    break;
            }
        }

        public void end() {
            endCamera();
        }

        public void controls() {
            float[] quaternion;
            PVector vector;

            if(this.dof5or6) { // 6 degrees of freedom
                if(mouseX != pmouseX) { // yaw
                    quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, map(mouseX - HALF_WIDTH, -HALF_WIDTH, HALF_WIDTH, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;

                    quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.rightX = vector.x;
                    this.rightY = vector.y;
                    this.rightZ = vector.z;

                    quaternion = vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;
                }
                if(mouseY != pmouseY) { // pitch
                    quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, map(mouseY - HALF_HEIGHT, -HALF_HEIGHT, HALF_HEIGHT, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;

                    quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.upX = vector.x;
                    this.upY = vector.y;
                    this.upZ = vector.z;

                    quaternion = vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;
                }
            } else { // 5 degrees of freedom
                if(mouseX != pmouseX) { // rotate left or right
                    quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, map(mouseX - HALF_WIDTH, -HALF_WIDTH, HALF_WIDTH, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;
                }
                if(mouseY != pmouseY) { // rotate up or down
                    quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, map(mouseY - HALF_HEIGHT, -HALF_HEIGHT, HALF_HEIGHT, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;
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
                quaternion = rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, this.angleSpeed);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;

                quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.rightX = vector.x;
                this.rightY = vector.y;
                this.rightZ = vector.z;

                quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;
            }
            if(this.keyServer.isPressed('e')) { // roll clockwise
                quaternion = rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, -this.angleSpeed);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;

                quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.rightX = vector.x;
                this.rightY = vector.y;
                this.rightZ = vector.z;

                quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;
            }
            if(this.keyServer.isPressed('1')) { // zoom out
                this.zoom -= this.zoom / this.zoomDiffDiv;
                if(this.zoom < this.zoomMin) {
                    this.zoom = this.zoomMin;
                }
            }
            if(this.keyServer.isPressed('2')) { // normal zoom
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
            if(this.keyServer.isPressed('5')) { // normal relative distance
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
            if(this.keyServer.isPressed('7')) { // absolute viewing mode
                PVector bodyPosition = this.relativeBody.getPosition();
                float x = bodyPosition.x, y = bodyPosition.y, z = bodyPosition.z;
                float r = this.relativeDistance * this.relativeBody.getRadius();
                if(this.viewingMode == 1) {
                    this.positionX += x;
                    this.positionY += y;
                    this.positionZ += z;
                }
                if(this.viewingMode == 2) {
                    this.positionX = x - r * this.forwardX;
                    this.positionY = y - r * this.forwardY;
                    this.positionZ = z - r * this.forwardZ;
                }

                this.viewingMode = 0;
            }
            if(this.keyServer.isPressed('8')) { // absolute-relative viewing mode
                PVector bodyPosition = this.relativeBody.getPosition();
                float x = bodyPosition.x, y = bodyPosition.y, z = bodyPosition.z;
                float r = this.relativeDistance * this.relativeBody.getRadius();
                if(this.viewingMode == 0) {
                    this.positionX -= x;
                    this.positionY -= y;
                    this.positionZ -= z;
                }
                if(this.viewingMode == 2) {
                    this.positionX = -r * this.forwardX;
                    this.positionY = -r * this.forwardY;
                    this.positionZ = -r * this.forwardZ;
                }

                this.viewingMode = 1;
            }
            if(this.keyServer.isPressed('9')) { // relative viewing mode
                this.viewingMode = 2;
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

    private class Telescope {
        private Space.Body body;

        private float positionX, positionY, positionZ, forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ;
        private float speed, angleSpeed, pitchAndYawToRollRatio;

        private KeyServer keyServer;


        public Telescope(Space.Body body, KeyServer keyServer) {
            this.body = body;

            this.positionX = this.positionY = this.positionZ = 0.0;
            this.forwardX = this.forwardY = 0.0;
            this.forwardZ = 1.0;
            this.upX = this.upZ = 0.0;
            this.upY = 1.0;
            this.rightX = 1.0;
            this.rightY = this.rightZ = 0.0;
            this.angleSpeed = TWO_PI / FPS * 2E-1;
            this.pitchAndYawToRollRatio = 8.0;
            this.speed = 1E-2;

            this.keyServer = keyServer;
        }


        public Space.Body getBody() {
            return this.body;
        }

        public void controls() {
            float[] quaternion;
            PVector vector;

            if(this.keyServer.isPressed('w')) { // move forward
                this.body.accelerate(new PVector(this.forwardX * this.speed, this.forwardY * this.speed, this.forwardZ * this.speed));
            }
            if(this.keyServer.isPressed('s')) { // move backward
                this.body.accelerate(new PVector(-this.forwardX * this.speed, -this.forwardY * this.speed, -this.forwardZ * this.speed));
            }
            if(this.keyServer.isPressed('d')) { // move right
                this.body.accelerate(new PVector(this.rightX * this.speed, this.rightY * this.speed, this.rightZ * this.speed));
            }
            if(this.keyServer.isPressed('a')) { // move left
                this.body.accelerate(new PVector(-this.rightX * this.speed, -this.rightY * this.speed, -this.rightZ * this.speed));
            }
            if(this.keyServer.isPressed(' ')) { // move up
                this.body.accelerate(new PVector(this.upX * this.speed, this.upY * this.speed, this.upZ * this.speed));
            }
            if(this.keyServer.isPressed(SHIFT)) { // move down
                this.body.accelerate(new PVector(-this.upX * this.speed, -this.upY * this.speed, -this.upZ * this.speed));
            }
            if(this.keyServer.isPressed(UP)) { // pitch up
                quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, this.angleSpeed * this.pitchAndYawToRollRatio);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;

                quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;

                quaternion = vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;
            }
            if(this.keyServer.isPressed(DOWN)) { // pitch down
                quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, -this.angleSpeed * this.pitchAndYawToRollRatio);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;

                quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;

                quaternion = vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;
            }
            if(this.keyServer.isPressed(RIGHT)) { // yaw right
                quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, this.angleSpeed * this.pitchAndYawToRollRatio);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;

                quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.rightX = vector.x;
                this.rightY = vector.y;
                this.rightZ = vector.z;

                quaternion = vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;
            }
            if(this.keyServer.isPressed(LEFT)) { // yaw left
                quaternion = rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, -this.angleSpeed * this.pitchAndYawToRollRatio);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;

                quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.rightX = vector.x;
                this.rightY = vector.y;
                this.rightZ = vector.z;

                quaternion = vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.forwardX = vector.x;
                this.forwardY = vector.y;
                this.forwardZ = vector.z;
            }
            if(this.keyServer.isPressed('q')) { // roll counterclockwise
                quaternion = rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, this.angleSpeed);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;

                quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.rightX = vector.x;
                this.rightY = vector.y;
                this.rightZ = vector.z;

                quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;
            }
            if(this.keyServer.isPressed('e')) { // roll clockwise
                quaternion = rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, -this.angleSpeed);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;

                quaternion = vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.rightX = vector.x;
                this.rightY = vector.y;
                this.rightZ = vector.z;

                quaternion = vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                vector.normalize();
                this.upX = vector.x;
                this.upY = vector.y;
                this.upZ = vector.z;
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


    public float[] rotateOnQuaternion(float px, float py, float pz, float ax, float ay, float az, float angle) {
        float[] p = new float[]{0, px, py, pz};
        float[] a = new float[]{cos(angle), sin(angle) * ax, sin(angle) * ay, sin(angle) * az};

        p[0] = 0 - (a[1]) * (p[1]) - (a[2]) * (p[2]) - (a[3]) * (p[3]);
        p[1] = (a[0]) * (p[1]) + 0 + (a[2]) * (p[3]) - (a[3]) * (p[2]);
        p[2] = (a[0]) * (p[2]) - (a[1]) * (p[3]) + 0 + (a[3]) * (p[1]);
        p[3] = (a[0]) * (p[3]) + (a[1]) * (p[2]) - (a[2]) * (p[1]) + 0;

        p[0] = + (p[0]) * (a[0]) + (p[1]) * (a[1]) + (p[2]) * (a[2]) + (p[3]) * (a[3]);
        p[1] = - (p[0]) * (a[1]) + (p[1]) * (a[0]) - (p[2]) * (a[3]) + (p[3]) * (a[2]);
        p[2] = - (p[0]) * (a[2]) + (p[1]) * (a[3]) + (p[2]) * (a[0]) - (p[3]) * (a[1]);
        p[3] = - (p[0]) * (a[3]) - (p[1]) * (a[2]) + (p[2]) * (a[1]) + (p[3]) * (a[0]);

        return new float[]{p[1], p[2], p[3]};
    }

    public float[] vectorProduct(float x1, float y1, float z1, float x2, float y2, float z2) {
        return new float[]{y1 * z2 - y2 * z1, x2 * z1 - x1 * z2, x1 * y2 - x2 * y1};
    }
}
