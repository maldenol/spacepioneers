import java.util.Iterator;


class Space {
    private float gConst, detailMode;
    private ArrayList<Body> bodies;
    private PImage skybox;
    
    
    public Space(String name) {       
        bodies = new ArrayList<Body>();
        
        generate(name);
    }
    
    
    private void generate(String name) {
        XML database;
        XML[] parents;
        
        database = loadXML("data/" + name + ".xml");
        this.gConst = database.getFloat("gravitationalConstant");
        this.detailMode = database.getFloat("detailMode");
        this.skybox = loadImage("data/textures/skybox.jpg");
        this.skybox.resize((int)(this.skybox.width * this.detailMode), 0);
        
        parents = database.getChildren("body");
        parents = parents[0].getChildren("body");
        
        generateSpace(parents);
    }
    
    private void generateSpace(XML[] parents) {
        float posX, posY, posZ, velX, velY, velZ, angPosX, angPosY, angPosZ, angPeriod, mass, radius;
        float orbitMass, orbitPosX, orbitPosY, orbitPosZ, orbitVelX, orbitVelY, orbitVelZ;
        float semiMajorAxis, eccentricity, argumentOfPeriapsis, longitudeOfAscendingNode, inclination, meanAnomaly;
        String name;
        PImage texture;
        
        for (int i = 0; i < parents.length; i++) {
            posX = parents[i].getFloat("posX");
            posY = parents[i].getFloat("posY");
            posZ = parents[i].getFloat("posZ");
            velX = parents[i].getFloat("velX");
            velY = parents[i].getFloat("velY");
            velZ = parents[i].getFloat("velZ");
            angPosX = radians(new Float(parents[i].getFloat("angPosX")));
            angPosY = radians(parents[i].getFloat("angPosY"));
            angPosZ = radians(parents[i].getFloat("angPosZ"));
            angPeriod = parents[i].getFloat("angPeriod");
            mass = parents[i].getFloat("mass");
            radius = parents[i].getFloat("radius");
            
            XML parent = parents[i].getParent();
            orbitMass = parent.getFloat("mass");
            orbitPosX = parent.getFloat("posX");
            orbitPosY = parent.getFloat("posY");
            orbitPosZ = parent.getFloat("posZ");
            orbitVelX = parent.getFloat("velX");
            orbitVelY = parent.getFloat("velY");
            orbitVelZ = parent.getFloat("velZ");
            
            semiMajorAxis = parents[i].getFloat("semiMajorAxis");
            eccentricity = parents[i].getFloat("eccentricity");
            argumentOfPeriapsis = radians(parents[i].getFloat("argumentOfPeriapsis"));
            longitudeOfAscendingNode = radians(parents[i].getFloat("longitudeOfAscendingNode"));
            inclination = radians(parents[i].getFloat("inclination"));
            meanAnomaly = radians(parents[i].getFloat("meanAnomaly"));
            
            name = parents[i].getString("name");
            texture = loadImage("data/textures/" + name + ".jpg");
            texture.resize((int)(texture.width * this.detailMode), 0);
            
            Body body = new Body(posX, posY, posZ, mass, radius);
            
            body.setAnglePos(angPosX, angPosY, angPosZ);
            body.setAnglePeriod(angPeriod);
            body.setTexture(texture);
            
            body.setPos(posX, posY, posZ);
            body.setVel(velX, velY, velZ);
            
            if(orbitMass != 0.0) {
                float[][] result = convertKeplerianToCartesian(semiMajorAxis, eccentricity, argumentOfPeriapsis, longitudeOfAscendingNode, inclination, meanAnomaly, orbitMass);
                posX = result[0][0];
                posY = result[0][1];
                posZ = result[0][2];
                velX = result[1][0];
                velY = result[1][1];
                velZ = result[1][2];
                
                posX += orbitPosX;
                posY += orbitPosY;
                posZ += orbitPosZ;
                
                body.setPos(posX, posY, posZ);
                
                parents[i].setFloat("posX", posX);
                parents[i].setFloat("posY", posY);
                parents[i].setFloat("posZ", posZ);
                
                velX += orbitVelX;
                velY += orbitVelY;
                velZ += orbitVelZ;
                
                body.setVel(velX, velY, velZ);
                
                parents[i].setFloat("velX", velX);
                parents[i].setFloat("velY", velY);
                parents[i].setFloat("velZ", velZ);
            }
            
            this.bodies.add(body);
            
            generateSpace(parents[i].getChildren("body"));
        }
    }
    
    public float[][] convertKeplerianToCartesian(float sma, float e, float ap, float lan, float i, float ma, float orbitMass) {
        float ea, ta, distance, prePosX, prePosY, preVelX, preVelY, posX, posY, posZ, velX, velY, velZ;
        ea = ma;
        
        float diff = abs(ma - (ea - e * sin(ea))), lastDiff, lastEA;
        while(true) {
            lastEA = ea;
            lastDiff = diff;
            ea = ea - (ea - e * sin(ea) - ma) / (1 - e * cos(ea));
            diff = abs(ma - (ea - e * sin(ea)));
            
            if(diff == 0.0)
                break;
            
            if(diff > lastDiff) {
                ea = lastEA;
                break;
            }
        }
        
        ta = 2 * atan2(sqrt(1 + e) * sin(ea / 2), sqrt(1 - e) * cos(ea / 2));
        
        distance = sma * (1 - e * cos(ea));
        
        prePosX = distance * cos(ta);
        prePosY = distance * sin(ta);
        preVelX = sqrt(this.gConst * sma * orbitMass) / distance * -sin(ea);
        preVelY = sqrt(this.gConst * sma * orbitMass) / distance * sqrt(1 - e*e) * cos(ea);
        
        posX = prePosX * (cos(ap) * cos(lan) - sin(ap) * cos(i) * sin(lan)) - prePosY * (sin(ap) * cos(lan) + cos(ap) * cos(i) * sin(lan));
        posY = prePosX * (cos(ap) * sin(lan) + sin(ap) * cos(i) * cos(lan)) - prePosY * (sin(ap) * sin(lan) - cos(ap) * cos(i) * cos(lan));
        posZ = prePosX * (sin(ap) * sin(i)) + prePosY * (cos(ap) * sin(i));
        velX = preVelX * (cos(ap) * cos(lan) - sin(ap) * cos(i) * sin(lan)) - preVelY * (sin(ap) * cos(lan) + cos(ap) * cos(i) * sin(lan));
        velY = preVelX * (cos(ap) * sin(lan) + sin(ap) * cos(i) * cos(lan)) - preVelY * (sin(ap) * sin(lan) - cos(ap) * cos(i) * cos(lan));
        velZ = preVelX * (sin(ap) * sin(i)) + preVelY * (cos(ap) * sin(i));
        
        return new float[][]{{posX, posY, posZ}, {velX, velY, velZ}};
    }
    
    public void tick() {
        Iterator<Body> iter = bodies.iterator();
        
        while (iter.hasNext()) {
            Body obj1 = iter.next();
            
            if (obj1.isDeleted())
                iter.remove();
            else {
                for (Body obj2 : this.bodies) {
                    if (obj1 == obj2)
                        continue;
                    
                    if (this.isCollide(obj1, obj2))
                        this.collide(obj1, obj2);
                    
                    PVector force = this.gForce(obj1, obj2);
                    obj1.accelerate(force.div(obj1.getMass()));
                    obj2.accelerate(force.div(obj2.getMass()));
                }
                
                obj1.tick();
            }
        }
    }
    
    public void addBody(Body body) {
        this.bodies.add(body);
    }
    
    public boolean isCollide(Body obj1, Body obj2) {
        PVector pos1 = obj1.getPos();
        PVector pos2 = obj2.getPos();
        
        float x = pos1.x - pos2.x;
        float y = pos1.y - pos2.y;
        float z = pos1.z - pos2.z;
        
        float distance = obj1.getRadius() + obj2.getRadius();
        
        if (x*x + y*y + z*z < distance*distance)
            return true;
        return false;
    }
    
    public void collide(Body obj1, Body obj2) {
        PVector vector = new PVector(0, 0, 0);
        float mass1 = obj1.getMass();
        float mass2 = obj2.getMass();
        PVector vel1 = obj1.getVel().mult(mass1);
        PVector vel2 = obj2.getVel().mult(mass2);
        
        float mass = mass1 + mass2;
        float volume = (pow(obj1.getRadius(), 3) + pow(obj2.getRadius(), 3)) * 4/3.0 * PI;
        float radius = pow(volume * 3/4.0 / PI, 1/3.0);
        
        vector.add(vel1);
        vector.add(vel2);
        vector.div(mass);
        
        if (mass1 >= mass2) {
            obj1.setVel(vector);
            obj1.setRadius(radius);
            obj2.delete();
        } else {
            obj2.setVel(vector);
            obj2.setRadius(radius);
            obj1.delete();
        }
    }
    
    private PVector gForce(Body obj1, Body obj2) {
        float mass1 = obj1.getMass();
        float mass2 = obj2.getMass();
        PVector pos1 = obj1.getPos();
        PVector pos2 = obj2.getPos();
        
        float distanceSquared = pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2) + pow(pos1.z - pos2.z, 2);
        PVector force = new PVector(pos2.x - pos1.x, pos2.y - pos1.y, pos2.z - pos1.z);
        float scalar = mass1 * mass2 / distanceSquared * this.gConst;
        
        force.normalize();
        force.mult(scalar);
        
        return force;
    }
    
    public void show() {
        for (Body item : this.bodies) {
            PVector pos = item.getPos();
            float[] angle = item.getAnglePos();
            
            translate(pos.x, pos.y, pos.z);
            
            noStroke();
            PShape pshape = createShape(SPHERE, item.getRadius());
            pshape.setTexture(item.getTexture());
            pshape.rotateY(angle[1]);
            pshape.rotateX(angle[0]);
            pshape.rotateY(angle[2]);
            shape(pshape, 0, 0);
            
            translate(-pos.x, -pos.y, -pos.z);
        }
    }
    
    public PImage getSkybox() {
        return this.skybox.copy();
    }
}
