/***
  "Space Pioneers"
  Interface class
      Camera class
      Button class
      SoundtrackThread class that extends Thread
      TextureLoaderThread class that extends Thread
  Malovanyi Denys Olehovych
***/

import java.awt.Robot;
import java.awt.AWTException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;


class Interface {
    private int context;
    
    private float cameraPosX, cameraPosY, cameraPosZ, cameraForwardX, cameraForwardY, cameraForwardZ, cameraUpX, cameraUpY, cameraUpZ, cameraRightX, cameraRightY, cameraRightZ;
    private float cameraAngleX, cameraAngleY, cameraAngleZ;
    private float cameraSensivity, cameraSpeed;
    private float cameraZoom;
    private int cameraMode;
    
    private Robot robot;
    
    private Database db;
    
    private Space space;
    private PShape skybox;
    
    private Button buttonMenu;
    private Button buttonCredits, buttonPlay;
    private Button buttonSingleplayer, buttonMultiplayer, buttonEditor;
    private Button buttonHost, buttonConnect;
    private Button fieldIP, fieldPort;
    private Button[] buttons;
    
    private boolean fieldPressed;
    private char fieldLastChar;
    
    private PImage[] buffer;
    private int xo, yo, swap, textureIndex, textureIndexMax;
    
    private SoundtrackThread soundtrack;
    
    private String buttonCreditsContent;
    
    
    public Interface() {
        float w, h, x, y0;
        
        this.context = 0;  
        
        this.db = new Database();
        
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
            this.robot = new Robot();
        } catch(AWTException e) {}
        
        w = width / 8;
        h = height / 16;
        x = (width - w) / 2;
        this.buttonMenu = new Button(h / 10, h / 10, w, h, "MAIN MENU");
        this.buttonPlay = new Button(x, height / 5 * 2.5 - h * 2, w, h, "PLAY");
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
        
        this.fieldPressed = false;
        this.fieldLastChar = ' ';
        
        this.xo = this.yo = this.swap = this.textureIndex = 0;
        this.textureIndexMax = this.db.getTextures().length;
        this.buffer = new PImage[2];
        this.buffer[1] = this.db.getTexture("skybox");
        this.buffer[1].resize(width, height);
        this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[this.textureIndex]);
        this.buffer[0].resize(width, height);
        this.textureIndex = (this.textureIndex + 1) % this.textureIndexMax;
        
        this.soundtrack = new SoundtrackThread(this.db);
        
        this.buttonCreditsContent = "Space Pioneers\n\nCreated by Malovanyi Denys Olehovych\nFebruary-March 2020\n\nhttps://gitlab.com/maldenol/spacepioneers\nThis project is licensed under the GNU Affero General Public License v3.0.\n\nThanks for playing!";
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
                this.play();
                break;
            case 3:
                this.editor();
                break;
            case 4:
                this.chooseWorld();
                break;
            case 5:
                this.chooseHost();
                break;
            default:
                this.context = 0;
                break;
        }
    }
    
    private void menu() {
        this.drawBackground();
        
        buttonCredits.draw();
        buttonPlay.draw();
        
        if(this.buttonCredits.isPressed()) {
            this.context = 1;
        } else if(this.buttonPlay.isPressed()) {
            this.drawBackground();
            
            ArrayList<Button> buttonsList = new ArrayList<Button>();
            float w = width / 2, h = height / 16;
            float x = (width - w) / 2, y0 = height / 8;
            for(String name : this.db.getXMLs())
                buttonsList.add(new Button(x, y0 + buttonsList.size() * h, w, h, name));
            this.buttons = new Button[buttonsList.size()];
            this.buttons = buttonsList.toArray(this.buttons);
            
            this.context = 4;
        }
    }
    
    private void credits() {
        this.drawBackground();
        
        this.buttonMenu.draw();
        if(this.buttonMenu.isPressed())
            this.context = 0;
        
        float w = width / 10, h = height / 10;
        fill(0, 127);
        stroke(255);
        strokeWeight(h / 10);
        rect(w, h, width - w * 2, height - h * 2, h / 2, h / 2, h / 2, h / 2);
        fill(255);
        stroke(0);
        strokeWeight(1);
        textSize(24);
        text(this.buttonCreditsContent, (width - textWidth(this.buttonCreditsContent)) / 2, height / 2 - h * 2);
        noFill();
    }
    
    private void play() {
        this.space.tick();
        
        background(0);
        beginCamera();
        camera(this.cameraPosX, this.cameraPosY, this.cameraPosZ, this.cameraForwardX + this.cameraPosX, this.cameraForwardY + this.cameraPosY, this.cameraForwardZ + this.cameraPosZ, this.cameraUpX, this.cameraUpY, this.cameraUpZ);
        
        translate(this.cameraPosX, this.cameraPosY, this.cameraPosZ);
        shape(this.skybox, 0, 0);
        translate(-this.cameraPosX, -this.cameraPosY, -this.cameraPosZ);
        
        this.space.draw();
        
        endCamera();
        
        this.interfacePlay();
    }
    
    private void editor() {
        background(0);
        beginCamera();
        camera(this.cameraPosX, this.cameraPosY, this.cameraPosZ, this.cameraForwardX + this.cameraPosX, this.cameraForwardY + this.cameraPosY, this.cameraForwardZ + this.cameraPosZ, this.cameraUpX, this.cameraUpY, this.cameraUpZ);
        
        translate(this.cameraPosX, this.cameraPosY, this.cameraPosZ);
        shape(this.skybox, 0, 0);
        translate(-this.cameraPosX, -this.cameraPosY, -this.cameraPosZ);
        
        this.space.draw();
        
        endCamera();
        
        this.interfaceEditor();
    }
    
    private void chooseWorld() {
        this.drawBackground();
        
        this.buttonMenu.draw();
        if(this.buttonMenu.isPressed())
            this.context = 0;
        
        this.buttonSingleplayer.draw();
        this.buttonMultiplayer.draw();
        this.buttonEditor.draw();
        
        for(Button button : this.buttons) {
            button.draw();
            
            if(button.isPressed()) {
                for(Button b : this.buttons)
                    b.deactivate();
                button.activate();
            }
        }
        
        if(this.buttonSingleplayer.isPressed()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.drawBackground();
                    
                    noStroke();
                    fill(255);
                    this.space = new Space(button.getContent(), this.db);
                    this.skybox = createShape(SPHERE, 6E3);
                    this.skybox.setTexture(this.space.getSkybox());
                    this.skybox.rotateY(HALF_PI);
                    
                    this.robot.mouseMove((int)(width / 2), (int)(height / 2));
                    
                    this.soundtrack.kill();
                    
                    this.context = 2;
                    
                    break;
                }
            }
        } else if(this.buttonMultiplayer.isPressed()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.drawBackground();
                    
                    this.robot.mouseMove((int)(width / 2), (int)(height / 2));
                    
                    this.context = 5;
                    
                    break;
                }
            }
        } else if(this.buttonEditor.isPressed()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.drawBackground();
                    
                    this.robot.mouseMove((int)(width / 2), (int)(height / 2));
                    
                    this.soundtrack.kill();
                    
                    break;
                }
            }
        }
    }
    
    private void chooseHost() {
        this.drawBackground();
        
        this.buttonMenu.draw();
        if(this.buttonMenu.isPressed())
            this.context = 0;
        
        this.buttonHost.draw();
        this.buttonConnect.draw();
        this.fieldIP.draw();
        this.fieldPort.draw();
        
        if(this.fieldIP.isPressed()) {
            this.fieldIP.activate();
            this.fieldPort.deactivate();
        } else if(this.fieldPort.isPressed()) {
            this.fieldIP.deactivate();
            this.fieldPort.activate();
        } else if(this.buttonHost.isPressed()) {
            
        } else if(this.buttonConnect.isPressed()) {
            
        }
        
        if(this.fieldIP.isActive()) {
            if(keyPressed) {
                if(!this.fieldPressed || this.fieldLastChar != key) {
                    if(keyCode == BACKSPACE)
                        this.fieldIP.pop();
                    else if(key != CODED)
                        this.fieldIP.push(key);
                    this.fieldLastChar = key;
                }
                this.fieldPressed = true;
            } else
                this.fieldPressed = false;
        } else if(this.fieldPort.isActive()) {
            if(keyPressed) {
                if(!this.fieldPressed || this.fieldLastChar != key) {
                    if(keyCode == BACKSPACE)
                        this.fieldPort.pop();
                    else if(key != CODED)
                        this.fieldPort.push(key);
                    this.fieldLastChar = key;
                }
                this.fieldPressed = true;
            } else
                this.fieldPressed = false;
        }
    }
    
    private void interfacePlay() {
        float w = width / 2, h = height / 2;
        
        if(mouseX != pmouseX || mouseY != pmouseY) {
            this.cameraAngleY -= (radians(mouseX - w) * cos(this.cameraAngleZ) - radians(mouseY - h) * sin(this.cameraAngleZ)) * this.cameraSensivity;
            this.cameraAngleX += (radians(mouseY - h) * cos(this.cameraAngleZ) + radians(mouseX - w) * sin(this.cameraAngleZ)) * this.cameraSensivity;
            if(this.cameraAngleX <= -HALF_PI * 0.9)
                this.cameraAngleX = -HALF_PI * 0.9;
            else if(this.cameraAngleX >= HALF_PI * 0.9)
                this.cameraAngleX = HALF_PI * 0.9;
            this.robot.mouseMove((int)w, (int)h);
            
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
    
    private void interfaceEditor() {
        
    }
    
    private void drawBackground() {
        camera();
        background(0);
        
        if(swap == 1) {
            image(this.buffer[0], -width + this.xo, -height + this.yo);
            image(this.buffer[0], this.xo, -height + this.yo);
        }
        image(this.buffer[1], -width + this.xo, this.yo);
        image(this.buffer[1], this.xo, this.yo);
        
        this.xo = (this.xo + 1) % width;
        
        if(this.xo == 0 && this.swap == 0)
            this.swap = 1;
        
        if(this.swap == 1) {
            this.yo = (this.yo + height / FPS) % height;
            
            if(this.yo == 0) {
                this.swap = 0;
                
                this.buffer[1] = this.buffer[0];
                this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[this.textureIndex]);
                this.buffer[0].resize(width, height);
                this.textureIndex = (this.textureIndex + 1) % this.textureIndexMax;
            }
        }
        
        stroke(255);
        strokeWeight(2);
        fill(0, 127);
        circle(mouseX, mouseY, 8);
        noFill();
        
        if(this.soundtrack.getState() == Thread.State.NEW)
            this.soundtrack.start();
    }
    
    
    private class Camera {
        private float cameraPosX, cameraPosY, cameraPosZ, cameraForwardX, cameraForwardY, cameraForwardZ, cameraUpX, cameraUpY, cameraUpZ, cameraRightX, cameraRightY, cameraRightZ;
        private float cameraAngleX, cameraAngleY, cameraAngleZ;
        private float cameraSensivity, cameraSpeed;
        private float cameraZoom;
        private int cameraMode;
        
        
        public Camera() {
            
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
    
    
    public class SoundtrackThread extends Thread {
        private Database db;
        private int soundIndex, soundIndexMax;
        private boolean killed;
        
        public SoundtrackThread(Database db) {
            this.db = db;
            this.killed = false;
        }
        
        @Override
        public void run() {
            this.soundIndex = 0;
            this.soundIndexMax = this.db.getSounds().length;
            
            AudioInputStream audioInputStream;
            Clip clip;
            
            while(true)
                try {
                    audioInputStream = AudioSystem.getAudioInputStream(this.db.getSound(this.db.getSoundsOld()[soundIndex]));
                    this.soundIndex = (this.soundIndex + 1) % this.soundIndexMax;
                    clip = AudioSystem.getClip();
                    clip.open(audioInputStream);
                    clip.start();
                    int wait = (int)(1E-3 * clip.getMicrosecondLength());
                    for(int i = 0; i < FPS; i++) {
                        if(this.killed) {
                            clip.close();
                            return;
                        }
                        delay(wait / FPS);
                    }
                    clip.close();
                } catch(Exception e) {}
        }
        
        public void kill() {
            this.killed = true;
        }
    }
}
