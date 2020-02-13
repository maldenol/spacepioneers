/***
  "Space Pioneers"
  Database class
  Malovanyi Denys Olehovych
***/

import java.io.File;


class Database {
    private String[] textures, xmls;
    
    
    public Database() {
        this.getTextures();
        this.getXMLs();
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
            return loadXML("data/xmls/" + fileName + ".xml");
        }
        catch(Exception e) {
            return null;
        }
    }
}
