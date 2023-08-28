class PlaneGenerator {
  private int waitTime = 2;
  private int currentTime = 0;
  private int planeCount = 1;
  public PlaneGenerator () {
    
  }
  
  public void update() {
    currentTime++;
    if (currentTime >= waitTime*100) {
      for (int i = 0; i < planeCount; i++)
        createEnemyPlane(new PVector(width, 80 + random(height/4*2)));
      //planeCount++;
      currentTime = 0;
    }
  }
}
