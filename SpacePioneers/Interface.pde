/***
  "Space Pioneers"
  Interface class
  Button class
  Malovanyi Denys Olehovych
***/

class Interface {
    private int context;
    
    private float cameraPosX, cameraPosY, cameraPosZ, cameraCenterX, cameraCenterY, cameraCenterZ, cameraUpX, cameraUpY, cameraUpZ;
    
    private Database db;
    
    private Space space;
    private PShape skybox;
    private Button menu, credits, play, editor, exit;
    
    private PImage buffer[];
    private int xo, yo, swap, textureIndex, textureIndexMax;
    
    String creditsContent;
    
    
    public Interface() {
        this.context = 0;  
        
        this.db = new Database();
        
        this.cameraPosX = this.cameraPosY = this.cameraPosZ = 0;
        this.cameraCenterX = this.cameraCenterY = 0;
        this.cameraCenterZ = 1;
        this.cameraUpX = this.cameraUpZ = 0;
        this.cameraUpY = 1;
        
        float w = width / 8, h = height / 16;
        this.menu = new Button(0, 0, w, h, "MAIN MENU");
        this.play = new Button((width - w) / 2, height / 5 * 2 - h * 2, w, h, "PLAY");
        this.editor = new Button((width - w) / 2, height / 5 * 3 - h * 2, w, h, "EDITOR");
        this.credits = new Button((width - w) / 2, height / 5 * 4 - h * 2, w, h, "CREDITS");
        
        this.xo = this.yo = this.swap = this.textureIndex = 0;
        this.textureIndexMax = this.db.getTextures().length;
        this.buffer = new PImage[2];
        this.buffer[1] = this.db.getTexture("skybox");
        this.buffer[1].resize(width, height);
        this.buffer[0] = this.db.getTexture(this.db.getTextures()[this.textureIndex]);
        this.buffer[0].resize(width, height);
        this.textureIndex = (this.textureIndex + 1) % this.textureIndexMax;
        
        this.creditsContent = "Space Pioneers\n\nCreated by Malovanyi Denys Olehovych\nFebruary 2020\n\nhttps://gitlab.com/maldenol/spacepioneers\nThis project is licensed under the GNU Affero General Public License v3.0.\n\nThanks for playing!";
    }
    
    public void draw() {
        switch(this.context) {
            case 0:// menu
                this.drawBackground();
                
                credits.draw();
                play.draw();
                editor.draw();
                
                if(this.credits.isPressed(mouseX, mouseY)) {
                    this.context = 1;
                }
                else if(this.play.isPressed(mouseX, mouseY)) {
                    noStroke();
                    this.space = new Space("test", this.db);
                    this.skybox = createShape(SPHERE, 6E3);
                    this.skybox.setTexture(this.space.getSkybox());
                    this.skybox.rotateY(HALF_PI);
                    
                    this.context = 2;
                }
                else if(this.editor.isPressed(mouseX, mouseY)) {
                    this.context = 3;
                }
                
                break;
            case 1:// credits
                this.drawBackground();
                
                this.menu.draw();
                
                if(this.menu.isPressed(mouseX, mouseY))
                    this.context = 0;
                
                float w = width / 10, h = height / 10;
                fill(0);
                stroke(255);
                strokeWeight(h / 10);
                rect(w, h, width - w * 2, height - h * 2, h / 2, h / 2, h / 2, h / 2);
                fill(255);
                stroke(0);
                strokeWeight(1);
                textSize(24);
                text(this.creditsContent, (width - textWidth(this.creditsContent)) / 2, height / 2 - h * 2);
                noFill();
                
                break;
            case 2:// play
                if(this.menu.isPressed(mouseX, mouseY))
                    this.context = 0;
                
                this.space.tick();
                
                background(0);
                
                this.menu.draw();
                
                beginCamera();
                camera(this.cameraPosX, this.cameraPosY, this.cameraPosZ, this.cameraCenterX, this.cameraCenterY, this.cameraCenterZ, this.cameraUpX, this.cameraUpY, this.cameraUpZ);
                
                translate(this.cameraPosX, this.cameraPosY, this.cameraPosZ);
                shape(this.skybox, 0, 0);
                translate(-this.cameraPosX, -this.cameraPosY, -this.cameraPosZ);
                
                this.space.draw();
                
                endCamera();
                
                break;
            case 3:// editor
                
                break;
            case 4:// choose world (play)
                
                break;
            case 6:// choose world (editor)
                
                break;
            default:
                this.context = 0;
                break;
        }
        
        stroke(255);
        strokeWeight(1);
        circle(mouseX, mouseY, 5);
    }
    
    private void drawBackground() {
        camera();
        
        image(this.buffer[0], -width + this.xo, -height + this.yo);
        image(this.buffer[0], this.xo, -height + this.yo);
        image(this.buffer[1], -width + this.xo, this.yo);
        image(this.buffer[1], this.xo, this.yo);
        
        this.xo = (this.xo + 1) % width;
        
        if(this.xo == 0 && this.swap == 0)
            this.swap = 1;
        
        if(this.swap == 1) {
            this.yo = (this.yo + height / 60) % height;
            
            if(this.yo == 0) {
                this.swap = 0;
                
                this.buffer[1] = this.buffer[0];
                this.buffer[0] = this.db.getTexture(this.db.getTextures()[this.textureIndex]);
                this.buffer[0].resize(width, height);
                this.textureIndex = (this.textureIndex + 1) % this.textureIndexMax;
            }
        }
    }
}

class Button {
    private float x, y, w, h;
    private String content;
    
    
    public Button(float x, float y, float w, float h, String content) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.content = content;
    }
    
    public boolean isPressed(float mx, float my) {
        return (mousePressed && mx >= x && mx <= x + w && my >= y && my <= y + h);
    }
    
    public void draw() {
        fill(0);
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
}
