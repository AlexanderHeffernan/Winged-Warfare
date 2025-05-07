/**
 * This class manages the display and bevaviour of the game
 * controls panel, which displays at the start of each game,
 * and updates dynamically depending on gamemode.
 */
public class Controls {
  float xPos;
  int imageWidth;
  PImage sprite;
  
  // Constructor
  public Controls() {
    xPos = 250; // Initial X pos
    // Width changes depending on gamemode.
    if (gameMode == GameMode.ATTACK) { imageWidth = 94; } 
    else { imageWidth = 102; }
  }
  
  /**
   * Update method to handle controls panel behaviour
   */
  public void update() {
    if (imageWidth > 0) {
      // If attack mode
      if (gameMode == GameMode.ATTACK) {
        sprite = controlsSprites.get(0);
        
        // Move controls at same speed as sky
        xPos -= worldSpeed/30;
        
        // Draw controls
        imageMode(CORNER);
        image(sprite.get(0,0,imageWidth,32), xPos, 150, imageWidth*6, 192);
        
        // Adjust width of image to hide behind mountain.
        if (xPos < 91 && imageWidth > 0) {
         imageWidth = (int)(94 + ((xPos-90)/10));
        }
      } 
      // If supply mode
      else {
        sprite = controlsSprites.get(1);
        
        // Move controls at same speed as sky
        xPos -= worldSpeed/30;
        
        // Draw controls
        imageMode(CORNER);
        image(sprite.get(0,0,imageWidth,32), xPos, 150, imageWidth*6, 192);
        
        // Adjust width of image to hide behind moutain
        if (xPos < 91 && imageWidth > 0) { imageWidth = (int)(102 + ((xPos-90)/10)); }
      }
    }
  }
}
