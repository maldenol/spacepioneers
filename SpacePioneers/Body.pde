# This file is part of SpacePioneers.
#
# SpacePioneers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SpacePioneers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SpacePioneers.  If not, see <https://www.gnu.org/licenses/>.



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
    
    
    public void setPos(PVector value) {
        this.pos = value.copy();
    }
    
    public void setPos(float x, float y, float z) {
        this.pos = new PVector(x, y, z);
    }
    
    public PVector getPos() {
        return this.pos.copy();
    }
    
    public void setVel(PVector value) {
        this.vel = value.copy();
    }
    
    public void setVel(float x, float y, float z) {
        this.vel = new PVector(x, y, z);
    }
    
    public PVector getVel() {
        return this.vel.copy();
    }
    
    public void setMass(float value) {
        this.mass = value;
    }
    
    public float getMass() {
        return this.mass;
    }
    
    public void setRadius(float value) {
        this.radius = value;
    }
    
    public float getRadius() {
        return this.radius;
    }
    
    public void setAnglePos(float x, float y, float z) {
        this.anglePosX = x;
        this.anglePosY = y;
        this.anglePosZ = z;
    }
    
    public void setAnglePos(float x, float z) {
        this.setAnglePos(x, 0, z);
    }
    
    public float[] getAnglePos() {
        return new float[]{this.anglePosX, this.anglePosY, this.anglePosZ};
    }
    
    public void setAnglePeriod(float value) {
        this.angleVelY = TWO_PI / value;
    }
    
    public float getAnglePeriod() {
        return TWO_PI / this.angleVelY;
    }
    
    public void setTexture(PImage value) {
        this.texture = value.copy();
    }
    
    public PImage getTexture() {
        return this.texture.copy();
    }
    
    public void accelerate(PVector value) {
        this.vel.add(value);
    }
    
    public void accelerateAng(float value) {
        this.angleVelY += value;
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
