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
      Body class extends Physics.SphericalBody
  Malovanyi Denys Olehovych
***/



import java.util.Iterator;


class Space {
    private float gConst, detailMode, valuesKoefficient, backlight;
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
        this.backlight = database.getFloat("backlight");

        parents = database.getChildren("body");
        parents = parents[0].getChildren("body");

        generateSpace(parents);
    }

    private void generateSpace(XML[] parents) {
        float positionX, positionY, positionZ, velocityX, velocityY, velocityZ, angPositionX, angPositionY, angPositionZ, angPeriod, mass, radius;
        int bright;
        float orbitMass, orbitPositionX, orbitPositionY, orbitPositionZ, orbitVelocityX, orbitVelocityY, orbitVelocityZ;
        float semiMajorAxis, eccentricity, argumentOfPeriapsis, longitudeOfAscendingNode, inclination, meanAnomaly;
        String name;
        PImage texture;

        XML parent;
        float[][] result;

        for(int i = 0; i < parents.length; i++) {
            positionX = parents[i].getFloat("positionX");
            positionY = parents[i].getFloat("positionY");
            positionZ = parents[i].getFloat("positionZ");
            velocityX = parents[i].getFloat("velocityX");
            velocityY = parents[i].getFloat("velocityY");
            velocityZ = parents[i].getFloat("velocityZ");
            angPositionX = radians(new Float(parents[i].getFloat("angPositionX")));
            angPositionY = radians(parents[i].getFloat("angPositionY"));
            angPositionZ = radians(parents[i].getFloat("angPositionZ"));
            angPeriod = parents[i].getFloat("angPeriod");
            mass = parents[i].getFloat("mass") * this.valuesKoefficient;
            radius = parents[i].getFloat("radius") * this.valuesKoefficient;
            bright = parents[i].getInt("bright");

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
            body.setBright(bright == 1);
            body.setTexture(texture);

            if(orbitMass == 0.0) {
                positionX *= this.valuesKoefficient;
                positionY *= this.valuesKoefficient;
                positionZ *= this.valuesKoefficient;
                velocityX *= this.valuesKoefficient;
                velocityY *= this.valuesKoefficient;
                velocityZ *= this.valuesKoefficient;
            } else {
                result = Mathematics.convertKeplerianToCartesian(this.gConst, semiMajorAxis, eccentricity, argumentOfPeriapsis, longitudeOfAscendingNode, inclination, meanAnomaly, orbitMass);
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

    public void tick() {
        float[] force;
        float mass1, mass2;

        Iterator<Body> iter = bodies.iterator();
        while(iter.hasNext()) {
            Body body1 = iter.next();

            if(body1.isDeleted()) {
                iter.remove();
            } else {
                for(Body body2 : this.bodies) {
                    if(body1 == body2) {
                        continue;
                    }

                    if(this.isCollide(body1, body2)) {
                        this.collide(body1, body2);
                    } else {
                        force = this.gForce(body1, body2);
                        mass1 = body1.getMass();
                        mass2 = body2.getMass();
                        body1.accelerate(force[0] / mass1, force[1] / mass1, force[2] / mass1);
                        body2.accelerate(-force[0] / mass2, -force[1] / mass2, -force[2] / mass2);
                    }
                }

                body1.tick();
            }
        }
    }

    public void addBody(Body body) {
        this.bodies.add(body);
    }

    public boolean isCollide(Body obj1, Body obj2) {
        float[] position1 = obj1.getPosition(), position2 = obj2.getPosition();

        float x = position1[0] - position2[0];
        float y = position1[1] - position2[1];
        float z = position1[2] - position2[2];

        float distance = obj1.getRadius() + obj2.getRadius();

        if(x * x + y * y + z * z < distance * distance) {
            return true;
        }
        return false;
    }

    public void collide(Body obj1, Body obj2) {
        float[] vector = new float[]{0.0, 0.0, 0.0};
        float mass1 = obj1.getMass(), mass2 = obj2.getMass();
        float[] vector1 = obj1.getVelocity(), vector2 = obj2.getVelocity();
        vector1[0] *= mass1;
        vector1[1] *= mass1;
        vector1[2] *= mass1;
        vector2[0] *= mass2;
        vector2[1] *= mass2;
        vector2[2] *= mass2;

        float volume = (pow(obj1.getRadius(), 3) + pow(obj2.getRadius(), 3)) * 4.0 / 3.0 * PI;
        float radius = pow(volume * 3.0 / 4.0 / PI, 1.0 / 3.0);
        float mass = mass1 + mass2;

        vector[0] = (vector1[0] + vector2[0]) / mass;
        vector[1] = (vector1[1] + vector2[1]) / mass;
        vector[2] = (vector1[2] + vector2[2]) / mass;

        if(mass1 >= mass2) {
            obj1.setVelocity(vector[0], vector[1], vector[2]);
            obj1.setRadius(radius);
            obj2.delete();
        } else {
            obj2.setVelocity(vector[0], vector[1], vector[2]);
            obj2.setRadius(radius);
            obj1.delete();
        }
    }

    private float[] gForce(Body obj1, Body obj2) {
        float mass1 = obj1.getMass();
        float mass2 = obj2.getMass();
        float[] position1 = obj1.getPosition();
        float[] position2 = obj2.getPosition();

        float squaredDistance = pow(position1[0] - position2[0], 2) + pow(position1[1] - position2[1], 2) + pow(position1[2] - position2[2], 2);
        float[] force = new float[]{position2[0] - position1[0], position2[1] - position1[1], position2[2] - position1[2]};
        float scalar = mass1 * mass2 / squaredDistance * this.gConst;
        float vectorLength = sqrt(force[0] * force[0] + force[1] * force[1] + force[2] * force[2]);

        force[0] /= vectorLength;
        force[1] /= vectorLength;
        force[2] /= vectorLength;
        force[0] *= scalar;
        force[1] *= scalar;
        force[2] *= scalar;

        return force;
    }

    public void draw() {
        float[] position;
        float[] orientation;
        float[] angle;
        ArrayList<Float[]> lightsPositions = new ArrayList<Float[]>();
        float[] lightPosition;
        PShape pshape;

        for(Body body : this.bodies) {
            if(body.getBright()) {
                lightPosition = body.getPosition();
                lightsPositions.add(new Float[]{lightPosition[0], lightPosition[1], lightPosition[2]});
            }
        }

        noStroke();
        fill(255);
        for(Body body : this.bodies) {
            position = body.getPosition();
            angle = body.getAnglePosition();

            lightFalloff(1.0, 0.0, 0.0);
            if(body.getBright()) {
                ambientLight(255.0, 255.0, 255.0);
            } else {
                ambientLight(this.backlight, this.backlight, this.backlight);
                for(Float[] innerLightPosition : lightsPositions) {
                    pointLight(255.0, 255.0, 255.0, innerLightPosition[0], innerLightPosition[1], innerLightPosition[2]);
                }
            }

            translate(position[0], position[1], position[2]);

            pshape = createShape(SPHERE, body.getRadius());
            pshape.setTexture(body.getTexture());
            orientation = body.getOrientation();
            pshape.rotateY(angle[1] + Mathematics.Vector.angle(orientation[6], orientation[7], orientation[8], 1.0, 0.0, 0.0));
            pshape.rotateX(angle[0] + Mathematics.Vector.angle(orientation[3], orientation[4], orientation[5], 0.0, 1.0, 0.0));
            pshape.rotateY(angle[2] + Mathematics.Vector.angle(orientation[6], orientation[7], orientation[8], 1.0, 0.0, 0.0));
            shape(pshape, 0, 0);

            translate(-position[0], -position[1], -position[2]);

            noLights();
        }
    }

    public PImage getSkybox() {
        return this.skybox.copy();
    }

    public Body getTelescope() {
        return this.telescope;
    }


    public class Body extends Physics.SphericalBody {
        private float anglePositionX, anglePositionY, anglePositionZ, angleVelocityY;
        private boolean bright;
        private PImage texture;
        private boolean deleted;


        public Body(float positionX, float positionY, float positionZ, float mass, float radius) {
            super(positionX, positionY, positionZ, mass, radius);

            this.anglePositionX = 0.0;
            this.anglePositionY = 0.0;
            this.angleVelocityY = 0.0;
            this.bright = false;
            this.texture = null;
            this.deleted = false;
        }


        public void setAnglePosition(float anglePositionX, float anglePositionY, float anglePositionZ) {
            this.anglePositionX = anglePositionX;
            this.anglePositionY = anglePositionY;
            this.anglePositionZ = anglePositionZ;
        }

        public void setAnglePosition(float anglePositionX, float anglePositionZ) {
            this.setAnglePosition(anglePositionX, 0.0, anglePositionZ);
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

        public void setBright(boolean bright) {
            this.bright = bright;
        }

        public boolean getBright() {
            return this.bright;
        }

        public void setTexture(PImage texture) {
            this.texture = texture.copy();
        }

        public PImage getTexture() {
            return this.texture.copy();
        }

        public void accelerateAng(float angleVelocity) {
            this.angleVelocityY += angleVelocity;
        }

        public void delete() {
            this.deleted = true;
        }

        public boolean isDeleted() {
            return this.deleted;
        }

        @Override
        public void tick() {
            super.positionX += super.velocityX;
            super.positionY += super.velocityY;
            super.positionZ += super.velocityZ;
            this.anglePositionY = (this.anglePositionY + this.angleVelocityY) % TWO_PI;
        }
    }
}
