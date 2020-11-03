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
        float[] p = new float[]{0, px, py, pz};
        float[] a = new float[]{cos(angle), sin(angle) * ax, sin(angle) * ay, sin(angle) * az};

        p[0] = 0 - (a[1]) * (p[1]) - (a[2]) * (p[2]) - (a[3]) * (p[3]);
        p[1] = (a[0]) * (p[1]) + 0 + (a[2]) * (p[3]) - (a[3]) * (p[2]);
        p[2] = (a[0]) * (p[2]) - (a[1]) * (p[3]) + 0 + (a[3]) * (p[1]);
        p[3] = (a[0]) * (p[3]) + (a[1]) * (p[2]) - (a[2]) * (p[1]) + 0;

        p[0] = + (p[0]) * (a[0]) + (p[1]) * (a[1]) + (p[2]) * (a[2]) + (p[3]) * (a[3]);
        p[1] = - (p[0]) * (a[1]) + (p[1]) * (a[0]) - (p[2]) * (a[3]) + (p[3]) * (a[2]);
        p[2] = - (p[0]) * (a[2]) + (p[1]) * (a[3]) + (p[2]) * (a[0]) - (p[3]) * (a[1]);
        p[3] = - (p[0]) * (a[3]) - (p[1]) * (a[2]) + (p[2]) * (a[1]) + (p[3]) * (a[0]);

        return new float[]{p[1], p[2], p[3]};
    }

    public static float[] vectorProduct(float x1, float y1, float z1, float x2, float y2, float z2) {
        return new float[]{y1 * z2 - y2 * z1, x2 * z1 - x1 * z2, x1 * y2 - x2 * y1};
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
}
