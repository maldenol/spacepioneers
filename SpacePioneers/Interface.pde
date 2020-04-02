/***
  "Space Pioneers"
  Interface class
      Camera class
      Button class
      ButtonServer class
      SoundtrackThread class that extends Thread
      TextureLoaderThread class that extends Thread
  Malovanyi Denys Olehovych
***/

import java.awt.Robot;
import java.awt.AWTException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;

import java.util.concurrent.atomic.AtomicBoolean;


class Interface {
    private int context;
    
    private Camera camera;
    
    private Database db;
    
    private Space space;
    private PShape skybox;
    
    private Button buttonMenu;
    private Button buttonCredits, buttonSettings, buttonPlay;
    private Button buttonSingleplayer, buttonMultiplayer, buttonEditor;
    private Button buttonHost, buttonConnect;
    private Button fieldIP, fieldPort;
    private Button[] buttons;
    
    private ButtonServer buttonServer;
    
    private PImage[] buffer;
    private int xo, yo, swap;
    private AtomicBoolean textureLoaderWork;
    private TextureLoaderThread textureLoader;
    
    private SoundtrackThread soundtrack;
    
    private String creditsContent;
    
    
    public Interface() {
        float w, h, x, y0;
        
        this.context = 0;
        
        this.camera = new Camera();
        
        this.db = new Database();
        
        w = width / 8;
        h = height / 16;
        x = (width - w) / 2;
        this.buttonMenu = new Button(h / 10, h / 10, w, h, "MAIN MENU");
        this.buttonPlay = new Button(x, height / 5 * 2.5 - h * 2, w, h, "PLAY");
        this.buttonSettings = new Button(x, height / 5 * 3 - h * 2, w, h, "SETTINGS");
        this.buttonCredits = new Button(x, height / 5 * 3.5 - h * 2, w, h, "CREDITS");
        w = width / 8;
        h = height / 8;
        x = width - w;
        this.buttonSingleplayer = new Button(x - h / 10, height / 5 * 2 - h * 3 / 2, w, h, "SINGLEPLAYER");
        this.buttonMultiplayer = new Button(x - h / 10, height / 5 * 3 - h * 3 / 2, w, h, "MULTIPLAYER");
        this.buttonEditor = new Button(x - h / 10, height / 5 * 4 - h * 3 / 2, w, h, "EDITOR");
        w = width / 4;
        h = height / 16;
        x = (width - w) / 2;
        y0 = height / 2 - h * 2;
        this.fieldIP = new Button(x, y0 + h * 0, w, h, "0.0.0.0");
        this.fieldPort = new Button(x, y0 + h * 1, w, h, "16384");
        this.buttonHost = new Button(x, y0 + h * 2, w, h, "HOST");
        this.buttonConnect = new Button(x, y0 + h * 3, w, h, "CONNECT");
        
        this.buttonServer = new ButtonServer();
        this.buttonServer.addContext(new Button[]{this.buttonPlay, this.buttonSettings, this.buttonCredits}, new Button[]{}, new Button[]{}, new Button[][]{{}});
        this.buttonServer.addContext(new Button[]{this.buttonMenu}, new Button[]{}, new Button[]{}, new Button[][]{{}});
        this.buttonServer.addContext(new Button[]{this.buttonMenu}, new Button[]{}, new Button[]{}, new Button[][]{{}});
        this.buttonServer.addContext(new Button[]{}, new Button[]{}, new Button[]{}, new Button[][]{{}});
        this.buttonServer.addContext(new Button[]{}, new Button[]{}, new Button[]{}, new Button[][]{{}});
        this.buttonServer.addContext(new Button[]{this.buttonMenu, this.buttonSingleplayer, this.buttonMultiplayer, this.buttonEditor}, new Button[]{}, new Button[]{}, new Button[][]{this.buttons});
        this.buttonServer.addContext(new Button[]{this.buttonMenu, this.buttonHost, this.buttonConnect}, new Button[]{}, new Button[]{this.fieldIP, this.fieldPort}, new Button[][]{{}});
        
        this.xo = this.yo = this.swap = 0;
        this.buffer = new PImage[2];
        this.buffer[1] = this.db.getTexture("skybox");
        this.buffer[1].resize(width, height);
        this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[0]);
        this.buffer[0].resize(width, height);
        this.textureLoaderWork = new AtomicBoolean(false);
        
        this.creditsContent = "Space Pioneers\n\nCreated by Malovanyi Denys Olehovych\nFebruary-March 2020\n\nhttps://gitlab.com/maldenol/spacepioneers\nThis project is licensed under the GNU Affero General Public License v3.0.\n\nThanks for playing!";
    }
    
    public void draw() {
        switch(this.context) {
            case 0:
                this.menu();
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
    
    private void menu() {
        this.drawBackground();
        
        this.buttonServer.serve(this.context);
        
        if(this.buttonCredits.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 1;
        } else if(this.buttonSettings.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 2;
        } else if(this.buttonPlay.isActive()) {
            this.buttonServer.clear(this.context);
            
            this.drawBackground();
            
            ArrayList<Button> buttonsList = new ArrayList<Button>();
            float w = width / 2, h = height / 16;
            float x = (width - w) / 2, y0 = height / 8;
            for(String name : this.db.getXMLs())
                buttonsList.add(new Button(x, y0 + buttonsList.size() * h, w, h, name));
            this.buttons = new Button[buttonsList.size()];
            this.buttons = buttonsList.toArray(this.buttons);
            
            this.context = 5;
            
            this.buttonServer.setContext(this.context, new Button[]{this.buttonMenu, this.buttonSingleplayer, this.buttonMultiplayer, this.buttonEditor}, new Button[]{}, new Button[]{}, new Button[][]{this.buttons});
        }
    }
    
    private void credits() {
        if(keyPressed && key == 96) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        this.drawBackground();
        
        this.buttonServer.serve(this.context);
        
        if(this.buttonMenu.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        float w = width / 10, h = height / 10;
        fill(0, 127);
        stroke(255);
        strokeWeight(h / 10);
        rect(w, h, width - w * 2, height - h * 2, h / 2, h / 2, h / 2, h / 2);
        fill(255);
        stroke(0);
        strokeWeight(1);
        textSize(24);
        text(this.creditsContent, (width - textWidth(this.creditsContent)) / 2, height / 2 - h * 2);
        noFill();
    }
    
    private void settings() {
        if(keyPressed && key == 96) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        this.drawBackground();
        
        this.buttonServer.serve(this.context);
        
        if(this.buttonMenu.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
    }
    
    private void play() {
        if(keyPressed && key == 96) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        this.space.tick();
        
        this.camera.controls();
        background(0);
        this.camera.begin(this.skybox);
        this.space.draw();
        this.camera.end();
    }
    
    private void editor() {
        if(keyPressed && key == 96) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        this.camera.controls();
        background(0);
        this.camera.begin(this.skybox);
        this.space.draw();
        this.camera.end();
    }
    
    private void chooseWorld() {
        if(keyPressed && key == 96) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        this.drawBackground();
        
        this.buttonServer.serve(this.context);
        
        if(this.buttonMenu.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        }
        
        if(this.buttonSingleplayer.isActive()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.buttonServer.clear(this.context);
                    
                    this.drawBackground();
                    
                    noStroke();
                    fill(255);
                    this.space = new Space(button.getContent(), this.db);
                    this.skybox = createShape(SPHERE, 6E3);
                    this.skybox.setTexture(this.space.getSkybox());
                    this.skybox.rotateY(HALF_PI);
                    
                    this.soundtrack.kill();
                    this.soundtrack = null;
                    
                    this.textureLoader.kill();
                    this.textureLoader = null;
                    
                    this.context = 3;
                    
                    break;
                }
            }
        } else if(this.buttonMultiplayer.isActive()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.buttonServer.clear(this.context);
                    
                    this.drawBackground();
                    
                    this.context = 6;
                    
                    break;
                }
            }
        } else if(this.buttonEditor.isActive()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.buttonServer.clear(this.context);
                    
                    this.drawBackground();
                    
                    this.soundtrack.kill();
                    this.soundtrack = null;
                    
                    this.textureLoader.kill();
                    this.textureLoader = null;
                    
                    break;
                }
            }
        }
    }
    
    private void chooseHost() {
        if(keyPressed && key == 96) {
            this.buttonServer.clear(this.context);
            this.context = 5;
        }
        
        this.drawBackground();
        
        this.buttonServer.serve(this.context);
        
        if(this.buttonMenu.isActive()) {
            this.buttonServer.clear(this.context);
            this.context = 0;
        } else if(this.buttonHost.isActive()) {
            this.buttonServer.clear(this.context);
        } else if(this.buttonConnect.isActive()) {
            this.buttonServer.clear(this.context);
        }
    }
    
    private void drawBackground() {
        camera();
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
        
        if(this.xo == 0 && this.swap == 0)
            this.swap = 1;
        
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
        
        if(this.soundtrack == null) {
            this.soundtrack = new SoundtrackThread(this.db);
            this.soundtrack.start();
        }
        if(this.textureLoader == null) {
            this.textureLoader = new TextureLoaderThread(this.db, this.buffer, this.textureLoaderWork);
            this.textureLoader.start();
        }
    }
    
    
    private class Button {
        private float x, y, w, h;
        private String content;
        private boolean active;
        
        
        public Button(float x, float y, float w, float h, String content) {
            this.x = x;
            this.y = y;
            this.w = w;
            this.h = h;
            this.content = content;
            this.active = false;
        }
        
        
        public boolean isPressed() {
            return (mousePressed && mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h);
        }
        
        public void draw() {
            if(this.active)
                fill(255, 127);
            else
                fill(0, 127);
            stroke(255);
            strokeWeight(this.h / 10);
            rect(this.x, this.y, this.w, this.h, this.h / 2, this.h / 2, this.h / 2, this.h / 2);
            if(this.active)
                fill(0);
            else
                fill(255);
            stroke(0);
            strokeWeight(1);
            textSize(16);
            text(this.content, this.x + (this.w - textWidth(this.content)) / 2, this.y + this.h / 2);
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
             if(this.content.length() >= 1)
                 this.content = this.content.substring(0, this.content.length() - 1);
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
        private ArrayList<Button[][]> lists;
        
        private boolean fieldPressed;
        private char fieldLastChar;
        
        
        public ButtonServer() {
            this.buttons = new ArrayList<Button[]>();
            this.flags = new ArrayList<Button[]>();
            this.fields = new ArrayList<Button[]>();
            this.lists = new ArrayList<Button[][]>();
            
            this.fieldPressed = false;
            this.fieldLastChar = ' ';
        }
        
        
        public void addContext(Button[] buttons, Button[] flags, Button[] fields, Button[][] lists) {
            this.buttons.add(buttons.clone());
            this.flags.add(flags.clone());
            this.fields.add(fields.clone());
            this.lists.add(lists.clone());
        }
        
        public void setContext(int context, Button[] buttons, Button[] flags, Button[] fields, Button[][] lists) {
            this.buttons.set(context, buttons.clone());
            this.flags.set(context, flags.clone());
            this.fields.set(context, fields.clone());
            this.lists.set(context, lists.clone());
        }
        
        public void serve(int context) {
            for(Button button : buttons.get(context)) {
                button.draw();
                
                if(button.isPressed()) {
                    button.activate();
                    for(Button b : buttons.get(context))
                        if(b != button)
                            b.deactivate();
                }
            }
            
            for(Button flag : flags.get(context)) {
                flag.draw();
                
                if(flag.isPressed())
                    flag.toggle();
            }
            
            for(Button field : fields.get(context)) {
                field.draw();
                
                if(field.isPressed()) {
                    field.activate();
                    for(Button f : fields.get(context))
                        if(f != field)
                            f.deactivate();
                }
                
                if(field.isActive())
                    if(keyPressed) {
                        if(!this.fieldPressed || this.fieldLastChar != key) {
                            if(keyCode == BACKSPACE)
                                field.pop();
                            else if(key != CODED)
                                field.push(key);
                            this.fieldLastChar = key;
                        }
                        this.fieldPressed = true;
                    } else
                        this.fieldPressed = false;
            }
            
            for(Button[] list : lists.get(context)) {
                for(Button element : list) {
                    element.draw();
                    
                    if(element.isPressed()) {
                        element.activate();
                        for(Button e : list)
                          if(e != element)
                              e.deactivate();
                    }
                }
            }
        }
        
        public void clear(int context) {
            for(Button button : buttons.get(context))
                button.deactivate();
            
            for(Button flag : flags.get(context))
                flag.deactivate();
            
            for(Button field : fields.get(context))
                field.deactivate();
            
            for(Button[] list : lists.get(context))
                for(Button element : list)
                    element.deactivate();
        }
    }
    
    private class Camera {
        private float cameraPosX, cameraPosY, cameraPosZ, cameraForwardX, cameraForwardY, cameraForwardZ, cameraUpX, cameraUpY, cameraUpZ, cameraRightX, cameraRightY, cameraRightZ;
        private float cameraAngleX, cameraAngleY, cameraAngleZ;
        private float cameraSensivity, cameraSpeed;
        private float cameraZoom;
        private int cameraMode;
        
        private Robot mouse;
        
        
        public Camera() {
            this.cameraPosX = this.cameraPosY = this.cameraPosZ = 0;
            this.cameraForwardX = this.cameraForwardY = 0;
            this.cameraForwardZ = 1;
            this.cameraUpX = this.cameraUpZ = 0;
            this.cameraUpY = 1;
            this.cameraRightX = 1;
            this.cameraRightY = this.cameraRightZ = 0;
            this.cameraAngleX = this.cameraAngleY = cameraAngleZ = 0;
            this.cameraSensivity = 4E-2;
            this.cameraSpeed = 1E2;
            this.cameraZoom = 1;
            this.cameraMode = 0;
            
            try {
                this.mouse = new Robot();
            } catch(AWTException e) {}
        }
        
        
        public void begin() {
            beginCamera();
            camera(this.cameraPosX, this.cameraPosY, this.cameraPosZ, this.cameraForwardX + this.cameraPosX, this.cameraForwardY + this.cameraPosY, this.cameraForwardZ + this.cameraPosZ, this.cameraUpX, this.cameraUpY, this.cameraUpZ);
        }
        
        public void begin(PShape skybox) {
            this.begin();
            
            translate(this.cameraPosX, this.cameraPosY, this.cameraPosZ);
            shape(skybox, 0, 0);
            translate(-this.cameraPosX, -this.cameraPosY, -this.cameraPosZ);
        }
        
        public void end() {
            endCamera();
        }
        
        public void controls() {
            float w = width / 2, h = height / 2;
            
            if(mouseX != pmouseX || mouseY != pmouseY) {
                this.cameraAngleY -= (radians(mouseX - w) * cos(this.cameraAngleZ) - radians(mouseY - h) * sin(this.cameraAngleZ)) * this.cameraSensivity;
                this.cameraAngleX += (radians(mouseY - h) * cos(this.cameraAngleZ) + radians(mouseX - w) * sin(this.cameraAngleZ)) * this.cameraSensivity;
                if(this.cameraAngleX <= -HALF_PI * 0.9)
                    this.cameraAngleX = -HALF_PI * 0.9;
                else if(this.cameraAngleX >= HALF_PI * 0.9)
                    this.cameraAngleX = HALF_PI * 0.9;
                
                this.mouse.mouseMove((int)w, (int)h);
                
                this.cameraForwardX = cos(this.cameraAngleX) * sin(this.cameraAngleY);
                this.cameraForwardY = sin(this.cameraAngleX);
                this.cameraForwardZ = cos(this.cameraAngleX) * cos(this.cameraAngleY);
                
                PVector right = new PVector(this.cameraForwardY * this.cameraUpZ - this.cameraForwardZ * this.cameraUpY, this.cameraForwardX * this.cameraUpZ - this.cameraUpZ * this.cameraForwardX, this.cameraForwardX * this.cameraUpY - this.cameraForwardY * this.cameraUpX);
                right.normalize();
                this.cameraRightX = right.x;
                this.cameraRightY = right.y;
                this.cameraRightZ = right.z;
                
                /*
                PVector up = new PVector(this.cameraForwardY * this.cameraRightZ - this.cameraForwardZ * this.cameraRightY, this.cameraForwardX * this.cameraRightZ - this.cameraRightZ * this.cameraForwardX, this.cameraForwardX * this.cameraRightY - this.cameraForwardY * this.cameraRightX);
                up.normalize();
                this.cameraUpX = -up.x;
                this.cameraUpY = -up.y;
                this.cameraUpZ = -up.z;
                */
            }
            
            if(keyPressed) {
                if(key == 'w') { // move forward
                    this.cameraPosX += this.cameraForwardX * this.cameraSpeed;
                    this.cameraPosY += this.cameraForwardY * this.cameraSpeed;
                    this.cameraPosZ += this.cameraForwardZ * this.cameraSpeed;
                }
                if(key == 's') { // move backward
                    this.cameraPosX -= this.cameraForwardX * this.cameraSpeed;
                    this.cameraPosY -= this.cameraForwardY * this.cameraSpeed;
                    this.cameraPosZ -= this.cameraForwardZ * this.cameraSpeed;
                }
                if(key == 'd') { // move right
                    this.cameraPosX += this.cameraRightX * this.cameraSpeed;
                    this.cameraPosY += this.cameraRightY * this.cameraSpeed;
                    this.cameraPosZ += this.cameraRightZ * this.cameraSpeed;
                }
                if(key == 'a') { // move left
                    this.cameraPosX -= this.cameraRightX * this.cameraSpeed;
                    this.cameraPosY -= this.cameraRightY * this.cameraSpeed;
                    this.cameraPosZ -= this.cameraRightZ * this.cameraSpeed;
                }
                if(key == ' ') { // move up
                    this.cameraPosX -= this.cameraUpX * this.cameraSpeed;
                    this.cameraPosY -= this.cameraUpY * this.cameraSpeed;
                    this.cameraPosZ -= this.cameraUpZ * this.cameraSpeed;
                }
                if(keyCode == SHIFT) { // move down
                    this.cameraPosX += this.cameraUpX * this.cameraSpeed;
                    this.cameraPosY += this.cameraUpY * this.cameraSpeed;
                    this.cameraPosZ += this.cameraUpZ * this.cameraSpeed;
                }
                if(key == 'q') { // spin left
                    this.cameraAngleZ -= TWO_PI / FPS;
                    this.cameraUpX = sin(this.cameraAngleZ);
                    this.cameraUpY = cos(this.cameraAngleZ);
                    this.cameraUpZ = sin(this.cameraAngleZ);
                }
                if(key == 'e') { // spin right
                    this.cameraAngleZ += TWO_PI / FPS;
                    this.cameraUpX = sin(this.cameraAngleZ);
                    this.cameraUpY = cos(this.cameraAngleZ);
                    this.cameraUpZ = sin(this.cameraAngleZ);
                }
                if(key == 'r') { // spin back
                    this.cameraAngleZ = 0;
                    this.cameraUpX = sin(this.cameraAngleZ);
                    this.cameraUpY = cos(this.cameraAngleZ);
                    this.cameraUpZ = sin(this.cameraAngleZ);
                }
            }
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
            
            while(true)
                try {
                    audioInputStream = AudioSystem.getAudioInputStream(this.db.getSound(this.db.getSoundsOld()[index]));
                    this.index = (this.index + 1) % this.indexMax;
                    clip = AudioSystem.getClip();
                    clip.open(audioInputStream);
                    clip.start();
                    int wait = (int)(1E-3 * clip.getMicrosecondLength()), delayDuration = 10;
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
        
        public void kill() {
            this.killed = true;
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
            
            while(true)
                if(this.killed)
                    return;
                else if(this.work.get()) {
                    this.buffer[1] = this.buffer[0].copy();
                    this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[this.index]);
                    this.buffer[0].resize(width, height);
                    
                    this.index = (this.index + 1) % this.indexMax;
                    
                    this.work.set(false);
                }
        }
        
        public void kill() {
            this.killed = true;
        }
    }
}
