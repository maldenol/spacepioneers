class Telescope
{
  private PVector pos;
  private PVector speed;
  private float mass;
  private float w, h, l, r;
  
  public Telescope(PVector pos, PVector speed, float mass, float w, float h, float l)
  {
    this.pos = pos.copy();
    this.speed = speed.copy();
    this.mass = mass;
    this.w = w;
    this.h = h;
    this.l = l;
    this.updateRadius();
  }
  
  public Telescope(float px, float py, float pz, float sx, float sy, float sz, float mass, float w, float h, float l)
  {
    this(new PVector(px, py, pz), new PVector(sx, sy, sz), mass, w, h, l);
  }
  
  public void setMass(float value)
  {
    this.mass = value;
  }
  
  public float getMass()
  {
    return this.mass;
  }
  
  public void setPos(PVector value)
  {
    this.pos = value.copy();
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
  
  public void setPos(float x, float y, float z)
  {
    this.pos = new PVector(x, y, z);
  }
  
  public void setSize(float w, float h, float l)
  {
    this.w = w;
    this.h = h;
    this.l = l;
    this.updateRadius();
  }
  
  public float getWidth()
  {
    return this.w;
  }
  
  public float getHeight()
  {
    return this.h;
  }
  
  public float getLength()
  {
    return this.l;
  }
  
  public float getRadius()
  {
    return this.r;
  }
  
  public void updateRadius()
  {
    this.r = sqrt(w*w + h*h + l*l) / 2.0;
  }
  
  public void setWidth(float value)
  {
    this.w = value;
    this.updateRadius();
  }
  
  public void setHeight(float value)
  {
    this.h = value;
    this.updateRadius();
  }
  
  public void setLength(float value)
  {
    this.l = value;
    this.updateRadius();
  }
};
