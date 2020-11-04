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
  Mathematics static class
  Malovanyi Denys Olehovych
***/



static class Mathematics {
    public static float[] rotateOnQuaternion(float px, float py, float pz, float ax, float ay, float az, float angle) {
        float[] p = new float[]{0.0, px, py, pz};
        float[] a = new float[]{cos(angle), sin(angle) * ax, sin(angle) * ay, sin(angle) * az};

        p[0] = 0.0 - (a[1]) * (p[1]) - (a[2]) * (p[2]) - (a[3]) * (p[3]);
        p[1] = (a[0]) * (p[1]) + 0.0 + (a[2]) * (p[3]) - (a[3]) * (p[2]);
        p[2] = (a[0]) * (p[2]) - (a[1]) * (p[3]) + 0.0 + (a[3]) * (p[1]);
        p[3] = (a[0]) * (p[3]) + (a[1]) * (p[2]) - (a[2]) * (p[1]) + 0.0;

        p[0] = + (p[0]) * (a[0]) + (p[1]) * (a[1]) + (p[2]) * (a[2]) + (p[3]) * (a[3]);
        p[1] = - (p[0]) * (a[1]) + (p[1]) * (a[0]) - (p[2]) * (a[3]) + (p[3]) * (a[2]);
        p[2] = - (p[0]) * (a[2]) + (p[1]) * (a[3]) + (p[2]) * (a[0]) - (p[3]) * (a[1]);
        p[3] = - (p[0]) * (a[3]) - (p[1]) * (a[2]) + (p[2]) * (a[1]) + (p[3]) * (a[0]);

        return new float[]{p[1], p[2], p[3]};
    }

    public static float[][] convertKeplerianToCartesian(float gConst, float sma, float e, float ap, float lan, float i, float ma, float orbitMass) {
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
        preVelocityX = sqrt(gConst * sma * orbitMass) / distance * -sin(ea);
        preVelocityY = sqrt(gConst * sma * orbitMass) / distance * sqrt(1.0 - e * e) * cos(ea);

        positionX = prePositionX * (cos(ap) * cos(lan) - sin(ap) * cos(i) * sin(lan)) - prePositionY * (sin(ap) * cos(lan) + cos(ap) * cos(i) * sin(lan));
        positionY = prePositionX * (cos(ap) * sin(lan) + sin(ap) * cos(i) * cos(lan)) - prePositionY * (sin(ap) * sin(lan) - cos(ap) * cos(i) * cos(lan));
        positionZ = prePositionX * (sin(ap) * sin(i)) + prePositionY * (cos(ap) * sin(i));
        velocityX = preVelocityX * (cos(ap) * cos(lan) - sin(ap) * cos(i) * sin(lan)) - preVelocityY * (sin(ap) * cos(lan) + cos(ap) * cos(i) * sin(lan));
        velocityY = preVelocityX * (cos(ap) * sin(lan) + sin(ap) * cos(i) * cos(lan)) - preVelocityY * (sin(ap) * sin(lan) - cos(ap) * cos(i) * cos(lan));
        velocityZ = preVelocityX * (sin(ap) * sin(i)) + preVelocityY * (cos(ap) * sin(i));

        return new float[][]{{positionX, positionY, positionZ}, {velocityX, velocityY, velocityZ}};
    }


    public static class Vector {
        public static float[] add(float ax, float ay, float az, float bx, float by, float bz) {
            return new float[]{ax + bx, ay + by, az + bz};
        }

        public static float[] subtract(float ax, float ay, float az, float bx, float by, float bz) {
            return add(-ax, -ay, -az, -bx, -by, -bz);
        }

        public static float[] multiply(float x, float y, float z, float s) {
            return new float[]{x * s, y * s, z * s};
        }

        public static float[] divide(float x, float y, float z, float s) {
            return new float[]{x / s, y / s, z / s};
        }

        public static float length(float x, float y, float z) {
            return sqrt(x * x + y * y + z * z);
        }

        public static float[] normalize(float x, float y, float z) {
            float l = length(x, y, z);
            return new float[]{x / l, y / l, z / l};
        }

        public static float scalarProduct(float ax, float ay, float az, float bx, float by, float bz) {
            return ax * bx + ay * by + az * bz;
        }

        public static float[] vectorProduct(float ax, float ay, float az, float bx, float by, float bz) {
            return new float[]{ay * bz - by * az, bx * az - ax * bz, ax * by - bx * ay};
        }

        public static float angle180(float ax, float ay, float az, float bx, float by, float bz) {
            return acos(scalarProduct(ax, ay, az, bx, by, bz) / length(ax, ay, az) / length(bx, by, bz));
        }

        public static float angle360(float ax, float ay, float az, float bx, float by, float bz) {
            float dot = scalarProduct(ax, ay, az, bx, by, bz);
            float[] product = vectorProduct(ax, ay, az, bx, by, bz);
            float det = length(product[0], product[1], product[2]);
            return atan2(det, dot);
        }

        public static float angle(float ax, float ay, float az, float bx, float by, float bz) {
            return angle180(ax, ay, az, bx, by, bz);
        }
    }
}
