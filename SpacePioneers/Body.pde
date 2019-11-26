class Body {
    private PVector pos, speed;
    private float mass;
    private float radius;
    private float density;
    private PVector anglePos, angleSpeed;
    private PImage texture;
    private boolean deleted;
  
  
    public Body(PVector pos, float radius, float density) {
        this.pos = pos.copy();
        this.speed = new PVector(0, 0, 0);
        this.radius = radius;
        this.density = density;
        this.updateMass();
        this.anglePos = new PVector(0, 0, 0);
        this.angleSpeed = new PVector(0, 0, 0);
        this.deleted = false;
        this.texture = get();
    }
  
    public Body(float x, float y, float z, float radius, float density) {
        this(new PVector(x, y, z), radius, density);
    }
  
  
    public void setPos(PVector value) {
        this.pos = value.copy();
    }
  
    public void setPos(float x, float y, float z) {
        this.pos = new PVector(x, y, z);
    }
  
    public PVector getPos() {
        return this.pos.copy();
    }
  
    public void setSpeed(PVector value) {
        this.speed = value.copy();
    }
  
    public void setSpeed(float x, float y, float z) {
        this.speed = new PVector(x, y, z);
    }
  
    public PVector getSpeed() {
        return this.speed.copy();
    }
  
    public float updateMass() {
        this.mass = this.density * PI * this.radius*this.radius*this.radius * 4/3.0;
        return mass;
    }
  
    public float getMass() {
        return this.mass;
    }
  
    public void setRadius(float value) {
        this.radius = value;
        this.updateMass();
    }
  
    public float getRadius() {
        return this.radius;
    }
  
    public void setDensity(float value) {
        this.density = value;
        this.updateMass();
    }
  
    public float getDensity() {
        return this.density;
    }
  
    public void setAnglePos(PVector value) {
        this.anglePos = value.copy();
    }
  
    public void setAnglePos(float x, float y, float z) {
        this.anglePos = new PVector(x, y, z);
    }
  
    public PVector getAnglePos() {
        return this.anglePos.copy();
    }
  
    public void setAngleSpeed(PVector value) {
        this.angleSpeed = value.copy();
    }
  
    public void setAngleSpeed(float x, float y, float z) {
        this.angleSpeed = new PVector(x, y, z);
    }
  
    public PVector getAngleSpeed() {
        return this.angleSpeed.copy();
    }
  
    public void setTexture(PImage value) {
        this.texture = value.copy();
    }
  
    public PImage getTexture() {
        return this.texture.copy();
    }
  
    public void accelerate(PVector value) {
        this.speed.add(value);
    }
  
    public void accelerateAngle(PVector value) {
        this.angleSpeed.add(value);
    }
  
    public void tick() {
        this.pos.add(this.speed);
        this.anglePos.add(this.angleSpeed);
    }
  
    public void delete() {
        this.deleted = true;
    }
  
    public boolean isDeleted() {
        return this.deleted;
    }
};
