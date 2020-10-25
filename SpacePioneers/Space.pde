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
    private Body telescope;

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
        float positionX, positionY, positionZ, velocityX, velocityY, velocityZ, angPositionX, angPositionY, angPositionZ, angPeriod, mass, radius;
        float orbitMass, orbitPositionX, orbitPositionY, orbitPositionZ, orbitVelocityX, orbitVelocityY, orbitVelocityZ;
        float semiMajorAxis, eccentricity, argumentOfPeriapsis, longitudeOfAscendingNode, inclination, meanAnomaly;
        String name;
        PImage texture;

        XML parent;
        float[][] result;

        for(int i = 0; i < parents.length; i++) {
            positionX = parents[i].getFloat("positionX") * this.valuesKoefficient;
            positionY = parents[i].getFloat("positionY") * this.valuesKoefficient;
            positionZ = parents[i].getFloat("positionZ") * this.valuesKoefficient;
            velocityX = parents[i].getFloat("velocityX") * this.valuesKoefficient;
            velocityY = parents[i].getFloat("velocityY") * this.valuesKoefficient;
            velocityZ = parents[i].getFloat("velocityZ") * this.valuesKoefficient;
            angPositionX = radians(new Float(parents[i].getFloat("angPositionX")));
            angPositionY = radians(parents[i].getFloat("angPositionY"));
            angPositionZ = radians(parents[i].getFloat("angPositionZ"));
            angPeriod = parents[i].getFloat("angPeriod");
            mass = parents[i].getFloat("mass") * this.valuesKoefficient * this.valuesKoefficient;
            radius = parents[i].getFloat("radius") * this.valuesKoefficient;

            parent = parents[i].getParent();
            orbitMass = parent.getFloat("mass");
            orbitPositionX = parent.getFloat("positionX");
            orbitPositionY = parent.getFloat("positionY");
            orbitPositionZ = parent.getFloat("positionZ");
            orbitVelocityX = parent.getFloat("velocityX");
            orbitVelocityY = parent.getFloat("velocityY");
            orbitVelocityZ = parent.getFloat("velocityZ");

            semiMajorAxis = parents[i].getFloat("semiMajorAxis") * this.valuesKoefficient;
            eccentricity = parents[i].getFloat("eccentricity");
            argumentOfPeriapsis = radians(parents[i].getFloat("argumentOfPeriapsis"));
            longitudeOfAscendingNode = radians(parents[i].getFloat("longitudeOfAscendingNode"));
            inclination = radians(parents[i].getFloat("inclination"));
            meanAnomaly = radians(parents[i].getFloat("meanAnomaly"));

            name = parents[i].getString("name");
            texture = this.db.getTexture(name);
            if(this.detailMode < 1) {
                texture.resize((int)(texture.width * this.detailMode), 0);
            }

            Body body = new Body(positionX, positionY, positionZ, mass, radius);

            body.setVelocity(velocityX, velocityY, velocityZ);

            body.setAnglePosition(angPositionX, angPositionY, angPositionZ);
            body.setAnglePeriod(angPeriod);
            body.setTexture(texture);

            if(orbitMass != 0.0) {
                result = convertKeplerianToCartesian(semiMajorAxis, eccentricity, argumentOfPeriapsis, longitudeOfAscendingNode, inclination, meanAnomaly, orbitMass);
                positionX = result[0][0];
                positionY = result[0][1];
                positionZ = result[0][2];
                velocityX = result[1][0];
                velocityY = result[1][1];
                velocityZ = result[1][2];

                positionX += orbitPositionX;
                positionY += orbitPositionY;
                positionZ += orbitPositionZ;

                body.setPosition(positionX, positionY, positionZ);

                parents[i].setFloat("positionX", positionX);
                parents[i].setFloat("positionY", positionY);
                parents[i].setFloat("positionZ", positionZ);

                velocityX += orbitVelocityX;
                velocityY += orbitVelocityY;
                velocityZ += orbitVelocityZ;

                body.setVelocity(velocityX, velocityY, velocityZ);

                parents[i].setFloat("velocityX", velocityX);
                parents[i].setFloat("velocityY", velocityY);
                parents[i].setFloat("velocityZ", velocityZ);
            }

            this.bodies.add(body);

            if(name.equals("telescope")) {
                this.telescope = body;
            }

            generateSpace(parents[i].getChildren("body"));
        }
    }

    public float[][] convertKeplerianToCartesian(float sma, float e, float ap, float lan, float i, float ma, float orbitMass) {
        float ea, ta, distance, prePositionX, prePositionY, preVelocityX, preVelocityY, positionX, positionY, positionZ, velocityX, velocityY, velocityZ;
        ea = ma;

        float diff = abs(ma - (ea - e * sin(ea))), lastDiff, lastEA;
        while(true) {
            lastEA = ea;
            lastDiff = diff;
            ea = ea - (ea - e * sin(ea) - ma) / (1.0 - e * cos(ea));
            diff = abs(ma - (ea - e * sin(ea)));

            if(diff == 0.0) {
                break;
            }

            if(diff > lastDiff) {
                ea = lastEA;
                break;
            }
        }

        ta = 2.0 * atan2(sqrt(1.0 + e) * sin(ea / 2.0), sqrt(1.0 - e) * cos(ea / 2.0));

        distance = sma * (1.0 - e * cos(ea));

        prePositionX = distance * cos(ta);
        prePositionY = distance * sin(ta);
        preVelocityX = sqrt(this.gConst * sma * orbitMass) / distance * -sin(ea);
        preVelocityY = sqrt(this.gConst * sma * orbitMass) / distance * sqrt(1.0 - e * e) * cos(ea);

        positionX = prePositionX * (cos(ap) * cos(lan) - sin(ap) * cos(i) * sin(lan)) - prePositionY * (sin(ap) * cos(lan) + cos(ap) * cos(i) * sin(lan));
        positionY = prePositionX * (cos(ap) * sin(lan) + sin(ap) * cos(i) * cos(lan)) - prePositionY * (sin(ap) * sin(lan) - cos(ap) * cos(i) * cos(lan));
        positionZ = prePositionX * (sin(ap) * sin(i)) + prePositionY * (cos(ap) * sin(i));
        velocityX = preVelocityX * (cos(ap) * cos(lan) - sin(ap) * cos(i) * sin(lan)) - preVelocityY * (sin(ap) * cos(lan) + cos(ap) * cos(i) * sin(lan));
        velocityY = preVelocityX * (cos(ap) * sin(lan) + sin(ap) * cos(i) * cos(lan)) - preVelocityY * (sin(ap) * sin(lan) - cos(ap) * cos(i) * cos(lan));
        velocityZ = preVelocityX * (sin(ap) * sin(i)) + preVelocityY * (cos(ap) * sin(i));

        return new float[][]{{positionX, positionY, positionZ}, {velocityX, velocityY, velocityZ}};
    }

    public void tick() {
        PVector force;
        Iterator<Body> iter = bodies.iterator();
        while(iter.hasNext()) {
            Body obj1 = iter.next();

            if(obj1.isDeleted()) {
                iter.remove();
            } else {
                for(Body obj2 : this.bodies) {
                    if(obj1 == obj2) {
                        continue;
                    }

                    if(this.isCollide(obj1, obj2)) {
                        this.collide(obj1, obj2);
                    }

                    force = this.gForce(obj1, obj2);
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
        PVector position1 = obj1.getPosition();
        PVector position2 = obj2.getPosition();

        float x = position1.x - position2.x;
        float y = position1.y - position2.y;
        float z = position1.z - position2.z;

        float distance = obj1.getRadius() + obj2.getRadius();

        if(x * x + y * y + z * z < distance * distance) {
            return true;
        }
        return false;
    }

    public void collide(Body obj1, Body obj2) {
        PVector vector = new PVector(0, 0, 0);
        float mass1 = obj1.getMass();
        float mass2 = obj2.getMass();
        PVector velocity1 = obj1.getVelocity().mult(mass1);
        PVector velocity2 = obj2.getVelocity().mult(mass2);

        float volume = (pow(obj1.getRadius(), 3) + pow(obj2.getRadius(), 3)) * 4.0 / 3.0 * PI;
        float radius = pow(volume * 3.0 / 4.0 / PI, 1.0 / 3.0);

        vector.add(velocity1);
        vector.add(velocity2);
        vector.div(mass1 + mass2);

        if(mass1 >= mass2) {
            obj1.setVelocity(vector);
            obj1.setRadius(radius);
            obj2.delete();
        } else {
            obj2.setVelocity(vector);
            obj2.setRadius(radius);
            obj1.delete();
        }
    }

    private PVector gForce(Body obj1, Body obj2) {
        float mass1 = obj1.getMass();
        float mass2 = obj2.getMass();
        PVector position1 = obj1.getPosition();
        PVector position2 = obj2.getPosition();

        float squaredDistance = pow(position1.x - position2.x, 2) + pow(position1.y - position2.y, 2) + pow(position1.z - position2.z, 2);
        PVector force = new PVector(position2.x - position1.x, position2.y - position1.y, position2.z - position1.z);
        float scalar = mass1 * mass2 / squaredDistance * this.gConst;

        force.normalize();
        force.mult(scalar);

        return force;
    }

    public void draw() {
        PVector position;
        float[] angle;
        PShape pshape;

        noStroke();
        fill(255);
        for(Body item : this.bodies) {
            position = item.getPosition();
            angle = item.getAnglePosition();

            translate(position.x, position.y, position.z);

            pshape = createShape(SPHERE, item.getRadius());
            pshape.setTexture(item.getTexture());
            pshape.rotateY(angle[1]);
            pshape.rotateX(angle[0]);
            pshape.rotateY(angle[2]);
            shape(pshape, 0, 0);

            translate(-position.x, -position.y, -position.z);
        }
    }

    public PImage getSkybox() {
        return this.skybox.copy();
    }

    public Body getTelescope() {
        return this.telescope;
    }


    public class Body {
        private PVector position, velocity;
        private float mass;
        private float radius;
        private float anglePositionX, anglePositionY, anglePositionZ, angleVelocityY;
        private PImage texture;
        private boolean deleted;


        public Body(float positionX, float positionY, float positionZ, float mass, float radius) {
            this.position = new PVector(positionX, positionY, positionZ);
            this.velocity = new PVector(0, 0, 0);
            this.mass = mass;
            this.radius = radius;
            this.anglePositionX = 0;
            this.anglePositionY = 0;
            this.angleVelocityY = 0;
            this.deleted = false;
            this.texture = get();
        }


        public void setPosition(PVector position) {
            this.position = position.copy();
        }

        public void setPosition(float positionX, float positionY, float positionZ) {
            this.position = new PVector(positionX, positionY, positionZ);
        }

        public PVector getPosition() {
            return this.position.copy();
        }

        public void setVelocity(PVector velocity) {
            this.velocity = velocity.copy();
        }

        public void setVelocity(float velocityX, float velocityY, float velocityZ) {
            this.velocity = new PVector(velocityX, velocityY, velocityZ);
        }

        public PVector getVelocity() {
            return this.velocity.copy();
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

        public void setAnglePosition(float anglePositionX, float anglePositionY, float anglePositionZ) {
            this.anglePositionX = anglePositionX;
            this.anglePositionY = anglePositionY;
            this.anglePositionZ = anglePositionZ;
        }

        public void setAnglePosition(float anglePositionX, float anglePositionZ) {
            this.setAnglePosition(anglePositionX, 0, anglePositionZ);
        }

        public float[] getAnglePosition() {
            return new float[]{this.anglePositionX, this.anglePositionY, this.anglePositionZ};
        }

        public void setAnglePeriod(float anglePeriod) {
            this.angleVelocityY = TWO_PI / anglePeriod;
        }

        public float getAnglePeriod() {
            return TWO_PI / this.angleVelocityY;
        }

        public void setTexture(PImage texture) {
            this.texture = texture.copy();
        }

        public PImage getTexture() {
            return this.texture.copy();
        }

        public void accelerate(PVector velocity) {
            this.velocity.add(velocity);
        }

        public void accelerateAng(float angleVelocity) {
            this.angleVelocityY += angleVelocity;
        }

        public void tick() {
            this.position.add(this.velocity);
            this.anglePositionY = (this.anglePositionY + this.angleVelocityY) % TWO_PI;
        }

        public void delete() {
            this.deleted = true;
        }

        public boolean isDeleted() {
            return this.deleted;
        }
    }
}
