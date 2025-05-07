/**
 * This class is responsible for generating various game
 * objects based on game mode and incremental difficulty.
 */
class ObjectGenerator {
  private float waitTime = 0.15;
  private int currentTime;
  private float difficultyFactor;
  
  // Constructor
  public ObjectGenerator () { reset(); }
  
  /**
   * Updates the object generation logic and creates game
   * objects based on game mode and difficulty.
   */
  public void update() {
    currentTime++;
    
    // Check if it's time to generate objects.
    if (currentTime >= waitTime*100) {
      // Check the game mode to determine object generation rules
      if (gameMode == GameMode.ATTACK) {
        float random = random(100);
        
        // Increase difficulty over time.
        if (difficultyFactor < 40) { difficultyFactor += 0.005; }
        
        // Generate objects based on random values and difficulty
        if (0 <= random && random < 70-difficultyFactor) { createTree(); }
        else if (70-difficultyFactor <= random && random < 75 - difficultyFactor*0.25) { createTank(); }
        else if (75 - difficultyFactor*0.25 <= random && random <= 90) { createTent(); }
        
        // Reset timer
        currentTime = 0;
      } else {
        float random = random(100);
        
        // Increase difficulty over time.
        if (difficultyFactor < 40) { difficultyFactor += 0.005; }
        
        // Generate objects based on random values and difficulty.
        if (0 <= random && random < 50-difficultyFactor) { createTree(); }
        else if (50-difficultyFactor <= random && random < 80 - difficultyFactor*0.25) { createTank(); }
        else if (80 - difficultyFactor*0.25 <= random && random <= 90) { createAlliedTent(); }
        
        // Reset timer
        currentTime = 0;
      }
    }
  }
  
  /**
   * Reset to inital state
   */
  public void reset() {
    currentTime = 0;
    difficultyFactor = 0;
  }
}
