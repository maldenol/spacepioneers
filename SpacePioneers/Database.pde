/***
  "Space Pioneers"
  Database class
  Malovanyi Denys
***/

import java.io.File;


class Database {
    public Database() {
        
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
        
        return texturesList.toArray(texturesArr);
    }
    
    public PImage getTexture(String fileName) {
        try {
            return loadImage("data/textures/" + fileName + ".jpg");
        }
        catch(Exception e) {
            try {
                return loadImage("data/textures/" + fileName + ".jpg");
            }
            catch(Exception ee) {
                return null;
            }
        }
    }
    
    public String[] getXMLs() {
        ArrayList<String> xmlsList = new ArrayList<String>();
        
        for(String s : new File(sketchPath() + "/data/").list()) {
            if(s.endsWith(".xml"))
                xmlsList.add(s.replace(".xml", ""));
        }
        
        String[] xmlsArr = new String[xmlsList.size()];
        
        return xmlsList.toArray(xmlsArr);
    }
    
    public XML getXML(String fileName) {
        try {
            return loadXML("data/" + fileName + ".xml");
        }
        catch(Exception e) {
            return null;
        }
    }
}
