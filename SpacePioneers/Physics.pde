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
  Physics static class
      SphericalBody static class
  Malovanyi Denys Olehovych
***/



static class Physics {
    public static class SphericalBody {
        private float positionX, positionY, positionZ;
        private float velocityX, velocityY, velocityZ;
        private float forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ;
        private float mass;
        private float radius;


        public SphericalBody(float positionX, float positionY, float positionZ, float mass, float radius) {
            this.positionX = positionX;
            this.positionY = positionY;
            this.positionZ = positionZ;
            this.velocityX = 0.0;
            this.velocityY = 0.0;
            this.velocityZ = 0.0;
            this.mass = mass;
            this.radius = radius;
            this.positionX = this.positionY = this.positionZ = 0.0;
            this.forwardX = this.forwardY = 0.0;
            this.forwardZ = 1.0;
            this.upX = this.upZ = 0.0;
            this.upY = 1.0;
            this.rightX = 1.0;
            this.rightY = this.rightZ = 0.0;
        }


        public void setPosition(float positionX, float positionY, float positionZ) {
            this.positionX = positionX;
            this.positionY = positionY;
            this.positionZ = positionZ;
        }

        public float[] getPosition() {
            return new float[]{this.positionX, this.positionY, this.positionZ};
        }

        public void setVelocity(float velocityX, float velocityY, float velocityZ) {
            this.velocityX = velocityX;
            this.velocityY = velocityY;
            this.velocityZ = velocityZ;
        }

        public float[] getVelocity() {
            return new float[]{this.velocityX, this.velocityY, this.velocityZ};
        }

        public void setOrientation(float forwardX, float forwardY, float forwardZ, float upX, float upY, float upZ, float rightX, float rightY, float rightZ) {
            this.forwardX = forwardX;
            this.forwardY = forwardY;
            this.forwardZ = forwardZ;
            this.upX = upX;
            this.upY = upY;
            this.upZ = upZ;
            this.rightX = rightX;
            this.rightY = rightY;
            this.rightZ = rightZ;
        }

        public float[] getOrientation() {
            return new float[]{forwardX, forwardY, forwardZ, upX, upY, upZ, rightX, rightY, rightZ};
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

        public void accelerate(float velocityX, float velocityY, float velocityZ) {
            this.velocityX += velocityX;
            this.velocityY += velocityY;
            this.velocityZ += velocityZ;
        }

        public void tick() {
            this.positionX += this.velocityX;
            this.positionY += this.velocityY;
            this.positionZ += this.velocityZ;
        }
    }
}
