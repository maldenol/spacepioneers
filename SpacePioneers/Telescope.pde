class Telescope {
  private PVector pos;
  private PVector speed;
  private float mass;
  private float w, h, l, r;
  private PVector angle;
  private PVector angleSpeed;
  private boolean deleted;
  

  public Telescope(PVector pos, float mass, float w, float h, float l) {
    this.pos = pos.copy();
    this.speed = new PVector(0, 0, 0);
    this.mass = mass;
    this.w = w;
    this.h = h;
    this.l = l;
    this.updateRadius();
    this.deleted = false;
  }
  
  public Telescope(float px, float py, float pz, float mass, float w, float h, float l) {
    this(new PVector(px, py, pz), mass, w, h, l);
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
  
  public void setMass(float value) {
    this.mass = value;
  }
  
  public float getMass() {
    return this.mass;
  }
  
  public void setSize(float w, float h, float l) {
    this.w = w;
    this.h = h;
    this.l = l;
    this.updateRadius();
  }
  
  public void setWidth(float value) {
    this.w = value;
    this.updateRadius();
  }
  
  public float getWidth() {
    return this.w;
  }
  
  public void setHeight(float value) {
    this.h = value;
    this.updateRadius();
  }
  
  public float getHeight() {
    return this.h;
  }
  
  public void setLength(float value) {
    this.l = value;
    this.updateRadius();
  }
  
  public float getLength() {
    return this.l;
  }
  
  public void updateRadius() {
    this.r = sqrt(this.w*this.w + this.h*this.h + this.l*this.l) / 2.0;
  }
  
  public float getRadius() {
    return this.r;
  }
  
  public void setAngle(PVector value) {
    this.angle = value.copy();
  }
  
  public void setAngle(float x, float y, float z) {
    this.angle = new PVector(x, y, z);
  }
  
  public PVector getAngle() {
    return this.angle.copy();
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
  
  public void accelerate(PVector value) {
    this.speed.add(value);
  }
  
  public void accelerateAngle(PVector value) {
    this.angleSpeed.add(value);
  }

  public void delete() {
    this.deleted = true;
  }

  public boolean isDeleted() {
    return this.deleted;
  }
};
