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
      Camera class
      Button class
      ButtonServer class
      Key class
      KeyServer class
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

    private Button buttonMenuBack;
    private Button buttonMenuCredits, buttonMenuSettings, buttonMenuPlay;
    private Button buttonPlayMenu, buttonPlayResume, buttonPlaySettings, buttonPlayExit;
    private Button buttonEditorMenu, buttonEditorResume, buttonEditorSettings, buttonEditorExit, buttonEditorSave;
    private Button buttonMenuSingleplayer, buttonMenuMultiplayer, buttonMenuEditor;
    private Button buttonMenuHost, buttonMenuConnect;
    private Button fieldMenuIP, fieldMenuPort;
    private Button[] buttonsMenuWorlds, buttonsEditorBodies;

    private boolean pause;
    private float speed;

    private ButtonServer buttonServer;
    private KeyServer keyServer;

    private PImage[] buffer;
    private int xo, yo, swap;
    private AtomicBoolean textureLoaderWork;
    private TextureLoaderThread textureLoader;

    private SoundtrackThread soundtrack;

    private String creditsContent;

    private Space space;
    private Camera camera;

    private PShape skybox;


    public Interface() {
        this.db = new Database();

        this.context = 0;

        this.pause = false;
        this.speed = 1.0;

        float w, h, x, y0;
        w = width;
        h = height / 16.0;
        x = h / 10.0;
        y0 = h / 10.0;
        this.buttonMenuBack = new Button(x, y0, w - 2.0 * x, h, "BACK");
        w = width / 4.0;
        h = height / 4.0;
        this.buttonPlayMenu = new Button(w, h, width - w * 2.0, height - h * 2.0, h / 16.0, h / 4.0, "");
        w = width / 8.0;
        h = height / 16.0;
        x = (width - w) / 2.0;
        this.buttonMenuPlay = new Button(x, height / 5.0 * 2.5 - h * 2.0, w, h, "PLAY");
        this.buttonMenuSettings = new Button(x, height / 5.0 * 3.0 - h * 2.0, w, h, "SETTINGS");
        this.buttonMenuCredits = new Button(x, height / 5.0 * 3.5 - h * 2.0, w, h, "CREDITS");
        this.buttonPlayResume = new Button(x + 1, height / 5.0 * 2.5 - h * 2.0 + 1, w, h, "RESUME");
        this.buttonPlaySettings = new Button(x + 1, height / 5.0 * 3.0 - h * 2.0 + 1, w, h, "SETTINGS");
        this.buttonPlayExit = new Button(x + 1, height / 5.0 * 3.5 - h * 2.0 + 1, w, h, "EXIT");
        w = width / 3.0;
        this.buttonEditorMenu = new Button(width - w, -5.0, width, height + 5.0, 5.0, 0.0, "");
        w = width / 8.0;
        h = height / 4.0;
        x = 0;
        this.buttonEditorSave = new Button(x, h * 0.0, w, h, 2.0, 5.0, "SAVE");
        this.buttonEditorResume = new Button(x, h * 1.0, w, h, 2.0, 5.0, "RESUME");
        this.buttonEditorSettings = new Button(x, h * 2.0, w, h, 2.0, 5.0, "SETTINGS");
        this.buttonEditorExit = new Button(x, h * 3.0, w, h, 2.0, 5.0, "EXIT");
        w = width / 8.0;
        h = height / 8.0;
        x = width - w;
        this.buttonMenuSingleplayer = new Button(x - h / 10.0, height / 5.0 * 2.0 - h * 3.0 / 2.0, w, h, "SINGLEPLAYER");
        this.buttonMenuMultiplayer = new Button(x - h / 10.0, height / 5.0 * 3.0 - h * 3.0 / 2.0, w, h, "MULTIPLAYER");
        this.buttonMenuEditor = new Button(x - h / 10.0, height / 5.0 * 4.0 - h * 3.0 / 2.0, w, h, "EDITOR");
        w = width / 4.0;
        h = height / 16.0;
        x = (width - w) / 2.0;
        y0 = height / 2.0 - h * 2.0;
        this.fieldMenuIP = new Button(x, y0 + h * 0.0, w, h, "0.0.0.0");
        this.fieldMenuPort = new Button(x, y0 + h * 1.0, w, h, "16384");
        this.buttonMenuHost = new Button(x, y0 + h * 2.0, w, h, "HOST");
        this.buttonMenuConnect = new Button(x, y0 + h * 3.0, w, h, "CONNECT");

        this.buttonServer = new ButtonServer();
        this.buttonServer.addContext(new Button[]{this.buttonMenuPlay, this.buttonMenuSettings, this.buttonMenuCredits}, new Button[]{}, new Button[]{}, new Button[][]{{}}, new Button[][]{{}}, new Button[][]{{}}); // main menu
        this.buttonServer.addContext(new Button[]{this.buttonMenuBack}, new Button[]{}, new Button[]{}, new Button[][]{{}}, new Button[][]{{}}, new Button[][]{{}}); // credits
        this.buttonServer.addContext(new Button[]{this.buttonMenuBack}, new Button[]{}, new Button[]{}, new Button[][]{{}}, new Button[][]{{}}, new Button[][]{{}}); // settings
        this.buttonServer.addContext(new Button[]{this.buttonPlayMenu, this.buttonPlayResume, this.buttonPlaySettings, this.buttonPlayExit}, new Button[]{}, new Button[]{}, new Button[][]{{}}, new Button[][]{{}}, new Button[][]{{}}); // play menu
        this.buttonServer.addContext(new Button[]{this.buttonEditorMenu, this.buttonEditorSave, this.buttonEditorResume, this.buttonEditorSettings, this.buttonEditorExit}, new Button[]{}, new Button[]{}, new Button[][]{{}}, new Button[][]{{}}, new Button[][]{{}}); // editor menu
        this.buttonServer.addContext(new Button[]{this.buttonMenuBack, this.buttonMenuSingleplayer, this.buttonMenuMultiplayer, this.buttonMenuEditor}, new Button[]{}, new Button[]{}, new Button[][]{this.buttonsMenuWorlds}, new Button[][]{{}}, new Button[][]{{}}); // choose world
        this.buttonServer.addContext(new Button[]{this.buttonMenuBack, this.buttonMenuHost, this.buttonMenuConnect}, new Button[]{}, new Button[]{this.fieldMenuIP, this.fieldMenuPort}, new Button[][]{{}}, new Button[][]{{}}, new Button[][]{{}}); // choose host

        this.keyServer = new KeyServer();
        this.keyServer.addKey('`');

        this.xo = this.yo = this.swap = 0;
        this.buffer = new PImage[2];
        this.buffer[1] = this.db.getTexture("skybox");
        this.buffer[1].resize(width, height);
        this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[0]);
        this.buffer[0].resize(width, height);
        this.textureLoaderWork = new AtomicBoolean(false);

        this.creditsContent = "Space Pioneers\n\nCreated by Malovanyi Denys Olehovych\nFebruary-March 2020\n\nhttps://gitlab.com/maldenol/spacepioneers\nThis project is licensed under the GNU Affero General Public License v3.0.\n\nThanks for playing!";

        this.camera = new Camera();
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

            ArrayList<Button> buttonsList = new ArrayList<Button>();
            float w = width / 2.0, h = height / 16.0;
            float x = (width - w) / 2.0, y0 = height / 8.0;
            for(String name : this.db.getXMLs()) {
                buttonsList.add(new Button(x, y0 + buttonsList.size() * h, w, h, name));
            }
            this.buttonsMenuWorlds = new Button[buttonsList.size()];
            this.buttonsMenuWorlds = buttonsList.toArray(this.buttonsMenuWorlds);

            this.context = 5;

            this.buttonServer.setContext(this.context, new Button[]{this.buttonMenuBack, this.buttonMenuSingleplayer, this.buttonMenuMultiplayer, this.buttonMenuEditor}, new Button[]{}, new Button[]{}, new Button[][]{this.buttonsMenuWorlds}, new Button[][]{{}}, new Button[][]{{}}); // choose world
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
            this.camera.controls();
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
            for(Button button : this.buttonsMenuWorlds) {
                if(button.isActive()) {
                    this.buttonServer.clear(this.context);

                    try {
                        Robot mouse = new Robot();
                        mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
                    } catch(AWTException e) {}

                    this.drawBackground();

                    this.space = new Space(button.getContent(), this.db);
                    this.camera = new Camera();
                    noStroke();
                    fill(255);
                    this.skybox = createShape(SPHERE, 6E3);
                    this.skybox.setTexture(this.space.getSkybox());
                    this.skybox.rotateY(HALF_PI);
                    this.pause = false;

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

            if(choose == 1) {
                this.context = 3;
            } else if(choose == 2) {
                this.context = 6;
            } else if(choose == 3) {
                ArrayList<Button> buttonsList = new ArrayList<Button>();
                float w = width / 2.0, h = height / 16.0;
                float x = (width - w) / 2.0, y0 = height / 8.0;
                for(String name : this.db.getXMLs()) {
                    buttonsList.add(new Button(x, y0 + buttonsList.size() * h, w, h, name));
                }
                this.buttonsEditorBodies = new Button[buttonsList.size()];
                this.buttonsEditorBodies = buttonsList.toArray(this.buttonsEditorBodies);

                this.context = 4;

                this.buttonServer.setContext(this.context, new Button[]{this.buttonEditorMenu, this.buttonEditorSave, this.buttonEditorResume, this.buttonEditorSettings, this.buttonEditorExit}, new Button[]{}, new Button[]{}, new Button[][]{this.buttonsEditorBodies}, new Button[][]{{}}, new Button[][]{{}}); // editor
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
    }


    private class Key {
        private char content;
        private int timeLastPress, timeBetweenPresses;


        public Key(char content) {
            this.content = content;

            this.timeLastPress = 0;
            this.timeBetweenPresses = 300;
        }


        public boolean isPressed() {
            return (keyPressed && key == this.content);
        }

        public boolean isClicked() {
            if(keyPressed && key == this.content && millis() - this.timeLastPress >= this.timeBetweenPresses) {
                this.timeLastPress = millis();
                return true;
            }
            return false;
        }

        public char getContent() {
            return this.content;
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

        public void removeKey(char content) {
            Iterator<Key> iter = this.keys.iterator();
            while (iter.hasNext()) {
                if(iter.next().getContent() == content) {
                    iter.remove();
                }
            }
        }

        public boolean isPressed(char content) {
            for(Key key : this.keys) {
                if(key.getContent() == content) {
                    return key.isPressed();
                }
            }
            return false;
        }

        public boolean isClicked(char content) {
            for(Key key : this.keys) {
                if(key.getContent() == content) {
                    return key.isClicked();
                }
            }
            return false;
        }
    }


    private class Camera {
        private float posX, posY, posZ, forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ;
        private float speed, angleSpeed, pitchAndYawToRollRatio;
        private float zoom;
        private int mode;

        private Robot mouse;


        public Camera() {
            this.posX = this.posY = this.posZ = 0.0;
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
            this.mode = 0;

            try {
                this.mouse = new Robot();
            } catch(AWTException e) {}
        }


        public void begin() {
            beginCamera();
            camera(this.posX, this.posY, this.posZ, this.forwardX + this.posX, this.forwardY + this.posY, this.forwardZ + this.posZ, this.upX, this.upY, this.upZ);

            float fov = PI / 3.0 / zoom;
            float cameraZ = (height / 2.0) / tan(fov / 2.0);
            perspective(fov, float(width) / float(height), cameraZ / 100.0, cameraZ * 100.0);
        }

        public void begin(PShape skybox) {
            this.begin();

            translate(this.posX, this.posY, this.posZ);
            shape(skybox, 0, 0);
            translate(-this.posX, -this.posY, -this.posZ);
        }

        public void end() {
            endCamera();
        }

        public void controls() {
            float[] quaternion;
            PVector vector;

            if(mouseX != pmouseX || mouseY != pmouseY) {
                if(mouseX != pmouseX) { // rotate left or right
                    quaternion = this.rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.upX, this.upY, this.upZ, map(mouseX - HALF_WIDTH, -HALF_WIDTH, HALF_WIDTH, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;

                    quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.rightX = vector.x;
                    this.rightY = vector.y;
                    this.rightZ = vector.z;

                    quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;
                }

                if(mouseY != pmouseY) { // rotate up or down
                    quaternion = this.rotateOnQuaternion(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ, map(mouseY - HALF_HEIGHT, -HALF_HEIGHT, HALF_HEIGHT, this.angleSpeed, -this.angleSpeed) * this.pitchAndYawToRollRatio);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;

                    quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.upX = vector.x;
                    this.upY = vector.y;
                    this.upZ = vector.z;

                    quaternion = this.vectorProduct(this.rightX, this.rightY, this.rightZ, this.upX, this.upY, this.upZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.forwardX = vector.x;
                    this.forwardY = vector.y;
                    this.forwardZ = vector.z;
                }

                this.mouse.mouseMove((int)HALF_WIDTH, (int)HALF_HEIGHT);
            }

            if(keyPressed) {
                if(key == 'w') { // move forward
                    this.posX += this.forwardX * this.speed;
                    this.posY += this.forwardY * this.speed;
                    this.posZ += this.forwardZ * this.speed;
                }
                if(key == 's') { // move backward
                    this.posX -= this.forwardX * this.speed;
                    this.posY -= this.forwardY * this.speed;
                    this.posZ -= this.forwardZ * this.speed;
                }
                if(key == 'd') { // move right
                    this.posX += -this.rightX * this.speed;
                    this.posY += -this.rightY * this.speed;
                    this.posZ += -this.rightZ * this.speed;
                }
                if(key == 'a') { // move left
                    this.posX -= -this.rightX * this.speed;
                    this.posY -= -this.rightY * this.speed;
                    this.posZ -= -this.rightZ * this.speed;
                }
                if(key == ' ') { // move up
                    this.posX -= this.upX * this.speed;
                    this.posY -= this.upY * this.speed;
                    this.posZ -= this.upZ * this.speed;
                }
                if(keyCode == SHIFT) { // move down
                    this.posX += this.upX * this.speed;
                    this.posY += this.upY * this.speed;
                    this.posZ += this.upZ * this.speed;
                }
                if(key == 'q') { // spin left
                    quaternion = this.rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, this.angleSpeed);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.upX = vector.x;
                    this.upY = vector.y;
                    this.upZ = vector.z;

                    quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.rightX = vector.x;
                    this.rightY = vector.y;
                    this.rightZ = vector.z;

                    quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.upX = vector.x;
                    this.upY = vector.y;
                    this.upZ = vector.z;
                }
                if(key == 'e') { // spin right
                    quaternion = this.rotateOnQuaternion(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ, -this.angleSpeed);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.upX = vector.x;
                    this.upY = vector.y;
                    this.upZ = vector.z;

                    quaternion = this.vectorProduct(this.upX, this.upY, this.upZ, this.forwardX, this.forwardY, this.forwardZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.rightX = vector.x;
                    this.rightY = vector.y;
                    this.rightZ = vector.z;

                    quaternion = this.vectorProduct(this.forwardX, this.forwardY, this.forwardZ, this.rightX, this.rightY, this.rightZ);
                    vector = new PVector(quaternion[0], quaternion[1], quaternion[2]);
                    vector.normalize();
                    this.upX = vector.x;
                    this.upY = vector.y;
                    this.upZ = vector.z;
                }
                if(key == '-') {
                    this.zoom -= this.zoom / 1E2;
                    if(this.zoom < 5E-1) {
                        this.zoom = 5E-1;
                    }
                }
                if(key == '+') {
                    this.zoom += this.zoom / 1E2;
                    if(this.zoom > 3600.0) {
                        this.zoom = 3600.0;
                    }
                }
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
