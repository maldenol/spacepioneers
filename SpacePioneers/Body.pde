class Body
{
  private PVector pos;
  private PVector speed;
  private float mass;
  private float radius;
  private float density;
  private PVector angle;
  private PVector angleSpeed;
  
  public Body(PVector pos, float radius, float density)
  {
    this.pos = pos.copy();
    this.speed = new PVector(0, 0, 0);
    this.radius = radius;
    this.density = density;
    this.updateMass();
    this.angle = new PVector(0, 0, 0);
    this.angleSpeed = new PVector(0, 0, 0);
  }
  
  public Body(float x, float y, float z, float radius, float density)
  {
    this(new PVector(x, y, z), radius, density);
  }
  
  public void setPos(PVector value)
  {
    this.pos = value.copy();
  }
  
  public void setPos(float x, float y, float z)
  {
    this.pos = new PVector(x, y, z);
  }
  
  public PVector getPos()
  {
    return this.pos.copy();
  }
  
  public void setSpeed(PVector value)
  {
    this.speed = value.copy();
  }
  
  public void setSpeed(float x, float y, float z)
  {
    this.speed = new PVector(x, y, z);
  }
  
  public PVector getSpeed()
  {
    return this.speed.copy();
  }
  
  public float updateMass()
  {
    this.mass = this.density * PI * this.radius*this.radius*this.radius * 4/3;
    return mass;
  }
  
  public float getMass()
  {
    return this.mass;
  }
  
  public void setRadius(float value)
  {
    this.radius = value;
    this.updateMass();
  }
  
  public float getRadius()
  {
    return this.radius;
  }
  
  public void setDensity(float value)
  {
    this.density = value;
    this.updateMass();
  }
  
  public float getDensity()
  {
    return this.density;
  }
  
  public void setAngle(PVector value)
  {
    this.angle = value.copy();
  }
  
  public void setAngle(float x, float y, float z)
  {
    this.angle = new PVector(x, y, z);
  }
  
  public PVector getAngle()
  {
    return this.angle.copy();
  }
  
  public void setAngleSpeed(PVector value)
  {
    this.angleSpeed = value.copy();
  }
  
  public void setAngleSpeed(float x, float y, float z)
  {
    this.angleSpeed = new PVector(x, y, z);
  }
  
  public PVector getAngleSpeed()
  {
    return this.angleSpeed.copy();
  }
};
