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
    }
    
    
    public String[] getXMLs() {
        ArrayList<String> xmlsList = new ArrayList<String>();
        
        for(String s : new File(sketchPath() + "/data/xmls/").list()) {
            if(s.endsWith(".xml"))
                xmlsList.add(s.replace(".xml", ""));
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
            if(s.endsWith(".jpg"))
                texturesList.add(s.replace(".jpg", ""));
            else if(s.endsWith(".png"))
                texturesList.add(s.replace(".png", ""));
        }
        
        String[] texturesArr = new String[texturesList.size()];
        
        this.textures = texturesList.toArray(texturesArr);
        return texturesList.toArray(texturesArr);
    }
    
    public String[] getTexturesOld() {
        return this.textures.clone();
    }
    
    public PImage getTexture(String fileName) {
        try {
            return loadImage(sketchPath() + "/data/textures/" + fileName + ".jpg");
        } catch(Exception e) {
            try {
                return loadImage(sketchPath() + "/data/textures/" + fileName + ".jpg");
            } catch(Exception ee) {
                return null;
            }
        }
    }
    
    public String[] getSounds() {
        ArrayList<String> soundsList = new ArrayList<String>();
        
        for(String s : new File(sketchPath() + "/data/sounds/").list()) {
            if(s.endsWith(".mp3"))
                soundsList.add(s.replace(".mp3", ""));
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
            return new File(sketchPath() + "/data/sounds/" + fileName + ".mp3");
        } catch(Exception e) {
            return null;
        }
    }
}
