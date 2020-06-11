// This file is part of SpacePioneers.
//
// SpacePioneers is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// SpacePioneers is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SpacePioneers.  If not, see <https://www.gnu.org/licenses/>.



/***
  "Space Pioneers"
  Space class
      Body class
  Malovanyi Denys Olehovych
***/



import java.util.Iterator;


class Space {
    private float gConst, detailMode, valuesKoefficient;
    private ArrayList<Body> bodies;
    private PImage skybox;
    private Database db;
    
    
    public Space(String name, Database db) {       
        bodies = new ArrayList<Body>();
        
        this.db = db;
        
        generate(name);
    }
    
    
    private void generate(String name) {
        XML database;
        XML[] parents;
        
        database = this.db.getXML(name);
        this.gConst = database.getFloat("gravitationalConstant");
        this.detailMode = database.getFloat("detailMode");
        this.skybox = this.db.getTexture(database.getString("skybox"));
        this.skybox.resize((int)(this.skybox.width * this.detailMode), 0);
        this.valuesKoefficient = database.getFloat("valuesKoefficient");
        
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
            posX = parents[i].getFloat("posX") * this.valuesKoefficient;
            posY = parents[i].getFloat("posY") * this.valuesKoefficient;
            posZ = parents[i].getFloat("posZ") * this.valuesKoefficient;
            velX = parents[i].getFloat("velX") * this.valuesKoefficient;
            velY = parents[i].getFloat("velY") * this.valuesKoefficient;
            velZ = parents[i].getFloat("velZ") * this.valuesKoefficient;
            angPosX = radians(new Float(parents[i].getFloat("angPosX")));
            angPosY = radians(parents[i].getFloat("angPosY"));
            angPosZ = radians(parents[i].getFloat("angPosZ"));
            angPeriod = parents[i].getFloat("angPeriod");
            mass = parents[i].getFloat("mass") * this.valuesKoefficient*this.valuesKoefficient;
            radius = parents[i].getFloat("radius") * this.valuesKoefficient;
            
            XML parent = parents[i].getParent();
            orbitMass = parent.getFloat("mass");
            orbitPosX = parent.getFloat("posX");
            orbitPosY = parent.getFloat("posY");
            orbitPosZ = parent.getFloat("posZ");
            orbitVelX = parent.getFloat("velX");
            orbitVelY = parent.getFloat("velY");
            orbitVelZ = parent.getFloat("velZ");
            
            semiMajorAxis = parents[i].getFloat("semiMajorAxis") * this.valuesKoefficient;
            eccentricity = parents[i].getFloat("eccentricity");
            argumentOfPeriapsis = radians(parents[i].getFloat("argumentOfPeriapsis"));
            longitudeOfAscendingNode = radians(parents[i].getFloat("longitudeOfAscendingNode"));
            inclination = radians(parents[i].getFloat("inclination"));
            meanAnomaly = radians(parents[i].getFloat("meanAnomaly"));
            
            name = parents[i].getString("name");
            texture = this.db.getTexture(name);
            texture.resize((int)(texture.width * this.detailMode), 0);
            
            Body body = new Body(posX, posY, posZ, mass, radius);
            
            body.setVel(velX, velY, velZ);
            
            body.setAnglePos(angPosX, angPosY, angPosZ);
            body.setAnglePeriod(angPeriod);
            body.setTexture(texture);
            
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
        
        float volume = (pow(obj1.getRadius(), 3) + pow(obj2.getRadius(), 3)) * 4/3.0 * PI;
        float radius = pow(volume * 3/4.0 / PI, 1/3.0);
        
        vector.add(vel1);
        vector.add(vel2);
        vector.div(mass1 + mass2);
        
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
    
    public void draw() {
        noStroke();
        fill(255);
        for (Body item : this.bodies) {
            PVector pos = item.getPos();
            float[] angle = item.getAnglePos();
            
            translate(pos.x, pos.y, pos.z);
            
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
    
    
    class Body {
        private PVector pos, vel;
        private float mass;
        private float radius;
        private float anglePosX, anglePosY, anglePosZ, angleVelY;
        private PImage texture;
        private boolean deleted;
        
        
        public Body(PVector pos, float mass, float radius) {
            this.pos = pos.copy();
            this.vel = new PVector(0, 0, 0);
            this.mass = mass;
            this.radius = radius;
            this.anglePosX = 0;
            this.anglePosY = 0;
            this.angleVelY = 0;
            this.deleted = false;
            this.texture = get();
        }
        
        public Body(float posX, float posY, float posZ, float mass, float radius) {
            this(new PVector(posX, posY, posZ), mass, radius);
        }
        
        
        public void setPos(PVector pos) {
            this.pos = pos.copy();
        }
        
        public void setPos(float posX, float posY, float posZ) {
            this.pos = new PVector(posX, posY, posZ);
        }
        
        public PVector getPos() {
            return this.pos.copy();
        }
        
        public void setVel(PVector vel) {
            this.vel = vel.copy();
        }
        
        public void setVel(float velX, float velY, float velZ) {
            this.vel = new PVector(velX, velY, velZ);
        }
        
        public PVector getVel() {
            return this.vel.copy();
        }
        
        public void setMass(float mass) {
            this.mass = mass;
        }
        
        public float getMass() {
            return this.mass;
        }
        
        public void setRadius(float radius) {
            this.radius = radius;
        }
        
        public float getRadius() {
            return this.radius;
        }
        
        public void setAnglePos(float anglePosX, float anglePosY, float anglePosZ) {
            this.anglePosX = anglePosX;
            this.anglePosY = anglePosY;
            this.anglePosZ = anglePosZ;
        }
        
        public void setAnglePos(float anglePosX, float anglePosZ) {
            this.setAnglePos(anglePosX, 0, anglePosZ);
        }
        
        public float[] getAnglePos() {
            return new float[]{this.anglePosX, this.anglePosY, this.anglePosZ};
        }
        
        public void setAnglePeriod(float anglePeriod) {
            this.angleVelY = TWO_PI / anglePeriod;
        }
        
        public float getAnglePeriod() {
            return TWO_PI / this.angleVelY;
        }
        
        public void setTexture(PImage texture) {
            this.texture = texture.copy();
        }
        
        public PImage getTexture() {
            return this.texture.copy();
        }
        
        public void accelerate(PVector vel) {
            this.vel.add(vel);
        }
        
        public void accelerateAng(float angleVel) {
            this.angleVelY += angleVel;
        }
        
        public void tick() {
            this.pos.add(this.vel);
            this.anglePosY = (this.anglePosY + this.angleVelY) % TWO_PI;
        }
        
        public void delete() {
            this.deleted = true;
        }
        
        public boolean isDeleted() {
            return this.deleted;
        }
    }
}
