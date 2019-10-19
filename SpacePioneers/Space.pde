import java.util.Iterator;

class Space {
  private float gConst;
  private ArrayList<Body> bodies;
  private ArrayList<Telescope> sattelites;
  

  public Space(float gConst) {
    this.gConst = gConst;
    this.generate();
  }

  public Space() {
    this(6.67E-11);
  }
  

  public void generate() {
    XML database;
    database = loadXML("bodies.xml");
    XML[] children = database.getChildren("body");

    for(int i = 0; i < children.length; i++)
    {
      float px = children[i].getFloat("posx");
      float py = children[i].getFloat("posy");
      float pz = children[i].getFloat("posz");
      float radius = children[i].getFloat("radius");
      float density = children[i].getFloat("density");
      float sx = children[i].getFloat("velx");
      float sy = children[i].getFloat("vely");
      float sz = children[i].getFloat("velz");
      
      Body body = new Body(px, py, pz, radius, density);
      body.setSpeed(sx, sy, sz);
      
      bodies.add(body);
    }
  }
  
  public void tick() {
    Iterator<Body> iter = bodies.iterator();

    while(iter.hasNext())
    {
      Body obj1 = iter.next();

      if(obj1.isDeleted())
        iter.remove();
      else
      {
        for(Body obj2 : this.bodies)
        {
          if(this.isCollide(obj1, obj2))
            this.collide(obj1, obj2);
          
          PVector force = this.gForce(obj1, obj2);
          obj1.accelerate(force.div(obj1.getMass()));
          obj2.accelerate(force.div(-obj2.getMass()));
        }

        for(Telescope obj2 : this.sattelites)
        {
          if(this.isCollide(obj1, obj2))
            this.collide(obj1, obj2);
          
          PVector force = this.gForce(obj2, obj1);
          obj2.accelerate(force.div(obj2.getMass()));
        }
      }
    }
  }
  
  public boolean isCollide(Body obj1, Body obj2) {
    PVector pos1 = obj1.getPos();
    PVector pos2 = obj2.getPos();
    
    float x = pos1.x - pos2.x;
    float y = pos1.y - pos2.y;
    float z = pos1.z - pos2.z;
    
    float distance = obj1.getRadius() + obj2.getRadius();
    
    if(x*x + y*y + z*z < distance*distance)
      return true;
    return false;
  }

  public boolean isCollide(Telescope obj1, Body obj2) {
    PVector pos1 = obj1.getPos();
    PVector pos2 = obj2.getPos();
    
    float x = pos1.x - pos2.x;
    float y = pos1.y - pos2.y;
    float z = pos1.z - pos2.z;
    
    float distance = obj1.getRadius() + obj2.getRadius();
    
    if(x*x + y*y + z*z < distance*distance)
      return true;
    return false;
  }

  public boolean isCollide(Body obj1, Telescope obj2) {
    return this.isCollide(obj2, obj1);
  }
  
  public void collide(Body obj1, Body obj2) {
    PVector vector = new PVector(0, 0, 0);
    float mass1 = obj1.getMass();
    float mass2 = obj2.getMass();
    PVector speed1 = obj1.getSpeed().mult(mass1);
    PVector speed2 = obj2.getSpeed().mult(mass2);

    float mass = mass1 + mass2;
    float volume = (pow(obj1.getRadius(), 3) + pow(obj2.getRadius(), 3)) * 4/3.0 * PI;
    float density = mass / volume;
    float radius = pow(volume * 3/4.0 / PI, 1/3.0);
    
    vector.add(speed1);
    vector.add(speed2);
    vector.div(mass);
    
    if(mass1 >= mass2)
    {
      obj1.setSpeed(vector);
      obj1.setRadius(radius);
      obj1.setDensity(density);
      obj2.delete();
    }
    else
    {
      obj2.setSpeed(vector);
      obj2.setRadius(radius);
      obj2.setDensity(density);
      obj1.delete();
    }
  }

  public void collide(Telescope obj1, Body obj2) {
    obj1.delete();
  }

  public void collide(Body obj1, Telescope obj2) {
    collide(obj2, obj1);
  }
  
  private PVector gForce(Body obj1, Body obj2) {
    float mass1 = obj1.getMass();
    float mass2 = obj2.getMass();
    PVector pos1 = obj1.getPos();
    PVector pos2 = obj2.getPos();
    
    float distance = sqrt(pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2) + pow(pos1.z - pos2.z, 2));
    PVector force = new PVector(pos2.x - pos1.x, pos2.y - pos1.y, pos2.z - pos1.z);
    float scalar = mass1 * mass2 / (distance*distance) * this.gConst;

    force.normalize();
    force.mult(scalar);
    
    return force;
  }

  private PVector gForce(Telescope obj1, Body obj2) {
    float mass1 = obj1.getMass();
    float mass2 = obj2.getMass();
    PVector pos1 = obj1.getPos();
    PVector pos2 = obj2.getPos();
    
    float distance = sqrt(pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2) + pow(pos1.z - pos2.z, 2));
    PVector force = new PVector(pos2.x - pos1.x, pos2.y - pos1.y, pos2.z - pos1.z);
    float scalar = mass1 * mass2 / (distance*distance) * this.gConst;

    force.normalize();
    force.mult(scalar);
    
    return force;
  }

  public void draw() {
    for(Body item : this.bodies)
    {
      PVector pos = item.getPos();
      PVector angle = item.getAngle();

      translate(pos.x, pos.y, pos.z);
      rotate(angle.x);
      rotateY(angle.y);
      rotateX(angle.z);
      sphere(item.getRadius());
      rotate(-angle.x);
      rotateY(-angle.y);
      rotateX(-angle.z);
      translate(-pos.x, -pos.y, -pos.z);
    }
    
    for(Telescope item : this.sattelites)
    {
      PVector pos = item.getPos();
      PVector angle = item.getAngle();

      translate(pos.x, pos.y, pos.z);
      rotate(angle.x);
      rotateY(angle.y);
      rotateX(angle.z);
      sphere(item.getRadius());
      rotate(-angle.x);
      rotateY(-angle.y);
      rotateX(-angle.z);
      translate(-pos.x, -pos.y, -pos.z);
    }
  }
}
