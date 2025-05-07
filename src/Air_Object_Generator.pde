/**
 * This class is responsible for generating and managing 
 * the spawning of enemy planes and supply drops.
 */
class AirObjectGenerator {
  // Variables to control the timing of enemy places and supply drops
  private int waitPlaneTime;
  private int currentPlaneTime;
  private int waitSupplyDropTime;
  private int currentSupplyDropTime;
  private float difficultyFactor;
  
  // Constructor
  public AirObjectGenerator () { reset(); }
  
  // Update method to handle spawning of enemy planes and supply drops
  public void update() {
    // Increment times
    currentPlaneTime++;
    currentSupplyDropTime++;
    
    // Update difficulty factor
    if (difficultyFactor < 40) { difficultyFactor += 0.003; }
    
    // If time to spawn plane
    if (currentPlaneTime >= waitPlaneTime*100) {
      // Choose random yPos
      float yPos = 80 + random(height/4*2);
      float xDifference = 0;
      float yDifference = 0;
      
      // Loop through the number of planes to spawn based on difficulty factor
      for (int i = 0; i < round(1.0 + difficultyFactor/15.0); i++) { 
        createEnemyPlane(new PVector(width + xDifference, yPos + yDifference));
        // Stagger enemy planes with difference variables
        if (yDifference < 0) {
          yDifference *= -1;
        } else {
          yDifference += (int)random(80, 160);
          yDifference *= -1;
        }
        xDifference += (int)random(80, 200);
      }
      
      // Set new wait time
      waitPlaneTime = (int)random(4-difficultyFactor/10,7-difficultyFactor/10);
      currentPlaneTime = 0;
    }
    if (currentSupplyDropTime >= waitSupplyDropTime*100) {
      createSupplyDrop();
      resetWaitSupplyDropTime();
      currentSupplyDropTime = 0;
    }
  }
  
  /**
   * Reset method to initialize variables
   */
  public void reset() {
    waitPlaneTime = (int)random(1,3);
    currentPlaneTime = 0;
    resetWaitSupplyDropTime();
    currentSupplyDropTime = 0;
    difficultyFactor = 0;
  }
  
  /**
   * Quick method for reseting wait time for supply drops
   * based on game mode.
   */
  private void resetWaitSupplyDropTime() {
    if (gameMode == GameMode.ATTACK) { waitSupplyDropTime = (int)random(8, 15); }
    else                             { waitSupplyDropTime = (int)random(5, 10); }
  }
    
}
