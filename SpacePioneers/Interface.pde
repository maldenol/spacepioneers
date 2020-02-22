/***
  "Space Pioneers"
  Interface class
      Button class
  Malovanyi Denys Olehovych
***/

import java.awt.Robot;
import java.awt.AWTException;


class Interface {
    private int context;
    
    private float cameraPosX, cameraPosY, cameraPosZ, cameraCenterX, cameraCenterY, cameraCenterZ, cameraUpX, cameraUpY, cameraUpZ;
    private float cameraAngleX, cameraAngleY;
    private float cameraSensivity, cameraSpeed;
    private float cameraZoom;
    private Robot robot;
    
    private Database db;
    
    private Space space;
    private PShape skybox;
    private Button buttonMenu, buttonCredits, buttonPlay, buttonSingleplayer, buttonMultiplayer, buttonEditor;
    private Button[] buttons;
    
    private PImage[] buffer;
    private int xo, yo, swap, textureIndex, textureIndexMax;
    
    private String buttonCreditsContent;
    
    
    public Interface() {
        float w, h, x;
        
        this.context = 0;  
        
        this.db = new Database();
        
        this.cameraPosX = this.cameraPosY = this.cameraPosZ = 0;
        this.cameraCenterX = this.cameraCenterY = 0;
        this.cameraCenterZ = 1;
        this.cameraUpX = this.cameraUpZ = 0;
        this.cameraUpY = 1;
        this.cameraAngleX = this.cameraAngleY = 0;
        this.cameraSensivity = 2E1;
        this.cameraSpeed = 1E2;
        this.cameraZoom = 1;
        try {
            this.robot = new Robot();
        }
        catch(AWTException e) {}
        
        w = width / 8;
        h = height / 16;
        x = (width - w) / 2;
        this.buttonMenu = new Button(0, 0, w, h, "MAIN MENU");
        this.buttonPlay = new Button(x, height / 5 * 2.5 - h * 2, w, h, "PLAY");
        this.buttonCredits = new Button(x, height / 5 * 3.5 - h * 2, w, h, "CREDITS");
        w = width / 8;
        h = height / 8;
        x = width - w;
        this.buttonSingleplayer = new Button(x, height / 5 * 2 - h * 3 / 2, w, h, "SINGLEPLAYER");
        this.buttonMultiplayer = new Button(x, height / 5 * 3 - h * 3 / 2, w, h, "MULTIPLAYER");
        this.buttonEditor = new Button(x, height / 5 * 4 - h * 3 / 2, w, h, "EDITOR");
        
        this.xo = this.yo = this.swap = this.textureIndex = 0;
        this.textureIndexMax = this.db.getTextures().length;
        this.buffer = new PImage[2];
        this.buffer[1] = this.db.getTexture("skybox");
        this.buffer[1].resize(width, height);
        this.buffer[0] = this.db.getTexture(this.db.getTexturesOld()[this.textureIndex]);
        this.buffer[0].resize(width, height);
        this.textureIndex = (this.textureIndex + 1) % this.textureIndexMax;
        
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
        }
        else if(this.buttonPlay.isPressed()) {
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
        camera(this.cameraPosX, this.cameraPosY, this.cameraPosZ, this.cameraCenterX + this.cameraPosX, this.cameraCenterY + this.cameraPosY, this.cameraCenterZ + this.cameraPosZ, this.cameraUpX, this.cameraUpY, this.cameraUpZ);
        
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
        camera(this.cameraPosX, this.cameraPosY, this.cameraPosZ, this.cameraCenterX + this.cameraPosX, this.cameraCenterY + this.cameraPosY, this.cameraCenterZ + this.cameraPosZ, this.cameraUpX, this.cameraUpY, this.cameraUpZ);
        
        translate(this.cameraPosX, this.cameraPosY, this.cameraPosZ);
        shape(this.skybox, 0, 0);
        translate(-this.cameraPosX, -this.cameraPosY, -this.cameraPosZ);
        
        this.space.draw();
        
        endCamera();
        
        this.interfaceEditor();
    }
    
    private void chooseWorld() {
        this.drawBackground();
        
        this.buttonSingleplayer.draw();
        this.buttonMultiplayer.draw();
        this.buttonEditor.draw();
        this.buttonMenu.draw();
        
        if(this.buttonMenu.isPressed())
            this.context = 0;
        
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
                    this.space = new Space(button.content, this.db);
                    this.skybox = createShape(SPHERE, 6E3);
                    this.skybox.setTexture(this.space.getSkybox());
                    this.skybox.rotateY(HALF_PI);
                    
                    this.robot.mouseMove((int)(width / 2), (int)(height / 2));
                    
                    this.context = 2;
                    
                    break;
                }
            }
        }
        else if(this.buttonMultiplayer.isPressed()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.drawBackground();
                    
                    this.robot.mouseMove((int)(width / 2), (int)(height / 2));
                    
                    break;
                }
            }
        }
        else if(this.buttonEditor.isPressed()) {
            for(Button button : this.buttons) {
                if(button.isActive()) {
                    this.drawBackground();
                    
                    this.robot.mouseMove((int)(width / 2), (int)(height / 2));
                    
                    break;
                }
            }
        }
    }
    
    private void drawBackground() {
        camera();
        background(0);
        
        image(this.buffer[0], -width + this.xo, -height + this.yo);
        image(this.buffer[0], this.xo, -height + this.yo);
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
    }
    
    private void interfacePlay() {
        float w = width / 2, h = height / 2;
        
        this.cameraAngleX -= radians(mouseX - w) / this.cameraSensivity;
        this.cameraAngleY += radians(mouseY - h) / this.cameraSensivity;
        if(this.cameraAngleY <= -HALF_PI)
            this.cameraAngleY = -HALF_PI * 0.9999999;
        else if(this.cameraAngleY >= HALF_PI)
            this.cameraAngleY = HALF_PI * 0.9999999;
        
        this.cameraCenterX = cos(this.cameraAngleY) * sin(this.cameraAngleX);
        this.cameraCenterY = sin(this.cameraAngleY);
        this.cameraCenterZ = cos(this.cameraAngleY) * cos(this.cameraAngleX);
        
        this.robot.mouseMove((int)w, (int)h);
        
        PVector speed;
        
        if(keyPressed) {
            if(key != CODED) {
                switch(key) {
                    case 'w':
                        this.cameraPosX += this.cameraCenterX * this.cameraSpeed;
                        this.cameraPosY += this.cameraCenterY * this.cameraSpeed;
                        this.cameraPosZ += this.cameraCenterZ * this.cameraSpeed;
                        break;
                    case 's':
                        this.cameraPosX -= this.cameraCenterX * this.cameraSpeed;
                        this.cameraPosY -= this.cameraCenterY * this.cameraSpeed;
                        this.cameraPosZ -= this.cameraCenterZ * this.cameraSpeed;
                        break;
                    case 'd':
                        speed = new PVector(this.cameraCenterY * this.cameraUpZ - this.cameraCenterZ * this.cameraUpY, this.cameraCenterX * this.cameraUpZ - this.cameraCenterX * this.cameraUpZ, this.cameraCenterX * this.cameraUpY - this.cameraCenterY * this.cameraUpX);
                        speed.normalize();
                        this.cameraPosX += speed.x * this.cameraSpeed;
                        this.cameraPosY += speed.y * this.cameraSpeed;
                        this.cameraPosZ += speed.z * this.cameraSpeed;
                        break;
                    case 'a':
                        speed = new PVector(this.cameraCenterY * this.cameraUpZ - this.cameraCenterZ * this.cameraUpY, this.cameraCenterX * this.cameraUpZ - this.cameraCenterX * this.cameraUpZ, this.cameraCenterX * this.cameraUpY - this.cameraCenterY * this.cameraUpX);
                        speed.normalize();
                        this.cameraPosX -= speed.x * this.cameraSpeed;
                        this.cameraPosY -= speed.y * this.cameraSpeed;
                        this.cameraPosZ -= speed.z * this.cameraSpeed;
                        break;
                    case 'q':
                        
                        break;
                    case 'e':
                        
                        break;
                }
            }
        }
    }
    
    private void interfaceEditor() {
        
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
            return (mousePressed && mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
        }
        
        public void draw() {
            if(this.active)
                fill(255, 127);
            else
                fill(0, 127);
            stroke(255);
            strokeWeight(this.h / 10);
            rect(this.x, this.y, this.w, this.h, this.h / 2, this.h / 2, this.h / 2, this.h / 2);
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
    }
}
