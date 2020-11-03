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
  Database class
  Malovanyi Denys Olehovych
***/



import java.io.File;


class Database {
    private String[] xmls, textures, sounds;


    public Database() {
        this.getTextures();
        this.getXMLs();

        File directory;
        directory = new File("data/textures");
        directory.mkdirs();
        directory = new File("data/xmls");
        directory.mkdirs();
        directory = new File("data/sounds");
        directory.mkdirs();
        directory = new File("data/screenshots");
        directory.mkdirs();
    }


    public String[] getXMLs() {
        ArrayList<String> xmlsList = new ArrayList<String>();

        for(String s : new File(sketchPath() + "/data/xmls/").list()) {
            if(s.endsWith(".xml")) {
                xmlsList.add(s.replace(".xml", ""));
            }
        }

        String[] xmlsArr = new String[xmlsList.size()];

        this.xmls = xmlsList.toArray(xmlsArr);
        return xmlsList.toArray(xmlsArr);
    }

    public String[] getXMLsOld() {
        return this.xmls.clone();
    }

    public XML getXML(String fileName) {
        try {
            return loadXML(sketchPath() + "/data/xmls/" + fileName + ".xml");
        } catch(Exception e) {
            return null;
        }
    }

    public String[] getTextures() {
        ArrayList<String> texturesList = new ArrayList<String>();

        for(String s : new File(sketchPath() + "/data/textures/").list()) {
            if(s.endsWith(".jpg")) {
                texturesList.add(s.replace(".jpg", ""));
            } else if(s.endsWith(".png")) {
                texturesList.add(s.replace(".png", ""));
            }
        }

        String[] texturesArr = new String[texturesList.size()];

        this.textures = texturesList.toArray(texturesArr);
        return texturesList.toArray(texturesArr);
    }

    public String[] getTexturesOld() {
        return this.textures.clone();
    }

    public PImage getTexture(String fileName) {
        PImage result;
        try {
            result = loadImage(sketchPath() + "/data/textures/" + fileName + ".jpg");
            if(result == null) {
                throw new NullPointerException();
            }
            return result;
        } catch(Exception e) {
            try {
                result = loadImage(sketchPath() + "/data/textures/" + fileName + ".png");
                if(result == null) {
                    throw new NullPointerException();
                }
                return result;
            } catch(Exception ee) {
                return new PImage(1, 1, RGB);
            }
        }
    }

    public String[] getSounds() {
        ArrayList<String> soundsList = new ArrayList<String>();

        for(String s : new File(sketchPath() + "/data/sounds/").list()) {
            if(s.endsWith(".wav")) {
                soundsList.add(s.replace(".wav", ""));
            }
        }

        String[] soundsArr = new String[soundsList.size()];

        this.sounds = soundsList.toArray(soundsArr);
        return soundsList.toArray(soundsArr);
    }

    public String[] getSoundsOld() {
        return this.sounds.clone();
    }

    public File getSound(String fileName) {
        try {
            return new File(sketchPath() + "/data/sounds/" + fileName + ".wav");
        } catch(Exception e) {
            return null;
        }
    }
}
