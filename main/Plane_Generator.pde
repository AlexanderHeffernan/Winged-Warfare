class PlaneGenerator {
  private int waitTime = 2;
  private int currentTime = 0;
  public PlaneGenerator () {
    
  }
  
  public void update() {
    currentTime++;
    if (currentTime >= waitTime*100) {
      createEnemyPlane();
      currentTime = 0;
    }
  }
}
